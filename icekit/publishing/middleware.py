from contextlib import contextmanager
from threading import current_thread

from django.core.urlresolvers import Resolver404, resolve
from django.http import HttpResponseRedirect

from .utils import get_draft_url, verify_draft_url


class PublishingMiddleware(object):
    """
    Publishing middleware to set status flags and apply features:
        - permit members of the "Content Reviewers" group to view drafts
        - track whether this middleware has been activated for the current
          thread, so we can tell when it is safe to trust the status it reports
        - store the current user for use within the publishing manager where
          we do not have access to the ``request`` object.
        - set draft status flag if request context permits viewing drafts.
    """
    _draft_request_context = {}
    _middleware_active_status = {}
    _current_user = {}
    _draft_only_views = [
    ]

    @staticmethod
    def is_admin_request(request):
        try:
            return resolve(request.path).app_name == 'admin'
        except Resolver404:
            return False

    @staticmethod
    def is_draft_only_view(request):
        resolved = resolve(request.path)
        name = '%s.%s' % (resolved.func.__module__, resolved.func.__name__)
        return name in PublishingMiddleware._draft_only_views

    @staticmethod
    def is_content_reviewer_user(request):
        return request.user.is_authenticated() \
            and request.user.groups.filter(name='Content Reviewers').exists()

    @staticmethod
    def is_staff_user(request):
        return request.user.is_authenticated() and request.user.is_staff

    @staticmethod
    def is_draft_request(request):
        """ Is this request explicly flagged as for draft content? """
        return 'edit' in request.GET

    @staticmethod
    def is_draft(request):
        """
        A request is considered to be in draft mode if:
        - it is for *any* admin resource, since the admin site deals only with
          draft objects and hides the published version from admin users
        - it is for *any* view in *any* app that deals only with draft objects
        - user is a member of the "Content Reviewer" group, since content
          reviewers' sole purpose is to review draft content and they need not
          see the published content
        - the user is a staff member and therefore can see draft versions of
          pages if they wish, and the 'edit' GET parameter flag is included to
          show the draft page is definitely wanted instead of a normal
          published page.
        - the 'edit' GET parameter flag is included with a valid HMAC for the
          requested URL, regardless of authenticated permissions.
        """
        # Admin resource requested.
        if PublishingMiddleware.is_admin_request(request):
            return True
        # Draft-only view requested.
        if PublishingMiddleware.is_draft_only_view(request):
            return True
        # Content reviewer made request.
        if PublishingMiddleware.is_content_reviewer_user(request):
            return True
        # Draft mode requested.
        if PublishingMiddleware.is_draft_request(request):
            # User is staff.
            if PublishingMiddleware.is_staff_user(request):
                return True
            # Request contains a valid draft mode HMAC in the querystring.
            if verify_draft_url(request.get_full_path()):
                return True
        # Not draft mode.
        return False

    def process_request(self, request):
        is_draft = self.is_draft(request)
        # Redirect non-admin, GET method, draft mode requests, from staff users
        # (not content reviewers), that don't have a valid draft mode HMAC in
        # the querystring, to make URL sharing easy.
        if all([
            not PublishingMiddleware.is_admin_request(request),
            request.method == 'GET',
            is_draft,
            PublishingMiddleware.is_staff_user(request),
            not PublishingMiddleware.is_content_reviewer_user(request),
            not verify_draft_url(request.get_full_path()),
        ]):
            return HttpResponseRedirect(get_draft_url(request.get_full_path()))
        # Set middleware active status.
        PublishingMiddleware \
            ._middleware_active_status[current_thread()] = True
        # Set current user
        PublishingMiddleware._current_user[current_thread()] = \
            request.user
        # Set draft status
        PublishingMiddleware._draft_request_context[current_thread()] = \
            is_draft
        # Add draft status to request, for use in templates.
        request.IS_DRAFT = is_draft

    @staticmethod
    def process_response(request, response):
        try:
            del PublishingMiddleware._middleware_active_status[
                current_thread()]
        except KeyError:
            pass
        try:
            del PublishingMiddleware._current_user[current_thread()]
        except KeyError:
            pass
        try:
            del PublishingMiddleware._draft_request_context[current_thread()]
        except KeyError:
            pass
        return PublishingMiddleware.redirect_staff_to_draft_view_on_404(
            request, response)

    @staticmethod
    def is_publishing_middleware_active():
        try:
            return PublishingMiddleware._middleware_active_status[
                current_thread()]
        except KeyError:
            return False

    @staticmethod
    def get_current_user():
        try:
            return PublishingMiddleware._current_user[current_thread()]
        except KeyError:
            return None

    @staticmethod
    def is_draft_request_context():
        try:
            return PublishingMiddleware._draft_request_context[
                current_thread()]
        except KeyError:
            return False

    @staticmethod
    def redirect_staff_to_draft_view_on_404(request, response):
        """
        When a request fails with a 404, redirect to a (potential) draft
        version of the resource if the user is a staff member permitted to view
        drafts.
        """
        if (response.status_code == 404
                # No point redirecting if we already have a draft request
                and not PublishingMiddleware.is_draft_request(request)
                # Don't mess with admin requests at all
                and not PublishingMiddleware.is_admin_request(request)
                # Can user view draft content if we add the 'edit' param
                and PublishingMiddleware.is_staff_user(request)):
            # TODO Is there a sane way to check for draft version of resource
            # at this URL path, without just redirecting the user to it?
            return HttpResponseRedirect(get_draft_url(request.get_full_path()))
        return response


def is_publishing_middleware_active():
    return PublishingMiddleware.is_publishing_middleware_active()


def set_publishing_middleware_active(status):
    PublishingMiddleware._middleware_active_status[current_thread()] = status


def is_draft_request_context():
    return PublishingMiddleware.is_draft_request_context()


def set_draft_request_context(status):
    PublishingMiddleware._draft_request_context[current_thread()] = status


def get_current_user():
    return PublishingMiddleware.get_current_user()


def set_current_user(user):
    PublishingMiddleware._current_user[current_thread()] = user


@contextmanager
def override_draft_request_context(status):
    original = is_draft_request_context()
    set_draft_request_context(status)
    yield
    set_draft_request_context(original)


@contextmanager
def override_publishing_middleware_active(status):
    original = is_publishing_middleware_active()
    set_publishing_middleware_active(status)
    yield
    set_publishing_middleware_active(original)


@contextmanager
def override_current_user(user):
    original = get_current_user()
    set_current_user(user)
    yield
    set_current_user(original)

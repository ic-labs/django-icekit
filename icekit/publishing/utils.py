import urlparse

from django.apps import apps
from django.http import QueryDict
from django.utils.crypto import get_random_string, salted_hmac
from django.utils.encoding import force_bytes

from model_settings.models import Text


class PublishingException(Exception):
    pass


class NotDraftException(PublishingException):
    pass


def get_publishable_models():
    from .models import PublishingModel
    publishable_models = [
        model for model in apps.get_models()
        if issubclass(model, PublishingModel)
    ]
    return publishable_models


def assert_draft(method):
    def decorated(self, *args, **kwargs):
        if not self.is_draft:
            raise NotDraftException()

        return method(self, *args, **kwargs)
    return decorated


def get_draft_hmac(salt, url):
    """
    Return a draft mode HMAC for the given salt and URL.
    """
    return salted_hmac(salt, url, get_draft_secret_key()).hexdigest()


def get_draft_secret_key():
    """
    Return the secret key used to generate draft mode HMACs. It will be
    randomly generated on first access. Existing draft URLs can be invalidated
    by deleting or updating the ``DRAFT_SECRET_KEY`` setting.
    """
    # TODO: Per URL secret keys, so we can invalidate draft URLs for individual
    #       pages. For example, on publish.
    draft_secret_key, created = Text.objects.get_or_create(
        name='DRAFT_SECRET_KEY',
        defaults=dict(
            value=get_random_string(50),
        ))
    return draft_secret_key.value


def get_draft_url(url):
    """
    Return the given URL with a draft mode HMAC in its querystring.
    """
    if verify_draft_url(url):
        # Nothing to do. Already a valid draft URL.
        return url
    # Parse querystring and add draft mode HMAC.
    url = urlparse.urlparse(url)
    salt = get_random_string(5)
    # QueryDict requires a bytestring as its first argument
    query = QueryDict(force_bytes(url.query), mutable=True)
    query['edit'] = '%s:%s' % (salt, get_draft_hmac(salt, url.path))
    # Reconstruct URL.
    parts = list(url)
    parts[4] = query.urlencode(safe=':')
    return urlparse.urlunparse(parts)


def verify_draft_url(url):
    """
    Return ``True`` if the given URL has a valid draft mode HMAC in its
    querystring.
    """
    url = urlparse.urlparse(url)
    # QueryDict requires a bytestring as its first argument
    query = QueryDict(force_bytes(url.query))
    try:
        salt, hmac = query['edit'].split(':')
    except (KeyError, ValueError):
        return False
    return hmac == get_draft_hmac(salt, url.path)

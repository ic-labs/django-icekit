from django.core.urlresolvers import reverse
from django.db import models
from django.utils.functional import cached_property
from django.utils.translation import ugettext_lazy as _
from django.utils.six import text_type, python_2_unicode_compatible
from fluent_contents.models import PlaceholderField, ContentItem
from icekit.fields import ICEkitURLField
from icekit.plugins import descriptors


@python_2_unicode_compatible
class AbstractNavigation(models.Model):
    name = models.CharField(max_length=255)
    slug = models.SlugField()
    pre_html = models.TextField(blank=True)
    post_html = models.TextField(blank=True)
    content = PlaceholderField('navigation_content')
    request = None

    class Meta:
        abstract = True

    def __str__(self):
        return self.name

    def set_request(self, request):
        self.request = request

    @cached_property
    def active_items(self):
        if not self.request:
            raise Exception('`active_items` requires access to a request object. Call `.set_request(...)`')

        active_items = []
        for item in self.slots.navigation_content:
            if (
                hasattr(item, 'is_active_for_request') and
                item.is_active_for_request(self.request)
            ):
                active_items.append(item)
        return active_items

descriptors.contribute_to_class(AbstractNavigation, name='slots')


@python_2_unicode_compatible
class AbstractNavigationItem(ContentItem):
    title = models.CharField(max_length=255)
    url = ICEkitURLField()
    html_class = models.CharField(max_length=255, blank=True)

    class Meta:
        abstract = True
        verbose_name = _('Navigation Item')

    def __str__(self):
        return self.title

    def get_absolute_url(self):
        return self.url

    def is_active_for_request(self, request):
        url = text_type(self.get_absolute_url())
        # Note that `startswith` has an implicit equality check as well as substring matching
        return request.path.startswith(url)


@python_2_unicode_compatible
class AbstractAccountsNavigationItem(ContentItem):
    class Meta:
        abstract = True
        verbose_name = _('Accounts Navigation Item')

    def __str__(self):
        return 'Accounts Navigation Item'

    def get_login_url(self):
        return reverse('login')

    def get_logout_url(self):
        return reverse('logout')

    def is_active_for_request(self, request):
        if request.user.is_authenticated:
            return request.path == self.get_logout_url()
        else:
            return request.path == self.get_login_url()


from django.db import models
from django.utils.six import python_2_unicode_compatible
from django.utils.translation import ugettext_lazy as _
from fluent_contents.models import PlaceholderField, ContentItem
from icekit.fields import ICEkitURLField


@python_2_unicode_compatible
class AbstractNavigation(models.Model):
    name = models.CharField(max_length=255)
    slug = models.SlugField()
    pre_html = models.TextField(blank=True, default='<nav><ul>')
    post_html = models.TextField(blank=True, default='</ul></nav>')
    content = PlaceholderField('navigation_content')

    class Meta:
        abstract = True

    def __str__(self):
        return self.name


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


@python_2_unicode_compatible
class AbstractAccountsNavigationItem(ContentItem):
    class Meta:
        abstract = True
        verbose_name = _('Accounts Navigation Item')

    def __str__(self):
        return 'Accounts Navigation Item'

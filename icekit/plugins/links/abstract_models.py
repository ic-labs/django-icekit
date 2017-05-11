from fluent_contents.extensions import ContentPlugin
from fluent_contents.models import ContentItem
from django.db import models
import appsettings
from icekit.fields import ICEkitURLField
from icekit.utils.attributes import resolve


class AbstractLinkItem(ContentItem):
    """
    A content type that is a relation to another model.

    Subclasses should define:

        item = models.ForeignKey(to)

    Assuming the 'to' model implements `ListableMixin` then the Item renders as
    a list item.

    This class acts as a wrapper on the item - all the item's attributes are
    attributes of the AbstractLinkItem too, with some values overridden.
    """
    style = models.CharField("Link style", max_length=255, choices=appsettings.RELATION_STYLE_CHOICES, blank=True)
    type_override = models.CharField(max_length=255, blank=True)
    title_override = models.CharField(max_length=255, blank=True)
    oneliner_override = models.CharField(max_length=255, blank=True)
    url_override = ICEkitURLField(max_length=255, blank=True)
    image_override = models.ImageField(
        blank=True,
        upload_to="icekit/listable/list_image/",
    )

    class Meta:
        abstract = True

    def get_item(self):
        "If the item is publishable, get the visible version"

        if hasattr(self, 'get_draft'):
            draft = self.get_draft()
        else:
            draft = self

        if not hasattr(self, '_item_cache'):
            try:
                self._item_cache = draft.item.get_published_or_draft()
            except AttributeError:
                # not publishable
                self._item_cache = draft.item
        return self._item_cache

    def __unicode__(self):
        return "Link to '%s'" % unicode(self.item)

    def _resolve(self, attr):
        return resolve(self.get_item(), attr)

    def get_type(self):
        return self.type_override or self._resolve('get_type')

    def get_title(self):
        return self.title_override or self._resolve('get_title')

    def get_list_image(self):
        return self.image_override or self._resolve('get_list_image')

    def get_absolute_url(self):
        return self.url_override or self._resolve('get_absolute_url')

    def get_oneliner(self):
        return self.oneliner_override or self._resolve('get_oneliner')

    def get_admin_link(self): # specifying only so admin can look it up
        return self._resolve('get_admin_link')
    get_admin_link.allow_tags = True


class LinkPlugin(ContentPlugin):
    category = 'Links'
    raw_id_fields = ('item', )
    render_template = 'plugins/link/default.html'
    fieldsets = (
        (None, {
           'fields': (
               ('item', ),
               'style',
           )
        }),
        ('Overrides', {
           'fields': (
               'type_override',
               'title_override',
               'oneliner_override',
               'image_override',
               'url_override',
           ),
           'classes': ('collapse', )
        }),
    )

    # Do not cache output for linked items otherwise we get situations where
    # URL changes to ancestor pages don't get applied until a Django restart
    # because the old URL is cached in the original content.
    cache_output = False

    def render(self, request, instance, **kwargs):
        """
        Only render the plugin if the item can be shown to the user
        """
        if instance.get_item():
            return super(LinkPlugin, self).render(request, instance, **kwargs)
        return ""

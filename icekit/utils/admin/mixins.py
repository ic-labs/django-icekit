import logging

from django.contrib.admin.views.main import TO_FIELD_VAR
from django.contrib.admin.widgets import (ForeignKeyRawIdWidget,
    ManyToManyRawIdWidget,)
from django.contrib.contenttypes.models import ContentType
from django.utils.translation import ugettext_lazy as _

from fluent_contents.admin.contentitems import (BaseContentItemInline,
    get_content_item_inlines,)

logger = logging.getLogger(__name__)


class ThumbnailAdminMixin(object):
    """
    Shortcut for displaying a thumbnail in a changelist (or inline).

    Requires easy-thumbnails.

    Specify ImageField name in `thumbnail_field`, and optionally
    override `thumbnail_options` for customisation such as sizing,
    cropping, etc. If `thumbnail_show_exceptions` is truthy, exception
    messages are returned in place of a thumbnail on failure.

    Plays nicely with list_display_links if you want a click-able
    thumbnail.

    Add 'thumbnail' to `list_display` or `readonly_fields`, etc to
    display.
    """

    thumbnail_field = None
    thumbnail_options = {
        'size': (100, 100),
    }
    thumbnail_show_exceptions = False

    def get_thumbnail_source(self, obj):
        """
        Obtains the source image field for the thumbnail.

        :param obj: An object with a thumbnail_field defined.
        :return: Image field for thumbnail or None if not found.
        """
        if hasattr(self, 'thumbnail_field') and self.thumbnail_field:
            return getattr(obj, self.thumbnail_field)

        logger.warning('ThumbnailAdminMixin.thumbnail_field unspecified')
        return None

    def thumbnail(self, obj):
        """
        Generate the HTML to display for the image.

        :param obj: An object with a thumbnail_field defined.
        :return: HTML for image display.
        """
        source = self.get_thumbnail_source(obj)
        if source:
            try:
                from easy_thumbnails.files import get_thumbnailer
            except ImportError:
                logger.warning(
                    _(
                        '`easy_thumbnails` is not installed and required for '
                        'icekit.utils.admin.mixins.ThumbnailAdminMixin'
                    )
                )
                return ''
            try:
                thumbnailer = get_thumbnailer(source)
                thumbnail = thumbnailer.get_thumbnail(self.thumbnail_options)
                return '<img class="thumbnail" src="{0}" />'.format(
                    thumbnail.url)
            except Exception as ex:
                logger.warning(
                    _(u'`easy_thumbnails` failed to generate a thumbnail image'
                      u' for {0}'.format(source)))
                if self.thumbnail_show_exceptions:
                    return 'Thumbnail exception: {0}'.format(ex)
        return ''
    thumbnail.allow_tags = True


# RAW_ID_FIELDS FIX ###########################################################


class PolymorphicForeignKeyRawIdWidget(ForeignKeyRawIdWidget):
    def url_parameters(self):
        # Returns the GET parameters passed to the model selection pop-up
        # Only invoke the custom stuff for polymorphic models
        if hasattr(self.rel.to, 'polymorphic_ctype'):
            params = {}
            to_field = self.rel.get_related_field()
            # This condition should determine whether we're looking at the
            # parent model, or one of the children
            # TODO: make this recursive to support multi-level inheritance
            if getattr(to_field, 'rel', None):
                # Fortunately, since the PK of the child is a FK to the
                # parent, the numeric PK value of the parent will be equal to
                # the child's PK numeric value
                to_field = to_field.rel.get_related_field()
                # Filter by polymorphic type. Must be unset for parent model
                params['ct_id'] = ContentType.objects.get_for_model(self.rel.to).pk
            params[TO_FIELD_VAR] = to_field.name
            return params
        return super(PolymorphicForeignKeyRawIdWidget, self).url_parameters()


class PolymorphicManyToManyRawIdWidget(PolymorphicForeignKeyRawIdWidget, ManyToManyRawIdWidget):
    pass


class PolymorphicAdminRawIdFix(object):
    """
    Use this mixin in any ModelAdmin that has a foreign key to a polymorphic
    model that you would like to be a raw id field.
    """
    
    def _get_child_admin_site(self, rel):
        """
        Returns the separate AdminSite instance that django-polymorphic
        maintains for child models.
        
        This admin site needs to be passed to the widget so that it passes the
        check of whether the field is pointing to a model that's registered
        in the admin.
        
        The hackiness of this implementation reflects the hackiness of the way
        django-polymorphic does things.
        """
        if rel.to not in self.admin_site._registry:
            # Go through the objects the model inherits from and find one
            # that's registered in the main admin and has a reference to the
            # child admin site in it attributes.
            for parent in rel.to.mro():
                if parent in self.admin_site._registry \
                and hasattr(self.admin_site._registry[parent], '_child_admin_site'):
                    return self.admin_site._registry[parent]._child_admin_site
        return self.admin_site
    
    def formfield_for_foreignkey(self, db_field, request=None, **kwargs):
        """
        Replicates the logic in ModelAdmin.forfield_for_foreignkey, replacing
        the widget with the patched one above, initialising it with the child
        admin site.
        """
        db = kwargs.get('using')
        if db_field.name in self.raw_id_fields:
            kwargs['widget'] = PolymorphicForeignKeyRawIdWidget(
                db_field.rel,
                admin_site=self._get_child_admin_site(db_field.rel),
                using=db
            )
            if 'queryset' not in kwargs:
                queryset = self.get_field_queryset(db, db_field, request)
                if queryset is not None:
                    kwargs['queryset'] = queryset
            return db_field.formfield(**kwargs)
        return super(PolymorphicAdminRawIdFix, self).formfield_for_foreignkey(
            db_field, request=request, **kwargs)

    def formfield_for_manytomany(self, db_field, request=None, **kwargs):
        """
        Replicates the logic in ModelAdmin.formfield_for_manytomany, replacing
        the widget with the patched one above, initialising it with the child
        admin site.
        """
        db = kwargs.get('using')
        if db_field.name in self.raw_id_fields:
            kwargs['widget'] = PolymorphicManyToManyRawIdWidget(
                db_field.rel,
                admin_site=self._get_child_admin_site(db_field.rel),
                using=db
            )
            kwargs['help_text'] = ''
            if 'queryset' not in kwargs:
                queryset = self.get_field_queryset(db, db_field, request)
                if queryset is not None:
                    kwargs['queryset'] = queryset
            return db_field.formfield(**kwargs)
        return super(PolymorphicAdminRawIdFix, self).formfield_for_manytomany(
            db_field, request=request, **kwargs)


class PolymorphicFluentAdminRawIdFix(PolymorphicAdminRawIdFix):
    """
    Use this mixin in any ModelAdmin for a Fluent content page to make sure
    that any Fluent inlines in the admin for the page inherit from the mixin
    above.
    
    Using this as the FLUENT_PAGES_[PARENT/CHILD]_ADMIN_MIXIN setting does not
    appear to work (possibly because of explicit model_admin declarations in
    PagePlugins defining page types).
    """
    
    def get_extra_inlines(self):
        # Replicates the equivalent method on PlaceholderEditorAdmin, except
        # adds the `base` kwarg to the inline generator, so that all inlines
        # have the polymorphic fix
        return [self.placeholder_inline] + \
            get_content_item_inlines(
                plugins=self.get_all_allowed_plugins(),
                base=PolymorphicReferringItemInline,
            )


class PolymorphicReferringItemInline(PolymorphicAdminRawIdFix, BaseContentItemInline):
    pass

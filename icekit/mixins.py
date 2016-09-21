from unidecode import unidecode

from django.db import models
from django.contrib.contenttypes.models import ContentType
from django.template.defaultfilters import striptags

from fluent_contents.models import \
    ContentItemRelation, Placeholder, PlaceholderRelation
from fluent_contents.rendering import render_content_items

from icekit.tasks import store_readability_score
from icekit.utils.readability.readability import Readability


class LayoutFieldMixin(models.Model):
    """
    Add ``layout`` field to models that already have ``contentitem_set`` and
    ``placeholder_set`` fields.
    """
    layout = models.ForeignKey(
        'icekit.Layout',
        blank=True,
        null=True,
        related_name='%(app_label)s_%(class)s_related',
    )

    fallback_template = 'icekit/layouts/fallback_default.html'

    class Meta:
        abstract = True

    def get_layout_template_name(self):
        """
        Return ``layout.template_name`` or `fallback_template``.
        """
        if self.layout:
            return self.layout.template_name
        return self.fallback_template


class FluentFieldsMixin(LayoutFieldMixin):
    """
    Add ``layout``, ``contentitem_set`` and ``placeholder_set`` fields so we
    can add modular content with ``django-fluent-contents``.
    """
    contentitem_set = ContentItemRelation()
    placeholder_set = PlaceholderRelation()

    class Meta:
        abstract = True

    # HACK: This is needed to work-around a `django-fluent-contents` issue
    # where it cannot handle placeholders being added to a template after an
    # object already has placeholder data in the database.
    # See: https://github.com/edoburu/django-fluent-contents/pull/63
    def add_missing_placeholders(self):
        """
        Add missing placeholders from templates. Return `True` if any missing
        placeholders were created.
        """
        content_type = ContentType.objects.get_for_model(self)
        result = False
        if self.layout:
            for data in self.layout.get_placeholder_data():
                placeholder, created = Placeholder.objects.update_or_create(
                    parent_type=content_type,
                    parent_id=self.pk,
                    slot=data.slot,
                    defaults=dict(
                        role=data.role,
                        title=data.title,
                    ))
                result = result or created
        return result

    def placeholders(self):
        # return a dict of placeholders, organised by slot, for access in
        # templates use `page.placeholders.<slot_name>.get_content_items` to
        # test if a placeholder has any items.
        return dict([(p.slot, p)
                     for p in self.placeholder_set.all().select_related()])


# TODO: should be a sub-app.
class ReadabilityMixin(models.Model):
    readability_score = models.DecimalField(
        max_digits=4,
        decimal_places=2,
        null=True
    )

    class Meta:
        abstract = True

    def extract_text(self):
        # return the rendered content, with HTML tags stripped.
        html = render_content_items(
            request=None, items=self.contentitem_set.all())
        return striptags(html)

    def calculate_readability_score(self):
        try:
            return Readability(unidecode(self.extract_text())).SMOGIndex()
        except:
            return None

    def store_readability_score(self):
        store_readability_score.delay(
            self._meta.app_label, self._meta.model_name, self.pk)

    def save(self, *args, **kwargs):
        r = super(ReadabilityMixin, self).save(*args, **kwargs)
        self.store_readability_score()
        return r

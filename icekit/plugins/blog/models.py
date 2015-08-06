from django.db import models
from django.utils.encoding import python_2_unicode_compatible
from django.utils.translation import ugettext_lazy as _
from django.utils import six

from django_extensions.db.models import AutoSlugField, TimeStampedModel
from fluent_contents.models import ContentItem

from icekit.plugins.image.models import Image


@python_2_unicode_compatible
class ContentCategory(models.Model):
    """
    Provides a basic Category
    """
    name = models.CharField(
        max_length=255,
    )
    is_active = models.BooleanField(
        default=True,
    )

    def __str__(self):
        return str(self.name)


@python_2_unicode_compatible
class SingleCategoryMixin(models.Model):
    """
    Link to a single Category.
    """
    category = models.ForeignKey(
        ContentCategory,
    )

    class Meta:
        abstract = True

    def __str__(self):
        return str(self.category)


@python_2_unicode_compatible
class Location(models.Model):
    name = models.CharField(
        max_length=255,
        help_text=_('City or gallery.'),
    )
    google_map = models.URLField(
        max_length=500,
        blank=True,
        help_text=_('Optional. If a Google Maps Share URL is supplied '
                    'a hyperlink will be rendered to it.'),
    )

    def __str__(self):
        return str(self.name)


@python_2_unicode_compatible
class OptionalLocationMixin(models.Model):
    location = models.ForeignKey(
        Location,
        blank=True,
        null=True,
    )

    class Meta:
        abstract = True

    def __str__(self):
        if self.location:
            return str(self.location)
        return None


@python_2_unicode_compatible
class EventRangeMixin(models.Model):
    """
    Adds start & end date for an event or exhibition to a post.
    """
    event_start = models.DateField()
    event_end = models.DateField()

    class Meta:
        abstract = True

    def __str__(self):
        return str('%s - %s' % (self.start, self.end))


class PostManager(models.Manager):
    def all_active(self):
        return self.get_queryset().filter(is_active=True)


@python_2_unicode_compatible
class Post(
    TimeStampedModel,
    SingleCategoryMixin,
    EventRangeMixin,
    OptionalLocationMixin,
):
    """
    Contains blog content, typically news about upcoming events.

    ADC requires only basic content support but has some extra fields
    to include:
        Photo
        Event start & end dates
        Intro
        Location
        Category
    """
    photo = models.ForeignKey(
        Image
    )
    title = models.CharField(
        max_length=255,
        blank=True,
        help_text=_('The title of the post'),
    )
    slug = AutoSlugField(
        populate_from='title',
    )

    intro = models.TextField(
        blank=True,
        help_text=_('Optional, otherwise a truncated selection of the '
                    'body will be displayed'),
    )
    body = models.TextField()

    is_active = models.BooleanField(
        default=True,
    )
    admin_notes = models.TextField(
        blank=True,
        help_text=_('Internal notes for administrators only.'),
    )

    objects = PostManager()

    class Meta:
        verbose_name = _('Blog Post')
        verbose_name_plural = _('Blog Posts')
        ordering = ('-created',)

    def __str__(self):
        return str(self.title)


@python_2_unicode_compatible
class PostItem(ContentItem):
    """
    A post instance
    """
    post = models.ForeignKey(
        project.get_blog_class(),
        'Post',
        help_text=_('A blog post (unpublished items will not be visible '
                    'to the public)'),
    )

    class Meta:
        verbose_name = _('Blog Post')
        verbose_name_plural = _('Blog Posts')

    def __str__(self):
        return str(self.post)

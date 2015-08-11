from django.conf import settings
from django.db import models
from django.db.models.query import QuerySet
from django.utils.six import python_2_unicode_compatible
from django.utils.translation import ugettext_lazy as _

from django_extensions.db.models import AutoSlugField, TimeStampedModel
from fluent_contents.models import ContentItem
from polymorphic import PolymorphicModel
from icekit.plugins.image.models import Image
from model_utils.managers import PassThroughManager


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
    """
    Adds a named place relation to a Blog Post.

    e.g. Upcoming at <Museum of Contemporary Art> Oct 2015
    """
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
    """
    Adds an (optional) Location to Blog Post.
    """
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


@python_2_unicode_compatible
class SinglePhotoMixin(models.Model):
    """
    Adds a single photo to a Blog Post.
    """
    photo = models.ForeignKey(
        Image,
        blank=True,
        null=True,
    )

    class Meta:
        abstract = True

    def __str__(self):
        return str(self.photo)


class PostQuerySet(QuerySet):
    def all_active(self):
        return self.filter(is_active=True)


@python_2_unicode_compatible
class AbstractBlogPost(PolymorphicModel, TimeStampedModel):
    """
    Very basic blog post. Typically you'd want to subclass and integrate
    the mixins provided above.
    """
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

    class Meta:
        abstract = True
        verbose_name = _('Blog Post')
        verbose_name_plural = _('Blog Posts')
        ordering = ('-created',)

    def __str__(self):
        return str(self.title)


class BlogPost(AbstractBlogPost):
    objects = PassThroughManager.for_queryset_class(PostQuerySet)()


@python_2_unicode_compatible
class PostItem(ContentItem):
    """
    A post instance.

    This is a working, out-of-the-box blog item, but you probably want
    to copy this and replace the FK reference in your own site.
    """
    post = models.ForeignKey(
        'blog_tools.BlogPost',
        help_text=_('A blog post (unpublished items will not be visible '
                    'to the public)'),
        related_name='post',
    )

    class Meta:
        verbose_name = _('Blog Post')
        verbose_name_plural = _('Blog Posts')

    def __str__(self):
        return str(self.post)

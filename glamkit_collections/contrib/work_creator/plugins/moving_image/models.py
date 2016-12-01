from django.template.defaultfilters import pluralize
from django_countries.fields import CountryField
from fluent_contents.plugins.oembeditem.fields import OEmbedUrlField
from glamkit_collections.contrib.work_creator.models import WorkBase
from django.db import models
from icekit.content_collections.abstract_models import TitleSlugMixin, \
    PluralTitleSlugMixin


class Rating(TitleSlugMixin):
    image = models.ImageField(
        upload_to="collection/moving_image/rating/image/", blank=True,
    )

class Genre(TitleSlugMixin):
    pass


class MediaType(PluralTitleSlugMixin):
    pass

class MovingImageMixin(
    # ACMIContent, ACMIAttributes,
    models.Model,
):
    rating = models.ForeignKey("Rating", null=True, blank=True, on_delete=models.SET_NULL)
    rating_annotation = models.CharField(max_length=255, help_text="e.g. Contains flashing lights and quidditch", blank=True)
    genres = models.ManyToManyField("Genre", blank=True)
    media_type = models.ForeignKey("MediaType", blank=True, null=True, on_delete=models.SET_NULL)
    duration_minutes = models.PositiveIntegerField("Duration (minutes)", blank=True, null=True, help_text="How long (in minutes) should a visitor spend with this content?")
    trailer = OEmbedUrlField(blank=True)
    imdb_link = models.URLField("IMDB link", blank=True, help_text="e.g. 'http://www.imdb.com/title/tt2316801/'")

    class Meta:
        abstract = True

    def get_type(self):
        return self.media_type.title or "moving image work"

    def get_type_plural(self):
        return self.media_type.get_plural() or "moving image works"

    def get_duration(self):
        if self.duration_minutes is not None:
            return "%s mins" % self.duration_minutes
        return None


class MovingImageWork(WorkBase, MovingImageMixin):
    def get_type(self):
        # for some reason (MRO) we have to call the get_type that we want.
        # Swapping mixin order breaks other things.
        return MovingImageMixin.get_type(self)

    def get_type_plural(self):
        # for some reason (MRO) we have to call the get_type that we want.
        # Swapping mixin order breaks other things.
        return MovingImageMixin.get_type_plural(self)

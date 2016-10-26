from django_countries.fields import CountryField
from fluent_contents.plugins.oembeditem.fields import OEmbedUrlField
from glamkit_collections.contrib.work_creator.models import WorkBase
from django.db import models
from icekit.content_collections.abstract_models import TitleSlugMixin


class Rating(TitleSlugMixin):
    image = models.ImageField(
        upload_to="collection/moving_image/rating/image/", blank=True,
    )

class Genre(TitleSlugMixin):
    pass


class MediaType(TitleSlugMixin):
    pass


class MovingImageMixin(
    # ACMIContent, ACMIAttributes,
    models.Model,
):
    rating = models.ForeignKey("Rating", null=True, blank=True)
    rating_annotation = models.CharField(max_length=255, help_text="e.g. Contains flashing lights and quidditch", blank=True)
    genre = models.ForeignKey("Genre", blank=True, null=True)
    media_type = models.ForeignKey("MediaType", blank=True, null=True)
    trailer = OEmbedUrlField(blank=True)
    imdb_link = models.URLField("IMDB link", blank=True, help_text="e.g. 'http://www.imdb.com/title/tt2316801/'")

    class Meta:
        abstract = True

    def get_media_type(self):
        return self.media_type

    # TODO:
    # trailer (OEmbed)


class MovingImageWork(WorkBase, MovingImageMixin):
    pass
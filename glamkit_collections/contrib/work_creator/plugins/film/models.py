from glamkit_collections.contrib.work_creator.models import WorkBase
from django.db import models
from ..moving_image.models import MovingImageMixin
from icekit.content_collections.abstract_models import TitleSlugMixin


class FilmFormat(TitleSlugMixin):
    pass

class FilmMixin(models.Model):
    formats = models.ManyToManyField("FilmFormat", blank=True)

    class Meta:
        abstract = True

    def get_type(self):
        return self.media_type.title or "film"

    def get_type_plural(self):
        return self.media_type.get_plural() or "films"

class Film(WorkBase, FilmMixin, MovingImageMixin):
    def get_type(self):
        # for some reason (MRO) we have to call the get_type that we want.
        # Swapping mixin order breaks other things.
        return FilmMixin.get_type(self)

    def get_type_plural(self):
        # for some reason (MRO) we have to call the get_type that we want.
        # Swapping mixin order breaks other things.
        return FilmMixin.get_type_plural(self)

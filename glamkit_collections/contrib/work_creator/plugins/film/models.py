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

    def get_media_type(self):
        return self.media_type or "film"

class Film(WorkBase, FilmMixin, MovingImageMixin):
    pass
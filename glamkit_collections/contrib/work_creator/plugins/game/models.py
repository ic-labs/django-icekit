from glamkit_collections.contrib.work_creator.models import WorkBase
from django.db import models
from ..moving_image.models import MovingImageMixin
from icekit.content_collections.abstract_models import TitleSlugMixin


class GameInputType(TitleSlugMixin):
    pass


class GamePlatform(TitleSlugMixin):
    pass


class GameMixin(models.Model):
    is_single_player = models.BooleanField("Single player?", default=False)
    is_multi_player = models.BooleanField("Multiplayer?", default=False)
    input_types = models.ManyToManyField("GameInputType", blank=True, help_text="controller, touch, etc.")
    platforms = models.ManyToManyField("GamePlatform", blank=True, help_text="Xbox 360, Playstation 4, etc.")

    class Meta:
        abstract = True

    def get_media_type(self):
        return self.media_type or "game"


class Game(WorkBase, GameMixin, MovingImageMixin):
    pass
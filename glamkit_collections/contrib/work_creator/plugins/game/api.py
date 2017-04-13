from rest_framework import serializers
from rest_framework import routers

from icekit.api.base_views import ModelViewSet

from ...api_serializers import MovingImageWork
from .models import Game as GameModel, GameInputType as GameInputTypeModel, \
    GamePlatform as GamePlatformModel


VIEWNAME = 'game-api'


class GameInputType(serializers.ModelSerializer):
    class Meta:
        model = GameInputTypeModel
        fields = (
            'title',
            'slug',
        )


class GamePlatform(serializers.ModelSerializer):
    class Meta:
        model = GamePlatformModel
        fields = (
            'title',
            'slug',
        )


class Game(MovingImageWork):
    input_types = GameInputType(
        many=True,
        read_only=True,
    )
    platforms = GamePlatform(
        many=True,
        read_only=True,
    )

    class Meta:
        model = GameModel
        fields = MovingImageWork.Meta.fields + (
            # Relationships
            'input_types',
            'platforms',
            # Fields
            'is_single_player',
            'is_multi_player',
        )
        extra_kwargs = {
            'url': {
                'lookup_field': 'pk',
                'view_name': 'api:%s-detail' % VIEWNAME,
            }
        }


class APIViewSet(ModelViewSet):
    """
    Game resource
    """
    queryset = GameModel.objects.all() \
        .prefetch_related('creators', 'images')

    serializer_class = Game


router = routers.DefaultRouter()
router.register('game', APIViewSet, VIEWNAME)

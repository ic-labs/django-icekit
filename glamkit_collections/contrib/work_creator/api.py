import logging

from django.conf import settings
from django.utils.module_loading import import_string

from rest_framework import routers

from icekit.api.base_views import ModelViewSet

from .models import WorkCreator as WorkCreatorModel
from .api_serializers import WorkCreator


logger = logging.getLogger(__name__)


######################################################################
# Create and register API endpoint to mange work-creator relationships
######################################################################
class WorkCreatorAPIViewSet(ModelViewSet):
    """
    WorkCreator resource
    """
    queryset = WorkCreatorModel.objects.all() \
        .prefetch_related('work', 'creator', 'role')

    serializer_class = WorkCreator

router = routers.DefaultRouter()
router.register('workcreator', WorkCreatorAPIViewSet, 'workcreator-api')


###############################################################################
# Register additional installed plugins for plugins named in
# `COLLECTION_PLUGINS_WITH_API` as API routes.
###############################################################################
plugins_router = routers.DefaultRouter()
COLLECTION_PLUGINS_WITH_API = (
    # Works
    'artwork',
    'film',
    'game',
    # Creators
    'organization',
    'person',
)

for plugin_name in COLLECTION_PLUGINS_WITH_API:
    # Skip plugins that are not installed
    parent_module_path = '.'.join(__name__.split('.')[:-1])
    plugin_module_path = '%s.plugins.%s' % (parent_module_path, plugin_name)
    if plugin_module_path not in settings.INSTALLED_APPS:
        continue
    # Import viewset `APIViewSet` defined in all plugins' `api` modules
    viewset_dotted_path = '%s.api.APIViewSet' % plugin_module_path
    try:
        viewset = import_string(viewset_dotted_path)
    except ImportError, ex:
        logger.warn(
            "Failed to load 'APIViewSet' for plugin '%s' at '%s': %s"
            % (plugin_name, viewset_dotted_path, ex))
        continue
    # Register viewset with plugins router with default naming scheme
    plugins_router.register(plugin_name, viewset, '%s-api' % plugin_name)

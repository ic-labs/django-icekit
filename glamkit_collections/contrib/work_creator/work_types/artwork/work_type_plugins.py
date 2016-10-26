import models
from glamkit_collections.contrib.work_creator.admin import \
    WorkChildModelPlugin

class ArtworkPlugin(WorkChildModelPlugin):
    model = models.Artwork
    sort_priority = 1

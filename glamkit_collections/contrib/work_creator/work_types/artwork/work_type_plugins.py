import models, admin
from glamkit_collections.contrib.work_creator.admin import \
    WorkChildModelPlugin

class ArtworkPlugin(WorkChildModelPlugin):
    model = models.Artwork
    model_admin = admin.ArtworkAdmin
    sort_priority = 1

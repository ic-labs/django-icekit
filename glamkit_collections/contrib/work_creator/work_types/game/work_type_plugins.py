import models, admin
from glamkit_collections.contrib.work_creator.admin import \
    WorkChildModelPlugin

class GamePlugin(WorkChildModelPlugin):
    model = models.Game
    model_admin = admin.GameAdmin
    sort_priority = 2

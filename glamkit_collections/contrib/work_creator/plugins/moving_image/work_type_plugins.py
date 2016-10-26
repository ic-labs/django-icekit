import models, admin
from glamkit_collections.contrib.work_creator.admin import \
    WorkChildModelPlugin

class MovingImagePlugin(WorkChildModelPlugin):
    model = models.MovingImageWork
    model_admin = admin.MovingImageWorkAdmin
    sort_priority = 10

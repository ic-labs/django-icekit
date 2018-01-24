import models, admin
from glamkit_collections.contrib.work_creator.admin import \
    CreatorChildModelPlugin

class PersonCreatorPlugin(CreatorChildModelPlugin):
    model = models.PersonCreator
    model_admin = admin.PersonCreatorAdmin
    sort_priority = 1

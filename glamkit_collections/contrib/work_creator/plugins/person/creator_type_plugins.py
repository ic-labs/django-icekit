import models
from glamkit_collections.contrib.work_creator.admin import \
    CreatorChildModelPlugin

class PersonCreatorPlugin(CreatorChildModelPlugin):
    model = models.PersonCreator
    sort_priority = 1

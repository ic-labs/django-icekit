import models
from glamkit_collections.contrib.work_creator.admin import \
    CreatorChildModelPlugin

class OrganizationCreatorPlugin(CreatorChildModelPlugin):
    model = models.OrganizationCreator
    sort_priority = 10

import models, admin
from glamkit_collections.contrib.work_creator.admin import \
    WorkChildModelPlugin

class FilmPlugin(WorkChildModelPlugin):
    model = models.Film
    model_admin = admin.FilmAdmin
    sort_priority = 1

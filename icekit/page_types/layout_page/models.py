from . import abstract_models

class LayoutPage(abstract_models.AbstractLayoutPage):

    class Meta:
        verbose_name = "Layout page"
        # Fluent prepends `pagetype_` to the db table. This seems to break
        # Django's inference of m2m table names during migrations, when the
        # m2m is defined on an abstract model that's mixed in. Instead we
        # give the table a name that's different from the default.
        # https://github.com/django-fluent/django-fluent-pages/issues/89
        db_table = "icekit_layoutpage"
from django.db.models.query import QuerySet


class PostQuerySet(QuerySet):
    def all_active(self):
        return self.filter(is_active=True)

from django.contrib.contenttypes.models import ContentType
from django.db.models.query import QuerySet


class LayoutQuerySet(QuerySet):

    def for_model(self, model, **kwargs):
        """
        Return layouts that are allowed for the given model.
        """
        queryset = self.filter(
            content_types=ContentType.objects.get_for_model(model),
            **kwargs
        )
        return queryset

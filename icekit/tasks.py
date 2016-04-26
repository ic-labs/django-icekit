import json

try:
    from celery import shared_task
except ImportError:
    def shared_task(f):
        f.delay = f
        return f

from django.db.models.loading import get_model

@shared_task
def store_readability_score(app_label, model_name, pk):
    # non-blockingly update the readability score for this work. Needs to happen after save, as all the m2m content
    # items are relevant
    cls = get_model(app_label, model_name)
    obj = cls.objects.get(pk=pk)
    obj.readability_score = obj.calculate_readability_score()
     # avoid calling save() recursively
    type(obj).objects.filter(pk=obj.pk).update(readability_score=obj.readability_score)

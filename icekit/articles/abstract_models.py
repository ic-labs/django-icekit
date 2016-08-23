from icekit.abstract_models import FluentFieldsMixin
from icekit.publishing.models import PublishingModel
from django.db import models

class PublishableArticle(FluentFieldsMixin, PublishingModel):
    '''
    Basic Article type (ie that forms the basis of independent collections of
    publishable things).
    '''

    title = models.CharField(max_length=255)
    slug = models.SlugField(max_length=255)

    def __unicode__(self):
        return self.title

    class Meta:
        abstract = True


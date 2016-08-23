from icekit.abstract_models import FluentFieldsMixin
from icekit.publishing.models import PublishingModel
from django.db import models

# TODO: this should ideally be in icekit.abstract_models, but doing so
# creates circular import errors.
class PublishableFluentModel(FluentFieldsMixin, PublishingModel):
    class Meta:
        abstract = True


class PublishableArticle(PublishableFluentModel):
    '''
    Basic Article type (ie that forms the basis of independent collections of
    publishable things).
    '''

    # TODO: this should perhaps become part of an ICEkit mixin that covers
    # standard content behaviour.
    title = models.CharField(max_length=255)
    slug = models.SlugField(max_length=255)

    def __unicode__(self):
        return self.title

    class Meta:
        abstract = True


from icekit.abstract_models import FluentFieldsMixin
from icekit.publishing.models import PublishingModel
from django.db import models

# TODO: this should ideally be in icekit.abstract_models, but doing so
# creates circular import errors.
class PublishableFluentModel(FluentFieldsMixin, PublishingModel):
    class Meta:
        abstract = True

class TitleSlugMixin(models.Model):
    # TODO: this should perhaps become part of a wider ICEkit mixin that covers
    # standard content behaviour.

    title = models.CharField(max_length=255)
    slug = models.SlugField(max_length=255)

    class Meta:
        abstract = True

    def __unicode__(self):
        return self.title


class PublishableArticle(PublishableFluentModel, TitleSlugMixin):
    '''
    Basic Article type (ie that forms the basis of independent collections of
    publishable things).
    '''

    class Meta:
        abstract = True


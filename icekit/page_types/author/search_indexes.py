# from haystack import indexes
#
# from django.conf import settings
# from django.utils import translation
#
# from . import models
#
#
# class AuthorIndex(indexes.SearchIndex, indexes.Indexable):
#     """
#     Search index for `Author`.
#     """
#     text = indexes.CharField(document=True, use_template=True)
#     name = indexes.CharField(model_attr='title', boost=2.0)
#     url = indexes.CharField(model_attr='get_absolute_url')
#     has_url = indexes.BooleanField(model_attr='get_absolute_url')
#     # We add this for autocomplete.
#     content_auto = indexes.EdgeNgramField(model_attr='title')
#
#     def index_queryset(self, using=None):
#         """ Index only published authors """
#         # TODO Hack to activate the site language if none is yet active, to
#         # avoid complaints about null language_code when traversing the
#         # `parent` relationship -- should probably do this elsewhere?
#         if not translation.get_language():
#             translation.activate(settings.LANGUAGE_CODE)
#         return self.get_model().objects.published()
#
#     def get_model(self):
#         """
#         Get the model for the search index.
#         """
#         return models.Author

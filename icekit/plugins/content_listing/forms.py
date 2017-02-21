from fluent_contents.forms import ContentItemForm

#from icekit.content_collections.abstract_models import AbstractCollectedContent

from .models import ContentListingItem


class ContentListingAdminForm(ContentItemForm):

    class Meta:
        model = ContentListingItem
        fields = '__all__'

    # def __init__(self, *args, **kwargs):
    #     super(ContentListingAdminForm, self).__init__(*args, **kwargs)
    #     # TODO Restrict content types to those for models that are subclasses
    #     # of `AbstractCollectedContent`?
    #     valid_ct_ids = []
    #     cts_qs = self.fields['content_type'].queryset.all()
    #     for ct in cts_qs:
    #         model = ct.model_class()
    #         if model and issubclass(model, AbstractCollectedContent):
    #             valid_ct_ids.append(ct.id)
    #     cts_qs = self.fields['content_type'].queryset = \
    #         cts_qs.filter(pk__in=valid_ct_ids)

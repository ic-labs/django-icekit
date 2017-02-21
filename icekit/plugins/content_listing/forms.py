from django.forms import ModelChoiceField
from django.contrib.contenttypes.models import ContentType

from fluent_contents.forms import ContentItemForm

from .models import ContentListingItem


class ContentTypeModelChoiceField(ModelChoiceField):

    def label_from_instance(self, content_type):
        return u".".join(content_type.natural_key())


class ContentListingAdminForm(ContentItemForm):

    content_type = ContentTypeModelChoiceField(
        queryset=ContentType.objects.all()
    )

    class Meta:
        model = ContentListingItem
        fields = '__all__'

    def __init__(self, *args, **kwargs):
        super(ContentListingAdminForm, self).__init__(*args, **kwargs)
        # Apply `filter_content_types` filter
        self.fields['content_type'].queryset = self.filter_content_types(
            self.fields['content_type'].queryset)

    def filter_content_types(self, content_type_qs):
        """
        Filter the content types selectable for the content listing.

        Example to restrict content types to those for models that are
        subclasses of `AbstractCollectedContent`:

            valid_ct_ids = []
            for ct in content_type_qs:
                model = ct.model_class()
                if model and issubclass(model, AbstractCollectedContent):
                    valid_ct_ids.append(ct.id)
            return content_type_qs.filter(pk__in=valid_ct_ids)
        """
        return content_type_qs

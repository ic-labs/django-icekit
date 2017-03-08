from django.contrib.admin.widgets import ForeignKeyRawIdWidget, \
    ManyToManyRawIdWidget
from django.contrib.admin.views.main import TO_FIELD_VAR

# RAW_ID_FIELDS FIX ###########################################################
from django.contrib.contenttypes.models import ContentType


class PolymorphicForeignKeyRawIdWidget(ForeignKeyRawIdWidget):
    def url_parameters(self):
        # Returns the GET parameters passed to the model selection pop-up
        # Only invoke the custom stuff for polymorphic models
        if hasattr(self.rel.to, 'polymorphic_ctype'):
            params = {}
            to_field = self.rel.get_related_field()
            # This condition should determine whether we're looking at the
            # parent model, or one of the children
            # TODO: make this recursive to support multi-level inheritance
            if getattr(to_field, 'rel', None):
                # Fortunately, since the PK of the child is a FK to the
                # parent, the numeric PK value of the parent will be equal to
                # the child's PK numeric value
                to_field = to_field.rel.get_related_field()
                # Filter by polymorphic type. Must be unset for parent model
                params['ct_id'] = ContentType.objects.get_for_model(self.rel.to).pk
            params[TO_FIELD_VAR] = to_field.name
            return params
        return super(PolymorphicForeignKeyRawIdWidget, self).url_parameters()


class PolymorphicManyToManyRawIdWidget(PolymorphicForeignKeyRawIdWidget, ManyToManyRawIdWidget):
    pass

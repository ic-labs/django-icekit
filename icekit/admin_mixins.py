from django.contrib import admin
from fluent_contents.admin import PlaceholderEditorAdmin
from fluent_contents.models import PlaceholderData


class FluentLayoutsMixin(PlaceholderEditorAdmin):
    """
    Mixin class for models that have a ``layout`` field and fluent content.
    """

    change_form_template = 'icekit/admin/fluent_layouts_change_form.html'

    class Media:
        js = ('icekit/admin/js/fluent_layouts.js', )

    def formfield_for_foreignkey(self, db_field, *args, **kwargs):
        """
        Update queryset for ``layout`` field.
        """
        formfield = super(FluentLayoutsMixin, self).formfield_for_foreignkey(
            db_field, *args, **kwargs)
        if db_field.name == 'layout':
            formfield.queryset = formfield.queryset.for_model(self.model)
        return formfield

    def get_placeholder_data(self, request, obj):
        """
        Get placeholder data from layout.
        """
        if not obj or not obj.layout:
            data = [PlaceholderData(slot='main', role='m', title='Main')]
        else:
            data = obj.layout.get_placeholder_data()
        return data

class HeroMixinAdmin(admin.ModelAdmin):
    raw_id_fields = ('hero_image',)

    # Alas, we cannot use 'fieldsets' as it causes a recursionerror on
    # (polymorphic?) admins that use base_fieldsets.
    FIELDSETS = (
        ('Hero section', {
            'fields': (
                'hero_image',
            )
        }),
    )


class ListableMixinAdmin(admin.ModelAdmin):
    FIELDSETS = (
        ('Advanced listing options', {
            'classes': ('collapse',),
            'fields': (
                'list_image',
                'boosted_search_terms',
            )
        }),
    )

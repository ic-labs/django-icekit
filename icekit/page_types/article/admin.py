from django import forms
from django.utils.translation import ugettext_lazy as _
from fluent_pages.adminui import PageAdminForm
from fluent_pages.integration.fluent_contents.admin import FluentContentsPageAdmin
from icekit.admin import FluentLayoutsMixin

from . import models


class ArticleAdminForm(PageAdminForm):
    """
    Custom admin form for StoryPageAdmin.

    Change the status field to a hidden input and set as published by
    default.

    Change the parent field to a hidden input.
    """
    status = forms.CharField(
        widget=forms.HiddenInput,
        initial=models.ArticlePage.PUBLISHED
    )

    class Meta:
        model = models.ArticlePage
        exclude = []


class ArticlePageAdmin(FluentLayoutsMixin, FluentContentsPageAdmin):
    """
    Article Page Admin integration.
    """
    raw_id_fields = ['parent', ]
    # Change form templates that add ``content_type_id`` to the JS scope.
    change_form_template = [
        'admin/articlepage/change_form.html',
        FluentContentsPageAdmin.base_change_form_template
    ]

    base_form = ArticleAdminForm

    fieldsets = (
        (
            None, {
                'fields': ('title', 'slug', 'status', 'layout', 'parent',),
            }
        ),
        (
            _('Publication settings'), {
                'fields': ('override_url', ),
                'classes': ('collapse',),
            }
        ),
    )

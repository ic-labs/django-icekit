from icekit.admin_mixins import FluentLayoutsMixin


class CreatorAdmin(FluentLayoutsMixin):
    """
    Implementing subclasses should add

    inlines = [WorkInline]
    """

    search_fields = (
        "name_display", "name_full",
    )
    list_display = (
        'name_display',
        'artwork_count',
    )

    raw_id_fields = ['portrait', ]

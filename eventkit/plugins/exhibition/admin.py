"""
Admin configuration for ``eventkit_exhibition`` app.
"""

from icekit.admin import FluentLayoutsMixin

from eventkit.admin import EventChildAdmin
from eventkit.plugins.exhibition.admin_forms import ExhibitionForm
from eventkit.plugins.exhibition.models import Exhibition


class ExhibitionAdmin(FluentLayoutsMixin, EventChildAdmin):
    base_form = ExhibitionForm
    model = Exhibition
    raw_id_fields = ('events', )

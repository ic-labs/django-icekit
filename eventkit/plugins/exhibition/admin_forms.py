from django import forms

from eventkit.admin_forms import BaseEventForm


class ExhibitionForm(BaseEventForm):
    def __init__(self, *args, **kwargs):
        """
        Always hide ``propagate`` field. Adding it to the ``Meta.exclude``
        attribute does not seem to work.
        """
        kwargs.setdefault('initial', {})['all_day'] = True
        super(ExhibitionForm, self).__init__(*args, **kwargs)
        self.fields['recurrence_rule'].widget = forms.HiddenInput()
        self.fields['end_repeat'].widget = forms.HiddenInput()
        self.fields['propagate'].widget = forms.HiddenInput()

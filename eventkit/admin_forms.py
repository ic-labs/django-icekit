"""
Admin forms for ``eventkit`` app.
"""

from django import forms

from eventkit import models


class BaseEventForm(forms.ModelForm):
    propagate = forms.BooleanField(
        help_text='Propagate changes to all future repeat events?',
        required=False,
    )

    class Meta:
        fields = '__all__'
        model = models.Event

    def __init__(self, *args, **kwargs):
        """
        Add a ``propagate`` field for existing events.
        """
        super(BaseEventForm, self).__init__(*args, **kwargs)
        # Hide the `propagate` field when adding a new event. Repeat events are
        # always created for new events with a recurrence rule.
        if self.instance._state.adding:
            self.fields['propagate'].widget = forms.HiddenInput()

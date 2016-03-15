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
            self.fields['starts'].initial = models.default_starts()
            self.fields['ends'].initial = models.default_ends()
            self.fields['date_starts'].initial = models.default_date_starts()
            self.fields['date_ends'].initial = models.default_date_ends()

    @property
    def media(self):
        media = super(BaseEventForm, self).media
        media.add_js(['admin/js/event_all_day_field.js'])
        return media

    def clean(self):
        cleaned_data = super(BaseEventForm, self).clean()
        if self.cleaned_data.get('all_day'):
            if not self.cleaned_data.get('date_starts'):
                self.add_error(
                    'date_starts',
                    self.fields.get('date_starts').error_messages['required'])
            if not self.cleaned_data.get('date_ends'):
                self.add_error(
                    'date_ends',
                    self.fields.get('date_ends').error_messages['required'])
        else:
            if not self.cleaned_data.get('starts'):
                self.add_error(
                    'starts',
                    self.fields.get('starts').error_messages['required'])
            if not self.cleaned_data.get('ends'):
                self.add_error(
                    'ends',
                    self.fields.get('ends').error_messages['required'])

        if self.instance.id and not self.cleaned_data.get('propagate', False):
            changed_data = set(self.changed_data)
            intersection = changed_data & set(self.instance.PROPAGATE_FIELDS)
            if intersection:
                for field in intersection:
                    self.add_error(
                        field,
                        'Cannot update field'
                    )

                raise forms.ValidationError('Cannot update occurrences without propagating changes to repeat events.')

        return cleaned_data

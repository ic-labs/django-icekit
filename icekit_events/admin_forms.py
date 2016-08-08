"""
Admin forms for ``icekit_events`` app.
"""

from django import forms

from . import models


class BaseEventRepeatsGeneratorForm(forms.ModelForm):

    class Meta:
        fields = '__all__'
        model = models.EventRepeatsGenerator

    @property
    def media(self):
        media = super(BaseEventRepeatsGeneratorForm, self).media
        media.add_js(['admin/js/event_all_day_field.js'])
        return media


class BaseOccurrenceForm(forms.ModelForm):

    class Meta:
        fields = '__all__'
        model = models.Occurrence

    @property
    def media(self):
        media = super(BaseOccurrenceForm, self).media
        media.add_js(['admin/js/event_all_day_field.js'])
        return media

    def save(self, *args, **kwargs):
        # We assume any change to a model made via the admin (as opposed to
        # an ``EventRepeatsGenerator``) implies a user modification.
        occurrence = self.instance
        occurrence._flag_user_modification = True
        return super(BaseOccurrenceForm, self).save(*args, **kwargs)


class BaseEventForm(forms.ModelForm):

    class Meta:
        fields = '__all__'
        model = models.Event

    def __init__(self, *args, **kwargs):
        """
        Add a ``propagate`` field for existing events.
        """
        super(BaseEventForm, self).__init__(*args, **kwargs)

    def clean(self):
        cleaned_data = super(BaseEventForm, self).clean()
        #if self.cleaned_data.get('all_day'):
        #    if not self.cleaned_data.get('date_starts'):
        #        self.add_error(
        #            'date_starts',
        #            self.fields.get('date_starts').error_messages['required'])
        #    if not self.cleaned_data.get('date_ends'):
        #        self.add_error(
        #            'date_ends',
        #            self.fields.get('date_ends').error_messages['required'])
        #else:
        #    if not self.cleaned_data.get('starts'):
        #        self.add_error(
        #            'starts',
        #            self.fields.get('starts').error_messages['required'])
        #    if not self.cleaned_data.get('ends'):
        #        self.add_error(
        #            'ends',
        #            self.fields.get('ends').error_messages['required'])

        ## check to see whether something has been done that requires propagating.
        #if self.instance.id and not self.cleaned_data.get('propagate', False):
        #    changed_data = set(self.changed_data)
        #    # if there's a recurrence rule, or the recurrence rule has been changed.
        #    # (ie only show a propogation error on events that have repeats)
        #    if self.cleaned_data.get('recurrence_rule') or ('recurrence_rule' in changed_data):
        #        intersection = changed_data & set(self.instance.PROPAGATE_FIELDS)
        #        if intersection:
        #            for field in intersection:
        #                self.add_error(
        #                    field,
        #                    'Cannot update field'
        #                )

        #            error = 'Cannot update {} or "recurrence rule" fields without propagating changes to repeat events.'

        #            if self.cleaned_data.get('all_day'):
        #                date_fields = ['date starts', 'date ends']
        #                'starts' in intersection and date_fields.append('starts')
        #                'ends' in intersection and date_fields.append('ends')
        #            else:
        #                date_fields = ['starts', 'ends']
        #                'date_starts' in intersection and date_fields.append('date starts')
        #                'date_ends' in intersection and date_fields.append('date ends')

        #            error = error.format(', '.join(map(lambda x: '"{}"'.format(x), date_fields)))
        #            raise forms.ValidationError(error)

        return cleaned_data

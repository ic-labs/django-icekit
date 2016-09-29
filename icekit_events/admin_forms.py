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

    def clean(self):
        cleaned_data = super(BaseEventRepeatsGeneratorForm, self).clean()
        # Handle situation where hidden time fields in admin UI submit the
        # value "00:00:00" for `repeat_end` without a corresponding date.
        if 'repeat_end' in self.errors:
            if self.data.get(self.prefix + '-repeat_end_1') == '00:00:00' \
                    and not self.data.get(self.prefix + '-repeat_end_0'):
                cleaned_data['repeat_end'] = None
                del(self.errors['repeat_end'])
        return cleaned_data


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


DEFAULT_EVENT_FORM_WIDGETS = {
    'human_dates': forms.Textarea({'cols': 80, 'rows': 3}),
    'human_times': forms.Textarea({'cols': 80, 'rows': 3}),
    'special_instructions': forms.Textarea({'cols': 80, 'rows': 4}),
}


class BaseEventForm(forms.ModelForm):

    class Meta:
        fields = '__all__'
        model = models.Event
        widgets = DEFAULT_EVENT_FORM_WIDGETS


class BaseEventPageForm(forms.ModelForm):

    class Meta:
        fields = '__all__'
        model = models.EventPage
        widgets = DEFAULT_EVENT_FORM_WIDGETS

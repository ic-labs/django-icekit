"""
Forms for ``icekit_events`` app.
"""

import json

from django import forms
from django.contrib.admin.widgets import AdminTextareaWidget
from django.template import Context, loader

from . import models, validators


# WIDGETS #####################################################################


class RecurrenceRuleWidget(forms.MultiWidget):
    """
    A ``MultiWidget`` subclass that uses a ``Select`` widget for selection of
    preset recurrence rules and an ``AdminTextareaWidget`` for custom
    recurrence rules.
    """

    class Media:
        css = {
            'all': ('icekit_events/css/recurrence_rule_widget.css', ),
        }
        js = (
            'icekit_events/bower_components/lodash/lodash.js',
            'icekit_events/bower_components/skveege-rrule/lib/rrule.js',
            'icekit_events/bower_components/skveege-rrule/lib/nlp.js',
        )

    def __init__(self, *args, **kwargs):
        """
        Set the default widgets and queryset.
        """
        widgets = kwargs.pop('widgets', (
            forms.Select,
            AdminTextareaWidget,
            AdminTextareaWidget,
        ))
        super(RecurrenceRuleWidget, self).__init__(
            widgets=widgets, *args, **kwargs)
        self.queryset = models.RecurrenceRule.objects.all()

    def _get_choices(self):
        """
        Return choices from the ``Select`` widget.
        """
        return self.widgets[0].choices

    def _set_choices(self, value):
        """
        Set choices on the ``Select`` widget.
        """
        self.widgets[0].choices = value

    choices = property(_get_choices, _set_choices)

    def decompress(self, value):
        """
        Return the primary key value for the ``Select`` widget if the given
        recurrence rule exists in the queryset.
        """
        if value:
            try:
                pk = self.queryset.get(recurrence_rule=value).pk
            except self.queryset.model.DoesNotExist:
                pk = None
            return [pk, None, value]
        return [None, None, None]

    def format_output(self, rendered_widgets):
        """
        Render the ``icekit_events/recurrence_rule_widget/format_output.html``
        template with the following context:

            preset
                A choice field for preset recurrence rules.
            natural
                An input field for natural language recurrence rules.
            rfc
                A text field for RFC compliant recurrence rules.

        The default template positions the ``preset`` field above the
        ``natural`` and ``rfc`` fields.
        """
        template = loader.get_template(
            'icekit_events/recurrence_rule_widget/format_output.html')
        preset, natural, rfc = rendered_widgets
        context = Context({
            'preset': preset,
            'natural': natural,
            'rfc': rfc,
        })
        return template.render(context)

    def render(self, name, value, attrs=None):
        """
        Render the ``icekit_events/recurrence_rule_widget/render.html``
        template with the following context:

            rendered_widgets
                The rendered widgets.
            id
                The ``id`` attribute from the ``attrs`` keyword argument.
            recurrence_rules
                A JSON object mapping recurrence rules to their primary keys.

        The default template adds JavaScript event handlers that update the
        ``Textarea`` and ``Select`` widgets when they are updated.
        """
        rendered_widgets = super(RecurrenceRuleWidget, self).render(
            name, value, attrs)
        template = loader.get_template(
            'icekit_events/recurrence_rule_widget/render.html')
        recurrence_rules = json.dumps(dict(
            self.queryset.values_list('pk', 'recurrence_rule')))
        context = Context({
            'rendered_widgets': rendered_widgets,
            'id': attrs['id'],
            'recurrence_rules': recurrence_rules,
        })
        return template.render(context)


# FIELDS ######################################################################


class RecurrenceRuleField(forms.MultiValueField):
    """
    A ``MultiValueField`` subclass that uses a ``ModelChoiceField`` for
    selection of preset recurrence rules and a ``CharField`` for input of
    natural language and RFC recurrence rules.
    """
    widget = RecurrenceRuleWidget

    def __init__(self, *args, **kwargs):
        """
        Set the default fields and queryset.
        """
        # Parse keyword arguments and pass through to each field appropriately.
        queryset = kwargs.pop('queryset', models.RecurrenceRule.objects.all())
        max_length = kwargs.pop('max_length', None)
        validators_ = kwargs.pop('validators', [validators.recurrence_rule])
        fields = (
            forms.ModelChoiceField(queryset=queryset, required=False),
            forms.CharField(required=False),
            forms.CharField(max_length=max_length, validators=validators_),
        )
        kwargs.setdefault('fields', fields)
        kwargs.setdefault('require_all_fields', False)
        super(RecurrenceRuleField, self).__init__(*args, **kwargs)
        self.queryset = queryset

    def compress(self, values):
        """
        Always return the value from the RFC field, even when a preset is
        selected. The recurrence rule is always defined in the RFC field.
        """
        if values:
            return values[2]

    def _get_queryset(self):
        """
        Return the queryset from the ``ModelChoiceField``.
        """
        return self.fields[0].queryset

    def _set_queryset(self, queryset):
        """
        Set the queryset on the ``ModelChoiceField`` and choices on the widget.
        """
        self.fields[0].queryset = self.widget.queryset = queryset
        self.widget.choices = self.fields[0].choices

    def _has_changed(self, initial, data):
        # override to return True only if the last field has changed.
        if initial is None:
            initial = ['' for x in range(0, len(data))]
        else:
            if not isinstance(initial, list):
                initial = self.widget.decompress(initial)

        try:
            field, initial, data = zip(self.fields, initial, data)[-1]
        except IndexError:
            return False

        try:
            initial = field.to_python(initial)
        except forms.ValidationError:
            return True
        if field._has_changed(initial, data):
            return True
        return False

    queryset = property(_get_queryset, _set_queryset)

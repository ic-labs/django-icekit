import re
import uuid

from django.conf import settings
from django.contrib.admin.widgets import ForeignKeyRawIdWidget, \
    ManyToManyRawIdWidget
from django.contrib.admin.views.main import TO_FIELD_VAR

from django.contrib.contenttypes.models import ContentType
from django.forms import widgets
from django.utils.formats import get_format
from django.utils.safestring import mark_safe
from django.utils.six import string_types

################################################################################
# RAW_ID_FIELDS FIX
################################################################################
class PolymorphicForeignKeyRawIdWidget(ForeignKeyRawIdWidget):
    def url_parameters(self):
        # Returns the GET parameters passed to the model selection pop-up
        # Only invoke the custom stuff for polymorphic models
        if hasattr(self.rel.to, 'polymorphic_ctype'):
            params = {}
            to_field = self.rel.get_related_field()
            # This condition should determine whether we're looking at the
            # parent model, or one of the children
            # TODO: make this recursive to support multi-level inheritance
            if getattr(to_field, 'rel', None):
                # Fortunately, since the PK of the child is a FK to the
                # parent, the numeric PK value of the parent will be equal to
                # the child's PK numeric value
                to_field = to_field.rel.get_related_field()
                # Filter by polymorphic type. Must be unset for parent model
                params['ct_id'] = ContentType.objects.get_for_model(self.rel.to).pk
            params[TO_FIELD_VAR] = to_field.name
            return params
        return super(PolymorphicForeignKeyRawIdWidget, self).url_parameters()


class PolymorphicManyToManyRawIdWidget(PolymorphicForeignKeyRawIdWidget, ManyToManyRawIdWidget):
    pass

################################################################################
# BOOTSTRAP DATETIME PICKER
# adapted from https://github.com/asaglimbeni/django-datetime-widget
################################################################################
try:
    from django.forms.widgets import to_current_timezone
except ImportError:
    to_current_timezone = lambda obj: obj # passthrough, no tz support


dateConversiontoPython = {
    'P': '%p',
    'ss': '%S',
    'ii': '%M',
    'hh': '%H',
    'HH': '%I',
    'dd': '%d',
    'mm': '%m',
    'yy': '%y',
    'yyyy': '%Y',
}


toPython_re = re.compile(r'\b(' + '|'.join(dateConversiontoPython.keys()) + r')\b')


dateConversiontoJavascript = {
    '%M': 'mm', # minute as a zero-padded decimal .. 00 01 ... 58 59
    '%m': 'MM', # month as a zero-padded decimal .. 09
    '%I': 'hh', # Hour (12-hour clock) as a zero-padded decimal
    '%H': 'HH', # Hour (24-hour clock) as a zero-padded decimal
    '%d': 'DD', # Day of the month as a zero-padded decimal number
    '%Y': 'YYYY', # Year with century as a decimal number
    '%y': 'YY', # Year without century as a zero-padded decimal number
    '%p': 'A', # Locale's equivalent of either AM or PM.
    '%S': 'ss', # Second as a zero-padded decimal number.
    '%f': 'SSSSSS', # Microsecond as a decimal number, zero-padded on the left. 000000
}


toJavascript_re = re.compile(r'(?<!\w)(' + '|'.join(dateConversiontoJavascript.keys()) + r')\b')


BOOTSTRAP_INPUT_TEMPLATE = """
        <div class='input-group date'>
           %(rendered_widget)s
        </div>
        <script type="text/javascript">
            (function($) {
                var $el = $('#%(id)s')
                $el.datetimepicker({%(options)s})
                    .find('input').addClass("form-control")
                $el.closest('.form-row').css("overflow", "visible");

            })(window.jQuery || django.jQuery);
        </script>
"""

# CLEAR_BTN_TEMPLATE = """<span class="input-group-addon"><span class="glyphicon glyphicon-remove"></span></span>"""


quoted_options = {
    'format',
    'dayViewHeaderFormat',
    'minDate',
    'maxDate',
    'locale',
    'defaultDate',
    'viewMode',
    'toolbarPlacement',
}


# to traslate boolean object to javascript
quoted_bool_options = {
    'extraFormats',
    'minDate',
    'maxDate',
    'useCurrent',
    'collapse',
    'defaultDate',
    'disabledDates',
    'enabledDates',
    'useStrict',
    'sideBySide',
    'calendarWeeks',
    'showTodayButton',
    'showClear',
    'showClose',
    'keepOpen',
    'inline',
    'keepInvalid',
    'debug',
    'ignoreReadonly',
    'disabledTimeIntervals',
    'allowInputToggle',
    'focusOnShow',
    'enabledHours',
    'enabledHours',
    'viewDate',
}


def quote(key, value):
    """Certain options support string values. We want clients to be able to pass Python strings in
    but we need them to be quoted in the output. Unfortunately some of those options also allow
    numbers so we type check the value before wrapping it in quotes.
    """

    if key in quoted_options and isinstance(value, string_types):
        return "'%s'" % value

    if key in quoted_bool_options and isinstance(value, bool):
        return {True:'true',False:'false'}[value]

    return value

class PickerWidgetMixin(object):

    format_name = None
    glyphicon = None

    def __init__(self, attrs=None, options=None):

        if attrs is None:
            attrs = {}

        if options is None:
            options = {}

        options.setdefault('stepping', 5) # number of minutes to jump, default 1
        options.setdefault('viewMode', 'months')
        options.setdefault('showClear', True)
        # 'debug' is handy for tweaking styles
        # options.setdefault('debug', True)

        self.options = options

        self.is_localized = False
        self.format = None

        # We want to have a Javascript style date format specifier in the options dictionary and we
        # want a Python style date format specifier as a member variable for parsing the date string
        # from the form data
        if settings.USE_L10N:
            # If we're doing localisation, get the local Python date format and convert it to
            # Javascript data format for the options dictionary
            self.is_localized = True

            # Get format from django format system
            self.format = get_format(self.format_name)[0]

            # Convert Python format specifier to Javascript format specifier
            self.options.setdefault('format', toJavascript_re.sub(
                lambda x: dateConversiontoJavascript[x.group()],
                self.format
            ))

        else:

            # If we're not doing localisation, get the Javascript date format provided by the user,
            # with a default, and convert it to a Python data format for later string parsing
            # format = self.options['format']
            self.format = toPython_re.sub(
                lambda x: dateConversiontoPython[x.group()],
                format
            )

        super(PickerWidgetMixin, self).__init__(attrs, format=self.format)

    def render(self, name, value, attrs=None):
        final_attrs = self.build_attrs(attrs)
        rendered_widget = super(PickerWidgetMixin, self).render(name, value, final_attrs)

        # Build javascript options out of python dictionary
        options_list = []
        for key, value in iter(self.options.items()):
            options_list.append("%s: %s" % (key, quote(key, value)))

        js_options = ",\n".join(options_list)

        # Use provided id or generate hex to avoid collisions in document
        id = final_attrs.get('id', uuid.uuid4().hex)

        return mark_safe(
            BOOTSTRAP_INPUT_TEMPLATE % dict(
                id=id,
                rendered_widget=rendered_widget,
                options=js_options
            )
        )

    def _media(self):
        return widgets.Media(
            css={
                'all': ('eonasdan-bootstrap-datetimepicker/build/css/bootstrap-datetimepicker.css',)
                },
            js=[
                "moment/moment.js",
                "eonasdan-bootstrap-datetimepicker/build/js/bootstrap-datetimepicker.min.js",
            ]
        )
    media = property(_media)


class DateTimeWidget(PickerWidgetMixin, widgets.DateTimeInput):
    """
    DateTimeWidget is the corresponding widget for Datetime field, it renders both the date and time
    sections of the datetime picker.
    """

    format_name = 'DATETIME_INPUT_FORMATS'
    glyphicon = 'glyphicon-th'

    def __init__(self, attrs=None, options=None):

        if options is None:
            options = {}

        options.setdefault('sideBySide', True)

        super(DateTimeWidget, self).__init__(attrs, options)


class DateWidget(PickerWidgetMixin, widgets.DateInput):
    """
    DateWidget is the corresponding widget for Date field, it renders only the date section of
    datetime picker.
    """

    format_name = 'DATE_INPUT_FORMATS'
    glyphicon = 'glyphicon-calendar'

    def __init__(self, attrs=None, options=None):

        if options is None:
            options = {}

        super(DateWidget, self).__init__(attrs, options)


class TimeWidget(PickerWidgetMixin, widgets.TimeInput):
    """
    TimeWidget is the corresponding widget for Time field, it renders only the time section of
    datetime picker.
    """

    format_name = 'TIME_INPUT_FORMATS'
    glyphicon = 'glyphicon-time'

    def __init__(self, attrs=None, options=None):

        if options is None:
            options = {}

        super(TimeWidget, self).__init__(attrs, options)

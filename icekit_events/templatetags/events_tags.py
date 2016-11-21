from datetime import timedelta
from django import template
from django.template.defaultfilters import time
from django.template.defaultfilters import date as datefilter
from django.utils.safestring import mark_safe
from icekit.templatetags.icekit_tags import grammatical_join

register = template.Library()

@register.filter
def timesf(times_list, format=None):
    """
    :param times_list: the list of times to format
    :param format: the format to apply (default = settings.TIME_FORMAT)
    :return: the times, formatted according to the format
    """
    return [time(t, format) for t in times_list]

@register.filter
def times_range(event, format=None):
    sts = timesf(event.start_times_set(), format=format)
    all_days = event.occurrences.filter(is_all_day=True)
    if all_days:
        sts = ["all day"] + sts

    times = grammatical_join(sts, final_join=", ")
    return times


@register.filter
def add_days(date, days):
    return date + timedelta(days)


@register.filter(is_safe=True)
def dates_range(event, format=""):
    date_format = None
    separator = "&nbsp;&ndash; "
    from_text = "from "
    to_text = "to "
    arg_list = [arg.strip() for arg in format.split(',')]
    if arg_list:
        date_format = arg_list[0]
        try:
            separator = arg_list[1]
            from_text = arg_list[2]
            to_text = arg_list[2]
        except IndexError:
            pass

    if event.human_dates:
        return event.human_dates
    else:
        first, last = event.get_occurrences_range()
        if first:
            start = first.local_start
        if last:
            end = last.local_end

        if not (first or last):
            return ''
        elif first and not last:
            return '%s %s' % (from_text, datefilter(start, date_format))
        elif last and not first:
            return '%s %s' % (to_text, datefilter(end, date_format))
        else:
            return mark_safe('%s%s%s' % (
                datefilter(start, date_format),
                separator,
                datefilter(end, date_format)
            ))
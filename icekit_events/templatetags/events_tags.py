import re
from datetime import timedelta
from django import template
from django.conf import settings
from django.template.defaultfilters import time
from django.template.defaultfilters import date as datefilter
from django.utils.formats import get_format
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
    if event.human_times:
        return event.human_times.strip()

    sts = timesf(event.start_times_set(), format=format)
    all_days = event.get_occurrences().filter(is_all_day=True)
    if all_days:
        sts = ["all day"] + sts

    if len(sts) > 3:
        return "Various times"
    times = grammatical_join(sts, final_join=", ")
    return times


@register.filter
def add_days(date, days):
    return date + timedelta(days)


YEAR_RE = r"\W*(o|y|Y)\W*" # year markers, plus any surrounding non-word text
MONTH_RE = r"\W*(b|E|F|m|M|n|N|S|t)\W*" # month markers, plus any surrounding non-word text

def _format_with_same_year(format_specifier):
    """
    Return a version of `format_specifier` that renders a date
    assuming it has the same year as another date. Usually this means ommitting
    the year.
    
    This can be overridden by specifying a format that has `_SAME_YEAR` appended
    to the name in the project's `formats` spec.
    """
    # gotta use a janky way of resolving the format
    test_format_specifier = format_specifier + "_SAME_YEAR"
    test_format = get_format(test_format_specifier, use_l10n=True)
    if test_format == test_format_specifier:
        # this format string didn't resolve to anything and may be a raw format.
        # Use a regex to remove year markers instead.
        return re.sub(YEAR_RE, '', get_format(format_specifier))
    else:
        return test_format

def _format_with_same_year_and_month(format_specifier):
    """
    Return a version of `format_specifier` that renders a date
    assuming it has the same year and month as another date. Usually this 
    means ommitting the year and month.

    This can be overridden by specifying a format that has 
    `_SAME_YEAR_SAME_MONTH` appended to the name in the project's `formats` 
    spec.
    """
    test_format_specifier = format_specifier + "_SAME_YEAR_SAME_MONTH"
    test_format = get_format(test_format_specifier, use_l10n=True)
    if test_format == test_format_specifier:
        # this format string didn't resolve to anything and may be a raw format.
        # Use a regex to remove year and month markers instead.
        no_year = re.sub(YEAR_RE, '', get_format(format_specifier))
        return re.sub(MONTH_RE, '', no_year)
    else:
        return test_format

@register.filter(is_safe=True)
def dates_range(event, format=""):
    """
    :param event: An Event 
    :param format: A |-separated string specifying:
        date_format - a format specifier
        separator - the string to join the start and end dates with, if they're 
            different
        no_dates_text - text to return if the event has no occurrences, 
            default ''
        from_text - text to prepend if the event never ends (the 'last' date is 
            None)
    :return: text describing the date range for the event. If human dates are 
    given, use that, otherwise, use the first and last occurrences for an event.

    If the first and last dates have year or year and month in common, 
    the format string for the first date is modified to exclude those items.
    
    If the first and last dates are equal, only the first date is used (ie with
    no range)

    You can override this behaviour by specifying additional formats with
    "_SAME_YEAR" and "_SAME_YEAR_SAME_MONTH" appended to the name.
    """

    # TODO: factor out a more general filter that accepts 1-2 dates and
    # renders the range.

    if event.human_dates:
        return event.human_dates.strip()

    # resolve arguments
    date_format = settings.DATE_FORMAT # Django's default
    separator = "&nbsp;&ndash; "
    no_dates_text = ''
    from_text = "from "
    arg_list = [arg.strip() for arg in format.split('|')]
    if arg_list:
        date_format = arg_list[0]
        try:
            separator = arg_list[1]
            no_dates_text = arg_list[2]
            from_text = arg_list[3]
        except IndexError:
            pass

    # Get the dates from the occurrence
    first, last = event.get_occurrences_range()
    start, end = None, None
    if first:
        start = first.local_start
    if last:
        end = last.local_end

    # figure out to what extent the dates differ
    if start and end:
        first_date_format = get_format(date_format, use_l10n=True)
        if start.year == end.year:
            # use a first_date_format without the year
            first_date_format = _format_with_same_year(date_format)
            if start.month == end.month:
                # remove month spec from first_date_format
                first_date_format = _format_with_same_year_and_month(date_format)
                if start.day == end.day:
                    # the two dates are equal, just return one date.
                    return mark_safe(datefilter(start, date_format))

        return mark_safe('%s%s%s' % (
            datefilter(start, first_date_format),
            separator,
            datefilter(end, date_format)
        ))

    elif start and not end:
        return '%s%s' % (from_text, datefilter(start, date_format))
    elif not (start or end):
        return no_dates_text
    else:
        raise AssertionError("Got a date range that has a last date but no first date")

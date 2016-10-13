import math
from django.utils import six
from django.http import Http404
from el_pagination.utils import get_page_numbers


# We use a subclass of Http404 so that unexpected page numbers
# are handled by default by Django
class PageNumberOutOfBounds(Http404):
    pass


def describe_page_numbers(current_page, total_count, per_page, page_numbers_at_ends=3, pages_numbers_around_current=3):
    """
    Produces a description of how to display a paginated list's page numbers. Rather than just
    spitting out a list of every page available, the page numbers returned will be trimmed
    to display only the immediate numbers around the start, end, and the current page.

    :param current_page: the current page number (page numbers should start at 1)
    :param total_count: the total number of items that are being paginated
    :param per_page: the number of items that are displayed per page
    :param page_numbers_at_ends: the amount of page numbers to display at the beginning and end of the list
    :param pages_numbers_around_current: the amount of page numbers to display around the currently selected page

    :return: a dictionary describing the page numbers, relative to the current page
    """
    if total_count:
        page_count = int(math.ceil(1.0 * total_count / per_page))
        if page_count < current_page:
            raise PageNumberOutOfBounds
        page_numbers = get_page_numbers(
            current_page=current_page,
            num_pages=page_count,
            extremes=page_numbers_at_ends,
            arounds=pages_numbers_around_current,
        )
    else:
        page_count = 0
        page_numbers = []

    return {
        'numbers': [num for num in page_numbers if not isinstance(num, six.string_types)],
        'has_previous': 'previous' in page_numbers,
        'has_next': 'next' in page_numbers,
        'current_page': current_page,
        'previous_page': current_page - 1,
        'next_page': current_page + 1,
        'total_count': total_count,
        'page_count': page_count,
        'per_page': per_page,
    }

import math
from django.utils import six
from el_pagination.utils import get_page_numbers
from pprint import pprint

def describe_page_numbers(current_page, total_count, per_page, page_numbers_at_ends=3, pages_numbers_around_current=3):
    """
    Produces a description of how to display a paginated list's page numbers. Rather than just
    spitting out a list of every page available, the page numbers returned will be trimmed
    to display only the immediate numbers around the start, end, and the current page.

    ```
    >>> pprint(describe_page_numbers(1, 500, 10))
    {'current_page': 1,
     'has_next': True,
     'has_previous': False,
     'next_page': 2,
     'numbers': [1, 2, 3, 4, None, 48, 49, 50],
     'per_page': 10,
     'previous_page': 0,
     'total_count': 500}

    >>> pprint(describe_page_numbers(10, 500, 10))
    {'current_page': 10,
     'has_next': True,
     'has_previous': True,
     'next_page': 11,
     'numbers': [1, 2, 3, None, 7, 8, 9, 10, 11, 12, 13, None, 48, 49, 50],
     'per_page': 10,
     'previous_page': 9,
     'total_count': 500}

    >>> pprint(describe_page_numbers(50, 500, 10))
    {'current_page': 50,
     'has_next': False,
     'has_previous': True,
     'next_page': 51,
     'numbers': [1, 2, 3, None, 47, 48, 49, 50],
     'per_page': 10,
     'previous_page': 49,
     'total_count': 500}

    >>> pprint(describe_page_numbers(2, 40, 10))
    {'current_page': 2,
     'has_next': True,
     'has_previous': True,
     'next_page': 3,
     'numbers': [1, 2, 3, 4],
     'per_page': 10,
     'previous_page': 1,
     'total_count': 40}

    # total_count / per_page == 0 - need float math
    >>> pprint(describe_page_numbers(1, 1, 20))
    {'current_page': 1,
     'has_next': False,
     'has_previous': False,
     'next_page': 2,
     'numbers': [1],
     'per_page': 20,
     'previous_page': 0,
     'total_count': 1}

    # empty results - total_count==0
    >>> pprint(describe_page_numbers(1, 0, 20))
    {'current_page': 1,
     'has_next': False,
     'has_previous': False,
     'next_page': 2,
     'numbers': [],
     'per_page': 20,
     'previous_page': 0,
     'total_count': 0}

    ```

    :param current_page: the current page number (page numbers should start at 1)
    :param total_count: the total number of items that are being paginated
    :param per_page: the number of items that are displayed per page
    :param page_numbers_at_ends: the amount of page numbers to display at the beginning and end of the list
    :param pages_numbers_around_current: the amount of page numbers to display around the currently selected page

    :return: a dictionary describing the page numbers, relative to the current page
    """
    if total_count:
        page_numbers = get_page_numbers(
            current_page=current_page,
            num_pages=int(math.ceil(1.0 * total_count / per_page)),
            extremes=page_numbers_at_ends,
            arounds=pages_numbers_around_current,
        )
    else:
        page_numbers = []

    return {
        'numbers': [num for num in page_numbers if not isinstance(num, six.string_types)],
        'has_previous': 'previous' in page_numbers,
        'has_next': 'next' in page_numbers,
        'current_page': current_page,
        'previous_page': current_page - 1,
        'next_page': current_page + 1,
        'total_count': total_count,
        'per_page': per_page,
    }

if __name__ == "__main__":
    import doctest
    doctest.testmod()

def dedupe_and_sort(sequence, sorted_sequence=None):
    """
    De-dupe and partially sort a sequence. The `sorted_sequence` argument
    should contain all the items that might appear in `sequence` and for which
    the order (relative to each other) is important.

    For example, `INSTALLED_APPS` and `MIDDLEWARE_CLASSES` settings.

    Items from `sorted_sequence` will only be included if they also appear in
    `sequence`.

    Items from `sequence` that don't appear in `sorted_sequence` will come
    after any that do, and retain their existing order.

    Returns a sequence of the same as given.
    """
    sorted_sequence = sorted_sequence or []
    # First, add items from the sorted sequence that intersect with the main
    # sequence.
    new_sequence = [i for i in sorted_sequence if i in sequence]
    # Then, add the remaining items from the main sequence in their current
    # order, ignoring duplicates.
    for item in sequence:
        if item not in new_sequence:
            new_sequence.append(item)
    # Return a sequence of the same type as given.
    return type(sequence)(new_sequence)


def slice_sequences(sequences, start, end):
    """
    Performs a slice across multiple sequences.
    Useful when paginating across chained collections.

    ```
    >>> slice_sequences([[[1, 2, 3], 3], [[4, 5, 6, 7], 4]], 0, 2)
    [1, 2]
    >>> slice_sequences([[[1, 2, 3], 3], [[4, 5, 6, 7], 4]], 2, 4)
    [3, 4]
    >>> slice_sequences([[[1, 2, 3], 3], [[4, 5, 6, 7], 4]], 4, 6)
    [5, 6]
    >>> slice_sequences([[[1, 2, 3], 3], [[4, 5, 6, 7], 4]], 6, 8)
    [7]
    >>> slice_sequences([[[1, 2, 3], 3], [[4, 5, 6, 7], 4]], 0, 10)
    [1, 2, 3, 4, 5, 6, 7]
    >>> slice_sequences([[[1, 2, 3], 3], [[4, 5, 6, 7], 4]], 0, 4)
    [1, 2, 3, 4]
    >>> slice_sequences([[[1, 2, 3], 3], [[4, 5, 6, 7], 4]], 1, 5)
    [2, 3, 4, 5]
    >>> slice_sequences([[[1, 2, 3], 3], [[4, 5, 6, 7], 4]], 3, 11)
    [4, 5, 6, 7]
    >>> slice_sequences([[[1, 2, 3], 3], [[4, 5, 6, 7], 4]], 100, 200)
    []
    >>> slice_sequences([[[1, 2, 3], 3], [[4, 5, 6, 7], 4]], -100, 200)
    Traceback (most recent call last):
     ...
    ValueError: Start and/or End out of range. Start: -100. End: 200
    >>> slice_sequences([[[1, 2, 3], 3], [[4, 5, 6, 7], 4]], 200, 100)
    Traceback (most recent call last):
     ...
    ValueError: Start and/or End out of range. Start: 200. End: 100
    >>> slice_sequences([[[1, 2, 3], 3], [[4, 5, 6, 7], 4]], 100, 100)
    Traceback (most recent call last):
     ...
    ValueError: Start and/or End out of range. Start: 100. End: 100

    ```

    :param sequences: an iterable of iterables, each nested iterable should contain
      a sequence and its size
    :param start: starting index to apply the slice from
    :param end: index that the slice should end at

    :return: a list of the items sliced from the sequences
    """

    if start < 0 or end < 0 or end <= start:
        raise ValueError('Start and/or End out of range. Start: %s. End: %s' % (start, end))

    items_to_take = end - start
    items_passed = 0
    collected_items = []

    for collection, count in sequences:
        offset_start = start - items_passed
        offset_end = end - items_passed

        if items_passed == start:
            items = collection[:items_to_take]
        elif 0 < offset_start < count:
            items = collection[offset_start:offset_end]
        elif offset_start < 0:
            items = collection[:offset_end]
        else:
            items = []

        items = list(items)
        collected_items += items
        items_to_take -= len(items)
        items_passed += count

        if items_passed > end or items_to_take == 0:
            break

    return collected_items

if __name__ == "__main__":
    import doctest
    doctest.testmod()

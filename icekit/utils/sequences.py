def dedupe_and_sort(sequence, first=None, last=None):
    """
    De-dupe and partially sort a sequence.

    The `first` argument should contain all the items that might appear in
    `sequence` and for which the order (relative to each other) is important.

    The `last` argument is the same, but matching items will be placed at the
    end of the sequence.

    For example, `INSTALLED_APPS` and `MIDDLEWARE_CLASSES` settings.

    Items from `first` will only be included if they also appear in `sequence`.

    Items from `sequence` that don't appear in `first` will come
    after any that do, and retain their existing order.

    Returns a sequence of the same as given.
    """
    first = first or []
    last = last or []
    # Add items that should be sorted first.
    new_sequence = [i for i in first if i in sequence]
    # Add remaining items in their current order, ignoring duplicates and items
    # that should be sorted last.
    for item in sequence:
        if item not in new_sequence and item not in last:
            new_sequence.append(item)
    # Add items that should be sorted last.
    new_sequence.extend([i for i in last if i in sequence])
    # Return a sequence of the same type as given.
    return type(sequence)(new_sequence)


def slice_sequences(sequences, start, end):
    """
    Performs a slice across multiple sequences.
    Useful when paginating across chained collections.

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

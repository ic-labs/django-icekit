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

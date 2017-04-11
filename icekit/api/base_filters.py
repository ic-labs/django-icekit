import rest_framework_filters as filters


class CaseInsensitiveBooleanFilter(filters.Filter):
    def filter(self, qs, value):
        if value is not None:
            lc_value = value.lower()
            if lc_value == "true":
                value = True
            elif lc_value == "false":
                value = False
            return qs.filter(**{self.name: value})
        return qs


class WorkHasImagesFilter(filters.Filter):
    """
    Filter for choosing only works with images.
    """
    def filter(self, qs, value):
        # the __isnull filter inverts meaning of true/false
        if value.lower() == 'false' or value == '0':
            v = True
        else:
            v = False

        return qs.filter(images__isnull=v)

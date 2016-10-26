from django.db.models import ImageField

class QuietImageField(ImageField):
    """An imagefield that doesn't lose the plot when trying to find the
    dimensions of an image that doesn't exist"""
    def update_dimension_fields(self, *args, **kwargs):
        try:
            super(QuietImageField, self).update_dimension_fields(*args, **kwargs)
        except:
            pass

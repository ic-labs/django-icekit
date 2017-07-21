from django.conf import settings


try:
    GOOGLE_MAPS_API_KEY = settings.GOOGLE_MAPS_API_KEY
except AttributeError:
    GOOGLE_MAPS_API_KEY = ''

from django.conf.urls import url, include
from rest_framework import routers

from . import views


# Obtain the default router and register the PageViewSet
router = routers.DefaultRouter()
router.register(r'pages', views.PageViewSet)

# Define the URL patterns based upon the default router config.
urlpatterns = [
    url(r'^', include(router.urls)),
]

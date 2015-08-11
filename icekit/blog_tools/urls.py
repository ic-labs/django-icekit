from django.conf.urls import patterns, url

from .views import BlogDetailView, BlogListView


urlpatterns = patterns('',
    url(r'^(?P<pk>[0-9]+)/$', BlogDetailView.as_view(), name='detail'),
    url(r'^$', BlogListView.as_view(), name='list'),
)

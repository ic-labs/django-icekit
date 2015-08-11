from django.apps import apps
from django.conf import settings
from django.views.generic.detail import DetailView
from django.views.generic.list import ListView

icekit_blog_model = getattr(settings, 'ICEKIT_BLOG_MODEL', 'blog_tools.BlogPost')
BLOG_MODEL = apps.get_model(*icekit_blog_model.rsplit('.', 1))


class BlogListView(ListView):
    model = BLOG_MODEL
    template_name = 'icekit/plugins/post/list.html'
    queryset = BLOG_MODEL.objects.all_active()


class BlogDetailView(DetailView):
    model = BLOG_MODEL
    template_name = 'icekit/plugins/post/detail.html'

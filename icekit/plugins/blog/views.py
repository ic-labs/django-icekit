from django.views.generic.detail import DetailView
from django.views.generic.list import ListView

from .models import Post


class BlogListView(ListView):
    model = Post
    template_name = 'icekit/plugins/post/list.html'
    queryset = Post.objects.all_active()


class BlogDetailView(DetailView):
    model = Post
    template_name = 'icekit/plugins/post/detail.html'


import inspect
from django.core.management.base import BaseCommand
from django.template.loader import get_template
from django.template.base import TemplateDoesNotExist
from django.utils.encoding import force_text


class Command(BaseCommand):
    help = '''\
Outputs a list of the installed fluent plugins.
Usage: ./manage.py fluent_plugins

Accepts an optional keyword for filtering of plugins.
Usage: ./manage.py fluent_plugins video
    '''

    def handle(self, plugin_filter=None, *args, **options):
        for plugin in describe_fluent_content_plugins():
            if plugin_filter:
                match = False
                for value in plugin.values():
                    # print plugin_filter, value
                    if value and plugin_filter.lower() in value.lower():
                        match = True
                if not match:
                    continue

            print plugin['verbose_name']
            for key in ('class', 'source_file', 'render_template', 'path_to_render_template'):
                name = ' '.join(key.split('_'))
                name = name[0].title() + name[1:]
                print '%s: %s' % (name, plugin[key])
            print '\n',


def describe_fluent_content_plugins():
    from fluent_contents.extensions import plugin_pool
    plugins = plugin_pool.get_plugins()
    return [describe_fluent_content_plugin(plugin) for plugin in plugins]


def describe_fluent_content_plugin(plugin):
    render_template = plugin.render_template

    if render_template:
        try:
            path_to_render_template = get_template(render_template).origin.name
        except TemplateDoesNotExist:
            path_to_render_template = render_template
    else:
        path_to_render_template = None

    return {
        'class': dotted_path_object_type(plugin),
        'source_file': inspect.getfile(type(plugin)),
        'verbose_name': force_text(plugin.verbose_name),
        'render_template': render_template,
        'path_to_render_template': path_to_render_template,
    }


def dotted_path_object_type(obj):
    if inspect.isclass(obj):
        object_type = obj
    else:
        object_type = type(obj)

    return '%s.%s' % (object_type.__module__, object_type.__name__)
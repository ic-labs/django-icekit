from django import template
from django.apps import apps
from django.conf import settings
from django.contrib import admin
from django.contrib.contenttypes.models import ContentType
from django.db.models.loading import get_model
from django.template.defaultfilters import stringfilter

register = template.Library()


@register.filter
@stringfilter
def obtain_content_type_id(model_name, app_label):
    """
    Obtains the content type id from the name of a content type.
    :param model_name: The name of the model to look for.
    :param app_label: The name off the app to look for.
    :return: Positive integer id
    """
    return ContentType.objects.get_for_model(get_model(app_label, model_name)).id


class AppObject(object):
    """
    Used by `filter_featured_apps` to assign generic properties to.
    """
    pass


@register.filter
def filter_featured_apps(admin_apps, request):
    """
    Given a list of apps return a set of sudo apps considered featured.

    Apps are considered featured if the are defined in the settings
    property called `FEATURED_APPS` which contains a list of the apps
    that are considered to be featured.

    :param admin_apps: A list of apps.
    :param request: Django request.
    :return: Subset of app like objects that are listed in
    the settings `FEATURED_APPS` setting.
    """
    featured_apps = []

    # Build the featured apps list based upon settings.
    for featured_app in settings.FEATURED_APPS:
        # Create a new sudo app like object we can add attributes to.
        new_app = AppObject()

        # Assign the verbose name to use for the app.
        setattr(new_app, 'verbose_name', featured_app['verbose_name'])
        # Assign the icon to use for the app.
        setattr(new_app, 'icon_html', featured_app['icon_html'])
        # Initial set the models to be empty.
        new_app.models = []

        # Search through each app for the models and change the verbose name adding it to the models
        # list for a sudo app instance.
        for app_and_model in featured_app['models']:
            app_label, model_name = app_and_model.split('.')

            for app in admin_apps:
                if app['app_label'] == app_label:
                    for model in app['models']:
                        if model['object_name'] == model_name:
                            model['verbose_name'] = \
                                featured_app['models'][app_and_model]['verbose_name']
                            # Get each of the polymorphic types to allow addition.
                            model_class = apps.get_model(app_and_model)
                            model_admin = admin.site._registry[model_class]

                            if hasattr(model_admin, 'get_child_type_choices'):
                                model['polymorphic_classes'] = model_admin.get_child_type_choices(
                                    request,
                                    'add'
                                )

                            if 'default_poly_child' in featured_app['models'][app_and_model].keys():
                                ct = ContentType.objects.get_by_natural_key(
                                    *featured_app['models'][app_and_model][
                                        'default_poly_child'
                                    ].lower().split('.')
                                )

                                new_app.default_poly_child = ct.id

                            new_app.models.append(model)

                    break

        # Only add the panel if more than one model listed.
        if len(new_app.models) > 0:
            featured_apps.append(new_app)

    return featured_apps


@register.filter
def get_model_list(app_list):
    result = []
    for app in app_list:
        for model in app['models']:
            result.append({
                'model': model,
                'app': app,
            })
    return result


@register.filter
def divide_list(l, n):
    result = []
    for i in xrange(0, len(l), n):
        result.append(l[i:i+n])
    return result

import warnings

from django import template
from django.apps import apps
from django.contrib import admin
from django.contrib.contenttypes.models import ContentType
from django.db.models.loading import get_model
from django.template.defaultfilters import stringfilter

from icekit import appsettings

register = template.Library()


def _build_app_models(request, admin_apps, models_tuples, ensure_all_models=False):
    """
    :param request: Request object
    :param admin_apps: The apps registered with the admin instance
    :param models_tuples: A list of (fully-qualified model name, config_dict) tuples
    :return:
    """

    app_models = []
    for app_and_model, config in models_tuples:
        if app_and_model:
            app_label, model_name = app_and_model.split('.')

            for app in admin_apps:
                if app['app_label'] == app_label:
                    for model in app['models']:
                        if model['object_name'] == model_name:
                            try:
                                model['name'] = \
                                    config['name']
                            except KeyError:
                                pass

                            # Get each of the polymorphic types to allow addition.
                            model_class = apps.get_model(app_and_model)
                            model_admin = admin.site._registry[model_class]

                            if hasattr(model_admin, 'get_child_type_choices'):
                                model['polymorphic_classes'] = \
                                    model_admin.get_child_type_choices(
                                        request, 'add'
                                    )

                            # TODO: Fluent/polymorphic has a way of sorting child order which should be used instead
                            if 'default_poly_child' in config.keys():
                                ct = ContentType.objects.get_by_natural_key(
                                    *config['default_poly_child'].lower().split('.')
                                )
                                model.default_poly_child = ct.id

                            app_models.append(model)

                    break

    return app_models


@register.filter
def filter_featured_apps(admin_apps, request):
    """
    Given a list of apps return a set of pseudo-apps considered featured.

    Apps are considered featured if the are defined in the settings
    property called `DASHBOARD_FEATURED_APPS` which contains a list of the apps
    that are considered to be featured.

    :param admin_apps: A list of apps.
    :param request: Django request.
    :return: Subset of app like objects that are listed in
    the settings `DASHBOARD_FEATURED_APPS` setting.
    """
    featured_apps = []

    # Build the featured apps list based upon settings.
    for orig_app_spec in appsettings.DASHBOARD_FEATURED_APPS:
        # make a copy that we can write to, to fix deprecations without
        # changing settings
        app_spec = orig_app_spec.copy()

        if "verbose_name" in app_spec:
            warnings.warn(
                "DASHBOARD_FEATURED_APPS[]['verbose_name'] = '%s' is deprecated. "
                "Use 'name' instead)" % app_spec['verbose_name'],
                DeprecationWarning, stacklevel=2
            )
            app_spec['name'] = app_spec['verbose_name']

        if hasattr(app_spec['models'], 'items'):
            warnings.warn(
                "DASHBOARD_FEATURED_APPS[]['models'] for '%s' should now be a "
                "list of tuples, not a dict." % app_spec['name'],
                DeprecationWarning, stacklevel=2
            )
            app_spec['models'] = app_spec['models'].items()

        # lookup the models from the names
        app_spec['models'] = _build_app_models(
            request, admin_apps, app_spec['models']
        )

        # Only add the panel if at least one model is listed.
        if app_spec['models']:
            featured_apps.append(app_spec)

    return featured_apps


def _remove_app_models(all_apps, models_to_remove):
    """
    Remove the model specs in models_to_remove from the models specs in the
    apps in all_apps. If an app has no models left, don't include it in the
    output.

    This has the side-effect that the app view e.g. /admin/app/ may not be
    accessible from the dashboard, only the breadcrumbs.
    """

    filtered_apps = []

    for app in all_apps:
        models = [x for x in app['models'] if x not in models_to_remove]
        if models:
            app['models'] = models
            filtered_apps.append(app)

    return filtered_apps


@register.filter
def filter_sorted_apps(admin_apps, request):
    """
    Filter admin_apps to show the ones in ``DASHBOARD_SORTED_APPS`` first,
    and remove them from the subsequent listings.
    """

    sorted_apps = []

    for orig_app_spec in appsettings.DASHBOARD_SORTED_APPS:
        # make a copy that we can write to, to fix deprecations without
        # changing settings
        app_spec = orig_app_spec.copy()
        # lookup the models from the names
        app_spec['models'] = _build_app_models(
            request, admin_apps, app_spec['models'], ensure_all_models=True
        )
        # Only add the panel if at least one model is listed.
        if app_spec['models']:
            sorted_apps.append(app_spec)

    used_models = []
    for app in sorted_apps:
        used_models += app['models']

    sorted_apps += _remove_app_models(admin_apps, used_models)

    return sorted_apps

@register.filter
def partition_app_list(app_list, n):
    """
    :param app_list: A list of apps with models.
    :param n: Number of buckets to divide into.
    :return: Partition apps into n partitions, where the number of models in each list is roughly equal. We also factor
    in the app heading.
    """
    num_rows = sum([1 + len(x['models']) for x in app_list]) # + 1 for app title
    num_rows_per_partition = num_rows / n

    result = [[] for i in range(n)] # start with n empty lists of lists
    partition = 0
    count = 0

    for a in app_list:
        # will the app fit in this column or overflow?
        c = len(a['models']) + 1 # the +1 is for the app title
        # if we're not on the last partition, and the models list fits
        # more on the next partition than this one, start the next partition.
        if (partition < n - 1) and (count + c/2.0 > num_rows_per_partition):
            partition += 1
            count = 0
        result[partition].append(a)
        count += c

    return result

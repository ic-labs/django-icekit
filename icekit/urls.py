"""
URLconf for ``icekit`` app.
"""

# Prefix URL names with the app name. Avoid URL namespaces unless it is likely
# this app will be installed multiple times in a single project.

from django.apps import apps
from django.conf import settings
from django.conf.urls import include, patterns, url
from django.contrib.auth import views
from django.core.urlresolvers import reverse_lazy

from . import admin_forms

# Create an empty patterns to append to as all patterns can be optional.
urlpatterns = patterns('')

# HOME ############################################################################################
# Optional home view by default. To turn off place `ICEKIT_USE_HOME_VIEW = False` in settings.
if getattr(settings, 'ICEKIT_USE_HOME_VIEW', True):
    urlpatterns += patterns(
        'icekit.views',
        url(r'^$', 'index', name='icekit_index'),
    )

# ACCOUNTS ########################################################################################
# Overwrite some admin URLS to provide admin / front end account handling separation.
# The admin URL patterns are only overwritten to allow correct redirection of URLs to patterns
# matching the admin specific URL and to display the correct information to staff users versus
# non-staff users.
# The admin templates will extend `admin/base_site.html` to provide administration styles.
if getattr(settings, 'ICEKIT_USE_ADMIN_URLS', True):  # Allows turning off the admin URL feature.
    admin_urls = patterns(
        '',
        url(
            r'password/reset/$',
            views.password_reset,
            {
                'post_reset_redirect': 'admin_password_reset_done',
                'email_template_name': 'icekit/admin/password_reset_email.html',
                'password_reset_form': admin_forms.PasswordResetForm,  # Ensures staff use only.
            },
            name='admin_password_reset'
        ),
        url(
            r'^password/reset/done/$',
            views.password_reset_done,
            name='admin_password_reset_done'
        ),
        url(
            r'^reset/(?P<uidb64>[0-9A-Za-z_\-]+)/(?P<token>[0-9A-Za-z]{1,13}-[0-9A-Za-z]{1,20})/$',
            views.password_reset_confirm,
            {
                'post_reset_redirect': 'admin_password_reset_complete'
            },
            name='admin_password_reset_confirm'
        ),
        url(
            r'^password/done/$',
            views.password_reset_complete,
            {
                'extra_context': {
                    'login_url': reverse_lazy('admin:index')  # Return staff to the admin login.
                }
            },
            name='admin_password_reset_complete'
        ),
    )

    # Allows for custom prefixes to be used for each of the admin patterns.
    # By default `admin/` will be used.
    urlpatterns += patterns(
        '',
        url(getattr(settings, 'ICEKIT_ADMIN_URL_PREFIX', r'admin/'), include(admin_urls))
    )

# Account URL patterns designed for non staff users.
# All templates extend `base.html` to extend front end styles with forms rendered in
# Bootstrap3 format.
if getattr(settings, 'ICEKIT_USE_LOGIN', True):
    auth_urls = patterns(
        '',
        url(
            r'^password/reset/$',
            views.password_reset,
            {
                'template_name': 'icekit/auth/password_reset.html',
                'email_template_name': 'icekit/auth/password_reset_email.html',
                'subject_template_name': 'icekit/auth/password_reset_subject.txt',
            },
            name='password_reset'
        ),
        url(
            r'^password/reset/done/$',
            views.password_reset_done,
            {
                'template_name': 'icekit/auth/password_reset_done.html',
            },
            name='password_reset_done'
        ),
        url(
            r'^reset/(?P<uidb64>[0-9A-Za-z_\-]+)/(?P<token>[0-9A-Za-z]{1,13}-[0-9A-Za-z]{1,20})/$',
            views.password_reset_confirm,
            {
                'template_name': 'icekit/auth/password_reset_confirm.html',
            },
            name='password_reset_confirm'
        ),
        url(
            r'^password/done/$',
            views.password_reset_complete,
            {
                'template_name': 'icekit/auth/password_reset_complete.html',
            },
            name='password_reset_complete'
        ),
        url(
            r'^login/$',
            views.login,
            {
                'template_name': 'icekit/auth/login.html',
            },
            name='login'
        ),
        url(
            r'^logout/$',
            views.logout,
            {
                'template_name': 'icekit/auth/logged_out.html',
            },
            name='logout'
        ),
        url(
            r'^password/change/$',
            views.password_change,
            {
                'template_name': 'icekit/auth/password_change_form.html',
            },
            name='password_change'
        ),
        url(
            r'^password/change/done/$',
            views.password_change_done,
            {
                'template_name': 'icekit/auth/password_change_done.html',
            },
            name='password_change_done'
        ),
    )

    # Allows for custom prefixes to be used for each of the non staff account patterns.
    # By default no prefix will be used.
    urlpatterns += patterns(
        '',
        url(getattr(settings, 'ICEKIT_LOGIN_URL_PREFIX', r''), include(auth_urls))
    )

# HAYSTACK ########################################################################################
# Add built in support for haystack if in installed apps.
if apps.is_installed('haystack') and getattr(settings, 'ICEKIT_USE_SEARCH_URL', True):
    urlpatterns += patterns('', url(r'^search/', include('haystack.urls')),)

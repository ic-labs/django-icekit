from django.conf import settings
from django.conf.urls import include, patterns, url
from django.contrib import admin
from django.core.urlresolvers import reverse_lazy
from django.views.generic import RedirectView, TemplateView
from fluent_pages.sitemaps import PageSitemap

from icekit.admin_tools.forms import PasswordResetForm
from icekit.views import index

admin.autodiscover()

sitemaps = {
    'pages': PageSitemap,
}

# Build Authentication URL patterns separately for re-use in standard web site
# and API web frontend.
auth_urlpatterns = patterns(
    '',

    # Authentication.
    url(
        r'^login/$',
        'django.contrib.auth.views.login',
        {
            'template_name': 'icekit/auth/login.html',
        },
        name='login'
    ),
    url(
        r'^logout/$',
        'django.contrib.auth.views.logout',
        {
            'template_name': 'icekit/auth/logged_out.html',
        },
        name='logout'
    ),

    # Password change.
    url(
        r'^password/change/$',
        'django.contrib.auth.views.password_change',
        {
            'template_name': 'icekit/auth/password_change_form.html',
        },
        name='password_change'
    ),
    url(
        r'^password/change/done/$',
        'django.contrib.auth.views.password_change_done',
        {
            'template_name': 'icekit/auth/password_change_done.html',
        },
        name='password_change_done'
    ),

    # Password reset.
    url(
        r'^password/reset/$',
        'django.contrib.auth.views.password_reset',
        {
            'template_name': 'icekit/auth/password_reset.html',
            'email_template_name': 'icekit/auth/password_reset_email.html',
            'subject_template_name': 'icekit/auth/password_reset_subject.txt',
        },
        name='password_reset'
    ),
    url(
        r'^password/reset/done/$',
        'django.contrib.auth.views.password_reset_done',
        {
            'template_name': 'icekit/auth/password_reset_done.html',
        },
        name='password_reset_done'
    ),
    url(
        r'^reset/(?P<uidb64>[0-9A-Za-z_\-]+)/(?P<token>[0-9A-Za-z]{1,13}-[0-9A-Za-z]{1,20})/$',
        'django.contrib.auth.views.password_reset_confirm',
        {
            'template_name': 'icekit/auth/password_reset_confirm.html',
        },
        name='password_reset_confirm'
    ),
    url(
        r'^password/done/$',
        'django.contrib.auth.views.password_reset_complete',
        {
            'template_name': 'icekit/auth/password_reset_complete.html',
        },
        name='password_reset_complete'
    ),
)

urlpatterns = patterns(
    '',

    url(r'^$', index, name="home"),

    # Test error templates.
    url(r'^404/$', TemplateView.as_view(template_name='404.html')),
    url(r'^500/$', TemplateView.as_view(template_name='500.html')),

    # Redirects for updated paths in the redactor package that don't match the
    # `django-wysiwyg` template.
    url(r'^css/redactor.css$',
        RedirectView.as_view(
            url=settings.STATIC_URL + 'redactor/redactor/redactor.css',
            permanent=True)),
    url(r'^redactor.min.js$',
        RedirectView.as_view(
            url=settings.STATIC_URL + 'redactor/redactor/redactor.min.js',
            permanent=True)),

    # Sitemap.
    url(r'^sitemap\.xml$',
        'django.contrib.sitemaps.views.sitemap',
        {'sitemaps': sitemaps}),

    # Installed apps.
    url(r'^forms/', include('forms_builder.forms.urls')),
    # API is made available at api.HOSTNAME domain by `icekit.project.hosts`
    # url(r'^api/', include('icekit.api.urls')),

    # Get admin URLs prefix from settings.
    # Handle admin and front-end authentication separately.
    url(getattr(settings, 'ICEKIT_ADMIN_URL_PREFIX', r'^admin/'), include(patterns(
        '',
        url(r'^doc/', include('django.contrib.admindocs.urls')),

        # Password reset.
        url(r'^password/reset/$',
            'django.contrib.auth.views.password_reset',
            {
                'post_reset_redirect': 'admin_password_reset_done',
                'email_template_name': 'admin/password_reset_email.html',
                'password_reset_form': PasswordResetForm,  # Staff use only
            },
            name='admin_password_reset'
        ),
        url(r'^password/reset/done/$',
            'django.contrib.auth.views.password_reset_done',
            name='admin_password_reset_done'
        ),
        url(r'^reset/(?P<uidb64>[0-9A-Za-z_\-]+)/(?P<token>[0-9A-Za-z]{1,13}-[0-9A-Za-z]{1,20})/$',
            'django.contrib.auth.views.password_reset_confirm',
            {
                'post_reset_redirect': 'admin_password_reset_complete'
            },
            name='admin_password_reset_confirm'
        ),
        url(r'^password/done/$',
            'django.contrib.auth.views.password_reset_complete',
            {
                'extra_context': {
                    'login_url': reverse_lazy('admin:index')  # Redirect staff to the admin login
                }
            },
            name='admin_password_reset_complete'
        ),

        # Admin.
        url(r'^', include(admin.site.urls)),
    ))),

    url(getattr(settings, 'ICEKIT_LOGIN_URL_PREFIX', r''), include(auth_urlpatterns)),

    # GLAMkit URLs
    url(r'^events/', include('icekit_events.urls')),
    url(r'^collection/', include('glamkit_collections.contrib.work_creator.urls')),
    url(r'^iiif/', include('icekit.plugins.iiif.urls')),
    url(r'^location/', include('icekit.plugins.location.urls')),

    # Catch all, fluent page dispatcher.
    url(r'^', include('fluent_pages.urls')),
)

if settings.DEBUG:
    try:
        import debug_toolbar
        urlpatterns = [
            url(r'^__debug__/', include(debug_toolbar.urls)),
        ] + urlpatterns
    except ImportError:
        pass

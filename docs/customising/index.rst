Customising your ICEkit site *
============================

.. toctree::
   :maxdepth: 2
   :caption: Contents:

   concepts
   rich-content-models
   content-plugins

## Where to put files

Put your layout template files in `templates/layouts/`.

Put your static files (js/css/static images) in `static/`.

Anything you put in the `static` or `templates` directories will override the
default ICEkit static files and templates.

You can specify additional Bower components in `bower.json`, Node modules in
`package.json`, and Python packages in `requirements.txt`.

The `project_settings.py` file is a Django settings module. You can override any
default Django/ICEkit settings or configure apps installed via `requirements
.txt`.


## How do I add project-specific URLs?

Create a `urls.py` file in a project folder of your choice, such as `myproject`.
It can contain something like::

   from django.conf.urls import include, patterns, url

   urlpatterns = patterns(
       'myproject.views',
       ... your URLs here ...
       # finally, fall back to ICEkit/GLAMkit URLs.
       url('', include('icekit.project.urls')), # use `glamkit_urls` if this is a GLAMkit project
   ]

Lastly, in `project_settings.py`, override the default URL path::

   ROOT_URLCONF = 'myproject.urls'

## Where's my virtualenv? How do I modify a source package?

If you're running in Docker, the requirements are installed in the Docker image
and aren't on your local machine.

From the [shell](commands.md#opening-a-shell), you can see what those
requirements are with:

    $ pip freeze

Or install packages (into `./var/venv/lib/python2.7/site-packages`):

    $ pip install django-debug-toolbar

Or install editable packages (into `./var/venv/src`):

    $ pip install -e 'git+https://github.com/ic-labs/django-icekit.git#egg=django-icekit'

Or list just the additional packages that you have already installed:

    $ pip freeze --user

You can also create a `requirements-local.txt` file (ignored by Git) that will
be installed automatically when the project is started.

## How do I change the base template?

All icekit templates extend a template named `base.html` which is automatically provided by
icekit. To change the base template, you can add a file named `base.html` into your root
`templates` directory. This ensures that all icekit templates will now default to using
your template as a base.

To ensure maximum compatibility with icekit's conventions for block names, we strongly
recommend refering to [icekit's base template](/icekit/templates/icekit/base.html).


## Configure your project

You will need to provide some basic information to configure your project.

You can do so with environment variables, or by editing the `docker-cloud.yml`
and `project_settings.py` files.

All settings are optional, but you can provide:

  * `BASE_SETTINGS_MODULE` tells ICEkit to run in `develop` or `production`
    mode.

  * `EMAIL_HOST`, `EMAIL_HOST_PASSWORD` and `EMAIL_HOST_USER`, so ICEkit can
    send emails (only in `production` mode).

    We recommend [Mailgun](http://www.mailgun.com/), but any SMTP credentials
    will do.

  * `MASTER_PASSWORD` (only in `develop` mode) so you can login as any user
    with the same password.

  * `MEDIA_AWS_ACCESS_KEY_ID`, `MEDIA_AWS_SECRET_ACCESS_KEY` and
    `MEDIA_AWS_STORAGE_BUCKET_NAME` so ICEkit can store file uploads
    [Amazon S3](https://aws.amazon.com/s3/).

    The specified bucket should already exist, or the credentials provided
    should have permission to create buckets. This is especially important when
    deploying to ephemeral infrastructure, like Docker Cloud.

  * `PGDATABASE`, `PGHOST`, `PGPASSWORD`, `PGPORT` and `PGUSER`, if you need to
    connect to provide credentials for your PostgreSQL database.

    We recommend [Amazon RDS](https://aws.amazon.com/rds/), especially when
    deploying to ephemeral infrastructure, like Docker Cloud.

  * `SENTRY_DSN`, if you want to use [Sentry](https://getsentry.com/) for
    real-time error tracking.

  * `SITE_DOMAIN` and `SITE_NAME`, so ICEkit knows how to generate redirects
    correctly and knows what to call your site.

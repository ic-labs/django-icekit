Configure your project
======================

The ``project_settings.py`` file is a Django settings module. You can override any
default Django/GLAMkit settings or configure apps installed via ``requirements
.txt``.

You will need to provide some basic information to configure your project.

You can do so with environment variables, or by editing the ``docker-cloud.yml``
and ``project_settings.py`` files.

All settings are optional, but you can provide:

-  ``BASE_SETTINGS_MODULE`` tells GLAMkit to run in ``develop`` or ``production``
   mode.

-  ``EMAIL_HOST``, ``EMAIL_HOST_PASSWORD`` and ``EMAIL_HOST_USER``, so ICEkit can
   send emails (only in ``production`` mode).

   We recommend `Mailgun <http://www.mailgun.com/>`_, but any SMTP credentials
   will do.

-  ``MASTER_PASSWORD`` (only in ``develop`` mode) so you can login as any user
   with the same password.

-  ``MEDIA_AWS_ACCESS_KEY_ID``, ``MEDIA_AWS_SECRET_ACCESS_KEY`` and
   ``MEDIA_AWS_STORAGE_BUCKET_NAME`` so GLAMkit can store file uploads in
   `Amazon S3 <https://aws.amazon.com/s3/>`_.

   The specified bucket should already exist, or the credentials provided
   should have permission to create buckets. This is especially important when
   deploying to ephemeral infrastructure, like Docker Cloud.

-  ``PGDATABASE``, ``PGHOST``, ``PGPASSWORD``, ``PGPORT`` and ``PGUSER``, if you need to
   connect to provide credentials for your PostgreSQL database.

   We recommend `Amazon RDS <https://aws.amazon.com/rds/>`_, especially when
   deploying to ephemeral infrastructure, like Docker Cloud.

-  ``SENTRY_DSN``, if you want to use `Sentry <https://getsentry.com/>`_ for
   real-time error tracking.

-  ``SITE_DOMAIN`` and ``SITE_NAME``, so GLAMkit knows how to generate redirects
   correctly and knows what to call your site.

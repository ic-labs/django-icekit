Testing
=======

We don't strictly require 100% test coverage (yet), but we aim to have:

-  >70% coverage.
-  Unit tests for all regression bugs.
-  Unit or integration tests for complex, fragile, or important
   functionality.

ICEkit uses a custom script ``runtests.sh`` to run tests, which
configures the test database and restores from ``test_initial_data.sql``
if available, to speed up migrations.

Running tests
-------------

Run ICEkit tests
~~~~~~~~~~~~~~~~

::

    runtests.sh path/to/icekit/

Run specific tests
~~~~~~~~~~~~~~~~~~

::

    runtests.sh foo.bar:Baz.test_foo

Discover tests in the current folder and run without migrations:
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

::

    runtests.sh -n .


Speed up test running
~~~~~~~~~~~~~~~~~~~~~

::

    QUICK=1 runtests.sh ...

This reuses the test databases, and skips the collectstatic
step -- you'll need to populate a test database and run collectstatic
beforehand.


Working with the database for tests
-----------------------------------

Creating migrations for a test model
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

::

    BASE_SETTINGS_MODULE=test manage.py makemigrations

Opening an interactive shell to inspect the test database
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

::

    BASE_SETTINGS_MODULE=test manage.py shell_plus


Creating a data dump with migrations applied
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The slowest part of running tests from scratch is usually the "Rendering
Model States..." stage of migrations. This can be speeded up by loading
a pre- migrated database dump. ICEkit's ``runtests.sh`` automatically
uses a file called ``test_initial_data.sql``.

To create a data dump called ``test_initial_data.sql`` with migrations
applied:

1. Drop/recreate your test database::

       dropdb FOO_test_develop
       createdb FOO_test_develop

2. Run migrations::

       BASE_SETTINGS_MODULE=test manage.py migrate

3. Dump the database to ``test_initial_data.sql``::

       pg_dump -O -x -f test_initial_data.sql -d test_FOO_develop
       git add test_initial_data.sql

Creating fluent pages in tests
------------------------------

You can create fluent pages efficiently using django-dynamic-fixture_::

    from django.contrib.auth import get_user_model
    from django_webtest import WebTest
    from django_dynamic_fixture import G
    from django.contrib.contenttypes.models import ContentType
    from django.contrib.sites.models import Site
    from icekit.models import Layout
    from icekit.page_types.layout_page.models import LayoutPage


    User = get_user_model()


    class FluentPageTestCase(WebTest):
        def setUp(self):
            self.layout_1 = G(
                Layout,
                template_name='layout_page/layoutpage/layouts/default.html',
            )
            self.layout_1.content_types.add(ContentType.objects.get_for_model(LayoutPage))
            self.layout_1.save()
            self.staff_1 = User.objects.create(
                email='test@test.com',
                is_staff=True,
                is_active=True,
                is_superuser=True,
            )
            self.page_1 = LayoutPage.objects.create(
                title='Test Page',
                slug='test-page',
                parent_site=Site.objects.first(),
                layout=self.layout_1,
                author=self.staff_1,
                status='p',  # Publish the page
            )

There is also a helper function to add content items::

    from icekit.utils.fluent_contents import create_content_instance

        ...
        self.child_page_1 = create_content_instance(
            models.ContentItem,
            page=self.page_1,
            placeholder_name="main", # default
            **kwargs # arguments for initialising the ContentItem model
        )

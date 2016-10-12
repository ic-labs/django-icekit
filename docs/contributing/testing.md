# Testing

ICEkit uses a custom script `runtests.sh` to run tests, which configures the
test database and restores from `test_initial_data.sql` if available,
 to speed up migrations.

## Recipes

### To run icekit tests

    runtests.sh path/to/icekit/

### To run specific tests

    runtests.sh foo.bar:Baz.test_foo

### To discover tests in the current folder and run without migrations:

    runtests.sh -n .

### To create migrations for a test model

    BASE_SETTINGS_MODULE=icekit.tests.settings manage.py makemigrations

### To get an interactive shell to inspect the test database

    BASE_SETTINGS_MODULE=icekit.tests.settings manage.py shell_plus

### To speed up test running

    QUICK=1 runtests.sh ...

This reuses the test databases, and skips collectstatic and compress steps.

### To create a data dump with migrations applied

To achieve permanent speedup, create a data dump called `test_initial_data.sql`
with migrations applied. It will be restored to the test database in
`runtests.sh`, bypassing all migrations.

1. Create a fresh database `foo`
2. Run migrations:

        manage.py migrate

3. Dump the database to `test_initial_data.sql`

        `pg_dump -O -x -f test_initial_data.sql -d foo`


# To create fluent pages in tests.

We do this by using dynamic fixture:

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


There is also a helper function to add content items:

    from icekit.utils.fluent_contents import create_content_instance

        ...
        self.child_page_1 = create_content_instance(
            models.ContentItem,
            page=self.page_1,
            placeholder_name="main", # default
            **kwargs # arguments for initialising the ContentItem model
        )

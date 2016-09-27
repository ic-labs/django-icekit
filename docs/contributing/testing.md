# Testing

ICEkit uses a custom script `runtests.sh` to run tests, which configures the
test database and restores from `test_initial_data.sql` if available,
 to speed up migrations.

## Recipes

### To run icekit tests

    runtests.sh path/to/icekit/

### To run specific tests

    runtets.sh foo.bar:Baz.test_foo

### To discover tests in the current folder and run without migrations:

    runtests.sh -n .

### To create migrations for a test model

    BASE_SETTINGS_MODULE=icekit.tests.settings manage.py makemigrations

### To get an interactive shell to inspect the test database

    BASE_SETTINGS_MODULE=icekit.tests.settings manage.py shell_plus

### To speed up test running

Use a data dump called `test_initial_data.sql` with migrations applied. It will
be restored to the test database in `runtests.sh`, bypassing all migrations.



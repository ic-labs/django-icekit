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


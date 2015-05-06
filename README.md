# Readme

Docs can be found in the [docs](docs/index.md) folder.

## App Template

This is a bare-bones skeleton app template, for use with the
`django-admin.py startapp` command.

You will need `django 1.4+`, `git`, `python 2.7+`, `pip`, and `virtualenv` to
create a new app with this template.

Create environment variables for the app and module name (e.g. `django-foo-bar`
and `foo_bar`), so we can use them in subsequent commands:

    $ export APP=<app_name>
    $ export MODULE=<module_name>

Create an app from the template:

    $ mkdir $APP
    $ django-admin.py startapp -e md,yml -n .coveragerc \
    --template=https://github.com/ixc/ixc-app-template/archive/master.zip \
    $MODULE $APP

Make the `manage.py` file executable, for convenience:

    $ cd $APP
    $ chmod 755 manage.py

Create a remote repository on [GitHub], then initialise a local repository and
push an initial commit:

    $ git init
    $ git add -A
    $ git commit -m 'Initial commit.'
    $ git remote add origin git@github.com:ixc/$APP.git
    $ git push

Create a virtualenv and install the dependencies:

    $ virtualenv venv
    $ source venv/bin/activate
    (venv)$ pip install -r requirements.txt

Run the tests:

    (venv)$ tox

Now, write your app! You might want to start with:

  * Remove the `App Template` section (these instructions) from `README.md`
    (this file).
  * Add a `LICENSE` file (e.g. [MIT]).
  * Update the `docs/index.md` file (e.g. the overview, installation and usage
    sections).
  * Read the [contributing] docs.

[contributing]: docs/contributing.md
[GitHub]: https://github.com
[MIT]: http://choosealicense.com/licenses/mit/

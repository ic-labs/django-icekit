Where to put project files
==========================

Relative to the project root:

-  Put your **template** files in ``templates/``

-  Put your **static** files (js/css/static images) in ``static/``.

-  Put your **layout template** files in ``templates/layouts/``.

.. TODO: crossref layout templates

.. note::
   Anything you put in the ``static`` or ``templates`` directories will override the
   default ICEkit static files and templates.

Python packages
~~~~~~~~~~~~~~~

ICEkit projects use `pip-tools <https://github.com/nvie/pip-tools>`_ to keep
requirements fresh, even when the versions are pinned.

Add project-specific requirements to ``requirements.in`` and compile into
``requirements.txt`` by running ``pip-compile requirements.in``.

Javascript/Node packages
~~~~~~~~~~~~~~~~~~~~~~~~

You can specify additional Bower components in ``bower.json`` and Node modules
in ``package.json``.


How do I add project-specific URLs?
-----------------------------------

Create a ``urls.py`` file in a project folder of your choice, such as
``myproject``. It can contain something like::

   from django.conf.urls import include, patterns, url

   urlpatterns = patterns(
       'myproject.views',
       ... your URLs here ...
       # finally, fall back to ICEkit/GLAMkit URLs.
       url('', include('icekit.project.urls')), # use `icekit.project.glamkit_urls` if this is a GLAMkit project
   ]

Lastly, in ``project_settings.py``, override the default URL path::

   ROOT_URLCONF = 'myproject.urls'


How do I override ICEkit's base template?
-----------------------------------------

All ICEkit templates extend a template named ``base.html`` which is automatically
provided by ICEkit. To change the base template, you can add a file named
``base.html`` into your root ``templates`` directory. This ensures that all
ICEkit templates will now default to using your template as a base.

To ensure maximum compatibility with ICEkit's conventions for block names, we
recommend referring to the names in
`ICEkit's base template <../../../icekit/templates/icekit/base.html>`_.

.. TODO: reference for template block names/context variables


Where's my virtualenv? How do I modify a source package?
--------------------------------------------------------

If you're running in Docker, the requirements are installed in the Docker image
and aren't on your local machine.

After :ref:`opening a shell <shell>`, you can see what those
requirements are with::

    $ pip freeze

Or install packages (into ``./var/venv/lib/python2.7/site-packages``)::

    $ pip install django-debug-toolbar

Or install editable packages (into ``./var/venv/src``)::

    $ pip install -e 'git+https://github.com/ic-labs/django-icekit.git#egg=django-icekit'

Or list just the additional packages that you have already installed::

    $ pip freeze --user

You can also create a ``requirements-local.txt`` file (ignored by Git) that will
be installed automatically when the project is started.

.. TODO: are there still shared directories mounted by docker-compose into the
container?


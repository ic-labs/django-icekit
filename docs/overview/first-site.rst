Creating your first site
========================

.. TODO: how to install glamkit packages?

Installation
------------

.. include:: ../install/docker.rst


Next steps
----------

At this point you can get a long way simply by overriding
templates and CSS styles. ICEkit sites are Django projects, and you can add
models, views, templates and URLs to your project in much the same way as you
would in any Django project.

Where to put your project files
-------------------------------

ICEkit looks for templates in the project root's `templates` folder. This is
a good place to override 3rd-party templates.

You can create apps in your project as normal, with ``manage.py startapp``.

You may want to create an app named after your project::

   manage.py startapp MY_PROJECT_NAME

Having done so, you can put, inside the app:

-  templates in ``MY_PROJECT_NAME/templates``
-  static files in ``MY_PROJECT_NAME/static``
   -  LESS and SCSS files can be compiled to CSS
   -  Javascript files can be compiled to JS
-  templatetags in ``MY_PROJECT_NAME/templatetags``
-  locale-specific date/time format overrides in ``MY_PROJECT_NAME/formats/``
-  URLs in ``MY_PROJECT_NAME/urls.py``
-  etc.

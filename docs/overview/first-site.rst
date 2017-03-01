Creating your first site
========================

.. TODO: how to install glamkit packages?

Installation
------------

.. include:: ../install/docker.rst


Enabling GLAMkit features
-------------------------

The key differences between ICEkit and GLAMkit come down to the settings file
that's used. To enable GLAMkit features, change your ``project_settings.py``
file from::

   from icekit.project.settings.icekit import *

to::

   from icekit.project.settings.glamkit import *

The GLAMkit settings file enables:

-  the icekit-events_ package, and some standard events types
-  the icekit-press-releases_ package
-  the glamkit-collections_ package, and some standard events types
-  the glamkit-sponsors_ package
-  urls for the above
-  dashboard customisations for the above


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

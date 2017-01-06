Contributing to ICEkit
======================

Please follow these guidelines when making contributions to ICEkit.

.. toctree::
   :maxdepth: 1
   :caption: Contents:

   source-setup
   style
   testing
   documentation
   releases
   conduct

Installing the ICEkit dev version on an existing project
--------------------------------------------------------

::

    $ docker-compose exec django entrypoint.sh
    $ pip install -e git+https://github.com/ic-labs/django-icekit.git#egg=django-icekit

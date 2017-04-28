1. Create a new project
^^^^^^^^^^^^^^^^^^^^^^^

::

    $ bash <(curl -Ls https://raw.githubusercontent.com/ic-labs/django-icekit/master/icekit/bin/startproject.sh) {project_name}

This will create a new project from the ICEkit project template, in a
directory named ``{project_name}`` in the current working directory.

NOTE: Windows users should run this command in Git Bash, which comes
with `Git for Windows <https://git-for-windows.github.io/>`__.

.. admonition:: Installing the `develop` branch

   The `curl` command installs the latest release (from the `master` branch).
   If you prefer to install the development release (the `develop` branch), use
   this::

      $ bash <(curl -Ls https://raw.githubusercontent.com/ic-labs/django-icekit/develop/icekit/bin/startproject.sh) {project_name} develop

   The above command differs from the normal one in two ways.
   First, it downloads (via curl) the develop version of the script, and second it
   passes a second argument ("develop") to the script, which tells it to download
   the develop versions of all the files it needs when it runs.

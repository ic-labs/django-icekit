Writing documentation
=====================

Good documentation is just as important as tests. ICEkit pull requests should
endeavour to include and/or update documentation where appropriate.

ICEkit documentation is written in ReStructured Text (ReST) format, and
compiled to HTML using Sphinx. Documentation is hosted on ReadTheDocs.

Conventions
-----------

* Include examples so new contributors can get started quickly.
* Keep the :doc:`../changelog` up to date. Describe features, not implementation
  details, except for backwards incompatible changes.
* We're aiming to document all non-private modules, classes and functions in
  ICEkit. The easiest way to do this is in the docstrings of the class, with
  an ``automodule`` call out from this document structure.
* Titles should be sentence case.
* File extensions are ``.rst`` and hard-wrapped at 80 columns.

Installing requirements
-----------------------

You'll need a source installation of ICEkit.

Activate the ICEkit virtualenv, e.g. with ``./go.sh bash``.

Install pandoc::

   brew install pandoc

Install the python requirements::

   pip install sphinx sphinx-autobuild recommonmark

Making HTML documentation
-------------------------

Run::

   cd $ICEKIT_DIR/../docs
   sphinx-autobuild . _build_html

And open http://localhost:8000 in a browser to preview the docs. Or, to build
manually::

   make html

And open ``_build/index.html`` in a browser to preview the docs.

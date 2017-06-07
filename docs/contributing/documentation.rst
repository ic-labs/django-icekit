Writing documentation
=====================

Good documentation is just as important as tests. GLAMkit pull requests should
endeavour to include and/or update documentation where appropriate.

GLAMkit documentation is written in ReStructured Text (ReST) format, and
compiled to HTML using Sphinx. Documentation is hosted on ReadTheDocs.

Conventions
-----------

*  Include examples so new contributors can get started quickly.
*  Keep the :doc:`../changelog` up to date. Describe features, not
   implementation details, except for backwards incompatible changes.
*  We're aiming to document all non-private modules, classes and functions in
   GLAMkit. The easiest way to do this is in the docstrings of the class, with
   an ``automodule`` call out from this document structure.
*  Titles should be sentence case.
*  File extensions are ``.rst`` and hard-wrapped at 80 columns.

Setup (macOS)
-------------

Install Homebrew::

   $ /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

Install system dependencies::

   $ brew install git pandoc pyenv pyenv-virtualenv
   $ cat <<EOF >> ~/.bash_profile

   # Configure pyenv.
   export PATH="$HOME/.pyenv/bin:$PATH"
   eval "$(pyenv init -)"
   eval "$(pyenv virtualenv-init -)"
   EOF

Clone the repository and change directory::

   $ git clone https://github.com/ic-labs/django-icekit.git
   $ cd django-icekit/docs

Create a virtualenv::

   $ pyenv install 2.7.13
   $ pyenv virtualenv django-icekit-docs 2.7.13
   $ pyenv local django-icekit-docs

Install Python dependencies::

   (django-icekit-docs)$ pip install -r requirements.txt

Building HTML documentation
---------------------------

Run a server to autobuild and preview the docs (open
http://icekit-docs.lvh.me:8000 in a browser)::

   (django-icekit-docs)$ sphinx-autobuild . _build_html

Or build static HTML docs (open ``_build/index.html`` in a browser)::

   (django-icekit-docs)$ make html

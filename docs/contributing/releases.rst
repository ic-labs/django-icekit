Releases
========

We will tag and upload a release to PyPI according to the :doc:`roadmap`.

Steps to prepare a GLAMkit release:

1. Merge all features to be included and ensure that tests pass and code
   operates as it should.
2. Ensure documentation and :doc:`../changelog` is up to date. In particular, edit the
   changelog so that major features appear first and are written such that
   users understand the benefits. Update the :doc:`roadmap` to reflect current
   status.
3. In git, tag the release with the version number.
4. Activate the pypi virtualenv and login to `devpi`_ using the password::

      workon devpi && devpi login ic --password={{ secret }}

   (see below for setting up the ``devpi`` virtualenv.)

5. Upload a develop version of the package::

      python setup.py --version && devpi upload

   or release an official version on Pypi::

      devpi push django-icekit==<version> pypi:ixc


.. TODO: deprecation policy
.. TODO: version numbering policy

Private Package Index
---------------------

We have a private, caching, on-demand mirror of PyPI (running `devpi`_) that
we can use to publish private packages.

It is available over HTTPS with basic authentication, plus a few whitelisted IP
addresses for convenient access.

To install devpi::

    mkvirtualenv devpi
    pip install devpi-client django

Version numbers
---------------

We use ``setuptools_scm`` to get the version number directly from the version
control system, which makes versioning part of the release process instead of
being part of the development process.
 and outdated at the next commit. Yay!

You can preview what the version number will be, before you build and upload::

    python setup.py --version

The version number will be one of::

    {tag}                                # no distance and clean
    {tag}+d{YYYYMMDD}                    # no distance and not clean
    {tag}.post{N}+n{commit}              # distance and clean
    {tag}.post{N}+n{commit}.d{YYYYMMDD}  # distance and not clean

We use semantic versioning (``{major}.{minor}.{patch}``) when tagging
releases.

* MAJOR version when you make incompatible API changes,
* MINOR version when you add functionality in a backwards-compatible manner, and
* PATCH version when you make backwards-compatible bug fixes.

For patch-level changes, you can forget about
adding a tag and just use the generated version number. When uploading to a
public index (PyPI), you must tag the release because public indexes may not
accept packages with `local version identifiers`_.

.. _devpi: http://doc.devpi.net/latest/
.. _`local version identifiers`: https://www.python.org/dev/peps/pep-0440/#local-version-identifiers

Release announcement template
-----------------------------

The Interaction Consortium is pleased to announce the new release of GLAMkit
(http://glamkit.com), the open-source CMS for the cultural sector, used by
ACMI, SFMOMA and others.

Version [x] features [...]

Full details can be found in the release notes at
http://docs.glamkit.com/en/latest/changelog.html .

Get GLAMkit
~~~~~~~~~~~
To install the development version of GLAMkit, see the instructions at
http://glamkit.com/get-started.html .

Help improve GLAMkit
~~~~~~~~~~~~~~~~~~~~
Like every open-source project, GLAMkit relies on people to help contribute
ideas, features, code and issues. If you wish to suggest improvements, please
add them to the project’s GitHub issue tracker:
https://github.com/ic-labs/django-icekit/issues .

User guides and documentation can be found at: http://docs.glamkit.com .

About GLAMkit
~~~~~~~~~~~~~
GLAMkit is a next-generation open-source CMS by the Interaction
Consortium (http://interaction.net.au), designed especially for
the cultural sector. It's used by SFMOMA, ACMI, MCA Australia, and the Art
Galleries of New South Wales and South Australia, among others.

GLAMkit has rich Events, Collections, asset management and storytelling tools
for teams of content professionals in public-facing institutions, supported by
a powerful content publishing framework. Everything is written in Python,
using the Django framework.

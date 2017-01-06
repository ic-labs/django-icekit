ICEkit features
===============

.. TODO: link to where the features are covered

Easy, digital-native content management
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-  Structured modular ("rich") content:

   -  Create content in lists or trees
   -  Each content page in a list or tree can be a different shape (e.g.
      articles can be a mix of Text articles, Image articles,
      Redirects, etc). This is called polymorphic models.
   -  Each page can have several content placeholders (e.g. Main region,
      More info, Authors)
   -  Each content placeholder can contain as many of any kind of
      content plugins as required (e.g. Intro text, followed by image, followed
      by event promo, followed by video, etc). Content blocks can be added,
      removed and reordered as much as you like.
   -  Flexible layouts system:

      -  Provide a range of templates for any rich content model.
      -  Each template can define its own placeholders.
   - Consistent API for content, allowing maximum re-use of template code.

-  Built-in rich content models:

   -  Pages are permanent content (they appear in site map, and generally are
      accessed via permanent nav).
   -  Articles are ongoing/editorial content arranged in many different ways,
      e.g. by tag, listing, category.
   -  Authors, for promoting people who create your content.

-  Essential content plugins:

   -  Rich text
   -  Asset from the library, with overrideable/removeble caption
   -  Embed Instagram, Youtube/Vimeo videos, Soundcloud audio, etc.
   -  Raw HTML
   -  Maps
   -  Pull quotes, with links to source
   -  Slideshows and image galleries
   -  Extend these or add your own

-  Powerful asset library, to manage images, files, video, audio and
   reusable content

-  Friendly, powerful, admin interface

   -  Customisable dashboard - the things you use all the time are right at the
      top

-  Customisable search

   -  Powered by `Elastic Search`_
   -  Facet by type of content, then content-specific sub-facets.
   -  Easily create content-specific search pages

- Create and publish custom forms

   - Contact forms
   - Surveys
   - Applications
   - Acquittals

Designed to support your content workflow
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-  Preview, publish and unpublish rich content models
-  Simple, customisable User and Group permissions

   - Editors, publishers, supersuers

-  Content can be assigned to someone to take the next action
-  Streamlined content review	and publishing workflow
-  Generate a secret review link to allow anyone to review content

   - useful for external reviewers who don't need CMS accounts.


Made for developers to love
~~~~~~~~~~~~~~~~~~~~~~~~~~~

-  Easy to get up and running
-  Architected by an experienced company who cares about craftsmanship
-  Built on open-source
-  Strong test coverage
-  Built with Django, which makes it easy to keep data in its natural
   structure, ready for clean migrations and easy export
-  Made in Python, a language that is fun to use and fast to innovate on, and
   which makes it easy to connect to existing systems and legacy data
-  Structured for easy installation and deployment using Docker
-  Designed for high performance and continuous up-time

   - works with `Travis CI`_ and `Docker Cloud`_ to only deploy when tests pass
   - `Docker Cloud` makes scaling services as easy as dragging a slider

More information
~~~~~~~~~~~~~~~~

For more detail on how ICEkit works, see :doc:`/architecture/index`.

For recent updates, see the :doc:`/changelog`.


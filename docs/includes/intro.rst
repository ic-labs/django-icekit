.. The following also appears in README. Keep synchronised.

GLAMkit is a next-generation Python CMS by |the IC|_, designed especially for
the cultural sector. It has tools for dealing with complex events, collections,
press releases, sponsors, and a institutional storytelling engine.

ICEkit sits one layer below GLAMkit, and is a framework for building CMSes.
It has publishing and workflow tools for small teams of content professionals,
and a powerful content framework, based on django-fluent_. Everything is written
in Python, using the Django framework.

.. rubric:: Key features

ICEkit has:

-  Patterns for hierarchical pages and collections of rich content models.
-  Advanced publishing / preview / unpublishing controls
-  Simple workflow controls
-  Content plugins for working with rich text, images, embedded media, etc.
-  Customisable site search using `Elastic Search`_
-  `django-reversion`_ compatible, allowing versioning of content
-  Customisable admin dashboard
-  Docker-compatible project template supplied
-  Batteries included: bower, LessCSS, Bootstrap
-  Easily extensible with models, templates, plugins, etc.

GLAMkit extends ICEkit with:

-  complex repeating calendared events
-  collection patterns: art, moving image, etc.
-  a story-telling engine (e.g. rich 'watch', 'read', 'listen' articles)
-  press releases
-  sponsors

GLAMkit is delivered as a Docker-compatible package, which means that it's easy
to share a consistent development environment across your team, or to deploy on
any Docker-compatible web host, including top-tier cloud hosting services like
AWS.

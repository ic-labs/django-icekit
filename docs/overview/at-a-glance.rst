ICEkit at a glance
==================

ICEkit is a next-generation Python CMS by |the IC|_. It has publishing and
workflow tools for small teams of content professionals, and a powerful content
framework, based on django-fluent_. ICEkit is written in Python, using the
Django framework.

ICEkit is delivered as a Docker-compatible package, which means that it's easy
to share a consistent development environment across your team, or to deploy on
any Docker-compatible web host, including top-tier cloud hosting services like
AWS.

Key features
------------

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

What is GLAMkit?
----------------

GLAMkit_ is an extension of ICEkit designed especially for
Galleries, Libraries, Archives and Museums (the GLAM sector) and pretty much
any cultural or collecting institution.

GLAMkit extends ICEkit with:

-  complex repeating calendared events
-  collection patterns: art, moving image, etc.
-  a story-telling engine (e.g. rich 'watch', 'read', 'listen' articles)
-  press releases
-  sponsors

Why did we create ICEkit?
-------------------------

Every day, we at IC_ create and host sites for clients with demanding digital
needs. Our clients have large amounts of content to work through and publish.
They usually only have a small team (of busy people) who edit on the site.
They usually have databases and other systems throughout their organisation
that need to integrate with the site. And of course the result needs to look
great and not break the bank.

ICEkit represents the distillation of our knowledge and experience in working
on technically challenging projects with these clients. Out of the box, it has
everything that small teams of content professionals need to get started
creating and publishing pages of content. ICEkit includes a distillation of
patterns and hooks to allow easy and future-proofed customisation, extension
and integration.

We love building sites in Python/Django, and it's a perfect framework to solve
demanding digital challenges. But no Python CMS has the enterprise-level
workflow and publishing features that our clients need.

So we made one -- and here it is.

More than that, ICEkit also includes our knowledge about how to deploy and
scale. That's why it can be installed and deployed as a scalable Docker image,
which can be installed on any top-tier cloud host.

For more, take a look at our blog series on the
`future of content management <https://interaction.net.au/blog/2015/future-content-management-part-1/>`_.


Who uses ICEkit and GLAMkit?
----------------------------
ICEkit and GLAMkit are used by:

-  `San Francisco Museum of Modern Art <https://www.sfmoma.org>`_
-  `Australian Centre for the Moving Image <https://www.acmi.net.au>`_
-  `Museum of Contemporary Art Australia <http://mca.com.au>`_
-  `Art Gallery of New South Wales <https://www.artgallery.nsw.gov.au/>`_
-  `The National Art School <https://www.nas.edu.au/>`_
.. coming soon -  Art Gallery of South Australia

Read more about :doc:`features`, :doc:`../architecture/index`, or skip ahead to :doc:`creating your first site <first-site>`.

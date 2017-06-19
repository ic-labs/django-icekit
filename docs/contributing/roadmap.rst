Roadmap
=======

Like every open-source project, GLAMkit is looking for people to help contribute
ideas, features, code and issues. This document outlines the medium- and
long-term feature roadmap for GLAMkit. If anything on this list is of interest,
you should get involved - see :doc:`index`.

This roadmap is subject to change as needed -- there is very little stopping us
from bringing features forward if necessary. For a more immediate and detailed
overview, refer to the Github issues_.

Release schedule
----------------

GLAMkit will receive incremental releases every 3-4 months, and major releases
every 8-12 months. The changes in each release are documented in the
:doc:`../changelog`.

Backwards-compatibility
-----------------------

Incremental releases should not break backwards-compatibility with the previous
incremental release, but may introduce deprecations, and may break
backwards-compatibility from versions before the previous incremental release.
If breaking backwards-compatibility is unavoidable, the change
should be documented in the changelog, in the "backwards-incompatible" section.

Version Overview
----------------

Version 0.18
~~~~~~~~~~~~
* Include Events/Collections/Press Releases/Sponsors in the main repository as standard
* Add REST API endpoints for Collection and Images
* Include new EDTF fields in Collection
* Drop any deprecation shims added in 0.16.
* Author listings

Version 0.19
~~~~~~~~~~~~
* Drop any deprecation shims added in 0.17.
* Remove Django-Haystack, using ElasticSearch libraries directly.
* Events Location model
* Solution for adding extended information and themes to Events (a.k.a the minisites replacement)
* Image sRGB colourspace handling

Version 0.20
~~~~~~~~~~~~
* Drop any deprecation shims added in 0.18.
* Return of versioning and reverting
* Factored-out collection search
* Events API

Version 1.0
~~~~~~~~~~~
* Drop any deprecation shims added in 0.19.
* Polymorphic asset refactor
* Solution for reducing the need to fork apps merely to add fields to models.
* Navigation content model
* Improved embargo/archive behaviour
* Education landing page and education search

Version 1.x
~~~~~~~~~~~
* 3rd-party signals notification framework, with email/trello/slack examples, maybe IFTTT/Zapier
* Collection models for natural history museum
* End-user editable header/footer content
* Plan your Visit model and content types
* Advanced Exhibitions model and content types
* Editable help/internal documentation
* Content strategy - set reminders to review content
* Content calendar, showing scheduled events
* Built-in ecommerce
* Email reminders when content is about to go live/deadline approaching, etc.
* Review tools
   * Watch/unwatch for published updates
   * See and reply to comments on front-end and back-end.
* Audience behaviour
   * Visitor surveys - pop-up and inside content
   * Sharing built-in
   * Integrated analytics
* Publish to different platforms
   * Medium
   * Facebook
* Internationalization/localization for multilingual sites
* Digital signage plugins

Version 2.0 and beyond
~~~~~~~~~~~~~~~~~~~~~~
* Import and export GLAMkit data as YAML/JSON
* Make a difference (aka Get Involved) landing page and content types
* Interactive timelines model
* Refactored/custom admin
* Customisable dashboard
* Live preview
* Basic CRM
* Create and track press packs for authorized members of the press
* Front-end/back-end separation (aka "headless mode")
* Custom icon set

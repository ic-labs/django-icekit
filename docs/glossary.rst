Glossary of terms *
=================

.. TODO: merge with concepts, turn off ordering.

.. glossary::

   Content model
      See :term:`Rich content model`.

   Content type
      See :term:`Rich content model`.

   Rich content type
      See :term:`Rich content model`.

   Rich content model
      A Django model that defines one or more placeholders that allow
      term:`content plugin`s to be used, for example "Page", "Press release"
      or "Event".

   Content item
      A Django model that represents a 'block' of content that can be added to
      any rich content model, for example "Text", "Image", "Embedded Media".

      Content items are related to rich content models by a generic foreign
      key, using the ``fluent-contents`` approach.

   Content plugin
      A class that registers a content item in GLAMkit which specifies how
      it is to be rendered in a given context and
how it is edited in the admin.


   ICEkit
      ICEkit_ is the engine that runs GLAMkit (actually GLAMkit is just an
      extended set of settings and requirements on top of ICEkit). ICEkit is a
      basic CMS toolkit, designed for small teams of content professionals.

   .. Placeholder

   .. Layout

   .. Page

   .. Collected Content

   Editor
      A person who uses the CMS admin system to edit content.

   Publisher
      A person who publishes content once it has been edited.

   Rich content
      A sorted list of term:`content plugin` items.

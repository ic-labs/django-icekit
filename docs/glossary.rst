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
      A class that registers a content item in ICEkit which specifies how
      it is
       to be rendered in a given context and
how it is edited in the admin.


   GLAMkit
      GLAMkit_ is an extension of ICEkit designed especially for
      Galleries, Libraries, Archives and Museums (the GLAM sector) and pretty much
      any cultural or collecting institution.

      Concretely, GLAMkit uses an extended set of Python requirements, and a
      different settings file. It's otherwise the same codebase as ICEkit.

   .. Placeholder

   .. Layout

   .. Page

   .. Collected Content

   Editor
      A person who uses the ICEkit admin system to edit content.

   Publisher
      A person who publishes content once it has been edited.

   Rich content
      A sorted list of term:`content plugin` items.

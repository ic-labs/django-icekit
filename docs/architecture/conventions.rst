Architectural conventions *
=========================

One of the intentions of ICEkit is to implement a common approach for
working with web content, in order to maximise predictability and template
reusability, without being so prescriptive as to prevent innovation and
easy extension.

This common approach is embodied in ``ListableMixin``, which describes several
common methods for retrieving information about an item of content.

The original intention behind ``ListableMixin`` was to provide a common
interface for showing items of content in a list, such as in search results,
related items, or listings pages. In practice, the same interface can be used
by templates for rendering different kinds of contents without unnecessary
duplication of template code.

.. TODO: pic of item in list from acmi (with preview links)

Using methods rather than properties in content models
------------------------------------------------------

Different content may use different techniques to describe themselves. For
example, the title of an article may be the value of the ``title`` field, but
the title of an artwork may be the title field with the year appended.

In order to avoid reimplementing templates for every variation of content,
ICEkit uses ``get_FOO()`` methods to access attributes, even if the attribute
is trivial, like a field.

The reason we don't use getter and setter properties is to allow calls to be
parameterised when called from within Python, and to make it easier to override
injected properties such as Django fields.

Portable apps
-------------

ICEkit models and content plugins are portable, which means the code can be
moved without affecting table names or migration history.

This is useful to cleanly extend ICEkit functionality beyond what can be
accomplished by subclassing.

For more, see :doc:`../topics/portable-apps`


Template contexts
-----------------

In ICEkit contents that render templates, there is a convention of naming the
primary content object ``page`` in the template context. Thus, in an Article
view, the template context is populated with ``'page': article``. Similarly with
Event models.

And each `page` object implements sever

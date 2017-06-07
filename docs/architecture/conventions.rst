Architectural conventions
=========================

One of GLAMkit's intentions is to implement a common approach for
working with web content, in order to maximise predictability and template
reusability, without being so prescriptive as to prevent innovation and
easy extension.

This section gives an overview of conventions to follow when using and extending
the CMS.


Template contexts
-----------------

In GLAMkit contents models that render templates, there is a convention of
naming the primary content object ``page`` in the template context. Thus, in an Article
view, the template context is populated with the context ``{'page': article}``.
Similarly in Event models, the context variable ``page`` is the event to be
rendered.

``ListableMixin``
-----------------

Major content types (for example, ``Page``, ``Article``,
``PressRelease``, ``Event``) implement :doc:`content/listable`, which describes
several common methods for retrieving attributes of an item of content.

The original intention behind ``ListableMixin`` was to provide a common
interface for showing items of content in a list, such as in search results,
related items, or listings pages. In addition, the same interface can be used
by templates for rendering different kinds of contents without unnecessary
duplication of template code.

.. TODO: pic of item in list from acmi (with preview links)

Using methods (rather than properties) in content models
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Different content may use different techniques to describe themselves. For
example, the title of an 'article' may be the value of the ``title`` field, but
the title of an 'artwork' may include the artist and year.

In order to avoid reimplementing templates for every variation of content,
we use ``get_FOO()`` methods to access attributes, even if the attribute
is trivial, like a field.

.. note::
   The reason we don't use getter and setter properties is to allow calls to be
   parameterised when called from within Python, and to avoid needing to
   override protected or injected properties, such as Django fields.

Portable apps
-------------

GLAMkit models and content plugins are portable, which means the code can be
moved without affecting table names or migration history.

This is useful to cleanly extend functionality beyond what can be
accomplished by subclassing.

For more, see :doc:`../topics/portable-apps`

Naming Conventions
------------------

GLAMkit is spelled as one word with an uppercase GLAM and lowercase 'kit'.

Model Classes
~~~~~~~~~~~~~

-  Use ``AbstractFoo`` for abstract models.
-  Use ``FooMixin`` for abstract models that are designed to be mixed-in to
   other models.

Admin Classes
~~~~~~~~~~~~~

Use ``AbstractFooAdmin`` or ``FooMixinAdmin`` for the corresponding admin
   classes.

When defining abstract or mixin models, it's helpful to define a corresponding
``ModelAdmin`` class which defines useful fieldsets and other attributes.

That means in concrete admin subclasses, it's easy to concatenate the
attributes of the parent classes to avoid unDRY admin specification.
Wherever possible, define admin attributes as tuples for consistent
concatenation::

   class FOOAttributesMixinAdmin(admin.ModelAdmin):
       FIELDSETS = (
           ('FOO attributes', {
               'fields': (
                   'big_ideas',
                   'recommended_for',
                   'education_groups',
               )
           }),
       )

       filter_horizontal = ('big_ideas', 'recommended_for', 'education_groups', )

   class ConcreteAdmin(FOOAttributesMixinAdmin):
       fieldsets = \
           (('Details', {
               'fields': (
                   'rating',
                   'imdb_link',
               )
           }),) + \
           FOOAttributesMixinAdmin.FIELDSETS



.. TODO: describe project layout conventions


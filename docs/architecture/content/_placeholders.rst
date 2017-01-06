:orphan:

Placeholders *
==============

When an editor edits rich content in ICEkit, she adds **Content
Plugins** into one or more **Placeholders**.

Placeholders are specified in the html template that is associated with
the rich content model. At render time, each ``render_placeholder``
template tag renders all of the content items as they were added by the
editor.

Allowing direct access to slot contents with ``PlaceholderDescriptor``
----------------------------------------------------------------------

There are several times where it is useful to gain direct access to a
slots contents without wanting to render them. The is especially useful
in templates to detect if there are any slot contents so that the
rendered slot output can be wrapped in appropriate tags.

Adding ``PlaceholderDescriptor`` to a model class
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

``PlaceholderDescriptor`` assumes that ``Placeholder`` objects are
created for the appropriate model class.

To add the descriptor directly to the model class create a property on
the class and create an instance of ``PlaceholderDescriptor``.

::

    from icekit.plugins.descriptors import PlaceholderDescriptor


    class TestFluentPage(AbstractFluentPage):
        slots = PlaceholderDescriptor()

For external libraries a monkey patching utility is provided. Calling
the monkey patch function with the model class is all that is required.

::

    from fluent_pages.pagetypes.fluentpage.models import FluentPage
    from icekit.plugins.descriptors import contribute_to_class


    contribute_to_class(FluentPage)

Using ``PlaceholderDescriptor``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

When accessed via an instance of a model class with
``PlaceholderDescriptor`` enabled a ``PlaceholderAccess`` object is
created with all of the slot names available as attributes. If we have
an instance with contents in a ``Placeholder`` named ``main`` we would
access the contents by accessing the property such as
``instance.slots.main``. This will return an ordered ``QuerySet`` of
content items for that slot.

If not corresponding slot exists on the referenced property an
``AttributeError`` will be thrown. This is swallowed in templates.
Fluent contents will only create a ``Placeholder`` object when data is
to be added to the relevant slot so the ``AttributeError`` may be thrown
before the initial data is created.

You may also perform the lookup in a dictionary style manner such as
``instance.slots['main']`` and if the slot referenced does not exist a
``KeyError`` will be raised.

Template tags
~~~~~~~~~~~~~

As slot names are arbitrary strings they may use characters which wont
allow access to attributes on descriptors in templates e.g. the '-'
character.

To help with this problem some template tags have been created.

To use any of the following tags you will need to load ``icekit_tags``
into your template. To do this at the top of your template do the
following:

::

    {% load icekit_tags %}

Template tag: ``get_slot_contents``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The tag ``get_slot_contents`` may be used as a filter, or an assignment
tag.

In each of the below examples we will assume that we have an object
named ``page`` with a ``PlaceholderDescriptor`` on it named ``slots``
and a placeholder with a slot named ``test-main``.

To use this tag as a filter:

::

    {{ page.slots|get_slot_contents:'test-main' }}

This will output the list of contents directly into your template (which
is only useful for debugging).

Each of the these items can be iterated and worked on as required e.g.

::

    {% for item in page.slots|get_slot_contents:'test-main' %}
        {{ item }}
    {% endfor %}

The assignment tag will allow assignment to a variable name for use
later in your template. If we wanted to assign the returned list into a
variable named ``testname`` we can do the following:

::

    {% get_slot_contents page.slots 'test-main' as testname %}

This will then let us work on the contents later in the template e.g.

::

    {% for item in testname %}
        {{ item }}
    {% endfor %}

If a placeholder does not exist ``None`` will be returned.

# Features Specific for Fluent Contents

Most ICEkit content uses the Fluent-contents system for adding an ordered list of arbitrary
content items to a given Django model (aka "Rich Content"). A content item is a (usually) small
django model for representing an item of content on a page and can have any fields that a normal
model has.

ContentItems and Fluent Contents models (which contain them) are related with Generic Foreign Keys.

ICEkit comes with a fairly complex `AbstractLayoutPage` model, which implements a Publishable
FluentPage - ie it's a Polymorphic model that sits in a tree (you can have many kinds of rich
content pages being parents of each other in a tree), and each such page has a draft copy and a
published copy. This is useful for a permanent page hierarchy, particularly things that are
included in a site's information architecture. See `icekit.pagetypes` for included examples of usage.

ICEkit also has a simpler `AbstractArticle` model, which implements a Publishable Fluent Contents
model - ie it's a straightforward Django model that happens to have rich content and be publishable.
This is useful for more normal Django collections-of-things, like Press Releases, People, Articles.
It's common to have a collecton of items with a paired `AbstractLayoutPage` Page to list/navigate
the collection. See `icekit-press-releases` for a worked example of this.

## Which content plugins are being used in the project and how do I remove / add one?

All content plugins need to be registered with `INSTALLED_APPS` as they are self contained Django
apps. Each of these apps to be available for registration must extend `ContentItem` for the model
declaration and `ContentPlugin` for the registration for use.

To be able to find which plugins are installed into the project looking in `INSTALLED_APPS` can
start you on the process of discovery as well as searching the project and environment for
`ContentItem` or `ContentPlugin`.

If the app is installed it does not necessarily mean that it is available for use every where in
the project. There is a setting named `FLUENT_CONTENTS_PLACEHOLDER_CONFIG` which allows each region
to have specified content plugins enabled for it. If the region is not defined in this setting it is
assume that all content plugins are appropriate for use with it.

To add a content plugin to a project add it in `INSTALLED_APPS` and if applicable define its use in
`FLUENT_CONTENTS_PLACEHOLDER_CONFIG`.

To remove a content plugin first ensure all the content instances have been removed from your
database and then remove the content plugin from `INSTALLED_APPS` and
`FLUENT_CONTENTS_PLACEHOLDER_CONFIG`.

## Allowing direct access to slot contents with `PlaceholderDescriptor`

There are several times where it is useful to gain direct access to a slots contents without
wanting to render them. The is especially useful in templates to detect if there are any slot
contents so that the rendered slot output can be wrapped in appropriate tags.

### Adding `PlaceholderDescriptor` to a model class

`PlaceholderDescriptor` assumes that `Placeholder` objects are created for the appropriate model
 class.

To add the descriptor directly to the model class create a property on the class and create an
instance of `PlaceholderDescriptor`.

    from icekit.plugins.descriptors import PlaceholderDescriptor


    class TestFluentPage(AbstractFluentPage):
        slots = PlaceholderDescriptor()


For external libraries a monkey patching utility is provided. Calling the monkey patch function
with the model class is all that is required.

    from fluent_pages.pagetypes.fluentpage.models import FluentPage
    from icekit.plugins.descriptors import contribute_to_class


    contribute_to_class(FluentPage)

### Using `PlaceholderDescriptor`

When accessed via an instance of a model class with `PlaceholderDescriptor` enabled a
`PlaceholderAccess` object is created with all of the slot names available as attributes. If we have
an instance with contents in a `Placeholder` named `main` we would access the contents by accessing
the property such as `instance.slots.main`. This will return an ordered `QuerySet` of content items
for that slot.

If not corresponding slot exists on the referenced property an `AttributeError` will be thrown. This
is swallowed in templates. Fluent contents will only create a `Placeholder` object when data is to
be added to the relevant slot so the `AttributeError` may be thrown before the initial data is
created.

You may also perform the lookup in a dictionary style manner such as `instance.slots['main']` and
if the slot referenced does not exist a `KeyError` will be raised.

### Template tags

As slot names are arbitrary strings they may use characters which wont allow access to attributes
on descriptors in templates e.g. the '-' character.

To help with this problem some template tags have been created.

To use any of the following tags you will need to load `icekit_tags` into your template. To do this
at the top of your template do the following:

    {% load icekit_tags %}

#### Template tag: `get_slot_contents`

The tag `get_slot_contents` may be used as a filter, or an assignment tag.

In each of the below examples we will assume that we have an object named `page` with a
`PlaceholderDescriptor` on it named `slots` and a placeholder with a slot named `test-main`.

To use this tag as a filter:

    {{ page.slots|get_slot_contents:'test-main' }}

This will output the list of contents directly into your template (which is not very useful).

Each of the these items can be iterated and worked on as required e.g.

    {% for item in page.slots|get_slot_contents:'test-main' %}
        {{ item }}
    {% endfor %}

The assignment tag will allow assignment to a variable name for use later in your template.
If we wanted to assign the returned list into a variable named `testname` we can do the following:

    {% get_slot_contents page.slots 'test-main' as testname %}

This will then let us work on the contents later in the template e.g.

    {% for item in testname %}
        {{ item }}
    {% endfor %}

If a placeholder does not exist `None` will be returned.


## Frequently Asked Questions

### How do I target a specific page layout with a plugin?

[Defining a 'placeholder slot'](https://django-fluent-contents.readthedocs.org/en/latest/templatetags.html#cms-page-placeholders)

[Configuring the available plugins](https://django-fluent-contents.readthedocs.org/en/latest/configuration.html#configuration)

### How do I make changes to the fields on a plugin that lives in the venv? How do I add/remove fields in the admin?

Inherit from the plugin, make changes as a subclass, use `fieldsets` (property on the content plugin) to hide fields.

Refer to [fluent-contents](https://django-fluent-contents.readthedocs.org/en/latest/index.html) - specifically [Customizing the admin interface](https://django-fluent-contents.readthedocs.org/en/latest/newplugins/admin.html)

### How do I know what plugins are available in IC repos so that I don't roll my own?

Look through IC repos (check Icekit/Glamkit, specifically the plugins directory). Also ask people.

### How much of icekit is django-fluent and how much of it has been rolled bespoke - what's our maintenance debt?

Currently fluent pages is running a branch that adds support for reversions. Sometime soon, this should all get merged into the fluent-pages repo.

Everything else is just extensions and normal stuff.

### When something breaks in the new system, what's the order of people that I should ask for help?

Backend: Tai Lee, James Murty, Greg Turner, Mark Finger
Frontend: Mark Finger, Greg Turner

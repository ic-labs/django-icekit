# Features Specific for Fluent Contents

## Allowing direct access to slot contents with `SlotDescriptor`

There are several times where it is useful to gain direct access to a slots contents without 
wanting to render them. The is especially useful in templates to detect if there are any slot 
contents so that the rendered slot output can be wrapped in appropriate tags.

### Adding `SlotDescriptor` to a model class

`SlotDescriptor` assumes that `Placeholder` objects are created for the appropriate model class.

To add the descriptor directly to the model class create a property on the class and create an 
instance of `SlotDescriptor`.

```
from icekit.plugins.descriptors import SlotDescriptor


class TestFluentPage(AbstractFluentPage):
    slots = SlotDescriptor()
```

For external libraries a monkey patching utility is provided. Calling the monkey patch function 
with the model class is all that is required.

```
from fluent_pages.pagetypes.fluentpage.models import FluentPage
from icekit.plugins.descriptors import monkey_patch


monkey_patch(FluentPage)
```

### Using `SlotDescriptor`

When accessed via an instance of a model class with `SlotDescriptor` enabled a `PlaceholderAccess` 
object is created with all of the slot names available as attributes. If we have an instance with 
contents in a `Placeholder` named `main` we would access the contents by accessing the property such
as `instance.slots.main`. This will return an ordered `QuerySet` of content items for that slot.
 
If not corresponding slot exists on the referenced property an `AttributeError` will be thrown. This 
is swallowed in templates. Fluent contents will only create a `Placeholder` object when data is to 
be added to the relevant slot so the `AttributeError` may be thrown before the initial data is 
created.

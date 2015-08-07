from django.contrib.contenttypes.models import ContentType


# USEFUL FUNCTIONS FOR FLUENT CONTENTS #############################################################

# Fluent Contents Helper Functions #################################################################
def create_content_instance(content_plugin_class, test_page, placeholder_name='main', **kwargs):
    """
    Creates a content instance from a content plugin class.

    :param content_plugin_class: The class of the content plugin.
    :param test_page: The fluent_page instance to create the content
    instance one.
    :param placeholder_name: The placeholder name defined in the
    template. [DEFAULT: main]
    :param kwargs: Additional keyword arguments to be used in the
    content instance creation.
    :return: The content instance created.
    """
    # Get the placeholders that are currently available for the slot.
    placeholders = test_page.get_placeholder_by_slot(placeholder_name)

    # If a placeholder exists for the placeholder_name use the first one provided otherwise create
    # a new placeholder instance.
    if placeholders.exists():
        placeholder = placeholders[0]
    else:
        placeholder = test_page.create_placeholder(placeholder_name)

    # Obtain the content type for the page instance class.
    ct = ContentType.objects.get_for_model(type(test_page))

    # Create the actual plugin instance.
    try:
        content_instance = content_plugin_class.objects.create(
            parent_type=ct,
            parent_id=test_page.id,
            placeholder=placeholder,
            **kwargs
        )
    except TypeError:
        raise Exception(
            'Could not create content item instance, ensure you '
            'have all required field values for the Model.'
        )
    return content_instance

# END Fluent Contents Helper Functions #############################################################

from django.contrib.contenttypes.models import ContentType


# USEFUL FUNCTIONS DESIGNED FOR TESTS ##############################################################

# Fluent Contents Helper Functions #################################################################
def create_content_instance(content_plugin_class, page, placeholder_name='main', **kwargs):
    """
    Creates a content instance from a content plugin class.

    :param content_plugin_class: The class of the content plugin.
    :param page: The fluent_page instance to create the content
    instance one.
    :param placeholder_name: The placeholder name defined in the
    template. [DEFAULT: main]
    :param kwargs: Additional keyword arguments to be used in the
    content instance creation.
    :return: The content instance created.
    """
    # Get the placeholders that are currently available for the slot.
    placeholders = page.get_placeholder_by_slot(placeholder_name)

    # If a placeholder exists for the placeholder_name use the first one provided otherwise create
    # a new placeholder instance.
    if placeholders.exists():
        placeholder = placeholders[0]
    else:
        placeholder = page.create_placeholder(placeholder_name)

    # Obtain the content type for the page instance class.
    ct = ContentType.objects.get_for_model(type(page))

    # Create the actual plugin instance.
    content_instance = content_plugin_class.objects.create(
        parent_type=ct,
        parent_id=page.id,
        placeholder=placeholder,
        **kwargs
    )
    return content_instance

# END Fluent Contents Helper Functions #############################################################

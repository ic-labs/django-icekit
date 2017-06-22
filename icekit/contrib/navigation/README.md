icekit.contrib.navigation
=========================


Installation
------------

In project settings

```
INSTALLED_APPS += (
    'icekit.contrib.navigation',
)

FLUENT_CONTENTS_PLACEHOLDER_CONFIG['navigation_content'] = {
    'plugins': DEFAULT_NAVIGATION_CONTENT_PLUGINS,
}
```


Usage
-----


```
{% load icekit_contrib_navigation_tags %}

{% render_navigation 'main_nav' %}
```

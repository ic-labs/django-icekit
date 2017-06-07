APIs
====


APIs provide a way for clients to read data from, and sometimes write data
to, GLAMkit sites using programmatic interfaces instead of manually through
the web admin.

GLAMkit's API features are built with the `Django REST framework
<http://www.django-rest-framework.org/>`_ library.

Settings
--------

To enable these APIs:

- add to ``INSTALLED_APPS`` the apps ``'rest_framework``,
  ``rest_framework.authtoken`` (if using authentication tokens), and
  ``icekit.api``
- add URL patterns for the root API endpoint, such as:
  ``url(r'^api/', include('icekit.api.urls'))``

Note that most projects -- which are based on the standard templates and use
the default GLAMkit settings -- will already have the APIs enabled.

API access and privileges are configured with the ``REST_FRAMEWORK`` Django
setting. In GLAMkit the default API permissions are to require either
session-based or token-based user authentication (no anonymous users), and to
permit or deny API actions based on Django's model permissions. These settings
are defined as follows::

    REST_FRAMEWORK = {
        'DEFAULT_AUTHENTICATION_CLASSES': (
            # Enable session authentication for simple access via web browser and
            # for AJAX requests, see
            # http://www.django-rest-framework.org/api-guide/authentication/#sessionauthentication
            'rest_framework.authentication.SessionAuthentication',
            # Enable token authentication for access by clients such as bots
            # outside a web browser context, see
            # http://www.django-rest-framework.org/api-guide/authentication/#tokenauthentication
            'rest_framework.authentication.TokenAuthentication',
        ),
        'DEFAULT_PERMISSION_CLASSES': (
            # Apply Django's standard model permissions for API operations, with
            # customisation to prevent any API access for GET listings, HEAD etc
            # to those users permitted to view model listings in the admin. See
            # http://www.django-rest-framework.org/api-guide/permissions/#djangomodelpermissions
            'icekit.utils.api.DjangoModelPermissionsRestrictedListing',
        )
    }

Use the APIs
------------

Web Interface
^^^^^^^^^^^^^

You can explore the APIs exposed on a GLAMkit site in a standard web browser
by visiting the root API URL path, generally */api/*.

Programmatic Clients
^^^^^^^^^^^^^^^^^^^^

To use the APIs from other systems or programs, instead of manually in a web
browser, you must use token-based authentication to identify your program to
the site.
See the Django REST framework documentation on
`token authentication
<http://www.django-rest-framework.org/api-guide/authentication/#tokenauthentication>`_.

Visit the tokens administration section in the site CMS admin at
*/admin/authtoken/token/* to generate a per-user authentication tokens,
then include this token value in the ``Authorization`` HTTP header value in
requests from your client. Note that the full format for this header is::

    Authorization: Token <token-key-value>

Images API
----------

The Images API is a **read and write** API for the ``icekit.plugins.image.Image``
model, and is available by default at */api/images/*.

This API uses the default access and privilege settings.

Here are example curl commands to perform API operations with token
authorisation, assuming the token's associated user has sufficient permissions.

List Images::
    curl -X GET -H 'Authorization: Token abc123' http://icekit.lvh.me:8000/api/images/

Get details of a specific image with ID=1::
    curl -X GET -H 'Authorization: Token abc123' http://icekit.lvh.me:8000/api/images/1/

Create an Image::
    curl -X POST -H 'Authorization: Token abc123' --form title='New image' --form image=@image_file.jpg http://icekit.lvh.me:8000/api/images/

Replace an image (must include image file data)::
    curl -X PUT -H 'Authorization: Token abc123' --form title='Replaced image' --form image=@image_file.jpg http://icekit.lvh.me:8000/api/images/1/

Update an image (can be with partial changes, image file data need not be included)::
    curl -X PATCH -H 'Authorization: Token abc123' --form title='Updated image' http://icekit.lvh.me:8000/api/images/1/

Delete an image::
    curl -X DELETE -H 'Authorization: Token abc123' http://icekit.lvh.me:8000/api/images/1/


Pages API
---------

The Pages API is a **public-access** and **read-only** API for site pages that
are published, and is available by default at */api/pages/*.

This API does not use the default privilege settings, since it is available to
the general public (you don't need to authenticated) and provides only
read-only access.

Here are example curl commands to perform API operations.

List Pages::
    curl -X GET http://icekit.lvh.me:8000/api/pages/

Get details of a specific published page with ID=1::
    curl -X GET http://icekit.lvh.me:8000/api/pages/1/

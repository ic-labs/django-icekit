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
by visiting the API endpoint.

The API endpoint will be at a custom subdomain if your project is configured
with this feature using ``django_hosts``, e.g. https://api.icekit.lvh.me

If your site is not configured with the API subdmain this endpoint will be
at a root API URL path instead, generally */api/*.

If you are accessing APIs where user privileges are required, you can log in
to the API interface at http://api.icekit.lvh.me:8000/login/ if the API is on
a custom subdomain, or at the standard login URL if the API is on the normal
domain under */api/*.

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
model, and is available by default at */images/*.

This API uses the default access and privilege settings, which means you must
provide an authorization token in requests.

Here are example curl commands to perform API operations with token
authorisation, assuming the token's associated user has sufficient permissions.

List Images::
    curl -X GET \
         -H 'Authorization: Token abc123' \
         http://api.icekit.lvh.me:8000/images/

Create an Image::
    curl -X POST \
         -H 'Authorization: Token abc123' \
         --form title='New image' \
         --form image=@image_file.jpg \
         http://api.icekit.lvh.me:8000/images/

Get details of a specific image with ID=1::
    curl -X GET \
         -H 'Authorization: Token abc123' \
         http://api.icekit.lvh.me:8000/images/1/

Replace an image with ID=1 (must include image file data)::
    curl -X PUT \
         -H 'Authorization: Token abc123' \
         --form title='Replaced image' \
         --form image=@image_file.jpg \
         http://api.icekit.lvh.me:8000/images/1/

Update an image with ID=1 (for partial changes, image file data not required)::
    curl -X PATCH \
         -H 'Authorization: Token abc123' \
         --form title='Updated image' \
         http://api.icekit.lvh.me:8000/images/1/

Delete an image with ID=1::
    curl -X DELETE \
         -H 'Authorization: Token abc123' \
         http://api.icekit.lvh.me:8000/images/1/


Pages API
---------

The Pages API is a **public-access** and **read-only** API for site pages that
are published, and is available by default at */pages/*.

This API does not use the default privilege settings, since it is available to
the general public (you don't need to authenticated) and provides only
read-only access.

Here are example curl commands to perform API operations.

List Pages::
    curl -X GET http://api.icekit.lvh.me:8000/pages/

Get details of a specific published page with ID=1::
    curl -X GET http://api.icekit.lvh.me:8000/pages/1/


GLAMkit Collections API
-----------------------

The GLAMkit Collections API is a **read and write** API for Collections models
including Artwork, Film, Game, Person, and Organization that is accessible only
to authenticated users with permissions to write and/or read specific models.

This API uses the default access and privilege settings, which means you must
provide an authorization token in requests.

Here are example curl commands to perform API operations.

Artwork (``gk_collections_artwork.Artwork``)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Get list of items::
    curl -X GET \
         -H 'Authorization: Token abc123' \
         http://api.icekit.lvh.me:8000/artwork/

Create a minimal item, with required fields only::
    curl -X POST \
         -H 'Authorization: Token abc123' \
         -H 'Content-Type: application/json' \
         -d '{"title": "New Item"}' \
         http://api.icekit.lvh.me:8000/artwork/

Get details of a specific item with ID=1::
    curl -X GET  \
         -H 'Authorization: Token abc123' \
         http://api.icekit.lvh.me:8000/artwork/1/

Replace an item with ID=1::
    curl -X PUT \
         -H 'Authorization: Token abc123' \
         -H 'Content-Type: application/json' \
         -d '{"title": "Replaced Item"}' \
         http://api.icekit.lvh.me:8000/artwork/1/

Update an item with ID=1::
    curl -X PATCH \
         -H 'Authorization: Token abc123' \
         -H 'Content-Type: application/json' \
         -d '{"title": "Updated Item"}' \
         http://api.icekit.lvh.me:8000/artwork/1/

Delete an item with ID=1::
    curl -X DELETE \
         -H 'Authorization: Token abc123' \
         http://api.icekit.lvh.me:8000/artwork/1/


Film (``gk_collections_film.Film``)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Get list of items::
    curl -X GET \
         -H 'Authorization: Token abc123' \
         http://api.icekit.lvh.me:8000/film/

Create a minimal item, with required fields only::
    curl -X POST \
         -H 'Authorization: Token abc123' \
         -H 'Content-Type: application/json' \
         -d '{"title": "New Item"}' \
         http://api.icekit.lvh.me:8000/film/

Get details of a specific item with ID=1::
    curl -X GET  \
         -H 'Authorization: Token abc123' \
         http://api.icekit.lvh.me:8000/film/1/

Replace an item with ID=1::
    curl -X PUT \
         -H 'Authorization: Token abc123' \
         -H 'Content-Type: application/json' \
         -d '{"title": "Replaced Item"}' \
         http://api.icekit.lvh.me:8000/film/1/

Update an item with ID=1::
    curl -X PATCH \
         -H 'Authorization: Token abc123' \
         -H 'Content-Type: application/json' \
         -d '{"title": "Updated Item"}' \
         http://api.icekit.lvh.me:8000/film/1/

Delete an item with ID=1::
    curl -X DELETE \
         -H 'Authorization: Token abc123' \
         http://api.icekit.lvh.me:8000/film/1/


Game (``gk_collections_game.Game``)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Get list of items::
    curl -X GET \
         -H 'Authorization: Token abc123' \
         http://api.icekit.lvh.me:8000/game/

Create a minimal item, with required fields only::
    curl -X POST \
         -H 'Authorization: Token abc123' \
         -H 'Content-Type: application/json' \
         -d '{"title": "New Item"}' \
         http://api.icekit.lvh.me:8000/game/

Get details of a specific item with ID=1::
    curl -X GET  \
         -H 'Authorization: Token abc123' \
         http://api.icekit.lvh.me:8000/game/1/

Replace an item with ID=1::
    curl -X PUT \
         -H 'Authorization: Token abc123' \
         -H 'Content-Type: application/json' \
         -d '{"title": "Replaced Item"}' \
         http://api.icekit.lvh.me:8000/game/1/

Update an item with ID=1::
    curl -X PATCH \
         -H 'Authorization: Token abc123' \
         -H 'Content-Type: application/json' \
         -d '{"title": "Updated Item"}' \
         http://api.icekit.lvh.me:8000/game/1/

Delete an item with ID=1::
    curl -X DELETE \
         -H 'Authorization: Token abc123' \
         http://api.icekit.lvh.me:8000/game/1/


Person (``gk_collections_person.PersonCreator``)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Get list of items::
    curl -X GET \
         -H 'Authorization: Token abc123' \
         http://api.icekit.lvh.me:8000/person/

Create a minimal item, with required fields only::
    curl -X POST \
         -H 'Authorization: Token abc123' \
         -H 'Content-Type: application/json' \
         -d '{"name": {"full": "New Person"}}' \
         http://api.icekit.lvh.me:8000/person/

Get details of a specific item with ID=1::
    curl -X GET  \
         -H 'Authorization: Token abc123' \
         http://api.icekit.lvh.me:8000/person/1/

Replace an item with ID=1::
    curl -X PUT \
         -H 'Authorization: Token abc123' \
         -H 'Content-Type: application/json' \
         -d '{"name": {"full": "Replaced Person"}}' \
         http://api.icekit.lvh.me:8000/person/1/

Update an item with ID=1::
    curl -X PATCH \
         -H 'Authorization: Token abc123' \
         -H 'Content-Type: application/json' \
         -d '{"name": {"full": "Updated Person"}}' \
         http://api.icekit.lvh.me:8000/person/1/

Delete an item with ID=1::
    curl -X DELETE \
         -H 'Authorization: Token abc123' \
         http://api.icekit.lvh.me:8000/person/1/


Organization (``gk_collections_organization.OrganizationCreator``)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Get list of items::
    curl -X GET \
         -H 'Authorization: Token abc123' \
         http://api.icekit.lvh.me:8000/organization/

Create a minimal item, with required fields only::
    curl -X POST \
         -H 'Authorization: Token abc123' \
         -H 'Content-Type: application/json' \
         -d '{"name_full": "New Organization"}' \
         http://api.icekit.lvh.me:8000/organization/

Get details of a specific item with ID=1::
    curl -X GET  \
         -H 'Authorization: Token abc123' \
         http://api.icekit.lvh.me:8000/organization/1/

Replace an item with ID=1::
    curl -X PUT \
         -H 'Authorization: Token abc123' \
         -H 'Content-Type: application/json' \
         -d '{"name_full": "Replaced Organization"}' \
         http://api.icekit.lvh.me:8000/organization/1/

Update an item with ID=1::
    curl -X PATCH \
         -H 'Authorization: Token abc123' \
         -H 'Content-Type: application/json' \
         -d '{"name_full": "Updated Organization"}' \
         http://api.icekit.lvh.me:8000/organization/1/

Delete an item with ID=1::
    curl -X DELETE \
         -H 'Authorization: Token abc123' \
         http://api.icekit.lvh.me:8000/organization/1/


WorkCreator (``gk_collections_work_creator.WorkCreator``)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Work-Creator represents relationships between a Work (such as an Artwork or
film) and a Creator (a Person or an Organization).

These example assume that there are already work and creator items in the
system with IDs 1 and 2 for works, and 3 for creators.

Get list of relationships::
    curl -X GET \
         -H 'Authorization: Token abc123' \
         http://api.icekit.lvh.me:8000/workcreator/

Create a minimal relationship, with required fields only::
    curl -X POST \
         -H 'Authorization: Token abc123' \
         -H 'Content-Type: application/json' \
         -d '{"work": {"id": 1}, "creator": {"id": 4}}' \
         http://api.icekit.lvh.me:8000/workcreator/

Get details of a specific relationship with ID=1::
    curl -X GET  \
         -H 'Authorization: Token abc123' \
         http://api.icekit.lvh.me:8000/workcreator/1/

Replace a relationship with ID=1::
    curl -X PUT \
         -H 'Authorization: Token abc123' \
         -H 'Content-Type: application/json' \
         -d '{"work": {"id": 2}, "creator": {"id": 3}}' \
         http://api.icekit.lvh.me:8000/workcreator/1/

Update a relationship with ID=1::
    curl -X PATCH \
         -H 'Authorization: Token abc123' \
         -H 'Content-Type: application/json' \
         -d '{"work": {"id": 1}, "creator": {"id": 3}}' \
         http://api.icekit.lvh.me:8000/workcreator/1/

Delete a relationship with ID=1::
    curl -X DELETE \
         -H 'Authorization: Token abc123' \
         http://api.icekit.lvh.me:8000/workcreator/1/

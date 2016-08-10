# Readme

Docs can be found in the [docs](docs/index.md) folder.

## ICEkit Press Releases

This is a simple app to implement general-purpose Press Releases in ICEkit
projects.

Press Releases are publishable, and can contain fluent rich content and
downloadable pdf.

There is also a basic press contacts model.

Also included is a Fluent Page type that lists press releases underneath it.

This app is useful as an example of how to create new rich content models in
ICEkit.

### Installation

These instructions presume you already have an ICEkit project set up.

#### To install the press releases model

* Add `press_releases` to `settings.INSTALLED_APPS`.
* Add
    ```
    'pressrelease_contacts': {
        'plugins': (
            'ContactItemPlugin',
            'TextPlugin',
        ),
    }
    ```
  to `settings.FLUENT_CONTENTS_PLACEHOLDER_CONFIG`.

* Run migrations.
* In the admin, create a Layout that uses the "press releases: Press
Release" template, and is available to the "Press release" content type.

#### To install the optional press release listing page

* Add `press_releases.page` to `settings.INSTALLED_APPS`.
* Run migrations.
* In the admin, create a Layout that uses the "Page: Press release listing"
template, and is available to the "Press release listing" content type.
* You can now create and publish a "Press release listing" page, at the URL of
your choosing.

### TODO

* Test coverage
* Nicer templates
* Incorporate listing mixin, when it is added to ICEkit.
* Abstract out the listing-detail pattern into ICEkit

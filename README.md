## ICEkit Press Releases

This is a simple app to implement general-purpose Press Releases in ICEkit
projects.

Press Releases are publishable, and can contain fluent rich content and
downloadable pdf.

Also included is a Fluent Page type that lists press releases and
serves them at child URLs.

This app is useful as an example of how to create new rich content models in
ICEkit, and to make a mountable Page that lists them.

### Installation

These instructions presume you already have an ICEkit project set up.

#### To install the press releases model

* Add `press_releases` to `settings.INSTALLED_APPS`.
* In `settings`,  enable the `ContactPersonPlugin` plugin for the  `Contacts`
region in the template. Something like:

        FLUENT_CONTENTS_PLACEHOLDER_CONFIG.update({
            'main': {'plugins': DEFAULT_PLUGINS },
            'pressrelease_contacts': {
                'plugins': (
                    'ContactPersonPlugin',
                    'TextPlugin',
                ),
            },
        })

* Run migrations.
* In the admin, create a Layout that uses the "Page: Press release listing"
template, and is available to the "Press release listing" content type.
* You can now create and publish a "Press release listing" page, at the URL of
your choosing.
* In the admin, create a Layout that uses the "press releases: Press
Release" template, and is available to the "Press release" content type.

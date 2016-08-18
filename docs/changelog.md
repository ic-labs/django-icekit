# Changelog

## (in development)

Backwards incompatible changes:

  * Make the `icekit.plugins.image` app "portable". You will need to run a raw
    SQL statement manually to fix Django's migration history when upgrading
    an existing project. See [portable apps](portable-apps.md).

        UPDATE django_migrations SET app='icekit_plugins_image' WHERE app='image';

## 0.9 (11 August 2016)

  * Initial release.

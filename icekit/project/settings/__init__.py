from __future__ import absolute_import

try:
    try:
        # Local (override) project settings.
        from icekit_settings_local import *
    except ImportError:
        # Project settings.
        from icekit_settings import *
except ImportError:
    # ICEkit settings.
    from .calculated import *

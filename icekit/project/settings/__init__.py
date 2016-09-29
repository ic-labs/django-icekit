from __future__ import absolute_import

try:
    # Project settings.
    from icekit_settings import *
    try:
        # Local (override) project settings.
        from icekit_settings_local import *
    except ImportError:
        pass
except ImportError:
    # ICEkit settings.
    from .calculated import *

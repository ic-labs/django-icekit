from __future__ import absolute_import

try:
    try:
        # Local (override) project settings.
        from project_settings_local import *
    except ImportError:
        # Project settings.
        from project_settings import *
except ImportError:
    # ICEkit settings.
    from .icekit import *

# Allows for swappable models to be added to icekit
from icekit.project.settings import swappable

from __future__ import absolute_import

import os

try:
    from icekit_settings import *
except ImportError:
    from .calculated import *

"""
Import local or calculated settings module.
"""
import os

try:
    from .local import *
except ImportError:
    os.environ.setdefault('BASE_SETTINGS_MODULE', 'develop')
    from .calculated import *

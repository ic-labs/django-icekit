import os

try:
    from project.settings import *
except ImportError:
    os.environ.setdefault('BASE_SETTINGS_MODULE', 'develop')
    from .calculated import *

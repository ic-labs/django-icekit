# Do not commit secrets to VCS.

# Environment variables will be loaded from `.env.$DOTENV` or `.env.local`.
# Local settings will be imported from `project_settings_local.py`

from icekit.project.settings.glamkit import *  # glamkit, icekit

# Override the default ICEkit settings to form project settings.

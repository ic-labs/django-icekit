# Do not commit secrets to VCS.

# Local environment variables will be loaded from `.env.local`.
# Additional environment variables will be loaded from `.env.$DOTENV`.
# Local settings will be imported from `project_settings_local.py`

from icekit.project.settings.icekit import *  # glamkit, icekit

# Override the default ICEkit settings to form project settings.

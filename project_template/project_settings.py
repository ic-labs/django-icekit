# Do not commit secrets to VCS.

# Local environment variables will be loaded from `.env.local`.
# Additional environment variables will be loaded from `.env.$DOTENV`.
# Local settings will be imported from `icekit_settings_local.py`

from icekit.project.settings.glamkit import *  # glamkit, icekit

# Override the default ICEkit settings to form project settings.

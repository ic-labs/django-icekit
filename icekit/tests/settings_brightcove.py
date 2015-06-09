"""
Test settings for ``icekit`` app.
"""
from icekit.tests.settings import *

INSTALLED_APPS += (
    'django_brightcove',
    'icekit.plugins.brightcove',
)

# BRIGHTCOVE ##################################################################

BRIGHTCOVE_TOKEN = ''
BRIGHTCOVE_PLAYER = {
    'default': {
        'PLAYERID': 'a_default_player_id',
        'PLAYERKEY': 'a_default_player_key',
    },
    'single': {
        'PLAYERID': 'another_player_id',
        'PLAYERKEY': 'another_player_key',
    },
}

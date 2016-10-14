from .icekit import *

# DJANGO ######################################################################

INSTALLED_APPS += (
    'icekit.page_types.articles',
    'press_releases',
    'sponsors',
)

# ICEKIT ######################################################################

FEATURED_APPS[0]['models'].update({
    'icekit_articles.Article': {
        'verbose_name_plural': 'Articles',
    },
    'icekit_press_releases.PressRelease': {
        'verbose_name_plural': 'Press releases',
    },
})

from fluent_contents.extensions import ContentPlugin
from . import models
from fluent_contents.extensions import plugin_pool


@plugin_pool.register
class TodaysOccurrencesPlugin(ContentPlugin):
    model = models.TodaysOccurrences

    filter_horizontal = ('types_to_show', )
    category = "Events"
    render_template = 'plugins/todays_occurrences/default.html'


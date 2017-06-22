from fluent_contents.extensions import ContentPlugin, plugin_pool
from icekit.contrib.navigation.models import NavigationItem, AccountsNavigationItem


@plugin_pool.register
class NavigationItemPlugin(ContentPlugin):
    model = NavigationItem
    category = None
    render_template = 'icekit/contrib/navigation/navigation_item.html'


@plugin_pool.register
class AccountsNavigationItemPlugin(ContentPlugin):
    model = AccountsNavigationItem
    category = None
    render_template = 'icekit/contrib/navigation/accounts_navigation_item.html'

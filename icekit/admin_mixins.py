import warnings

from icekit.utils.deprecation import deprecated

from icekit.admin_tools.mixins import \
    FluentLayoutsMixin as new_FluentLayoutsMixin, \
    HeroMixinAdmin as new_HeroMixinAdmin, \
    ListableMixinAdmin as new_ListableMixinAdmin

from icekit.admin_tools.polymorphic import \
    ICEkitFluentPagesParentAdmin as new_ICEkitFluentPagesParentAdmin


warnings.warn(
    "the icekit.admin_mixins module is deprecated. Use icekit.admin_tools.mixins instead.",
    DeprecationWarning,
    stacklevel=2)


@deprecated
class FluentLayoutsMixin(new_FluentLayoutsMixin):
    """
    .. deprecated::
    Use :class:`icekit.admin_tools.mixins.FluentLayoutsMixin` instead.
    """
    pass


@deprecated
class HeroMixinAdmin(new_HeroMixinAdmin):
    """
    .. deprecated::
    Use :class:`icekit.admin_tools.mixins.HeroMixinAdmin` instead.
    """
    pass


@deprecated
class ListableMixinAdmin(new_ListableMixinAdmin):
    """
    .. deprecated::
    Use :class:`icekit.admin_tools.mixins.ListableMixinAdmin` instead.
    """
    pass


@deprecated
class ICEkitFluentPagesParentAdmin(new_ICEkitFluentPagesParentAdmin):
    """
    .. deprecated::
    Use :class:`icekit.admin_tools.mixins.ICEkitFluentPagesParentAdmin` instead.
    """
    pass

import warnings

warnings.warn(
    "the icekit.utils.admin.mixins module is deprecated. Use icekit.admin_tools.mixins/polymorphic instead.",
    DeprecationWarning,
    stacklevel=2)

from icekit.admin_tools.mixins import \
    ThumbnailAdminMixin as new_ThumbnailAdminMixin

from icekit.admin_tools.widgets import \
    PolymorphicForeignKeyRawIdWidget as new_PolymorphicForeignKeyRawIdWidget, \
    PolymorphicManyToManyRawIdWidget as new_PolymorphicManyToManyRawIdWidget

from icekit.admin_tools.polymorphic import \
    PolymorphicAdminRawIdFix as new_PolymorphicAdminRawIdFix, \
    PolymorphicFluentAdminRawIdFix as new_PolymorphicFluentAdminRawIdFix, \
    PolymorphicReferringItemInline as new_PolymorphicReferringItemInline

from icekit.utils.deprecation import deprecated


@deprecated
class ThumbnailAdminMixin(new_ThumbnailAdminMixin):
    pass

@deprecated
class PolymorphicForeignKeyRawIdWidget(new_PolymorphicForeignKeyRawIdWidget):
    pass


@deprecated
class PolymorphicManyToManyRawIdWidget(new_PolymorphicManyToManyRawIdWidget):
    pass


@deprecated
class PolymorphicAdminRawIdFix(new_PolymorphicAdminRawIdFix):
    pass


@deprecated
class PolymorphicFluentAdminRawIdFix(new_PolymorphicFluentAdminRawIdFix):
    pass


@deprecated
class PolymorphicReferringItemInline(new_PolymorphicReferringItemInline):
    pass

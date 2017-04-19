from rest_framework.permissions import DjangoModelPermissions


custom_perms_map = DjangoModelPermissions.perms_map
custom_perms_map.update({
    'GET': ['%(app_label)s.change_%(model_name)s'],
    'OPTIONS': ['%(app_label)s.change_%(model_name)s'],
    'HEAD': ['%(app_label)s.change_%(model_name)s'],
})


class DjangoModelPermissionsRestrictedListing(DjangoModelPermissions):
    perms_map = custom_perms_map

from django.conf import settings
from django.core.files.storage import FileSystemStorage, get_storage_class
# from ixc_whitenoise.storage import HashedMediaMixin
from storages.backends.s3boto3 import S3Boto3Storage


# MIXINS ######################################################################


class S3MediaLocationMixin(object):
    """
    Pass `settings.MEDIA_URL` (stripped of leading and trailing slashes) as the
    `location` argument to the init method.
    """

    def __init__(self, *args, **kwargs):
        kwargs.setdefault('location', settings.MEDIA_URL.strip('/'))
        super(S3MediaLocationMixin, self).__init__(*args, **kwargs)


class S3PrivateMixin(object):
    """
    Enable querystring auth and use `private` as default ACL.
    """

    def __init__(self, *args, **kwargs):
        kwargs.setdefault('default_acl', 'private')
        kwargs.setdefault('querystring_auth', True)
        super(S3PrivateMixin, self).__init__(*args, **kwargs)


class S3PublicMixin(object):
    """
    Disable querystring auth and use `public-read` as default ACL.
    """

    def __init__(self, *args, **kwargs):
        kwargs.setdefault('default_acl', 'public-read')
        kwargs.setdefault('querystring_auth', False)
        super(S3PublicMixin, self).__init__(*args, **kwargs)


class S3StaticLocationMixin(object):
    """
    Pass `settings.STATIC_URL` (stripped of leading and trailing slashes) as
    the `location` argument to the init method.
    """

    def __init__(self, *args, **kwargs):
        kwargs.setdefault('location', settings.STATIC_URL.strip('/'))
        super(S3StaticLocationMixin, self).__init__(*args, **kwargs)


# STORAGE CLASSES #############################################################


class S3DefaultPrivateStorage(
        # HashedMediaMixin,
        S3MediaLocationMixin,
        S3PrivateMixin,
        S3Boto3Storage):

    pass


class S3DefaultPublicStorage(
        # HashedMediaMixin,
        S3MediaLocationMixin,
        S3PublicMixin,
        S3Boto3Storage):

    pass


# TODO Deprecated, use `S3DefaultPrivateStorage` instead of `S3DefaultStorage`
S3DefaultStorage = S3DefaultPrivateStorage


default_storage = get_storage_class(settings.DEFAULT_FILE_STORAGE)()

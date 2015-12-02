import setuptools

from icekit import __version__

setuptools.setup(
    name='icekit',
    version=__version__,
    packages=setuptools.find_packages(),
    install_requires=[
        'django_extensions',
        'django-bootstrap3',
        'django-fluent-contents',
        'django-fluent-pages',
        # `PassThroughManager` was removed in version 2.4 meaning we need to update our code. This
        # should provide us the time to do so.
        'django-model-utils<2.4',
        'django-wysiwyg',
        'requests',
        'Pillow',
    ],
    extras_require={
        'brightcove': ['django-brightcove'],
        'dev': [
            'ipdb',
            'ipython',
            'mkdocs',
        ],
        'forms': [
            'django-forms-builder',
        ],
        'search': [
            'django-haystack',
            'django-fluent-pages[flatpage,fluentpage]',
        ],
        'test': [
            'coverage',
            'django-dynamic-fixture',
            'django-nose',
            'django-webtest',
            'mock',
            'nose-progressive',
            'WebTest',
            'micawber',
        ],
    },
)

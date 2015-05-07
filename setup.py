import setuptools

from eventkit import __version__

setuptools.setup(
    name='eventkit',
    version=__version__,
    packages=setuptools.find_packages(),
    install_requires=[
        'coverage',
        'croniter',
        'django-dynamic-fixture',
        'django-nose',
        'django-polymorphic',
        'django-webtest',
        'mkdocs',
        'nose-progressive',
        'pytz',
        'tox',
        'WebTest',
    ],
)

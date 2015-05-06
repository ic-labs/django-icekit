import setuptools

from eventkit import __version__

setuptools.setup(
    name='eventkit',
    version=__version__,
    packages=setuptools.find_packages(),
    install_requires=[
        'coverage',
        'django-dynamic-fixture',
        'django-nose',
        'django-webtest',
        'mkdocs',
        'nose-progressive',
        'tox',
        'WebTest',
    ],
)

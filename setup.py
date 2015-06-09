import setuptools

from eventkit import __version__

setuptools.setup(
    name='eventkit',
    version=__version__,
    packages=setuptools.find_packages(),
    install_requires=[
        'coverage',
        'django-dynamic-fixture',
        # 'django-icekit',
        'django-model-utils',
        'django-nose',
        'django-polymorphic-tree',
        # 'django-timezone',
        'django-webtest',
        'mkdocs',
        'nose-progressive',
        'python-dateutil',
        'pytz',
        'six',
        'WebTest',
    ],
    extras_require={
        'dev': ['ipdb', 'ipython'],
        'fluentevent': ['django-fluent-contents'],
        'postgres': ['psycopg2'],
    },
)

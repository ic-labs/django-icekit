from __future__ import print_function

import datetime
import os
import setuptools


# Make `pip install -e .` much faster.
# See: https://bitbucket.org/pypa/setuptools/pull-requests/140/big-performance-fix-for-find_packages-by/diff#comment-18174057
def find_packages(*paths):
    packages = []
    for path in paths or ['.']:
        path = os.path.abspath(path)
        cwd = os.getcwd()
        os.chdir(os.path.dirname(path))
        for dirpath, dirnames, filenames in os.walk(os.path.basename(path)):
            if '__init__.py' in filenames:
                packages.append('.'.join(dirpath.split(os.path.sep)))
            else:
                dirnames[:] = []
        os.chdir(cwd)
    return packages

# Allow installation without git repository, e.g. inside Docker.
if os.path.exists('.git'):
    kwargs = dict(
        use_scm_version={'version_scheme': 'post-release'},
        setup_requires=['setuptools_scm'],
    )
else:
    kwargs = dict(version='0+d' + datetime.date.today().strftime('%Y%m%d'))

with open(os.path.join(os.path.dirname(__file__), 'README.rst')) as f:
    long_description = f.read()

setuptools.setup(
    name='django-icekit',
    author='Interaction Consortium',
    author_email='studio@interaction.net.au',
    url='https://github.com/ic-labs/django-icekit',
    description='A modular content CMS by Interaction Consortium.',
    long_description=long_description,
    license='MIT',
    packages=find_packages('icekit'),
    include_package_data=True,
    install_requires=[
        'attrs',
        'django-any-urlfield',
        'django-app-namespace-template-loader',
        'django-bootstrap3',
        'django-compressor',
        'django-el-pagination',
        'django-fluent-contents>=1.2',  # 1.2+ has fix for placeholders in admin: https://github.com/django-fluent/django-fluent-contents/pull/89
        'django-fluent-pages!=1.1',  # Avoid 1.1 with missing import: https://github.com/django-fluent/django-fluent-pages/issues/125
        'django-model-settings',
        'django-mptt',
        'django-multiurl',
        # import pattern changed in 0.8; version 1 to 1.0.1 has bug with parent
        # admins: github.com/django-polymorphic/django-polymorphic/pull/246
        'django-object-actions>=0.7',  # See: https://github.com/crccheck/django-object-actions/issues/45
        'django-polymorphic>=0.8,!=1,!=1.0.1',
        'django-wysiwyg',
        'django_extensions',
        'html5lib==1.0.1',  # See: https://github.com/html5lib/html5lib-python/issues/189 and https://github.com/pydanny-archive/django-wysiwyg/issues/61
        'nltk',
        'Pillow>=4',  # See: https://github.com/python-pillow/Pillow/issues/2206
        'pip-tools',
        'requests',
        'unidecode',
        'bleach<2',  # Bleach 2 adds a dependency on html5lib>=0.99999999, which breaks our above requirement of html5lib==0.999

        # Django 1.8-specific version dependencies that must be here to be
        # respected. Ideally these restrictions would go below in the
        # 'django18' section but setuptools does not respect them there.
        # TODO Remove these once GLAMkit uses Django > 1.8 by default.
        'djangorestframework<3.7',  # Avoid JSONField errors with Django 1.8
        'django-filter<1.1',  # Avoid get_filter_name() errors with Django 1.8
    ],
    extras_require={
        'api': [
            'djangorestframework',
            'django-rest-swagger',
            'djangorestframework-filters',
            'djangorestframework-queryfields',
        ],
        'brightcove': [
            'django-brightcove',
        ],
        'dev': [
            'django-debug-toolbar',
            # 'glamkit-fallbackserve',
            'ipdb',
            'ipython<5',  # Prompt does not work in Docker Cloud web terminal
            'mkdocs',
            'Werkzeug',
        ],
        'django18': [
            'Django>=2.0,<2.1',  # LTS
        ],
        'forms': [
            'django-forms-builder',
        ],
        'project': [
            'boto3',
            'celery[redis]<4.0',
            'ConcurrentLogHandler',
            'django-admin-sortable2',
            'django-celery',
            'django-celery-email',
            'django-countries',
            'django-extensions',
            'django-flat-theme<1.1.3',  # See: https://github.com/elky/django-flat-theme/issues/30
            'django-fluent-contents[markupoembeditemtext]',
            'django-fluent-pages[redirectnodereversion]',
            'django-hosts',
            'django-master-password',
            'django-polymorphic-auth',
            'django-post-office',
            'django-redis',
            'django-reversion>=2.0,<2.1',  # 1.9.3+ use DB transactions 1.10 has breaking changes for Django 1.9'
            'django-storages<1.6', # 1.7 breaks s3 URLs - see https://github.com/jschneier/django-storages/issues/343
            'django-test-without-migrations',
            'django-timezone',
            'docutils',
            'easy_thumbnails',
            'flower',
            'gunicorn',
            'icekit-notifications',
            'ixc-django-compressor',
            'ixc-whitenoise',
            'Jinja2',
            'psycopg2',
            'python-redis-lock[django]',
            'pytz',
            'raven',
            'supervisor',
        ],
        'search': [
            'django-fluent-pages[flatpage,fluentpage]',
            'django-haystack',
            'elasticsearch>=6.0,<6.1',
            'elasticstack',
        ],
        'test': [
            'celery[redis]==4.1.0',
            'coverage',
            'coveralls',
            'django-dynamic-fixture',
            'django-nose',
            'django-webtest',
            'djangorestframework',
            'micawber',
            'mock',
            'nose-progressive',
            'psycopg2',
            'WebTest',
            'requests',
            'mock',
        ],
        'docs': [
            'sphinx',
            'sphinx-autobuild',
            'recommonmark',
        ],
        'events': [
            'python-dateutil',
            'six',
            'sqlparse',  # Required for SQL migrations, apparently
            'django-colorful',
        ],
        'collections': [
            'pyparsing',
            'unidecode',
            'edtf>=2.5',
            'webcolors==1.7',
            'colormath==2.1.1',
            # Disable as it's devpi-only
            # 'colorweave==0.1+0.ce27c83b4e06a8185531538fa11c18c5ea2c1aba.ixc',
        ]
    },
    setup_requires=['setuptools_scm'],
)

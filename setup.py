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

setuptools.setup(
    name='django-icekit',
    author='Interaction Consortium',
    author_email='studio@interaction.net.au',
    url='https://github.com/ic-labs/django-icekit',
    description='A modular content CMS by Interaction Consortium.',
    license='MIT',
    packages=find_packages('icekit'),
    include_package_data=True,
    install_requires=[
        'django-any-urlfield',
        'django-app-namespace-template-loader',
        'django-bootstrap3',
        'django-compressor',
        'django-el-pagination',
        'django-fluent-contents>=1.1.9',  # For JS compatibility, see #138
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
        'html5lib==0.999',  # See: https://github.com/html5lib/html5lib-python/issues/189 and https://github.com/pydanny-archive/django-wysiwyg/issues/61
        'nltk',
        'Pillow>=4',  # See: https://github.com/python-pillow/Pillow/issues/2206
        'pip-tools',
        'requests',
        'unidecode',
    ],
    extras_require={
        'api': [
            'djangorestframework',
            'django-rest-swagger',
            'djangorestframework-filters',
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
            'Django>=1.8,<1.9',  # LTS
        ],
        'forms': [
            'django-forms-builder',
        ],
        'glamkit': [
            'glamkit-sponsors',
            'icekit-events',
            'icekit-press-releases>=0.81',
            'glamkit-collections>=0.35',
        ],
        'project': [
            'boto3',
            'celery[redis]==3.1.24',
            'ConcurrentLogHandler',
            'django-celery',
            'django-celery-email',
            'django-countries',
            'django-extensions',
            'django-flat-theme<1.1.3',  # See: https://github.com/elky/django-flat-theme/issues/30
            'django-fluent-contents[markupoembeditemtext]',
            'django-fluent-pages[redirectnodereversion]',
            'django-master-password',
            'django-polymorphic-auth',
            'django-post-office',
            'django-redis',
            'django-reversion>=1.9.3,<1.10',  # 1.9.3+ use DB transactions 1.10 has breaking changes for Django 1.9'
            'django-storages',
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
            'elasticsearch',
            'elasticstack',
        ],
        'test': [
            'celery[redis]==3.1.24',
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
        ],
        'docs': [
            'sphinx',
            'sphinx-autobuild',
            'recommonmark',
        ],
    },
    **kwargs
)

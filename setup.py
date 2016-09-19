from __future__ import print_function

import datetime
import os
import setuptools
import sys


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

# Convert README.md to reStructuredText.
if {'bdist_wheel', 'sdist'}.intersection(sys.argv):
    try:
        import pypandoc
    except ImportError:
        print('WARNING: You should install `pypandoc` to convert `README.md` '
              'to reStructuredText to use as long description.',
              file=sys.stderr)
    else:
        print('Converting `README.md` to reStructuredText to use as long '
              'description.')
        kwargs['long_description'] = pypandoc.convert('README.md', 'rst')

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
        'django-app-namespace-template-loader',
        'django-bootstrap3',
        'django-compressor',
        'django-el-pagination',
        'django-fluent-contents',
        'django-fluent-pages',
        'django-model-settings',
        'django-mptt!=0.8.5',  # See: https://github.com/django-fluent/django-fluent-pages/commit/98a35e43fbedf78c190e2dee38dd12f88a496bf3
        'django-multiurl',
        'django-polymorphic',
        'django-wysiwyg',
        'django_extensions',
        'html5lib==0.999',
        'nltk',
        'Pillow',
        'requests',
        'unidecode',
    ],
    extras_require={
        'api': [
            'djangorestframework',
        ],
        'brightcove': [
            'django-brightcove',
        ],
        'dev': [
            'django-debug-toolbar',
            # 'glamkit-fallbackserve',
            'ipdb',
            'ipython',
            'mkdocs',
            'Werkzeug',
        ],
        'django18': [
            'Django>=1.8,<1.9',
        ],
        'forms': [
            'django-forms-builder',
        ],
        'project': [
            'celery[redis]',
            'ConcurrentLogHandler',
            'django-celery',
            'django-celery-email',
            'django-extensions',
            'django-flat-theme<1.1.3',  # See: https://github.com/elky/django-flat-theme/issues/30'
            'django-fluent-contents[markupoembeditemtext]',
            'django-fluent-pages[redirectnodereversion]',
            'django-master-password',
            'django-polymorphic-auth',
            'django-post-office',
            'django-redis',
            'django-reversion>=1.9.3,<1.10',  # 1.9.3+ use DB transactions 1.10 has breaking changes for Django 1.9'
            'django-storages<1.2',  # See: https://github.com/jschneier/django-storages/blob/cf3cb76ca060f0dd82766daa43ee92fccca3dec7/storages/backends/s3boto.py#L28-L30'
            'django-test-without-migrations',
            'django-timezone',
            'docutils',
            'easy_thumbnails',
            'flower',
            'gunicorn',
            'icekit-notifications',
            'ixc-django-compressor',
            # 'ixc-redactor',
            'ixc-whitenoise',
            'Jinja2',
            # 'newrelic',
            'psycopg2',
            'python-redis-lock[django]',
            'pytz',
            'raven',
            'supervisor',

            # Override incompatible versions for nested dependencies.
            'boto<=2.27',  # See: https://github.com/danilop/yas3fs/issues/26
        ],
        'search': [
            'django-fluent-pages[flatpage,fluentpage]',
            'django-haystack',
            'elasticsearch',
            'elasticstack',
        ],
        'test': [
            'celery[redis]',
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
    },
    **kwargs
)

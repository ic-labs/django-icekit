from __future__ import print_function

import datetime
import os
import setuptools
import sys

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
    packages=setuptools.find_packages(),
    include_package_data=True,
    install_requires=[
        'django-app-namespace-template-loader',
        'django-bootstrap3',
        'django-compressor',
        'django-el-pagination<3',  # 3+ drops support for Django < 1.8
        'django-fluent-contents',
        'django-fluent-pages',
        'django-model-settings',
        'django-model-utils<2.4',  # See: https://github.com/jp74/django-model-publisher/pull/26
        'django-mptt',
        'django-multiurl',
        'django-polymorphic<0.8',  # For compatibility with django-fluent-contents: https://django-polymorphic.readthedocs.org/en/latest/changelog.html#version-0-8-2015-12-28
        'django-wysiwyg',
        'django_extensions',
        'html5lib',
        'nltk',
        'Pillow',
        'requests',
        'unidecode',

        # Override incompatible versions for nested dependencies.
        'django-polymorphic-tree<1.2',  # See: https://github.com/django-polymorphic/django-polymorphic-tree/commit/389b4800aadf05a02bc66e0589e6fa511aabc3a2
    ],
    extras_require={
        'api': [
            'djangorestframework<3.4',  # For compatibility with Django < 1.8
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
        'django17': [
            'django-fluent-contents',
            'django-polymorphic<0.8',  # For compatibility with django-fluent-contents: https://django-polymorphic.readthedocs.org/en/latest/changelog.html#version-0-8-2015-12-28
            'Django>=1.7,<1.8',
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
            'django-generic',
            'django-master-password',
            'django-polymorphic-auth',
            'django-post-office',
            'django-redis',
            'django-reversion>=1.9.3,<1.10',  # 1.9.3+ use DB transactions 1.10 has breaking changes for Django 1.9'
            'django-storages<1.2',  # See: https://github.com/jschneier/django-storages/blob/cf3cb76ca060f0dd82766daa43ee92fccca3dec7/storages/backends/s3boto.py#L28-L30'
            'django-supervisor',
            'django-test-without-migrations',
            'django-timezone',
            'Django>=1.8,<1.9',  # LTS
            'docutils',
            'flower',
            'gunicorn',
            'icekit-notifications',
            'ixc-django-compressor',
            'ixc-redactor',
            'ixc-whitenoise',
            'Jinja2',
            # 'newrelic',
            'psycopg2',
            'python-redis-lock[django]',
            'pytz',
            'raven',

            # Override incompatible versions for nested dependencies.
            'boto<=2.27',  # See: https://github.com/danilop/yas3fs/issues/26
        ],
        'search': [
            'django-fluent-pages[flatpage,fluentpage]',
            'django-haystack',
            'elasticsearch',
            'elasticstack',
        ],
        'slideshow': [
            'easy_thumbnails',
        ],
        'test': [
            'coverage',
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
    entry_points={
        'console_scripts': [
            'icekit = icekit.bin.icekit:main',
            'abspath = icekit.manage:abspath',
            'icekit_dir = icekit.manage:icekit_dir',
            'manage.py = icekit.manage:main',
            'project_dir = icekit.manage:project_dir',
        ],
    },
    scripts=[
        'bin/bower-install.sh',
        'bin/migrate.sh',
        'bin/npm-install.sh',
        'bin/pip-install.sh',
        'bin/setup-postgres-database.sh',
        'bin/setup-postgres-env.sh',
        'bin/startproject.sh',
        'bin/waitlock.sh',
    ],
    **kwargs
)

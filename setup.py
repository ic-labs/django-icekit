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
        'attrs==17.4.0',
        'django-any-urlfield==2.4.2',
        'django-app-namespace-template-loader==0.4.1',
        'django-bootstrap3==9.1.0',
        'django-compressor==2.2',
        'django-el-pagination==3.1.0',
        'django-fluent-contents==1.2.2',
        'django-fluent-pages==1.1.3',
        'django-fluent-utils==1.4.1',
        'django-model-settings==0.3',
        'django-mptt==0.9.0',
        'django-multiurl==1.1.0',
        'django-object-actions==0.10.0',
        'django-polymorphic==1.3',
        'django-wysiwyg==0.8.0',
        'django_extensions==1.9.9',
        'html5lib==0.99',
        'nltk==3.2.5',
        'Pillow==5.0.0',
        'pip-tools==1.11.0',
        'requests==2.18.4',
        'unidecode==1.0.22',
        'bleach==1.5.0',
        'djangorestframework==3.6.4',
        'django-filter==1.0.4',
    ],
    extras_require={
        'api': [
            'djangorestframework==3.6.4',
            'django-rest-swagger==2.1.2',
            'djangorestframework-filters==0.10.2',
            'djangorestframework-queryfields==1.0.0',
        ],
        'brightcove': [
            'django-brightcove==0.0.7',
        ],
        'dev': [
            'django-debug-toolbar==1.9.1',
            'ipdb==0.10.3',
            'ipython==4.2.1',
            'mkdocs==0.17.2',
            'Werkzeug==0.14.1',
        ],
        'django18': [
            'Django==1.8.18',
        ],
        'forms': [
            'django-forms-builder==0.13.0',
        ],
        'project': [
            'boto3==1.5.17',
            'celery[redis]==3.1.25',
            'ConcurrentLogHandler==0.9.1',
            'django-admin-sortable2==0.6.19',
            'django-celery==3.2.2',
            'django-celery-email==2.0.0',
            'django-countries==5.0',
            'django-extensions==1.9.9',
            'django-flat-theme==1.1.2',
            'django-fluent-contents[markupoembeditemtext]==1.2.2',
            'django-fluent-pages[redirectnodereversion]==1.1.3',
            'django-hosts==2.0',
            'django-master-password==1.1.1',
            'django-polymorphic-auth==0.4',
            'django-post-office==3.0.4',
            'django-redis==4.8.0',
            'django-reversion==1.9.3',
            'django-storages==1.5.2',
            'django-test-without-migrations==0.6',
            'django-timezone==0.3',
            'docutils==0.14',
            'easy_thumbnails==2.5',
            'flower==0.9.2',
            'gunicorn==19.7.1',
            'icekit-notifications==0.2.1',
            'ixc-django-compressor==0.2',
            'ixc-whitenoise==0.6.1',
            'Jinja2==2.10',
            'psycopg2==2.7.3.2',
            'python-redis-lock[django]==3.2.0',
            'pytz==2017.3',
            'raven==6.4.0',
            'supervisor==3.3.3',
        ],
        'search': [
            'django-fluent-pages[flatpage,fluentpage]==1.1.3',
            'django-haystack==2.6.1',
            'elasticsearch==1.9.0',
            'elasticstack==0.5.0',
        ],
        'test': [
            'celery[redis]==3.1.24',
            'coverage==4.4.2',
            'coveralls==1.2.0',
            'django-dynamic-fixture==1.9.0',
            'django-nose==1.4.5',
            'django-webtest==1.9.2',
            'djangorestframework==3.6.4',
            'micawber==0.3.4',
            'mock==2.0.0',
            'nose-progressive==1.5.1',
            'psycopg2==2.7.3.2',
            'WebTest==2.0.29',
            'requests==2.18.4',
            'mock==2.0.0',
        ],
        'docs': [
            'sphinx',
            'sphinx-autobuild',
            'recommonmark',
        ],
        'events': [
            'python-dateutil==2.6.0',
            'six==1.10.0',
            'sqlparse==0.2.4',
            'django-colorful==1.2',
        ],
        'collections': [
            'pyparsing==2.2.0',
            'unidecode==1.0.22',
            'edtf==2.7.0',
            'webcolors==1.5',
            'colormath==2.1.1',
        ]
    },
    setup_requires=['setuptools_scm'],
)

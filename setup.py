from __future__ import print_function

import os
import setuptools
import shutil
import subprocess
import sys

version = '0.1.dev1'

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
        long_description = pypandoc.convert('README.md', 'rst')

# Clean and install bower components.
if {'bdist_wheel', 'develop', 'sdist'}.intersection(sys.argv):
    cwd = os.getcwd()
    os.chdir('eventkit/static/eventkit')
    if os.path.exists('bower_comonents'):
        print('Cleaning bower components.')
        shutil.rmtree('bower_components')
    print('Installing bower components.')
    try:
        if subprocess.call(['bower', 'install'], stderr=sys.stderr):
            raise RuntimeError
    except (OSError, RuntimeError):
        print('ERROR: Unable to install bower components.', file=sys.stderr)
        exit(1)
    os.chdir(cwd)

setuptools.setup(
    name='django-eventkit',
    version=version,
    author='Interaction Consortium',
    author_email='studio@interaction.net.au',
    url='https://github.com/ixc/django-eventkit',
    description='',
    long_description=locals().get('long_description', ''),
    license='MIT',
    packages=setuptools.find_packages(),
    include_package_data=True,
    install_requires=[
        'coverage',
        'django-dynamic-fixture',
        'django-icekit',
        'django-model-utils',
        'django-nose',
        'django-polymorphic-tree',
        'django-timezone',
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

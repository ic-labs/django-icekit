from __future__ import print_function

import os
import setuptools
import shutil
import subprocess
import sys

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
    os.chdir('icekit_events/static/icekit_events')
    if os.path.exists('bower_comonents'):
        print('Cleaning bower components.')
        shutil.rmtree('bower_components')
    print('Installing bower components.')
    try:
        if subprocess.call(['bower', 'install', '--allow-root'], stderr=sys.stderr):
            raise RuntimeError
    except (OSError, RuntimeError):
        print('ERROR: Unable to install bower components.', file=sys.stderr)
        if {'bdist_wheel', 'sdist'}.intersection(sys.argv):
            exit(1)
    os.chdir(cwd)

setuptools.setup(
    name='icekit-events',
    use_scm_version={'version_scheme': 'post-release'},
    author='Interaction Consortium',
    author_email='studio@interaction.net.au',
    url='https://github.com/ic-labs/icekit-events',
    description='',
    long_description=locals().get('long_description', ''),
    license='MIT',
    packages=setuptools.find_packages(),
    include_package_data=True,
    install_requires=[
        'Django<1.9',
        # TODO Specific version of django-dynamic-fixture is necessary to avoid
        # AttributeError: can't set attribute` failures on polymorphic models.
        # See https://github.com/paulocheque/django-dynamic-fixture/pull/59
        'django-dynamic-fixture==1.9.0+0.caeb3427399edd3b0d589516993c7da55e0de560.ixc',
        'django-icekit',
        'django-polymorphic',
        'django-polymorphic-tree',
        'django-timezone',
        'mkdocs',
        'python-dateutil',
        'pytz',
        'six',
        'sqlparse',  # Required for SQL migrations, apparently
    ],
    extras_require={
        'dev': ['ipdb', 'ipython'],
        'fluentevent': ['django-fluent-contents'],
        'postgres': ['psycopg2'],
        'test': ['coverage', 'django-nose', 'nose-progressive', 'django-webtest', 'WebTest']
    },
    setup_requires=['setuptools_scm'],
)

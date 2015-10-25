from __future__ import print_function

import setuptools
import sys

version = '0.1.dev0'

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

setuptools.setup(
    name='django-icekit',
    version=version,
    author='Interaction Consortium',
    author_email='studio@interaction.net.au',
    url='https://github.com/ixc/django-icekit',
    description='A modular content CMS by Interaction Consortium.',
    long_description=locals().get('long_description', ''),
    license='MIT',
    packages=setuptools.find_packages(),
    include_package_data=True,
    install_requires=[
        'django_extensions',
        'django-bootstrap3',
        'django-fluent-contents',
        'django-fluent-pages',
        'django-model-utils',
        'django-wysiwyg',
        'requests',
        'Pillow',
    ],
    extras_require={
        'brightcove': ['django-brightcove'],
        'dev': [
            'ipdb',
            'ipython',
            'mkdocs',
        ],
        'forms': [
            'django-forms-builder',
        ],
        'search': [
            'django-haystack',
            'django-fluent-pages[flatpage,fluentpage]',
        ],
        'test': [
            'coverage',
            'django-dynamic-fixture',
            'django-nose',
            'django-webtest',
            'mock',
            'nose-progressive',
            'WebTest',
            'micawber',
        ],
    },
)

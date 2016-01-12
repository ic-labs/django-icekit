from __future__ import print_function

import setuptools
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

setuptools.setup(
    name='django-icekit',
    use_scm_version={'version_scheme': 'post-release'},
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
        'django-el-pagination',
        # Nested dependency overrides.
        'django-polymorphic<0.8',  # Backwards incompatible. See: https://django-polymorphic.readthedocs.org/en/latest/changelog.html#version-0-8-2015-12-28
    ],
    extras_require={
        'brightcove': ['django-brightcove'],
        'dev': [
            'ipdb',
            'ipython',
            'mkdocs',
        ],
        'django17': ['django-mptt<0.8', ],
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
    setup_requires=['setuptools_scm'],
)

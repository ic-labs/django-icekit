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
        'django-bootstrap3',
        'django-el-pagination',
        'django-fluent-contents',
        'django-fluent-pages',
        'django-model-utils',
        'django-wysiwyg',
        'django_extensions',
        'Pillow',
        'requests',
        'nltk',
        'unidecode',
    ],
    extras_require={
        'brightcove': [
            'django-brightcove',
        ],
        'dev': [
            'ipdb',
            'ipython',
            'mkdocs',
        ],
        'django17': [
            'django-fluent-contents<1.1',  # See: https://github.com/edoburu/django-fluent-contents/issues/67
            'django-mptt<0.8',  # See: https://github.com/django-mptt/django-mptt/releases
            'django-polymorphic<0.8',  # See: https://django-polymorphic.readthedocs.org/en/latest/changelog.html#version-0-8-2015-12-28
            'Django>=1.7,<1.8',
        ],
        'forms': [
            'django-forms-builder',
        ],
        'search': [
            'django-fluent-pages[flatpage,fluentpage]',
            'django-haystack',
        ],
        'test': [
            'coverage',
            'django-dynamic-fixture',
            'django-nose',
            'django-webtest',
            'micawber',
            'mock',
            'nose-progressive',
            'WebTest',
        ],
    },
    setup_requires=['setuptools_scm'],
    entry_points={
        'console_scripts': [
            'icekit = icekit.bin.icekit:main',
        ],
    },
)

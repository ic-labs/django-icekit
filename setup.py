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
        'django-model-utils<2.4',  # See: https://github.com/jp74/django-model-publisher/pull/26
        'django-polymorphic<0.8',  # For compatibility with django-fluent-contents: https://django-polymorphic.readthedocs.org/en/latest/changelog.html#version-0-8-2015-12-28
        'django-wysiwyg',
        'django_extensions',
        'Pillow',
        'requests',
        'nltk',
        'unidecode',
        'django-app-namespace-template-loader',
    ],
    extras_require={
        'api': [
            'djangorestframework',
        ],
        'brightcove': [
            'django-brightcove',
        ],
        'publishing': [
            'django-model-settings',
            'django-compressor<1.6',  # See: https://github.com/django-compressor/django-compressor/issues/706
        ],
        'dev': [
            'ipdb',
            'ipython',
            'mkdocs',
        ],
        'django17': [
            'django-fluent-contents<1.1',  # See: https://github.com/edoburu/django-fluent-contents/issues/67
            'django-mptt<0.8',  # See: https://github.com/django-mptt/django-mptt/releases
            'django-polymorphic<0.8',  # For compatibility with Django < 1.8, see: https://django-polymorphic.readthedocs.org/en/latest/changelog.html#version-0-8-2015-12-28
            'Django>=1.7,<1.8',
            'djangorestframework<3.4',  # For compatibility with Django < 1.8
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
            'djangorestframework',
            'django-webtest',
            'micawber',
            'mock',
            'nose-progressive',
            'psycopg2',
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

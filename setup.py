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
    name='glamkit-collections',
    use_scm_version={'version_scheme': 'post-release'},
    author='Interaction Consortium',
    author_email='studio@interaction.net.au',
    url='https://github.com/ixc/glamkit-collections',
    description='Boilerplate for modelling collections of collecting institutions.',
    long_description=locals().get('long_description', ''),
    packages=setuptools.find_packages(),
    include_package_data=True,
    install_requires=[
        'django-icekit',
        'django-object-actions<0.6',  # See: https://github.com/crccheck/django-object-actions/issues/45
        'Django>=1.7',
        'pyparsing',
        'unidecode',
    ],
    extras_require={
        'colors': [
            'webcolors==1.5',
            'colormath==2.1.1',
            'colorweave==0.1+0.ce27c83b4e06a8185531538fa11c18c5ea2c1aba.ixc',
        ],
    },
    setup_requires=['setuptools_scm'],
)

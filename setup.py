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
    name='glamkit-collectionkit',
    use_scm_version={'version_scheme': 'post-release'},
    author='Interaction Consortium',
    author_email='studio@interaction.net.au',
    url='https://github.com/ic-labs/glamkit-collectionkit',
    description='Boilerplate for modelling collections of collecting institutions.',
    long_description=locals().get('long_description', ''),
    packages=setuptools.find_packages(),
    include_package_data=True,
    install_requires=[
        'imagetools==0.1.post8+ng6e73447.d20160404',
        'colorweave',
        'django-icekit',
        'django-object-actions<0.6',  # See: https://github.com/crccheck/django-object-actions/issues/45
        'Django>=1.7',
        'pyparsing',
        'unidecode',
        'django-brightcove',
    ],
    setup_requires=['setuptools_scm'],
)

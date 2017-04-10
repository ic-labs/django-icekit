import fnmatch
import shutil
from django.core.management import CommandError
from django.core.management.base import BaseCommand
from optparse import make_option
import os
import sys

from django.test import RequestFactory
from django.utils.six.moves import input
from django.utils.text import slugify
from rest_framework.renderers import JSONRenderer
import progressbar
import glob

from sfmoma.api.collection_views import ArtistViewSet, ArtworkViewSet, ExhibitionViewSet

rf = RequestFactory()

TEST_URL = "http://testserver/api/"
PROPER_URL = "https://www.sfmoma.org/api/"

def ensure_exists(path):
    if not os.path.exists(path):
        os.makedirs(path)


def dump_viewset(viewset_class, root_folder, folder_fn=lambda i: ".", sample_size=None):
    """
    Dump the contents of a rest-api queryset to a folder structure.

    :param viewset_class: A rest-api viewset to iterate through
    :param root_folder: The root folder to write results to.
    :param folder_fn: A function to generate a subfolder name for the instance.
    :param sample_size: Number of items to process, for test purposes.
    :return:
    """
    if os.path.exists(root_folder):
        shutil.rmtree(root_folder)
    os.makedirs(root_folder)

    vs = viewset_class()
    vs.request = rf.get('')

    serializer_class = vs.get_serializer_class()
    serializer = serializer_class(context={'request': vs.request, 'format': 'json', 'view': vs})

    renderer = PrettyJSONRenderer()

    bar = progressbar.ProgressBar()
    for instance in bar(vs.get_queryset()[:sample_size]):
        dct = serializer.to_representation(instance)
        content = renderer.render(dct)
        folder = os.path.join(root_folder, folder_fn(instance))
        if not os.path.exists(folder):
            os.makedirs(folder)
        filename = "%s.json" % instance.slug

        f = file(os.path.join(folder, filename), 'w')
        f.write(content)
        f.close()

def concatenate_json(source_folder, destination_file):
    """
    Concatenate all the json files in a folder to one big JSON file.
    """
    matches = []
    for root, dirnames, filenames in os.walk(source_folder):
        for filename in fnmatch.filter(filenames, '*.json'):
            matches.append(os.path.join(root, filename))

    with open(destination_file, "wb") as f:
        f.write("[\n")
        for m in matches[:-1]:
            f.write(open(m, "rb").read())
            f.write(",\n")
        f.write(open(matches[-1], "rb").read())
        f.write("\n]")


class PrettyJSONRenderer(JSONRenderer):
    def get_indent(self, *args, **kwargs):
        return 2

    def render(self, *args, **kwargs):
        default = super(PrettyJSONRenderer, self).render(*args, **kwargs)
        return default.replace(TEST_URL, PROPER_URL)

class Command(BaseCommand):
    args = "<destination folder>"
    help = ('Dump all items in the artists and artworks API to a series of json files and 2 csv files, ready for '
            'publishing.\n\nWARNING: This will overwrite files in the destination folder.')

    option_list = BaseCommand.option_list + (
        make_option(
            '--sample',
            dest='sample',
            type='int',
            help='Number of Artists and Artworks to use',
            default=None
        ),
        make_option(
            '--models',
            dest='models',
            help='Which models to dump',
            default="artist,artwork,exhibition"
        ),
    )

    def handle(self, *args, **options):
        try:
            path = os.path.abspath(args[0])
        except IndexError:
            raise CommandError('Please give a path to a destination folder')
        if not os.path.exists(path):
            if input("The folder %s does not exist. Create it now? (y/n): " % path) in ['yes', 'y']:
                os.makedirs(path)
            else:
                sys.exit()

        if 'artist' in options['models']:
            root_folder = os.path.join(path, "artists")
            dump_viewset(
                viewset_class=ArtistViewSet,
                root_folder=root_folder,
                folder_fn=lambda x: slugify(x.slug)[0],
                sample_size=options['sample'],
            )
            json_path = path+"/json/"
            if not os.path.exists(json_path):
                if input("The folder %s does not exist. Create it now? (y/n): " % json_path) in ['yes', 'y']:
                    os.makedirs(json_path)
                    concatenate_json(root_folder, os.path(json_path))
                else:
                    sys.exit()
            concatenate_json(root_folder, os.path.join(json_path, "sfmoma_raw_data_artists.json"))
            

        if 'artwork' in options['models']:
            root_folder = os.path.join(path, "artworks")
            dump_viewset(
                viewset_class=ArtworkViewSet,
                root_folder=root_folder,
                folder_fn=lambda x: os.path.join(*x.slug.split(".")[:-1] or x.slug),
                sample_size=options['sample'],
            )
            json_path = path+"/json/"
            if not os.path.exists(json_path):
                if input("The folder %s does not exist. Create it now? (y/n): " % json_path) in ['yes', 'y']:
                    os.makedirs(json_path)
                    concatenate_json(root_folder, os.path(json_path))
                else:
                    sys.exit()
            concatenate_json(root_folder, os.path.join(json_path, "sfmoma_raw_data_artworks.json"))
            

        if 'exhibition' in options['models']:
            root_folder = os.path.join(path, "exhibitions")
            dump_viewset(
                viewset_class=ExhibitionViewSet,
                root_folder=root_folder,
                folder_fn=lambda x: slugify(x.slug)[0],
                sample_size=options['sample'],
            )
            json_path = path+"/json/"
            if not os.path.exists(json_path):
                if input("The folder %s does not exist. Create it now? (y/n): " % json_path) in ['yes', 'y']:
                    os.makedirs(json_path)
                else:
                    sys.exit()
            concatenate_json(root_folder, os.path.join(json_path, "sfmoma_raw_data_exhibitions.json"))

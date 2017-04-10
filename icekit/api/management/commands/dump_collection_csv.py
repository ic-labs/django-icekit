from django.conf import settings
from django.core.management.base import BaseCommand
from optparse import make_option
import os
import sys
import json
from sfmoma.collection.models import Artist, Artwork, EmbarkExhibition
from djqscsv import write_csv
from collections import OrderedDict
import csv

DUMP_PATH = "~/sfmoma-collection/csv"

class Command(BaseCommand):
    args = "<destination folder>"
    help = ('Dump collection info into csv files.')

    option_list = BaseCommand.option_list + (
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
            path = DUMP_PATH
        if not os.path.exists(path):
            if input("The folder %s does not exist. Create it now? (y/n): " % path) in ['yes', 'y']:
                os.makedirs(path)
            else:
                sys.exit()

        if 'artwork' in options['models']:
            file_name = os.path.join(path, "sfmoma_raw_data_artworks.csv")
            qs = Artwork.public_objects.filter(is_whole_object=True)

            artwork_csv = list()
            for artwork in qs:
                a = OrderedDict()
                a['id'] = artwork.id
                a['slug'] = artwork.slug
                a['accession_number'] = artwork.accession_number
                a['medium_display'] = artwork.medium_display
                a['medium_medium'] = artwork.medium_medium
                a['date_display'] = artwork.date_display
                a['object_type'] = artwork.type
                a['origin_country'] = artwork.origin_country
                a['dimensions_display'] = artwork.dimensions_display
                a['department'] = artwork.department
                a['accession_date_year'] = artwork.accession_date_year
                a['credit_line'] = artwork.credit_line

                if len(artwork.artist_name_pairs) == 1:
                    a['primary_artist_name_display'] = artwork.artist_name_pairs[0][0]

                    # primary_artists_list = list()
                    # for work in artist.public_artworks:
                    #      work_accession_numbers.append(work.accession_number)
                    
                    # works = ",".join(work_accession_numbers)
                    # a['artwork_accession_numbers'] = works
                    # artist_csv.append(a)

                # primary_artists = list()
                # for artist in artwork.primary_artists:
                #     primary_artist = artist.name_display
                #     primary_artists.append(primary_artist)
                
                # primary_artists = ",".join(primary_artists)
                # a['primary_artists'] = primary_artists

                artwork_csv.append(a)

            keys = artwork_csv[0].keys()
            with open(file_name, 'w') as f:
                w = csv.DictWriter(f, keys)
                w.writeheader()
                for d in artwork_csv:
                    self.map_to(d)
                    w.writerow(d)


        if 'artist' in options['models']:
            file_name = os.path.join(path, "sfmoma_raw_data_artists.csv")
            qs = Artist.public_objects.all()

            artist_csv = list()
            # explicitly state the fields, this way we can add properties and customize headers
            for artist in qs:
                a = OrderedDict()
                a['id'] = artist.id
                a['slug'] = artist.slug
                a['gender'] = artist.gender
                a['life_info_birth_date_display'] = artist.life_info_birth_date_display
                a['life_info_death_date_display'] = artist.life_info_death_date_display
                a['background_nationality'] = artist.background_nationality
                a['name_display'] = artist.name_display
                a['sfmoma_website_url'] = artist.get_website_url
                a['sfmoma_api_url'] = artist.get_api_url

                work_accession_numbers = list()
                for work in artist.public_artworks:
                     work_accession_numbers.append(work.accession_number)
                
                works = ",".join(work_accession_numbers)
                a['artwork_accession_numbers'] = works
                artist_csv.append(a)

            keys = artist_csv[0].keys()
            with open(file_name, 'w') as f:
                w = csv.DictWriter(f, keys)
                w.writeheader()
                for d in artist_csv:
                    self.map_to(d)
                    w.writerow(d)

        if 'exhibition' in options['models']:
            file_name = os.path.join(path, "sfmoma_raw_data_exhibitions.csv")
            qs = EmbarkExhibition.objects.all().values('title', 'slug', 'start_date', 'end_date')
            with open(file_name, 'w') as csv_file:
                write_csv(qs, csv_file)

    def map_to(self, d):
            # iterate over the key/values pairings
            for k, v in d.items():
                # if v is a list join and encode else just encode as it is a string
                try:
                    d[k] = ",".join(v).encode("utf-8") if isinstance(v, list) else v.encode("utf-8")
                except:
                    continue

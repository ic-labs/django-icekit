from collections import defaultdict
from optparse import make_option
from pprint import pprint
from django.db import models
from django.core.management.base import BaseCommand
from requests.structures import CaseInsensitiveDict

def update_json_analysis(analysis, j):
    """
    Step through the items in a piece of json, and update an analysis dict
    with the values found.
    """
    def _analyze_list(l, parent=""):
        for v in l:
            if isinstance(v, (dict, CaseInsensitiveDict)):
                _analyze_json(v, parent=parent)
            elif isinstance(v, list):
                _analyze_list(v, parent=parent+"[]")
            else:
                analysis[parent].add(v)


    def _analyze_json(d, parent=""):
        for k, v in d.iteritems():
            if parent:
                path = ".".join([parent, k])
            else:
                path = k
            if isinstance(v, (dict, CaseInsensitiveDict)):
                _analyze_json(v, parent=path)
            elif isinstance(v, list):
                _analyze_list(v, parent=path+"[]")
            else:
                analysis[path].add(v)

    if isinstance(j, list):
        _analyze_list(j)
    if isinstance(j, (dict, CaseInsensitiveDict)):
        _analyze_json(j)



class Command(BaseCommand):
    help = """Look at JSON _api_record fields in the given model,
and print the discovered paths, with some sample values from both ends of a sorted
list of values."""

    option_list = BaseCommand.option_list + (
        make_option('--sample-size',
            action='store',
            dest='samplesize',
            default=10000,
            help='Limit records inspected to a given number'
        ),
        make_option('--result-size',
            action='store',
            dest='resultsize',
            default=20,
            help='Limit the number of variations in each result to a given number'
        ),
    )

    def handle(self, *args, **options):
        analysis = defaultdict(set)

        if len(args) < 1:
            print "You need to supply a model name that has a _api_record field (e.g. collection.Work)"
            exit()
        else:
            print "Collecting up to %s example values for a random sampling of %s records of %s\n" % (
                options['resultsize'],
                options['samplesize'],
                args[0]
            )

        model = models.get_model(args[0])

        for item in model.objects.exclude(_api_record="").order_by("?")[:int(options['samplesize'])]:
            j = item.api_record()
            update_json_analysis(analysis, j)

        # pare down and tidy the structure for presentation
        clean_analysis = dict()

        resultsize = int(options['resultsize'])

        for k, v in analysis.iteritems():
            clean_analysis[k+" {#variations}"] = len(v)
            # provide the first and last few values of a sorted list
            listv = sorted(list(v))
            rs = min(resultsize, len(listv))
            half_resultsize = rs/2 # integer division
            other_half = rs - half_resultsize
            clean_analysis[k+" {sample values}"] = listv[:half_resultsize] + listv[-other_half:]

        # print the results
        pprint(clean_analysis)
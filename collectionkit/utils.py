#!/usr/bin/python
#  -*- coding: UTF-8 -*-
import itertools
import unittest
from django.utils.functional import allow_lazy
from django.utils.safestring import mark_safe
from django.utils.text import slugify
import re
from pyparsing import Optional, nums, Word, ParseException, Group
import six
from unidecode import unidecode

def wikipedia_slugify(value, do_unidecode=False):
    """
    Converts to ASCII via unidecode.
    Converts spaces to underscore.

    Removes characters that
    aren't alphanumerics, underscores, or hyphens.

    Preserve case.

    Also strips leading and trailing whitespace.
    """
    if do_unidecode:
        value = unidecode(value)
    value = value.strip()
    return mark_safe(re.sub('[\s/#\?:@]+', '_', value))
wikipedia_slugify = allow_lazy(wikipedia_slugify, six.text_type)


def alt_slugify(value):
    if value and value.strip():
        return re.sub('[-_]', '', slugify(unicode(unidecode(value))))
    else:
        return ""
alt_slugify = allow_lazy(alt_slugify, six.text_type)

def grammatical_join(l, initial_joins=", ", final_join=" and "):
    # Return items concatenated with commas and "and" before the final one.
    # http://stackoverflow.com/questions/19838976/grammatical-list-join-in-python
    return initial_joins.join(l[:-2] + [final_join.join(l[-2:])])

def ensure_unique(qs, field_name, value, exclude_id=None):
    """
    Makes sure that `value` is unique on model.fieldname. And nonempty.
    """
    orig = value
    if not value:
        value = "None"
    for x in itertools.count(1):
        if not qs.exclude(id=exclude_id).filter(**{field_name: value}).exists():
            break
        if orig:
            value = '%s-%d' % (orig, x)
        else:
            value = '%d' % x

    return value


def strip_parens(s):
    result = re.sub(r'^\(', '', s)
    result = re.sub(r'\)$', '', result)
    return result


def ndashify(s):
    """replace ' - ' with an n-dash character"""
    return re.sub(r' - ', u'–', unicode(s))


def fix_line_breaks(s):
    """
    Convert \r\n and \r to \n chars. Strip any leading or trailing whitespace
    on each line. Remove blank lines.
    """
    l = s.splitlines()
    x = [i.strip() for i in l]
    x = [i for i in x if i]  # remove blank lines
    return "\n".join(x)


def strip_line_breaks(s):
    """
    Remove \r and \n chars, replacing with a space. Strip leading/trailing
    whitespace on each line. Remove blank lines.
    """
    return re.sub(r'[\r\n ]+', ' ', s).strip()


def remove_url_breaking_chars(s):
    r = re.sub(r'[\?#&/]', '', s)
    return r.strip()

# oh yay we need parsers for imperial units. Thanks Obama.
INTEGER = Word(nums).setParseAction(lambda t: [int(t[0])])
FRACTION = (INTEGER + "/" + INTEGER).setParseAction(
    lambda t: [float(t[0])/float(t[2])]
)
MIXED_NUMBER = INTEGER ^ FRACTION ^ \
    (INTEGER + FRACTION).setParseAction(lambda t: [t[0]+t[1]])

INCHES_PER_M = 39.3700787
LB_PER_KG = 0.453592
OZ_PER_LB = 16.0

DISTANCE = (
    MIXED_NUMBER + Optional(Group('in' + Optional(".")))
).setParseAction(lambda t: [t[0]])


def parse_inches_to_metres(s):
    try:
        t = DISTANCE.parseString(s)
        return t[0] / INCHES_PER_M
    except ParseException:
        return None

LB = INTEGER + Group('lb' + Optional("."))
OZ = (
    MIXED_NUMBER + Group('oz' + Optional("."))
).setParseAction(lambda t: [t[0]/OZ_PER_LB])
LB_OZ = (LB + OZ).setParseAction(lambda t: [t[0]+t[2]])
WEIGHT = LB ^ OZ ^ LB_OZ


def parse_lb_oz_to_kg(s):
    try:
        t = WEIGHT.parseString(s)
        return t[0] * LB_PER_KG
    except ParseException:
        return None
    # except Exception as e:
    #     print e
    #     import pdb; pdb.set_trace()

LETTER_GROUPS = {
    'ABCDEFGH': "A–H",
    'IJKLMNOP': "I–P",
    'QRSTUVWXYZ': "Q–Z"
}
def group_for_letter(letter):
    for k, v in LETTER_GROUPS.items():
        if letter.upper() in k:
            return v
    return "#"

class TestUnitsParsing(unittest.TestCase):
    def test_inches_to_m(self):
        for i, o in [
            ('1 in', 0.0254),
            ('1/16 in', 0.0015875),
            ('1 12/16 in', 0.04445),
            ('1 in.', 0.0254),
            ('1/16 in.', 0.0015875),
            ('1/16in', 0.0015875),
            ('0 1/16in.', 0.0015875),
            ('1 12/16 in.', 0.04445),
            ('1', 0.025400000025908),
            ('27 1/2', 0.69850000071247),
            ('x', None),
        ]:
            print i
            self.assertAlmostEqual(parse_inches_to_metres(i), o)

    def test_lb_oz_to_kg(self):
        for i, o in [
            ('8 oz', 0.226796),
            ('8oz.', 0.226796),
            ('8 lb.', 0.226796 * 16),
            ('8lb', 0.226796 * 16),
            ('8 lb 8 oz', 0.226796 * 17),
            ('8 lb 8 1/4 oz', 3.862619375),
            ('11 lb. 5/16 oz.', 4.99837121875),
            ('8 1/4 oz', 0.233883375),
            ('800 lb', 362.8736),
            ('x', None),
            ('1', None),
        ]:
            # print i
            self.assertAlmostEqual(parse_lb_oz_to_kg(i), o)

if __name__ == '__main__':
    unittest.main()

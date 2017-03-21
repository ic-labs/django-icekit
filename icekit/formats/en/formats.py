# To customise localisation formats for your project, set
#     FORMAT_MODULE_PATH = [
#         'myproject.formats',
#     ]
# and create a Python module at formats/XX/formats.py where
# XX is your country code, e.g. 'en'.

# These defaults are borrowed from a client project which has its own formats.py.
# It's OK to revisit these.
SHORT_DATE_FORMAT = "j M" # "Oct 31"
MED_DATE_FORMAT = "D j M" # Wed Oct 31
LONG_DATE_FORMAT = "D j M Y" # Wed 31 Oct 2017

# The precision of the first value determines what controls are shown in the
# datetime picker.
DATETIME_INPUT_FORMATS = (
    '%Y-%m-%d %H:%M',                   # '2006-10-25 14:30'
    '%Y-%m-%d %H:%M:%S',                # '2006-10-25 14:30:59'
    '%Y-%m-%d %H:%M:%S.%f',             # '2006-10-25 14:30:59.000200'
    '%Y-%m-%d',                         # '2006-10-25'
    '%d/%m/%Y %H:%M',                   # '25/10/2006 14:30'
    '%d/%m/%Y %H:%M:%S',                # '25/10/2006 14:30:59'
    '%d/%m/%Y %H:%M:%S.%f',             # '25/10/2006 14:30:59.000200'
    '%d/%m/%Y',                         # '25/10/2006'
    '%d/%m/%y %H:%M',                   # '25/10/06 14:30'
    '%d/%m/%y %H:%M:%S',                # '25/10/06 14:30:59'
    '%d/%m/%y %H:%M:%S.%f',             # '25/10/06 14:30:59.000200'
    '%d/%m/%y',                         # '25/10/06'
)

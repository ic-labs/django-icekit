Import Pages from a Site Map
============================

GLAMkit allows you to quickly create a page hierarchy by importing a site map
document using an import command.

Site Map Document
-----------------

A site map document is a comma-separated (CSV) document with a specific
structure. Site map documents can be created in a spreadsheet program, then
exported in CSV format (Unicode) once it is ready.

Here is a brief example site map showing some of the key features:

===============  ===============  =======  =====  ==================  ============
Level 1          Level 2          Level 3  Brief  Alternative titles  override_url
===============  ===============  =======  =====  ==================  ============
Home                                                                  /
What's on                                                              
                 Exhibitions                                           
                 Performances                                          
Plan your visit                                                        
                 Buy tickets                                           
                 Group visits                                          
                 Public tours                                          
About us                                                               
                 Our history                                           
                 Annual reports                                        
                 (Not ready yet)                                       
                                  2017                                 
===============  ===============  =======  =====  ==================  ============


When the document is imported a new page is created for each row with a page
title, as long as that does not already match an existing page.

The site hierarchy is expressed by putting page titles in the levels columns,
where "Level 1" pages are at the top level, "Level 2" pages are child pages,
"Level 3" pages are grand-children, and so on.

Here is what the column headers mean:

- Level N: columns where you must put page titles, higher-level titles are
  created as children of lower-level ones
- Brief: a document brief describing the purpose of this item
- Alternative titles: not yet used
- override_url: the URL path "slug" to use for the page instead of a default
  slug based on the page name. This is mostly used to specify the site's home
  page, which has the path ``/``.

Here are rules applied when a site map is imported:

- the site map document must have a header row with titles matching the example
  though you can have more or fewer "Level" columns if you wish using the
  ``--levels`` import option
- each page titles must be in a "Level" column
- rows without any page title (text in a "Level" column) are ignored
- page titles surrounded with brackets or parentheses are ignored, unless the
  ``--include-titles-with-brackets`` import option is used.
  The "(Not ready yet)" entry above is an example that would be ignored
- if a matching page already exists in your site hierarchy it is ignored. This
  means that you can re-import the same site map document multiple times and
  only new or changed pages will be created.

For a more complete example site map see the `IC museum sitemap template`__.

Import Command
--------------

Use the ``import_site_map`` management command to import a site map CSV
document.

Useful options are:

- ``--verbosity=LEVEL``: set this to 2 to see more detailed log statements when
  importing a document, such as which rows were skipped and why 
- ``--levels=NUMBER``: change the number of hierarchy levels expected in your
  site map. Defaults to 3, but you may prefer 2 or 4
- ``--include-titles-with-brackets``: set this option to import titles
  surrounded by square brackets or parentheses
- ``-author-id=ID``: set this to the identifier ID of the User on your site
  who should be considered the author of imported pages. This defaults to
  1, which is generally the ID of a super-user administrator on sites
- ``--model=APPNAME.MODELNAME``: set this to change the model class of imported
  pages. It defaults to ``layout_page.LayoutPage`` which is a generic page
  provided by GLAMkit, but you may need to change this if you have a custom
  page type you would rather use.

Here is the full output of ``manage.py import_site_map --help``::

  Usage: manage.py import_site_map [options] <site_map.csv>

  Import pages from a CSV site map document

  Options:
    --version             show program's version number and exit
    -h, --help            show this help message and exit
    -v VERBOSITY, --verbosity=VERBOSITY
                          Verbosity level; 0=minimal output, 1=normal output,
                          2=verbose output, 3=very verbose output
    --settings=SETTINGS   The Python path to a settings module, e.g.
                          "myproject.settings.main". If this isn't provided, the
                          DJANGO_SETTINGS_MODULE environment variable will be
                          used.
    --pythonpath=PYTHONPATH
                          A directory to add to the Python path, e.g.
                          "/home/djangoprojects/myproject".
    --traceback           Raise on CommandError exceptions
    --no-color            Don't colorize the command output.
    -l LEVELS, --levels=LEVELS
                          Number of level columns in site map (default: 3)
    -m MODEL, --model=MODEL
                          Model to use when creating pages (default:
                          layout_page.LayoutPage)
    --author-id=AUTHOR-ID
                          ID of user to assign as author of imported pages
                          (default: 1)
    --include-titles-with-brackets
                          Should rows with page titles surrounded by brackets --
                          () or [] -- be imported? (default: False)


.. _IC museum sitemap template: https://docs.google.com/spreadsheets/
   d/1uOdYPbY655aAYUJCN6-Dq2NZy8Yi06gdV6o62BZ9_CU/edit?usp=sharing

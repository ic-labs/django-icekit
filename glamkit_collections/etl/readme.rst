Beginnings of factoring out an ETL pattern for repeatable data migration and sync in future.

TODO:
=====
Enable threads
Make generic management command
Helpers for extracting from/loading to:
    XML
    JSON
Helpers for deleting destination models that weren't in the source data - set timestamp on a given property
Django-admin-style "fields" to indicate simple transforms from source to destination
Include data-cleansing tools
Logging/debugging/analysis
Cron job/supervisor helpers
Tests!

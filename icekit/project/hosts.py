from django_hosts import patterns, host


host_patterns = patterns(
    '',
    host(r'www', 'icekit.project.urls', name='www'),
    host(r'api', 'icekit.api.urls', name='api'),
)

from django.core.management.base import NoArgsCommand
from django.db.models import Q

from eventkit.models import Event


class Command(NoArgsCommand):
    help = 'Create missing repeat events.'

    def handle_noargs(self, *args, **options):
        verbosity = int(options.get('verbosity'))
        # Get all original events with recurrence rules.
        events = Event.objects.filter(
            ~Q(recurrence_rule=None) |
            ~Q(custom_recurrence_rule='') |
            ~Q(custom_recurrence_rule=None),
            original=None)
        count = 0
        for event in events:
            created = event.create_repeat_events()
            if verbosity >= 2 or verbosity and created:
                self.stdout.write(
                    'Created %s repeat events for: %s' % (created, event))
            count += created
        if verbosity >= 2 or verbosity and count:
            self.stdout.write('Created %s repeat events.' % count)

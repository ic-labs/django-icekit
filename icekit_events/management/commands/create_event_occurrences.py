from django.core.management.base import NoArgsCommand
from django.db.models import Q

from ...models import Event


class Command(NoArgsCommand):
    help = 'Create missing repeat event occurrences'

    def handle_noargs(self, *args, **options):
        verbosity = int(options.get('verbosity'))
        # Get all root and variation events with recurrence rules.
        events = Event.objects.filter(
            ~Q(recurrence_rule='') | ~Q(recurrence_rule=None))
        count = 0
        for event in events:
            created = event.extend_occurrences()
            if verbosity >= 2 or verbosity and created:
                self.stdout.write(
                    u'Created %s occurrences for: %s' % (created, event))
            count += created
        if verbosity >= 2 or verbosity and count:
            self.stdout.write('Created %s repeat events.' % count)

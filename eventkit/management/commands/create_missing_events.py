from django.core.management.base import NoArgsCommand
from django.db.models import Q

from eventkit.models import Event


class Command(NoArgsCommand):
    help = 'Create missing repeat events.'

    def handle_noargs(self, *args, **options):
        verbosity = int(options.get('verbosity'))
        # Get all root and variation events with recurrence rules.
        events = Event.objects.filter(
            ~Q(recurrence_rule='') | ~Q(recurrence_rule=None),
            is_repeat=False)
        count = 0
        for event in events:
            created = event.create_repeat_events()
            if verbosity >= 2 or verbosity and created:
                self.stdout.write(
                    'Created %s repeat events for: %s' % (created, event))
            count += created
        if verbosity >= 2 or verbosity and count:
            self.stdout.write('Created %s repeat events.' % count)

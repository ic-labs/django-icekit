from django.apps import apps
from django.core.management.base import NoArgsCommand
from django.utils.encoding import force_text
from icekit.abstract_models import FluentFieldsMixin


class Command(NoArgsCommand):
    help = ('Add missing placeholders from templates to database. See: '
            'https://github.com/edoburu/django-fluent-contents/pull/63')

    def handle_noargs(self, *args, **options):
        verbosity = int(options.get('verbosity'))
        for model in apps.get_models():
            if issubclass(model, FluentFieldsMixin):
                if verbosity:
                    self.stdout.write('Adding placeholders for %s "%s"...' % (
                        model.objects.count(),
                        force_text(model._meta.verbose_name_plural).title(),
                    ))
                ok = updated = 0
                for obj in model.objects.all():
                    if obj.add_missing_placeholders():
                        updated += 1
                    else:
                        ok += 1
                if verbosity:
                    self.stdout.write('%s updated, %s OK' % (updated, ok))

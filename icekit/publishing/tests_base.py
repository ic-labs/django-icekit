from django.contrib.contenttypes.models import ContentType
from django.core.urlresolvers import reverse

from django_webtest import WebTest


class BaseAdminTest(WebTest):
    """ Base utility methods to test interaction with the site admin. """
    csrf_checks = False

    def refresh(self, obj, obj_pk=None):
        """
        Return the same object reloaded from the database, or optinally load
        an arbitrary object by PK if this ID is provided.
        """
        if obj_pk is None:
            obj_pk = obj.pk
        return obj.__class__.objects.get(pk=obj_pk)

    def ct_for_model(self, model_class_or_obj):
        return ContentType.objects.get_for_model(model_class_or_obj)

    def assertNoFormErrorsInResponse(self, response):
        """
        Fail if response content has any lines containing the 'errorlist'
        keyword, which indicates the form submission failed with errors.
        """
        errorlist_messages = [
            l.strip()
            for l in response.text.split('\n')
            if 'errorlist' in l
        ]
        self.assertEqual([], errorlist_messages)

    def admin_publish_item(self, obj, user=None):
        ct = self.ct_for_model(obj)
        admin_app = '_'.join(ct.natural_key())
        response = self.app.get(
            reverse('admin:%s_publish' % admin_app, args=(obj.pk,)),
            user=user,
        )
        self.assertNoFormErrorsInResponse(response)
        self.assertEqual(302, response.status_code)

    def admin_unpublish_item(self, obj, user=None):
        ct = self.ct_for_model(obj)
        admin_app = '_'.join(ct.natural_key())
        response = self.app.get(
            reverse('admin:%s_unpublish' % admin_app, args=(obj.pk,)),
            user=user,
        )
        self.assertNoFormErrorsInResponse(response)
        self.assertEqual(302, response.status_code)

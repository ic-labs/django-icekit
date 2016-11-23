from django.contrib.auth import get_user_model
from django.db import transaction, IntegrityError
from django.test import TestCase, override_settings

from django_dynamic_fixture import G

from icekit.page_types.layout_page.models import LayoutPage

from . import models


User = get_user_model()


class TestWorkflowStateModel(TestCase):

    def setUp(self):
        self.user = G(User)
        self.layoutpage = G(LayoutPage)

    def test_workflowstate_model(self):
        # Content object and status are required fields
        with transaction.atomic():
            try:
                models.WorkflowState.objects.create()
                self.fail("`content_object` should be required")
            except IntegrityError:
                pass
        with transaction.atomic():
            try:
                models.WorkflowState.objects.create(
                    status=models.WORKFLOW_STATUS_DEFAULT)
                self.fail("`content_object` should be required")
            except IntegrityError:
                pass
        # Can create workflow state with valid minimal arguments
        wfstate = models.WorkflowState.objects.create(
            content_object=self.layoutpage,
        )
        self.assertEqual(self.layoutpage, wfstate.content_object)
        self.assertEqual(models.WORKFLOW_STATUS_DEFAULT, wfstate.status)
        self.assertEqual('New', unicode(wfstate))

    def test_workflowstate_assigned_to(self):
        wfstate = models.WorkflowState.objects.create(
            content_object=self.layoutpage,
            assigned_to=self.user,
        )
        self.assertEqual('New : %s' % self.user, unicode(wfstate))


class TestWorkflowStateMixin(TestCase):

    def setUp(self):
        self.obj_without_mixin = G(User)
        self.obj_with_mixin = G(LayoutPage)

    def test_can_associate_model_without_mixin_with_workflowstate(self):
        models.WorkflowState.objects.create(
            content_object=self.obj_without_mixin)

    def test_model_without_mixin_has_no_reverse_relationship(self):
        self.assertFalse(hasattr(self.obj_without_mixin, 'workflow_states'))

    def test_model_with_mixin_has_reverse_relationship(self):
        self.assertTrue(hasattr(self.obj_with_mixin, 'workflow_states'))
        self.assertEqual(
            [],
            list(self.obj_with_mixin.workflow_states.all()))
        wfstate = models.WorkflowState.objects.create(
            content_object=self.obj_with_mixin)
        self.assertEqual(
            [wfstate],
            list(self.obj_with_mixin.workflow_states.all()))

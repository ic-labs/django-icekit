from django.contrib.auth import get_user_model
from django.contrib.admin.models import LogEntry
from django.contrib.contenttypes.models import ContentType
from django.core.urlresolvers import reverse
from django.db import transaction, IntegrityError
from django.test import TestCase

from django_dynamic_fixture import G
from django_webtest import WebTest

from icekit.page_types.article.models import Article
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


class TestWorkflowMixinAdmin(WebTest):

    def setUp(self):
        self.superuser = G(
            User, is_active=True, is_staff=True, is_superuser=True)
        self.creator_user = G(User, is_staff=True, email='creator@email.com')
        self.updater_user = G(User, is_staff=True, email='updater@email.com')
        self.reviewer_user = G(User, is_staff=True, email='reviewer@email.com')
        self.article = G(Article, title='Test Article')
        # Create LogEntry records to simulate admin change history
        article_ct_id = ContentType.objects.get_for_model(self.article).pk
        LogEntry.objects.log_action(
            user_id=self.creator_user.pk,
            content_type_id=article_ct_id,
            object_id=self.article.pk,
            object_repr='',
            action_flag=1,  # ADDITION
        )
        LogEntry.objects.log_action(
            user_id=self.creator_user.pk,
            content_type_id=article_ct_id,
            object_id=self.article.pk,
            object_repr='',
            action_flag=2,  # CHANGE
        )
        # Add workflow state for article
        models.WorkflowState.objects.create(
            content_object=self.article,
            status='ready_to_review',
            assigned_to=self.reviewer_user,
        )
    #
    # def test_workflow_list_display_columns(self):
    #     response = self.app.get(
    #         reverse('admin:icekit_article_article_changelist'),
    #         user=self.superuser)
    #     self.assertEqual(200, response.status_code)
    #     # Expected column names are present
    #     self.assertContains(response, '<span>Title</span>')
    #     self.assertContains(response, '<span>Last edited by</span>')
    #     self.assertContains(response, '<span>Workflow States</span>')
    #     # Expected column values are present
    #     self.assertContains(response, 'Test Article')
    #     self.assertContains(response, 'updater@email.com')
    #     self.assertContains(response, 'Ready to review : reviewer@email.com')
    #
    # def test_workflow_list_filters(self):
    #     # Apply status filter with expected results
    #     response = self.app.get(
    #         reverse('admin:icekit_article_article_changelist') +
    #         '?workflow_status=ready_to_review',
    #         user=self.superuser)
    #     self.assertEqual(200, response.status_code)
    #     self.assertContains(response, 'Test Article')
    #     # Apply status filter with no expected results
    #     response = self.app.get(
    #         reverse('admin:icekit_article_article_changelist') +
    #         '?workflow_status=approved',
    #         user=self.superuser)
    #     self.assertEqual(200, response.status_code)
    #     self.assertNotContains(response, 'Test Article')
    #
    #     # Apply assigned user filter with expected results
    #     response = self.app.get(
    #         reverse('admin:icekit_article_article_changelist') +
    #         '?assigned_to=%d' % self.reviewer_user.pk,
    #         user=self.superuser)
    #     self.assertEqual(200, response.status_code)
    #     self.assertContains(response, 'Test Article')
    #     # Apply assigned user filter with no expected results
    #     response = self.app.get(
    #         reverse('admin:icekit_article_article_changelist') +
    #         '?assigned_to=%d' % self.creator_user.pk,
    #         user=self.superuser)
    #     self.assertEqual(200, response.status_code)
    #     self.assertNotContains(response, 'Test Article')

    # def test_workflow_state_tabular_inline(self):
    #     # Load Article change form
    #     response = self.app.get(
    #         reverse('admin:icekit_article_article_change',
    #                 args=(self.article.pk, )),
    #         user=self.superuser)
    #     self.assertEqual(200, response.status_code)
    #     wfstate_prefix = 'icekit_workflow-workflowstate-content_type-object_id-0-'
    #     # Check existing workflow status relationship with article
    #     form = response.forms[0]
    #     self.assertEqual(
    #         'ready_to_review',
    #         form[wfstate_prefix + 'status'].value)
    #     self.assertEqual(
    #         str(self.reviewer_user.pk),
    #         form[wfstate_prefix + 'assigned_to'].value)
    #     # Update workflow status relationship with article
    #     form[wfstate_prefix + 'status'] = 'approved'
    #     form[wfstate_prefix + 'assigned_to'] = self.superuser.pk
    #     response = form.submit(name='_continue')
    #     # Check workflow status is updated
    #     wfstate = self.article.workflow_states.all()[0]
    #     self.assertEqual('approved', wfstate.status)
    #     self.assertEqual(self.superuser, wfstate.assigned_to)


class TestWorkflowAdminForPagesThatDoNotExtendOurAdminMixin(WebTest):

    def setUp(self):
        self.superuser = G(
            User, is_active=True, is_staff=True, is_superuser=True)
        self.creator_user = G(User, is_staff=True, email='creator@email.com')
        self.updater_user = G(User, is_staff=True, email='updater@email.com')
        self.reviewer_user = G(User, is_staff=True, email='reviewer@email.com')
        self.layoutpage = G(LayoutPage, title='Test LayoutPage')
        # Create LogEntry records to simulate admin change history
        layoutpage_ct_id = self.layoutpage.polymorphic_ctype.pk
        LogEntry.objects.log_action(
            user_id=self.creator_user.pk,
            content_type_id=layoutpage_ct_id,
            object_id=self.layoutpage.pk,
            object_repr='',
            action_flag=1,  # ADDITION
        )
        LogEntry.objects.log_action(
            user_id=self.creator_user.pk,
            content_type_id=layoutpage_ct_id,
            object_id=self.layoutpage.pk,
            object_repr='',
            action_flag=2,  # CHANGE
        )
        # Add workflow state for layoutpage
        models.WorkflowState.objects.create(
            content_object=self.layoutpage,
            status='ready_to_review',
            assigned_to=self.reviewer_user,
        )

    def test_workflow_list_display_columns(self):
        response = self.app.get(
            reverse('admin:fluent_pages_page_changelist'),
            user=self.superuser)
        self.assertEqual(200, response.status_code)
        # Expected column names are present
        self.assertContains(response, '<span>Title</span>')
        self.assertContains(response, '<span>Last edited by</span>')
        self.assertContains(response, '<span>Workflow States</span>')
        # Expected column values are present
        #self.assertContains(response, 'Test LayoutPage')
        self.assertContains(response, 'updater@email.com')
        self.assertContains(response, 'Ready to review : reviewer@email.com')

    def test_workflow_list_filters(self):
        # Apply status filter with expected results
        response = self.app.get(
            reverse('admin:fluent_pages_page_changelist') +
            '?workflow_status=ready_to_review',
            user=self.superuser)
        self.assertEqual(200, response.status_code)
        self.assertContains(response, 'Ready to review : reviewer@email.com')
        # Apply status filter with no expected results
        response = self.app.get(
            reverse('admin:fluent_pages_page_changelist') +
            '?workflow_status=approved',
            user=self.superuser)
        self.assertEqual(200, response.status_code)
        self.assertNotContains(response, 'Ready to review : reviewer@email.com')

        # Apply assigned user filter with expected results
        response = self.app.get(
            reverse('admin:fluent_pages_page_changelist') +
            '?assigned_to=%d' % self.reviewer_user.pk,
            user=self.superuser)
        self.assertEqual(200, response.status_code)
        self.assertContains(response, 'Ready to review : reviewer@email.com')
        # Apply assigned user filter with no expected results
        response = self.app.get(
            reverse('admin:fluent_pages_page_changelist') +
            '?assigned_to=%d' % self.creator_user.pk,
            user=self.superuser)
        self.assertEqual(200, response.status_code)
        self.assertNotContains(response, 'Ready to review : reviewer@email.com')

    def test_workflow_state_tabular_inline(self):
        # Load LayoutPage change form
        response = self.app.get(
            reverse('admin:fluent_pages_page_change',
                    args=(self.layoutpage.pk, )),
            user=self.superuser)
        self.assertEqual(200, response.status_code)
        wfstate_prefix = 'icekit_workflow-workflowstate-content_type-object_id-0-'
        # Check existing workflow status relationship with layoutpage
        form = response.forms[0]
        self.assertEqual(
            'ready_to_review',
            form[wfstate_prefix + 'status'].value)
        self.assertEqual(
            str(self.reviewer_user.pk),
            form[wfstate_prefix + 'assigned_to'].value)
        # TODO Fix form submission to succeed
        ## Update workflow status relationship with layoutpage
        #form[wfstate_prefix + 'status'] = 'approved'
        #form[wfstate_prefix + 'assigned_to'] = self.superuser.pk
        #response = form.submit()
        ## Check workflow status is updated
        #wfstate = self.layoutpage.workflow_states.all()[0]
        #self.assertEqual('approved', wfstate.status)
        #self.assertEqual(self.superuser, wfstate.assigned_to)

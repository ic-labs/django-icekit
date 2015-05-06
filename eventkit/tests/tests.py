"""
Tests for ``eventkit`` app.
"""

# WebTest API docs: http://webtest.readthedocs.org/en/latest/api.html

from django.core.urlresolvers import reverse
from django_dynamic_fixture import G
from django_webtest import WebTest

from eventkit import forms, models, views
from eventkit.tests import models as test_models


class Forms(WebTest):
    def test(self):
        pass


class Models(WebTest):
    def test_BaseModel(self):
        """
        Test that ``modified`` field is updated on save.
        """
        obj = G(test_models.BaseModel)
        modified = obj.modified
        obj.save()
        self.assertNotEqual(obj.modified, modified)


class Views(WebTest):
    def test_index(self):
        response = self.app.get(reverse('eventkit_index'))
        response.mustcontain('Hello World')

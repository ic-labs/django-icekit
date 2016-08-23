import re
from django import forms
from fluent_contents.forms import ContentItemForm


class InstagramEmbedAdminForm(ContentItemForm):

    def clean_url(self):
        """
        Make sure the URL provided matches the instagram URL format.
        """
        url = self.cleaned_data['url']

        if url:
            pattern = re.compile(r'https?://(www\.)?instagr(\.am|am\.com)/p/\S+')
            if not pattern.match(url):
                raise forms.ValidationError('Please provide a valid instagram link.')

        return url

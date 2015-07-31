import re
from django import forms
from fluent_contents.forms import ContentItemForm
from icekit.plugins.twitter_embed.models import TwitterEmbedItem


class TwitterEmbedAdminForm(ContentItemForm):
    class Meta:
        model = TwitterEmbedItem
        fields = '__all__'

    def clean_twitter_url(self):
        """
        Make sure the URL provided matches the twitter URL format.
        """
        url = self.cleaned_data['twitter_url']

        if url:
            pattern = re.compile(r'https?://(www\.)?twitter.com/\S+/status(es)?/\S+')
            if not pattern.match(url):
                raise forms.ValidationError('Please provide a valid twitter link.')

        return url

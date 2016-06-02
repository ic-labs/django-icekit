$(document).ready(function() {
	var shareButtons = $('.js-share');
	var urls = {
		initial: window.location.href,
		short: ''
	};
	var buttonClass = {
		active: 'share-button--active',
		generate: 'share-button--generate'
	};
	shareButtons.data('copied', false);

	var copyTextToClipboard = function(button, text) {
		var _textArea = document.createElement("textarea");

		_textArea.style.position = 'fixed';
		_textArea.style.top = 0;
		_textArea.style.left = 0;
		_textArea.style.width = '2em';
		_textArea.style.height = '2em';
		_textArea.style.padding = 0;
		_textArea.style.border = 'none';
		_textArea.style.outline = 'none';
		_textArea.style.boxShadow = 'none';
		_textArea.style.background = 'transparent';
		_textArea.value = text;

		document.body.appendChild(_textArea);

		_textArea.select();

		try {
			var _successful = document.execCommand('copy');
			if (_successful) {
				button.addClass(buttonClass.active);
				button.data('copied', true);
			}
		} catch (err) {
			console.error('Oops, unable to copy');
		}

		document.body.removeChild(_textArea);
	}

	function prepareShareButtons(url) {
		var _username = window.ICEKIT_SHARE_USERNAME;
		var _key = window.ICEKIT_SHARE_KEY;
        if (!_username || !_key) {
            return;
        }
		$.ajax({
			url: "http://api.bit.ly/v3/shorten",
			data: {
				'longUrl': url,
				'apiKey': _key,
				'login': _username
			},
			dataType: 'JSON',
			success: function (data) {
				var _requestUrl = urls.short = data.data.url;
				var _truncateUrl = _requestUrl.replace(/http[s]*:\/\//, '');
				shareButtons.find('.js-short-url')
					.text(_truncateUrl)
					.prop('href', urls.short);
				shareButtons.addClass(buttonClass.generate);
			}
		});
	}

	prepareShareButtons(urls.initial);

	shareButtons.on('click', function () {
		var button = $(this);
		if (button.data('copied')) {
			button.removeClass(buttonClass.active);
			button.data('copied', false);
		} else {
			copyTextToClipboard(button, urls.short);
		}
	});
});

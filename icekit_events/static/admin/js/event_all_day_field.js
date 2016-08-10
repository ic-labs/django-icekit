(function($) {
	function toggleDateTimeFields(checkbox) {
		var formParent = checkbox.parents('.form-row');
		var timeInputs = formParent.find('input.vTimeField');
		if (checkbox.prop('checked')) {
			timeInputs.val("00:00:00").attr('readonly', 'readonly');
			timeInputs.each(function() {
				$(this).hide().next(".datetimeshortcuts").hide();
			});
		} else {
			timeInputs.removeAttr('readonly');
			timeInputs.each(function() {
				$(this).show().next(".datetimeshortcuts").show();
			});
		}
	}
	// NOTE: We use `window.load` event handler here because that's the same
	// one used by DateTimeShortcuts.js and we need our code to run *after*
	// the UI shorcuts are generated, not before which happens with
	// `document.ready`.
	$(window).load(function() {
		var allDayCheckboxes = $('.field-is_all_day input');
		// Handle fields on initial page load
		allDayCheckboxes.each(function() {
			toggleDateTimeFields($(this));
		});
		// Respond to changes as the all-day-field checkbox is changed
		allDayCheckboxes.change(function() {
			toggleDateTimeFields($(this));
		});
	});
})(django.jQuery);

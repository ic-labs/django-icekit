(function($) {
	function toggleDateTimeFields(checkbox) {
		var starts = $('.field-starts');
		var ends = $('.field-ends');
		var dateStarts = $('.field-date_starts');
		var dateEnds = $('.field-date_ends');
		if (checkbox.prop('checked')) {
			starts.hide();
			ends.hide();
			dateStarts.show();
			dateEnds.show();
		} else {
			starts.show();
			ends.show();
			dateStarts.hide();
			dateEnds.hide();
		}
	}
	$(document).ready(function() {
		var checkbox = $('#id_all_day');
		toggleDateTimeFields(checkbox);
		checkbox.change(function() {
			toggleDateTimeFields(checkbox);
		});
	});
})(django.jQuery);

(function($) {
	function toggleDateTimeFields(checkbox) {
		var starts = $('.field-starts');
		var ends = $('.field-ends');
		var endRepeat = $('.field-end_repeat');
		var dateStarts = $('.field-date_starts');
		var dateEnds = $('.field-date_ends');
		var dateEndRepeat = $('.field-date_end_repeat');
		if (checkbox.prop('checked')) {
			starts.hide();
			ends.hide();
			endRepeat.hide();
			dateStarts.show();
			dateEnds.show();
			dateEndRepeat.show();
		} else {
			starts.show();
			ends.show();
			endRepeat.show();
			dateStarts.hide();
			dateEnds.hide();
			dateEndRepeat.hide();
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

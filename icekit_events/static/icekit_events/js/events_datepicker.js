$(function() {
	var datepicker = $('#datepicker');

	datepicker.datepicker({
		dateFormat: 'yy-mm-dd',
		onSelect: function(date) {
			var queryParams = $.querystring(window.location.toString());
			queryParams.date = date;
			window.location = window.location.pathname + '?' + $.querystring(queryParams);
		}
	});

	datepicker.datepicker('setDate', datepicker.data('start'));

	// Hack this a little to get the date range selected
	var datepickerCells = $('.ui-datepicker-calendar td');
	var index = datepickerCells.index($('.ui-datepicker-current-day'));
	datepickerCells.slice(index, index + parseInt(datepicker.data("period"))).addClass('active');
});

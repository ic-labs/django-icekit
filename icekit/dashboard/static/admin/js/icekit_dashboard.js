(function ($) {
	var typeSelects = $('ul.object-tools select.type-select');

	typeSelects.each(function() {
		var typeSelect = $(this);
		var defaultOption = typeSelect.find('option:selected');
		if (defaultOption.length && defaultOption.val()) {
			var addButton = typeSelect.siblings('.js-add');
			addButton.attr('href', defaultOption.val());
		}
	});

	typeSelects.on('change', function (){
		var option = $(this).find('option:selected');
		if (option.length) {
			window.location = option.val();
		}
	});
})(window.jQuery || django.jQuery);

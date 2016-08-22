(function($) {
	$(function() {
		var typeSelects = $('ul.model-tools select.type-select');

		typeSelects.each(function() {
			var typeSelect = $(this);
			var addButton = typeSelect.siblings('.js-add');
			addButton.on('click', function() {
				var option = typeSelect.find('option:selected');
				if (option.length) {
					window.location = option.val();
				}
			});
		});

		typeSelects.on('change', function (){
			var option = $(this).find('option:selected');
			if (option.length) {
				window.location = option.val();
			}
		});
	});
})(window.jQuery || django.jQuery);

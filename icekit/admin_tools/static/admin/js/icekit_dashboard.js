(function($) {
	$(function() {
		// set up controls to add different model subtypes
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

		// MONKEY-PATCH in animated content reordering, pending merge of
		// https://github.com/django-fluent/django-fluent-contents/issues/82
		// This function overrides the equivalent function in
		// django-fluent-contents/fluent_contents/static/fluent_contents/admin/cp_plugins.js
		if (typeof(cp_plugins) != "undefined") {
			cp_plugins.swap_formset_item = function (child_node, isUp) {
				var current_item = cp_data.get_inline_formset_item_info(child_node);
				var $fs_item = current_item.fs_item;
				var pane = cp_data.get_placeholder_pane_for_item($fs_item);

				// Get next/previous item
				var relative = $fs_item[isUp ? 'prev' : 'next']("div");
				if (!relative.length) return;

				cp_plugins._fixate_item_height($fs_item);

				var _moveUpDown = function (fs_item) {
					// animate swapping the items;
					var fs_height = fs_item.height();
					var relative_height = relative.height();
					var fs_move_dist = isUp ? -relative_height : relative_height;
					var relative_move_dist = isUp ? fs_height : -fs_height;

					fs_item.css({"z-index": 1000});
					fs_item.animate({top: fs_move_dist + "px"}, 200);
					relative.animate({top: relative_move_dist + "px"}, 200, function () {
						fs_item.css({'top': '0px', 'z-index': 'auto'});
						relative.css('top', '0px');
						fs_item[isUp ? 'insertBefore' : 'insertAfter'](relative);
					});
				};

				$fs_item = cp_plugins._move_item_to($fs_item, _moveUpDown);
				cp_plugins._restore_item_height($fs_item);
				cp_plugins.update_sort_order(pane);
			}
		}


	});
})(window.jQuery || django.jQuery);

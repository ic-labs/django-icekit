$(function() {
	var requestAnimationFrame = window.requestAnimationFrame || function(cb) {
		// Basic requestAnimationFrame poly-fill
		return setTimeout(cb, 33);
	};

	var locationMaps = window.gkLocationMaps || [];

	function buildMap(map) {
		// Builds up the map's DOM structure - if necessary - then
		// ensures that the map's image adapts responsively

		if (!map.container) {
			map.container = $(map.containerSelector);
		}

		if (map.href && !map.link) {
			map.link = $('<a class="location-map-link" href="' + map.href + '">');
			map.container.append(map.link);
		}

		var containerElement = map.link || map.container;

		if (!map.image) {
			map.image = $('<img class="location-map-image">');
			containerElement.append(map.image);
		}

		var overlayTitle = _.first(map.description);
		var overlayDescription = _.tail(map.description);
		if (overlayTitle && !map.overlay) {
			map.overlay = $('<div class="location-map-overlay">');

			map.overlay.append(
				'<h4 class="location-map-overlay-title">' + overlayTitle + '</h4>'
			);

			if (overlayDescription && overlayDescription.length) {
				_.forEach(overlayDescription, function(text) {
					map.overlay.append(
						'<h5 class="location-map-overlay-description">' + text + '</h5>'
					);
				});
			}

			containerElement.append(map.overlay);
		}

		var containerWidth = map.container.outerWidth();
		var containerHeight = map.container.outerHeight();

		var staticMapParams = $.param({
			center: map.center,
			zoom: map.zoom || undefined,
			size: containerWidth + 'x' + containerHeight,
			markers: map.marker,
			key: map.key,
			scale: 2
		});

		map.image.attr(
			'src',
			'https://maps.googleapis.com/maps/api/staticmap?' + staticMapParams
		);
	}

	function deferMaps() {
		// Wait for an animation frame so that we can allow the DOM to settle
		// and avoid hitting it too hard during init
		requestAnimationFrame(function() {
			_.forEach(locationMaps, buildMap);
		})
	}

	if (locationMaps.length) {
		deferMaps();

		// Lazily ensure that the maps are responsive
		$(window).on('resize', _.debounce(deferMaps, 250));
	}
});

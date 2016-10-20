// https://github.com/kylefox/jquery-querystring/blob/3d3fcfc6ce6a4356d494884579c22a880470f90e/jquery.querystring.js

(function($) {

  // Naive method of yanking the querystring portion from a string (just splits on the first '?', if present).
  function extractQuery(string) {
    if(string.indexOf('?') >= 0) {
      return string.split('?')[1];
    } else if(string.indexOf('=') >= 0) {
      return string;
    } else {
      return '';
    }
  };

  // Returns the JavaScript value of a querystring parameter.
  // Decodes the string & coerces it to the appropriate JavaScript type.
  // Examples:
  //    'Coffee%20and%20milk' => 'Coffee and milk'
  //    'true' => true
  //    '21' => 21
  function parseValue(value) {
    value = decodeURIComponent(value);
    try {
      return JSON.parse(value);
    } catch(e) {
      return value;
    }
  }

  // Takes a URL (or fragment) and parses the querystring portion into an object.
  // Returns an empty object if there is no querystring.
  function parse(url) {
    var params = {},
        query = extractQuery(url);

    if(!query) {
      return params;
    }

    $.each(query.split('&'), function(idx, pair) {
      var key, value, oldValue;
      pair = pair.split('=');
      key = pair[0].replace('[]', ''); // FIXME
      value = parseValue(pair[1] || '');
      if (params.hasOwnProperty(key)) {
        if (!params[key].push) {
          oldValue = params[key];
          params[key] = [oldValue];
        }
        params[key].push(value);
      } else {
        params[key] = value;
      }
    });

    return params;
  };

  // Takes an object and converts it to a URL fragment suitable for use as a querystring.
  function serialize(params) {
    var pairs = [], currentKey, currentValue;

    for(key in params) {
      if(params.hasOwnProperty(key)) {
        currentKey = key;
        currentValue = params[key];

        if(typeof currentValue === 'object') {
          for(subKey in currentValue) {
            if(currentValue.hasOwnProperty(subKey)) {
              // If subKey is an integer, we have an array. In that case, use `person[]` instead of `person[0]`.
              pairs.push(currentKey + '[' + (isNaN(subKey, 10) ? subKey : '') + ']=' + encodeURIComponent(currentValue[subKey]));
            }
          }
        } else {
          pairs.push(currentKey + '=' + encodeURIComponent(currentValue));
        }
      }
    }

    return pairs.join("&");
  };

  // Public interface.
  $.querystring = function(param) {
    if(typeof param === 'string') {
      return parse(param);
    } else {
      return serialize(param);
    }
  };

  // Adds a method to jQuery objects to get & querystring.
  //  $('#my_link').querystring(); // => {name: "Joe", job: "Plumber"}
  //  $('#my_link').querystring({name: 'Jack'}); // => Appends `?name=Jack` to href.
  $.fn.querystring = function() {
    var elm = $(this),
        existingData,
        newData = arguments[0] || {},
        clearExisting = arguments[1] || false;

    if(!elm.attr('href')) {
      return;
    }

    existingData = parse(elm.attr('href'));

    // Get the querystring & bail.
    if(arguments.length === 0) {
      return existingData;
    }

    // Set the querystring.
    if(clearExisting) {
      existingData = newData;
    } else {
      $.extend(existingData, newData);
    }
    elm.attr('href', elm.attr('href').split("?")[0] + "?" + serialize(existingData));
    return elm;

  };

})(jQuery);

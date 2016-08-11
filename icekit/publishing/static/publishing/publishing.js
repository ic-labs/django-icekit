(function(){
  var $ = django.jQuery;
  $(function() {
    $('input:checkbox.publish-checkbox').change(function() {
      var elem = $(this);
      if (elem.is(':checked')) {
        var url = elem.attr('data-publish');
      } else {
        var url = elem.attr('data-unpublish');
      }
      $.get(url, function(data) {
        if (data.success) {
          elem.parent().find('.published-icon img').toggle();
        }
      });
    });
  });
})();

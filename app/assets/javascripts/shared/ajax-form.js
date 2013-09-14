//TODO: Have noe use CoffeeScript temporarily, translate this to coffee later
App.lib.ajax = function () {
  var $errorBar = $('.error');

  function showErrors(data){
    $errorBar.html(data.message).show();
  };

  (function(){
    $(document).on( 'ajax:before', 'form[data-remote], a[data-remote]', function (e) {
        //Going To add the spinner
      })
      .on('ajax:success', 'form[data-remote], a[data-remote]', function (e, data, status, xhr) {
        //implement realod the js after ajax later, use the element data-reload attribute, after make the js OO orenited
        var me = $(this);
        if ($.isPlainObject(data)) {
          if (data.update) {
            for (var id in data.update) {
              var newElement = $(data.update[id]);
              var updateMethod = newElement.find(id).andSelf().length > 0 ? 'replaceWith' : 'html';
              $('#' + id)[updateMethod](newElement);
            }
          }
          if (data.modal) {
              var newElement = $(data.modal);
              $('#myModal').html(newElement).modal();
            }
          else if (data.reload) {
            window.location.reload(true);
          }
          else if (data.redirect) {
            if (window.location.href.substr(-1 * data.redirect.length) == data.redirect) {
              window.location.reload(true);
            } else {
              window.location = data.redirect;
              if (window.location.pathname == data.redirect.replace(/#.*$/, "")) {
                window.location.reload(true);
              }
            }
          }
        }

        $('.error').hide();
      })
      .on( 'ajax:complete', 'form[data-remote], a[data-remote]',function (e, xhr) {

      })
      .on( 'ajax:error', 'form[data-remote], a[data-remote]',function (e, xhr, status, error) {
        var data = null;
        try { data = $.parseJSON(xhr.responseText); }
        catch (e) {}
        if(data.update) {
        }
        if (xhr.status > 399 && xhr.status < 500) {
          if (data.redirect) {
            window.location = data.redirect;
          } else {
            showErrors(data);
          }
        }
      });

  }())

}

//TODO: Have noe use CoffeeScript temporarily, translate this to coffee later
function showErrors(data){
  $('.error').html(data.errors).show();
}

$(document)
  .on( 'ajax:before', 'form[data-remote], a[data-remote]',function (e) {

  })
  .on('ajax:success', 'form[data-remote], a[data-remote]', function (e, data, status, xhr) {
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
      if (data) {
        showErrors(data);
      }
    }
  });

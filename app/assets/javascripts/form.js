//TODO: Have noe use CoffeeScript temporarily, translate this to coffee later
$(document)
  .on( 'ajax:before', 'form[data-remote], a[data-remote]',function (e) {

  })
  .on('ajax:success', 'form[data-remote], a[data-remote]', function (e, data, status, xhr) {
    var me = $(this);
    if ($.isPlainObject(data)) {
      if (data.update) {
        //TODO: add the partial refresh feture
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
  })
  .on( 'ajax:complete', 'form[data-remote], a[data-remote]',function (e, xhr) {

  })
  .on( 'ajax:failure', 'form[data-remote], a[data-remote]',function (e, xhr, status, error) {

  });

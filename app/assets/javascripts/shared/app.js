App = (function (){
  var self = {
    page: {},
    util: {}
  };

  self.util.exec = function(name, container){
    var namespace = App;

    if ( name !== "" && namespace.page[name] && typeof namespace.page[name] == "function" ) {
      var page = namespace.page[name];
      new page(container);
    } else {
      throw 'A plugin with the name [' + page + '] could not be found. Make sure the script is included on the page.';
    }
  }

  self.init = function(element){
    var $element = $(element),
        $pages = $element.find("[data-page]").add($element.filter("[data-page]"));
    $pages.each(function () {
      var $this = $(this),
          name = $this.attr('data-page');
      self.util.exec( name, $this );

    });
  }

  return self;
}());

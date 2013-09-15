App = (function (){
  var self = {
    page: {},
    lib: {},
    util: {}
  };

  self.util.exec = function(name, container){
    var namespace = App;

    if ( name !== "" && namespace.page[name] && typeof namespace.page[name] == "function" ) {
      var page = namespace.page[name];
      new page(container);
    }
  }

  self.init = function(element, reload){
    var $element = $(element),
        selector = typeof reload !== 'undefined'  ? "[data-reload]" : "[data-page]",
        $pages = $element.find(selector).add($element.filter(selector));
    $pages.each(function () {
      var $this = $(this),
          name = $this.attr('data-page');
      self.util.exec( name, $this );
    });
    for (var k in self.lib){
      new self.lib[k]();
    };
  }

  return self;
}());

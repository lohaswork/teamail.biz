!function($) {

  App.page.WelcomeIndexPage = function (element){
    this.el = element;
    this.init();
  }
  App.page.WelcomeIndexPage.prototype = {
    navbar: $(".navbar.navbar-fixed-top"),
    scrollTop: $('.scrolltop'),
    back2top: $('.back2top'),
    scroller: $('.scroller'),

    init: function(){
      var self =this;

      $(window).scroll(function(){
        // add navbar opacity on scroll
        if ($(this).scrollTop() > 100) {
          self.navbar.addClass("scroll");
        } else {
          self.navbar.removeClass("scroll");
        }

        // global scroll to top button
        if ($(this).scrollTop() > 160) {
          self.scrollTop.fadeIn();
        } else {
          self.scrollTop.fadeOut();
        }
      });

      // scroll back to top
      self.back2top.click(function(){
        $("html, body").animate({ scrollTop: 0 }, 700);
        return false;
      });

      // scroll navigation functionality
      self.scroller.click(function(){
        var section = $($(this).data("section"));
        var top = section.offset().top;
        $("html, body").animate({ scrollTop: top }, 700);
        return false;
      });
    }
  }

}(window.jQuery);

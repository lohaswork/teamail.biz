!function($) {

  App.page.EarlyAdoptersIndexPage = function (element){
    this.el = element;
    this.init();
  }
  App.page.EarlyAdoptersIndexPage.prototype = {
    navbar: $(".navbar.navbar-fixed-top"),
    scrollTop: $('.scrolltop'),
    back2top: $('.back2top'),
    scroller: $('.scroller'),

    videoReady: function (){
      // Once the video is ready
      _V_("demo-video").ready(function(){

        var myPlayer = this;    // Store the video object
        var aspectRatio = 9/16; // Make up an aspect ratio

        function resizeVideoJS(){
          // Get the parent element's actual width
          var width = document.getElementById(myPlayer.id).parentElement.offsetWidth;
          width = width - 8;
          // Set width to fill parent element, Set height
          myPlayer.width(width).height( width * aspectRatio );
        }

        resizeVideoJS(); // Initialize the function
        window.onresize = resizeVideoJS; // Call the function on resize
      });
    },

    init: function(){
      var self =this;
      self.videoReady();

      $(window).scroll(function(){
        // add navbar opacity on scroll
        if ($(this).scrollTop() > 100) {
          self.navbar.addClass("scroll");
        } else {
          self.navbar.removeClass("scroll");
        }

        // global scroll to top button
        if ($(this).scrollTop() > 160) {
          this.scrollTop.fadeIn();
        } else {
          this.scrollTop.fadeOut();
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

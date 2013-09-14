App.page.EarlyAdoptersIndexPage = function (element){
  this.init = function (){
  this.el = element;
  };

  this.navbar = $(".navbar.navbar-fixed-top");
  this.scrollTop = $('.scrolltop');
  this.back2top = $('.back2top');
  this.scroller = $('.scroller');

  function vedioReady(){
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
  }

  (function(me){
    vedioReady();

    $(window).scroll(function(){
      // add navbar opacity on scroll
      if ($(this).scrollTop() > 100) {
        me.navbar.addClass("scroll");
      } else {
        me.navbar.removeClass("scroll");
      }

      // global scroll to top button
      if ($(this).scrollTop() > 160) {
        this.scrollTop.fadeIn();
      } else {
        this.scrollTop.fadeOut();
      }
    });

    // scroll back to top
    me.back2top.click(function(){
      $("html, body").animate({ scrollTop: 0 }, 700);
      return false;
    });

    // scroll navigation functionality
    me.scroller.click(function(){
      var section = $($(this).data("section"));
      var top = section.offset().top;
      $("html, body").animate({ scrollTop: top }, 700);
      return false;
    });
  }(this));
}

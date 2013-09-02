//= require video-js

$(function () {
    $(window).scroll(function(){
        // add navbar opacity on scroll
        if ($(this).scrollTop() > 100) {
            $(".navbar.navbar-fixed-top").addClass("scroll");
        } else {
            $(".navbar.navbar-fixed-top").removeClass("scroll");
        }

        // global scroll to top button
        if ($(this).scrollTop() > 160) {
            $('.scrolltop').fadeIn();
        } else {
            $('.scrolltop').fadeOut();
        }
    });

    // scroll back to top
    $('.back2top').click(function(){
        $("html, body").animate({ scrollTop: 0 }, 700);
        return false;
    });

    // scroll navigation functionality
    $('.scroller').click(function(){
      var section = $($(this).data("section"));
      var top = section.offset().top;
        $("html, body").animate({ scrollTop: top }, 700);
        return false;
    });

});

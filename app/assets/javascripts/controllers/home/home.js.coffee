# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  class App.page.HomeFaqPage
    constructor: ->
      this.init()

    init: ->
      $('body').scrollspy({ target: '#question-nav-container' })

  class App.page.HomeIndexPage
    constructor: ->
      this.init()

    init: ->
      myPlayer = _V_("demo-video")
      $('#video-opener').click ->
        $('#video-modal').modal()
      $('#video-modal').on 'shown.bs.modal', ->
        myPlayer.play()
      .on 'hide.bs.modal', ->
        myPlayer.pause()



      $(window).scroll ->
        navbar = $(".navbar.navbar-fixed-top")
        scrollTop = $('.scrolltop')

        # add navbar opacity on scroll
        if $(this).scrollTop() > 100
          navbar.addClass("scroll")
        else
          navbar.removeClass("scroll")

        # global scroll to top button
        if $(this).scrollTop() > 350 && $(this).width() > 768
          scrollTop.fadeIn()
        else
          scrollTop.fadeOut()

      # scroll back to top
      $('.back2top').click (e) ->
        $("html, body").animate({ scrollTop: 0 }, 900)
        e.stopPropagation()

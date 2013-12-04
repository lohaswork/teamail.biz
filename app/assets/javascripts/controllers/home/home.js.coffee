# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  $('body').scrollspy({ target: '#question-nav-container' })
  $('#video-opener').click ->
    $('#video-modal').modal()

  $(window).scroll ->
    navbar = $(".navbar.navbar-fixed-top")
    scrollTop = $('.scrolltop')

    # add navbar opacity on scroll
    if $(this).scrollTop() > 100
      navbar.addClass("scroll")
    else
      navbar.removeClass("scroll")

    # global scroll to top button
    if $(this).scrollTop() > 160
      scrollTop.fadeIn()
    else
      scrollTop.fadeOut()

  # scroll back to top
  $('.back2top').click (e) ->
    $("html, body").animate({ scrollTop: 0 }, 700)
    e.stopPropagation()

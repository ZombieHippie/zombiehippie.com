say = (o)->
  $('#output').text o.toString()

navToggle = (event)->
  $('body').toggleClass 'open-nav'
navEvent = (event)->
  $('#out').text event.target.href
  text = event.target.href
  text = text.replace /^(http[s]?:\/\/)\w*\./, '$1sock.'
  say text
  event.preventDefault()
$("section p a").on 'click', navEvent
$("ul.nav li a").on 'click', navEvent
$(".nav-toggle").on 'click', navToggle
$("#page-overlay").on 'click', navToggle
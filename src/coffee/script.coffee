say = (o)->
  $('#output').text o.toString()
  console.log o

navToggle = (event)->
  $('body').toggleClass 'open-nav'
navEvent = (event)->
  return
  $('#out').text event.target.href
  text = event.target.href
  text = text.replace /^(http[s]?:\/\/[^\/]*)(\/.*)/, '$1/sock$2'
  event.preventDefault()
$("section p a").on 'click', navEvent
$("ul.nav li a").on 'click', navEvent
$(".nav-toggle").on 'click', navToggle
$("#page-overlay").on 'click', navToggle
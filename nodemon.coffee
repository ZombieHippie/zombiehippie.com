# This is for development purposes
devreload = require 'devreload'
gen = require './lib/gen.coffee'
ndm = require 'nodemon'
p = require 'path'

if devreload
  # Use devreload for reloading the browser
  devreload.listen {watch:null, port:9999}
else devreload = false

std = (data)->console.log data.toString()
willGenSrc = '--gensrc' in process.argv or '--gen' in process.argv
willGenVend = '--genvendors' in process.argv or '--gen' in process.argv
checkGenSrc = ->
  do gen.buildSrc if willGenSrc
checkGenVendors = ->
  do gen.buildVendors if willGenVend
checkGen = ->
  checkGenSrc()
  checkGenVendors()
start = ->
  ext = 'jade coffee js'
  watch = ['routes/','app.coffee']
  if willGenVend
    watch.push 'vendors/'
    ext += ' css'
  if willGenSrc
    watch.push 'src/coffee/'
    watch.push 'src/js/'
    watch.push 'src/stylus/'
    ext += ' styl'
  ndm {
    script: 'app.coffee'
    watch
    ext
  }
  .on 'restart', ->
    checkGen()
    devreload.reload()
  .on 'log', (log) ->
    console.log log.colour

checkGen()
start()
coffee = require 'coffee-script/register'
gen = require './lib/gen.coffee'
task 'build', 'populate ./static files', (o)->
	gen.gen()
task 'watch', 'watch ./src to build ./static files', (o)->
	directory = __dirname+"/src/"
	srcFW = fs.watch directory, {interval:500}
	srcFW.on 'change', ->
		console.log 'Change detected on src files\nCompiling...'
		gen.buildSrc()
task 'build:vendors', './vendor files to ./static files', gen.buildVendors
task 'build:src', './src to ./static', gen.buildSrc
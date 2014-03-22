gen = require './lib/gen.coffee'
task 'build', 'populate ./static files', (o)->
	gen.gen()
task 'watch', 'watch to build ./static files', (o)->
	directory = __dirname+"/src/"
	stylusFW = fs.watch directory + 'stylus/', {interval:500}
	stylusFW.on 'change', ->
		console.log 'Change detected on stylus files\nCompiling...'
		gen.buildSrcStylus()
	coffeeFW = fs.watch directory + 'coffee/', {interval:500}
	coffeeFW.on 'change', ->
		console.log 'Change detected on coffee files\nCompiling...'
		gen.buildSrcCoffee()
task 'build:vendors', './vendor files to ./static files', buildVendors
task 'build:src', './src to ./static', buildSrc
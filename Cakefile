fs = require 'fs'
coffee = require 'coffee-script'
stylus = require 'stylus'
Rehab = require 'rehab'
nib = require 'nib'

ensureDir = ->
	try
		fs.mkdirSync dir = __dirname+'/static'
		fs.mkdirSync dir + '/css'
		fs.mkdirSync dir + '/js'
	catch err
		return
buildVendors = ->
	ensureDir()
	directory = __dirname+"/vendor/"
	outputdir = __dirname+"/static/"
	cssStr = ""
	jsStr = ""
	writeVendorsFiles = ->
		fs.writeFileSync outputdir+"css/vendors.css", cssStr
		fs.writeFileSync outputdir+"js/vendors.js", jsStr
	cssFiles = fs.readdirSync directory+'css/'
	jsFiles = fs.readdirSync directory+'js/'
	for filename in cssFiles when filename.match /\.css$/i
		cssStr += fs.readFileSync(directory+'css/'+filename)+'\n'
	for filename in jsFiles when filename.match /\.js$/i
		jsStr += fs.readFileSync(directory+'js/'+filename)+'\n'
	writeVendorsFiles()
	return null
buildSrc = ->
	ensureDir()
	buildSrcCoffee()
	buildSrcStylus()
buildSrcCoffee = ->
	directory = __dirname+"/src/"
	outputdir = __dirname+"/static/"
	jsfiles = {}
	writeFiles = ->
		for filename, data of jsfiles
			path = outputdir+"js/"+filename
			fs.writeFileSync path, data
	#Compile CoffeeScript
	coffeeDir = directory + 'coffee/'
	coffeeOutput = ""
	for filepath in new Rehab().process coffeeDir
		coffeeOutput += coffee.compile fs.readFileSync(filepath, 'utf8'), {bare:true}
	jsfiles["script.js"] = coffeeOutput
	writeFiles()
buildSrcStylus = ->
	directory = __dirname+"/src/"
	outputdir = __dirname+"/static/"
	cssfiles = {}
	#Compile Stylus
	stylFiles = fs.readdirSync directory + 'stylus/'
	stylTasks = stylFiles.length
	writeFiles = ->
		for filename, data of cssfiles
			path = outputdir+"css/"+filename
			fs.writeFileSync path, data
	for filename in stylFiles when filename.match /\.styl$/i
		stylus(fs.readFileSync directory+'stylus/'+filename, 'utf8')\
		.use(nib()).render (err, css)->
			if not err
				cssfiles[filename.replace /\.styl$/i, '.css']=css
			else console.error err
			
			stylTasks--
			if not stylTasks
				writeFiles()

task 'build', 'populate ./static files', (o)->
	buildVendors()
	buildSrc()
task 'watch', 'watch to build ./static files', (o)->
	ensureDir()
	directory = __dirname+"/src/"
	stylusFW = fs.watch directory + 'stylus/', {interval:500}
	stylusFW.on 'change', ->
		console.log 'Change detected on stylus files\nCompiling...'
		buildSrcStylus()
	coffeeFW = fs.watch directory + 'coffee/', {interval:500}
	coffeeFW.on 'change', ->

		console.log 'Change detected on coffee files\nCompiling...'
		buildSrcCoffee()
task 'build:vendors', './vendor files to ./static files', buildVendors
task 'build:src', './src to ./static', buildSrc
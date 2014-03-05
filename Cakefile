fs = require 'fs'
p = require 'path'
coffee = require 'coffee-script'
stylus = require 'stylus'
R = require 'coffeescript-rehab'
nib = require 'nib'
uglify = require 'uglify-js'

try fs.mkdirSync dir = __dirname+'/static'
try fs.mkdirSync dir + '/css'
try fs.mkdirSync dir + '/js'

buildVendors = ->
	directory = __dirname+"/vendor/"
	outputdir = __dirname+"/static/"
	cssStr = ""
	jsStr = ""
	writeVendorsFiles = ->
		fs.writeFileSync outputdir+"css/vendors.css", cssStr
		jsStr = uglify.minify(jsStr, { fromString: true }).code;
		fs.writeFileSync outputdir+"js/vendors.js", jsStr

	cssFiles = fs.readdirSync directory+'css/'
	cssFiles = (p.resolve(directory+'css/',fl) for fl in cssFiles)[...]
		.concat (p.resolve('node_modules/codemirror/',fl) for fl in [
			"lib/codemirror.css", "theme/xq-light.css"
		])[...]

	jsFiles = fs.readdirSync directory+'js/'
	jsFiles = (p.resolve(directory+'js/',fl) for fl in jsFiles)[...] 
		.concat (p.resolve('node_modules/codemirror/',fl) for fl in [
			"lib/codemirror.js",
			"addon/edit/continuelist.js", "addon/fold/markdown-fold.js",
			"addon/selection/active-line.js", "addon/selection/mark-selection.js",
			"mode/markdown/markdown.js"
		])[...]
	jsFiles.push p.resolve('node_modules/showdown/',"compressed/showdown.js")

	for filepath in cssFiles when filepath.match /\.css$/i
		cssStr += fs.readFileSync(filepath)+'\n'
	for filepath in jsFiles when filepath.match /\.js$/i
		jsStr += fs.readFileSync(filepath)+';\n'
	writeVendorsFiles()

buildSrc = ->
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
	files = fs.readdirSync coffeeDir
	for fl in files
		r = new R(p.resolve coffeeDir, fl)
		jsfiles[fl.replace(/coffee$/, 'js')] = r.compile()
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
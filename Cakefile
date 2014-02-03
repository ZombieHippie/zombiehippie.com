fs = require 'fs'
coffee = require 'coffee-script'
stylus = require 'stylus'
Rehab = require 'rehab'
nib = require 'nib'

task 'build', 'populate ./static files', (o)->
	buildVendors()
	buildSrc()
buildVendors = ->
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
	directory = __dirname+"/src/"
	outputdir = __dirname+"/static/"
	files = { js:{} , css:{} }
	writeFiles = ->
		for filename, data of files.css
			path = outputdir+"css/"+filename
			fs.writeFileSync path, data
		for filename, data of files.js
			path = outputdir+"js/"+filename
			fs.writeFileSync path, data
	
	#Compile CoffeeScript
	coffeeDir = directory + 'coffee/'
	coffeeOutput = ""
	for filepath in new Rehab().process coffeeDir
		coffeeOutput += coffee.compile fs.readFileSync(filepath, 'utf8'), {bare:true}
	files.js["script.js"] = coffeeOutput

	#Compile Stylus
	stylFiles = fs.readdirSync directory + 'stylus/'
	stylTasks = stylFiles.length
	for filename in stylFiles when filename.match /\.styl$/i
		stylus(fs.readFileSync directory+'stylus/'+filename, 'utf8')\
		.use(nib()).render (err, css)->
			if not err
				files.css[filename.replace /\.styl$/i, '.css']=css
			else console.error err
			
			stylTasks--
			if not stylTasks
				writeFiles()

task 'build:vendors', './vendor files to ./static files', buildVendors
task 'build:src', './src to ./static', buildSrc
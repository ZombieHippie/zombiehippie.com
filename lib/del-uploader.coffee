busboy = require "busboy"
path = require "path"
qs = require "querystring"
fs = require "fs"
exports.uploadRequest = (req, res)->
	req.query = qs.parse(req.url.match(/\?(.*)$/)[1])
	console.log(" Upload started")

	# FEATURE: Check permissions
	if not clients[cookie]
		res.statusCode = 500
		res.setHeader("Content-Type", "text/plain")
		res.end()
		return

	busboy = new Busboy({ headers: req.headers, fileHwm: 1024 * 1024 })
	done = false
	files = []

	busboy.on "file", (fieldname, file, filename)->
		dstRelative = filename ? decodeURIComponent(filename) : fieldname
		dst = path.join(req.query.slug, req.query.filename)
		file.pipe fs.createWriteStream()

	closeConnection = ->
		res.statusCode = 200
		res.setHeader("Content-Type", "text/plain")
		res.setHeader("Connection", "close")
		res.end()

	busboy.on "finish", ->
		done = true
		console.log "Finished upload: " + slug + "/" + filename
		#names = Object.keys(files)
		#for name in names
		#	fs.rename files[name].src, files[name].dst, ->
		#		console.log(" Received: " + slug + "/" + filename)
		closeConnection()

	req.on "close", ->
		if not done
			console.log(" Upload cancelled")
		closeConnection()

	req.pipe(busboy)
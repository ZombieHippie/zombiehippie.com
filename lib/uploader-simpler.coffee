path = require "path"
qs = require "querystring"
fs = require "fs"
exports.handler = (req, res)->
	{filename, slug} = qs.parse(req.url.match(/\?(.*)$/)[1])
	console.log("Upload started #{slug}/#{filename}")
	if not req.session.user && false
		res.statusCode = 500
		res.setHeader("Content-Type", "text/plain")
		res.end()
		return
	closeConnection = ->
		res.statusCode = 200
		res.setHeader("Content-Type", "text/plain")
		res.setHeader("Connection", "close")
		res.end()
	req.on "close", ->
		console.log("Upload finished #{slug}/#{filename}")
		closeConnection()
	writer = fs.createWriteStream("./data/files/#{slug}/#{filename}")
	try fs.mkdirSync "./data/files/#{slug}"
	req.pipe(writer)
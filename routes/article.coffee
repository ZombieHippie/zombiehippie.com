send = require 'send'
url = require 'url'
module.exports = class Write
	constructor: (@app, @db)->
		@app.get '/article/:slug', @get
		@app.get '/article/:slug/*', @getFile
		@app.get '/article/', (req, res)->
			res.redirect '/'
	get: (req,res) =>
		slug = req.params.slug
		@db.getArticle slug, (err, post) =>
			if post?
				res.render 'article.jade', post
			else
				res.redirect '/'
	getFile: (req, res) =>
		fileLoc = req.path.replace(/^article\//, '').match /([^\/]+)(.+)$/
		console.log fileLoc[0]
		redir = ->
				res.redirect '/article/' + fileLoc[1]
		send(req, fileLoc[0])
			.root('./data/files')
			.on('error', redir)
			.on('directory', redir)
			.pipe(res)
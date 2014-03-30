url = require 'url'
md = new (require 'showdown').converter()#({extensions:[require './showdown-extensions.js']})
renderer = (text, slug) ->
	text = text.replace ///
			! \[ ([^\n]*?) \]
				\( ([\S]+?) \s? ("[^"]*")? \)
		///, (match, alt, src, title) ->
			src = "/files/#{slug}/#{src}"
			"""
				<p>
					<img alt="#{alt}" src="#{src}" title=#{title}></img>
				</p>
			"""
	text = text.replace /\blive\:([\w\d\-\_]+)\s*\n/, '\n<div id="$1" class="live-previewer"></div>\n'
	md.makeHtml(text)

express = require 'express'
module.exports = class Write
	constructor: (@app, @db)->
		@app.get '/article/:slug', @get
		@app.get '/article/', (req, res)->
			res.redirect '/'
	get: (req,res) =>
		slug = req.params.slug
		@db.getArticle slug, (err, post) =>
			post.md = renderer(post.md, post.slug)
			if post?
				res.render 'article.jade', post
			else
				res.redirect '/'
m = require 'methodder'

module.exports = class Write
	constructor: (@app, @db)->
		@app.get '/write', m @get, @
		@app.post '/write', m @post, @
	get: (req,res) =>
		return res.redirect('/') if not req.session.user
		res.render 'write.jade', {
				title: 'Write on Inkblur'
				user: req.session.user
				isNew: true}
	post: (req,res) =>
		return res.redirect('/') if not req.session.user
		@write req.body, req.session.user.name, (err, post)->
			console.log {err} if err
			if post
				console.log "Wrote new post:"+post.title
				res.redirect('/article/' + post.slug)
			else
				res.redirect '/write?failed'
	write: (body, user, fn) =>
		body["date"] = (new Date()).getTime()
		body["user"] = user
		@db.writeArticle body, fn
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
				res.redirect('/')
			else
				res.redirect '/write?failed'
	write: (body, user, fn) =>
		{title, slug, content} = body
		@db.Post.findOne {slug}, 'slug', (err, post) =>
			return fn(err) if err
			# query the db for the slug
			if post
				return fn(new Error('post already written to that slug!'))
			post = new @db.Post {
				user
				title
				slug
				content
				date: new Date()
			}
			post.save (err)->
				if not err
					console.log "SAVE: #{user}'s post: #{title} at: #{slug}"
					fn(null, post)
				else
					fn(err)
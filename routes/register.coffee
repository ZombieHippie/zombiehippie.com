hasher = require('../lib/pass').hash
m = require 'methodder'
registration_key = "Q;vi74;7mRWQ4''1"

module.exports = class Register
	constructor: (@app, @db)->
		@app.get '/register', m @get, @
		@app.post '/register', m @post, @
	get: (req,res) =>
		res.render 'login.jade', {
				title: 'Register to Inkblur'
				user: req.session.user
				isNew: true}
	post: (req,res) =>
		if req.body.key isnt registration_key
			return res.redirect '/register?failed'
		@register req.body.username, req.body.password, (err, user)->
			console.log {err} if err
			if user
				console.log "User logged in:"+user.name
				# Regenerate session when signing in
				# to prevent fixation 
				req.session.regenerate ->
					console.log "Regenerate"
					# Store the user's primary key 
					# in the session store to be retrieved,
					# or in this case the entire user object
					req.session.user = user
					res.redirect('/')
			else
				res.redirect '/register?failed'
	register: (name, pass, fn) =>
		hasher pass, (err, salt, hash) =>
			if(err)
				return fn(err)
			@db.writeUser name, salt, hash, fn

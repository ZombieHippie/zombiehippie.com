hasher = require('../lib/pass').hash

module.exports = class Login
	constructor:(@app, @db)->
		@app.get '/login', @get
		@app.post '/login', @post
		@app.all '/logout', @logout
	get: (req, res)=>
		res.render 'login.jade', {
				title: 'Login to Inkblur'
				user: req.session.user
				isNew: false}
	post: (req, res)=>
		@authenticate req.body.username, req.body.password, (err, user)=>
			if user
				console.log "User logged in:"+user.name
				# Regenerate session when signing in
				# to prevent fixation
				req.session.regenerate =>
					console.log "Regenerate"
					# Store the user's primary key 
					# in the session store to be retrieved,
					# or in this case the entire user object
					req.session.user = user
					res.redirect('/')
			else
				console.error( new Error err ) if err
				res.redirect '/login?failed'

	logout: (req, res)=>
		# destroy the user's session to log them out
		# will be re-created next request
		req.session.destroy ->
			res.redirect('/')

	authenticate: (name, pass, fn)=>
		@db.getUser name, (err, user) ->
			return fn(err) if err
			# apply the same algorithm to the POSTed password, applying
			# the hash against the pass / salt, if there is a match we
			# found the user
			hasher pass, user.salt, (err, hash) ->
				if(err)
					return fn(err)
				if(hash is user.hash)
					return fn(null, user)
				fn('invalid password')
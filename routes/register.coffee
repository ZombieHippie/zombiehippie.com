module.exports = class Register
	constructor: (@app, @db)->
		@app.get '/register', @get
		@app.post '/register', @post
	get: (req,res) =>
		res.render 'register.jade', {
				title: 'Register'
				user: req.session.user}
	post: (req,res) =>
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
					res.redirect('back')
			else
				res.redirect '/login'	
	register: (name, pass, fn)=>
		@db.User.findOne {name}, 'name', (err, user) ->
			return fn(err) if err
			console.log user
			# query the db for the given username
			if user
				return fn(new Error('user already registered'))
			# apply the same algorithm to the POSTed password, applying
			# the hash against the pass / salt, if there is a match we
			# found the user
			hash pass, (err, salt, hash) ->
				if(err)
					return fn(err)
				user = new @db.User {
					name
					hash
					salt
				}
				user.save (err)->
					console.log "SAVE: "+name
					console.log err
					return if(err) then fn(err) else fn(null, user)
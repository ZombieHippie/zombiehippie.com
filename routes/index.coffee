m = require 'methodder'
module.exports = class Index
	constructor:(@app, @db)->
		# navigation bar
		@app.locals nav:{Home:"/"}
		@app.get '/', m @get, @
		@app.post '/', m @post, @
		@login = new (require('./login'))(@app, @db)
		@register = new (require('./register'))(@app, @db)
		@write = new (require('./write'))(@app, @db)
	get: (req, res) ->
		@getPosts (err, tiles)->
			res.render('index_tile_list', {
				title: 'Inkblur'
				user: req.session.user
				tiles
			})
	post: (req, res) ->
		console.log req.body

	getPosts:(fn)->
		@db.Post.find (err, posts) =>
			return fn(err) if err

			console.log posts

			fn(null, posts)
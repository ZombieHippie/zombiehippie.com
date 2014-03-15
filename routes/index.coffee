module.exports = class Index
	constructor:(@app, @db)->
		# navigation bar
		@app.locals {
			nav:{Home:"/", Login:"/login"},
			site_name:"Media by Cole Lawrence (ZombieHippie)",
			author:"Cole Lawrence"
		}
		@app.get '/', @get
		@app.post '/', @post
		@article = new (require('./article'))(@app, @db)
		@login = new (require('./login'))(@app, @db)
		@register = new (require('./register'))(@app, @db)
		@write = new (require('./write'))(@app, @db)
	get: (req, res) =>
		@getPosts req.query.sort || "date", (err, tiles)->
			res.render('index_tile_list', {
				title: 'Inkblur'
				user: req.session.user
				tiles
			})
	post: (req, res) =>
		console.log req.body

	getPosts:(sortBy, fn)->
		@db.getArticlesBy sortBy, fn
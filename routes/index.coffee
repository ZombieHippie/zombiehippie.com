m = require 'methodder'
module.exports = class Index
	constructor:(@app, @db)->
		# navigation bar
		@app.locals nav:{Home:"/"}
		@app.get '/', m @get, @
		@app.post '/', m @post, @
		@login = new (require('./login'))(@app, @db)
		@register = new (require('./register'))(@app, @db)
	get: (req, res) ->
		res.render('index_tile_list', {
			title: 'Inkblur'
			user: req.session.user
			tiles: {
				sally: "pumpkin"
				molly: "green dress"
				svetla: "playful"
				lana: "beautiful"
			}
		})
	post: (req, res) ->
		console.log req.body
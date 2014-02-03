m = require 'methodder'
module.exports = class Index
	constructor:(@app, @db)->
		# navigation bar
		@app.locals nav:{Home:"/",Login:"/login",Logout:"/logout",Register:"/register"}
		@app.get '/', new m @get, @
		@app.post '/', new m @post, @
		@login = new require('./login')(@app, @db)
		@register = new require('./register')(@app, @db)
	get: (req, res) ->
		res.render('index', { title: 'Express' })
	post: (req, res) ->
		console.log req.body
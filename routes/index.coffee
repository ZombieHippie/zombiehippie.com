module.exports = class Index
	constructor:(@app, @db)->
		@app.get '/', @get
		@app.post '/', @post
		require('./login')(@app, @db)
		require('./register')(@app, @db)
	get: (req, res) ->
		res.render('index', { title: 'Express' })
	post: (req, res) ->
		console.log req.body
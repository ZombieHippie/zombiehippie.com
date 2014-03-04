module.exports = class Write
	constructor: (@app, @db)->
		@app.get '/article/:slug', @get
		@app.get '/article/', (req, res)->
			res.redirect '/'
	get: (req,res) =>
		slug = req.params.slug
		@getArticle slug, (err, post)=>
			if post?
				res.render 'article.jade', post
			else
				res.redirect '/'
	getArticle:(slug, fn)->
		@db.getArticle slug, fn
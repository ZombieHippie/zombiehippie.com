module.exports = class Write
	constructor: (@app, @db)->
		@app.get '/article/:slug', @get
		@app.get '/article/', (req, res)->
			res.redirect '/'
	get: (req,res) =>
		slug = req.params.slug
		@getPost slug, (err, post)=>
			console.log post
			title = "Richness"
			author = "Cole Lawrence"
			contents = "<h2 id='Richness'>Richness</h2><p>Richness in youth and spirit</p><br><h2 id='Which-is'>Which is</h2>"
			tableOfContents = ["Richness","Which is"]
			date = new Date()
			if post?
				res.render 'article.jade', {
						title: post.title
						tableOfContents: post.tableOfContents
						contents: post.content
						author: post.user
						date: post.date
						user: req.session.user}
			else
				res.redirect '/'
	getPost:(slug, fn)->
		@db.Post.findOne {slug}, "date user title content", (err, post) ->
			return fn(err) if err

			fn(null, post)
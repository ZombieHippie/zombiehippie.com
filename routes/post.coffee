module.exports = class Write
	constructor: (@app, @db)->
		@app.get '/post/:slug', @get
	get: (req,res) =>
		title = "Richness"
		author = "Cole Lawrence"
		contents = "<h2 id='Richness'>Richness</h2><p>Richness in youth and spirit</p><br><h2 id='Which-is'>Which is</h2>"
		tableOfContents = ["Richness","Which is"]
		date = new Date()
		res.render 'post.jade', {
				title
				tableOfContents
				contents
				author
				date
				user: req.session.user}
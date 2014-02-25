fs = require 'fs'

sortedSlugs = (articles, property) ->
	props = []
	propToSlug = {}
	for slug, article of articles
		prop = article[property]
		props.push prop
		propToSlug[prop.toString()] = article.slug
	do props.sort
	slugs = []
	slugs.push(propToSlug[prop.toString()]) for prop in props
	return slugs

module.exports = class jsondb
	constructor:(@dbpath)->
		alreadyMade = fs.existsSync @dbpath
		if not alreadyMade
			@db = {articles:{},users:{}}
			do @writeDB
		else
			@db = JSON.parse(fs.readFileSync @dbpath)
		do @sortArticles
		console.log @slugsByDate
	writeArticle:(article, fn) =>
		@db.articles[article.slug] = article
		do @sortArticles
		do @writeDB
		fn null, article
	sortArticles: ->
		@slugsByDate = sortedSlugs @db.articles, "date"
		@slugsByTitle = sortedSlugs @db.articles, "title"
	getArticle: (slug, fn)->
		if article = @db.articles[slug]
			fn null, article
		else
			fn "Article with slug:#{slug} does not exist!"
	getArticlesBy: (prop, count, fn) =>
		if not fn?
			fn = count
			count = no
		articles = []
		slugs = undefined
		switch prop
			when "date"
				slugs = @slugsByDate
			when "title"
				slugs = @slugsByTitle
			else
				fn "Unrecognized sorting property:#{prop}"
		if count
			slugs = slugs[...count]
		for slug in slugs
			articles.push @db.articles[slug]
		console.log articles
		fn null, articles
	getUser: (name, fn) =>
		user = @db.users[name]
		if user?
			fn null, user
		else
			fn "User:#{name} does not exist!"
	writeUser: (name, salt, hash, fn) =>
		if @db.users[name]?
			fn "User:#{name} already exists!"
		else
			fn null, @db.users[name] = {name, salt, hash}
		do @writeDB
	writeDB: =>
		fs.writeFileSync @dbpath, JSON.stringify(@db, null, 4)
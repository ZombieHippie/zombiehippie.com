fs = require "fs"
p = require "path"
nib = require "nib"
stylus = require "stylus"
coffee = require "coffee-script"
uglify = require "uglify-js"
quick = require "quick-compile"

try fs.mkdirSync dir = __dirname+"/../static"
try fs.mkdirSync dir + "/css"
try fs.mkdirSync dir + "/js"
cssFiles = (p.join("node_modules/codemirror/",fl) for fl in [
    "lib/codemirror.css", "theme/xq-light.css", "addon/hint/show-hint.css"
  ])[...]
cssFiles.push "vendor/css"
vendorsJSArr = (p.join("node_modules/codemirror/",fl) for fl in [
    "lib/codemirror.js",
    "addon/selection/active-line.js", "addon/selection/mark-selection.js",
    "mode/xml/xml.js", "mode/htmlmixed/htmlmixed.js",
    "mode/css/css.js", "mode/javascript/javascript.js",
  ])[...]
vendorsJSArr.push "node_modules/showdown/compressed/showdown.js"
vendorsJSArr.push "vendor/js/zepto.js"
editorVendorsJSArr = (p.join("node_modules/codemirror/",fl) for fl in [
    "addon/edit/continuelist.js", "addon/fold/markdown-fold.js",
    "addon/hint/show-hint.js",
    "mode/markdown/markdown.js",
  ])[...]

uglyCompiler = (src) ->
  return uglify.minify(src, { fromString: true }).code
cssCompiler = (src) ->
  return src.replace(/\/[\n\s]*\*[\s\S]*?\*\/[\n\s]*/g, "")
    .replace /([\n\:\{\}\;,]|[\w\d\*]\s)([\s\n\}\{]+)/g, (match, prec, suff) ->
      return prec + suff.replace /[\s\n]+/g, ""
stylusCompiler = (min)-> (src)->
  out = stylus(src).use(nib()).render()
  return if min then cssCompiler(out) else out
coffeeCompiler = (min)-> (src) ->
  out = coffee.compile src
  return if min then uglyCompiler(out) else out

vendgen = srcgen = undefined
exports.init = (min = false) ->
  jsCompiler = if min then uglyCompiler else false
  vendgen = new quick({
      files: {
        "static/js/vendors.js":
          files: vendorsJSArr
          compiler: jsCompiler
        "static/js/editor-vendors.js":
          files: editorVendorsJSArr
          compiler: jsCompiler
        "static/css/vendors.css":
          files: cssFiles
          compiler: if min then cssCompiler else false
          separator: "\n"
      }
      cacheFile: "genvend.cache.json"
    })
  srcgen = new quick({
      files: {
        "static/js/script.js":
          files: "src/coffee/script.coffee"
          compiler: coffeeCompiler(min)
        "static/css/style.css":
          files: "src/stylus/style.styl"
          compiler: stylusCompiler(min)
        "static/js/editor-script.js":
          files: "src/js/editor.js"
          compiler: jsCompiler
        "static/js/article-script.js":
          files: "src/js/article.js"
          compiler: jsCompiler
      }
      cacheFile: "gensrc.cache.json"
    })
ensure = (min = false) ->
  if not vendgen?
    exports.init(min)
exports.gen = (min) ->
  ensure(min)
  srcgen.generate()
  vendgen.generate()
exports.buildVendors = (min) ->
  ensure(min)
  vendgen.generate()
exports.buildSrc = (min) ->
  ensure(min)
  srcgen.generate()
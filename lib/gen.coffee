fs = require "fs"
p = require "path"
coffee = require "coffee-script"
stylus = require "stylus"
quick = require "quick-compile"
nib = require "nib"
uglify = require "uglify-js"


try fs.mkdirSync dir = __dirname+"/../static"
try fs.mkdirSync dir + "/css"
try fs.mkdirSync dir + "/js"


uglyCompiler = (src) ->
  return uglify.minify(src, { fromString: true }).code
cssCompiler = (src) ->
  return src.replace(/\/[\n\s]*\*[\s\S]*?\*\/[\n\s]*/g, "")
    .replace /([\n\:\{\}\;,]|[\w\d\*]\s)([\s\n\}\{]+)/g, (match, prec, suff) ->
      return prec + suff.replace /[\s\n]+/g, ""
stylusCompiler = (min) -> (src)->
  out = stylus(src).use(nib()).render()
  return if min then cssCompiler(out) else out
coffeeCompiler = (min) -> (src) ->
  out = coffee.compile src
  return if min then uglyCompiler(out) else out

exports.buildVendors = (min) ->
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
  new quick({
      files: {
        "static/js/vendors.js": {
          files: vendorsJSArr
        },
        "static/js/editor-vendors.js": {
          files: editorVendorsJSArr
        },
        "static/js/editor-script.js": {
          files: "src/js/editor.js"
        },
        "static/js/article-script.js": {
          files: "src/js/article.js"
        },
        "static/css/vendors.css": {
          files: cssFiles,
          compiler: if min then cssCompiler else false,
          separator: "\n"
        }
      },
      compiler: if min then uglyCompiler else false,
      separator: ";\n"
    }).generate()
exports.buildSrc = (min = true)->
  exports.buildSrcCoffee(min)
  exports.buildSrcStylus(min)
exports.gen = (min = true) ->
  exports.buildSrc(min)
  exports.buildVendors(min)
  console.log "Generated src and vendors"
exports.buildSrcCoffee = (min) ->
  new quick({
      compiler: coffeeCompiler(min),
      files: {
        "static/js/script.js":"src/coffee/script.coffee"
      }
    }).generate()
exports.buildSrcStylus = (min) ->
  new quick({
      compiler: stylusCompiler(min),
      files: {
        "static/css/style.css": "src/stylus/style.styl"
      }
    }).generate()
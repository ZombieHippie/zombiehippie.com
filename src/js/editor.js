var hinter = function (arg) {
    return function (cm) {
      var doHint = false;
        cur = cm.getCursor(),
        pos = CodeMirror.Pos(cur.line, cur.ch),
        lineContents = cm.getLine(cur.line),
        before = lineContents.slice(0, cur.ch),
        after = lineContents.slice(cur.ch, lineContents.length - 1),
        length = after.match(/^[^\)\s]*/)[0].length;
      if (arg === '(' && /\!\[[^\]]*\]$/.test(before)) doHint = true;

      if (doHint) setTimeout( function(){
        cur.ch++;
        CodeMirror.showHint(cm, function (cm) {
          return {
            list: fileList,
            from: cur,
            to: {
              line: cur.line,
              ch: cur.ch + length
            }
          }
        })
      }, 100);
      return CodeMirror.Pass
    }
  };
window.editor = CodeMirror.fromTextArea($("textarea[name=md-content]")[0], {
    styleSelectedText: true,
    showCursorWhenSelecting: true,
    styleActiveLine: true,
    theme: "xq-light",
    indentWithTabs: true,
    indentUnit: 4,
    lineWrapping: true,
    lineNumbers: true,
    // keyMap: "sublime",
    mode: "markdown",
    extraKeys: {
      "'('" : hinter('(')
    }
  });

var premarker = function (val) {
    return val.replace(/!\[([\s\S]*?)\]\(([\S]+?)\s?("[^"]*")?\)/
      , function (match, alt, src, title) {
        src = "/files/#{article.slug}/" + src
        return  "<p>\n" +
              "<img alt=\"" + alt + "\" src=\"" + src + "\" title=" + title + "></img>\n" +
            "</p>\n"
      });
  },
  converter = new Showdown.converter(),
  slug = $("[name=slug]")[0].value,
  fileList = [],
  makePreview = function() {
    var html = converter.makeHtml(premarker(editor.getValue()));
    $('#preview-md').html(html);
    $("#preview-style").html($("textarea[name=article_styles]").val());
  };
$(".file-list li").each(function (){
  fileList.push(this.innerHTML);
});
editor.on("change", makePreview);
$("textarea[name=article_styles]").on("input", makePreview);
$(".toggle-editor").on("click", function() {
  $(".markdown-editor .CodeMirror").toggleClass("hidden-editor");
  $(".unique-code").toggleClass("hidden-editor");
});
$(".upload-file").on("click", function() {
  $("#upload").click();
})
$("#upload").on("change", function(event) {
  var fd = new FormData(),
    file = this.files[0],
    xhr = new XMLHttpRequest();
  fd.append("file", file);
  xhr.open("POST", "/upload?" + $.param({
    slug : slug,
    filename : file.name
  }));
  xhr.send(fd);
  fileList.push(file.name);
  $(".file-list").append("<li>" + file.name + "</li>");
});
makePreview();
window.editor.focus()
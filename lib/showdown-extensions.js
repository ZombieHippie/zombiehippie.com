//  CodeMirror

(function(){
  // define globally
  CodeMirror = require('codemirror/addon/runmode/runmode.node.js');
  require('codemirror/mode/javascript/javascript.js');
  var
    cm = function(converter) {
      return [
        { // runner
          type    : 'output',
//          regex   : '```(javascript|coffeescript|css|stylus)([\s\S]+?)```',
          filter : function(text) {
            var code_Match,
              code_RE = /(<pre>)?<code[\s\S]+?(class="([^"]+?)")?[^>]*?>([\s\S]+?)<\/code>(<\/pre>)?/g,
              code_RE2 = /^(<pre>)?<code[\s\S]+?(class="([^"]+?)")?[^>]*?>([\s\S]+?)<\/code>(<\/pre>)?$/;
            while(code_Match = text.match(code_RE)) {
              code_Match = code_Match[0].match(code_RE2);
              console.log(code_Match);
              console.log(code_Match[3]);
              var curStyle = null;
              text.replace(code_Match[0], CodeMirror.runMode(code_Match[4], code_Match[3]), function (words, style) {
                if (style != curStyle) {
                  flush();
                  curStyle = style; accum = words;
                } else {
                  accum += words;
                }
              });
            };
            return text;
            //   "<textarea class=\"CodeMirror-run $3\">$4</textarea>"
            // );
            // console.log(match[0]);
            // return lang + content + "Hello";
            //return '<textarea class="CodeMirror-run" data-lang="' + lang + '">' + content + '</textarea>';
          }
        }
      ];
    };

  // Client-side export
  if (typeof window !== 'undefined' && window.Showdown && window.Showdown.extensions) { window.Showdown.extensions.cm = cm; }
  // Server-side export
  if (typeof module !== 'undefined') module.exports = cm;
}());

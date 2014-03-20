//  CodeMirror

(function(){

    var cm = function(converter) {
        return [
            { // runner
              type    : 'lang',
              regex   : '```(javascript|coffeescript|css|stylus)([\s\S]+?)```',
              replace : function(match, lang, content) {
                  return '<textarea class="CodeMirror-run" data-lang="' + lang + '">' + content + '</textarea>';
              }
            }
        ];
    };

    // Client-side export
    if (typeof window !== 'undefined' && window.Showdown && window.Showdown.extensions) { window.Showdown.extensions.codemirror = codemirror; }
    // Server-side export
    if (typeof module !== 'undefined') module.exports = cm;
}());

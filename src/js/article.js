(function(){
	$("code.live").each(function(){
		var mode;
		var selector = (this.className.match(/\#[\w\d\-\_]+$/) || [false])[0]
		if (!selector) return;
		else selector = "#live-" + selector.slice(1);
		var liveCode = $(selector);
		if (/^css\s/.test(this.className))
			mode = "css";
		else if (/^html\s/.test(this.className))
			mode = "html";
		else if (/^script\s/.test(this.className))
			mode = "javascript";
		else return console.log("Unknown live type");
		liveCode.addClass(mode)
		var code = this.innerText;
		switch (mode) {
		case "css":
			liveCode.append("<style>" + code + "</style>");
			break;
		case "html":
			liveCode.append("<div>" + code + "</div>");
			break;
		case "javascript":
			liveCode.append("<script>" + code + "<\/script>");
			break;
		default:
			break;
		}
		this.innerText = ""
		CodeMirror(this.parentNode, {
			mode: "text/" + mode,
			value: code.replace(/[\s\n]*$/, ""),
			lineWrapping: true
		})
		.on("change", function(cm) {
			var code = cm.getValue();
			switch (mode) {
			case "css":
				liveCode.children("style").html(code);
				break;
			case "html":
				liveCode.children("div").html(code);
				var script = liveCode.children("script").html();
				liveCode.append("<script>" + script + "<\/script>");
				break;
			case "javascript":
				liveCode.children("script").remove();
				liveCode.append("<script>" + code + "<\/script>");
				break;
			default:
				break;
			}
		});
	});
}())
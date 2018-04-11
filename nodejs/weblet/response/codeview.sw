#>>==>>|nodejs|weblet.response.codeview|/nodejs/weblet/response/codeview.sw
(package "weblet.response.codeview" "protocol.mime" (lambda (NS MIME)
	htmlDocString:"<!DOCTYPE HTML>\n<html style=\"width:100%;height:100%;\">\n<head>\n<meta http-equiv=\"Content-Type\" content=\"text\/html; charset=UTF-8\" \/>\n<meta name=\"viewport\" content=\"width=device-width, height=device-height,initial-scale=1, maximum-scale=1, minimum-scale=1, user-scalable=no\">\n<style>\n<style type=\"text\/css\" media=\"screen\">\nbody {\noverflow:hidden;\n}\n#editor {\nmargin:0;\nposition:absolute;\ntop:0;\nbottom:0;\nleft:0;\nright:0;\n}\n<\/style>\n<script src=\"http:\/\/ajaxorg.github.io\/ace-builds\/src-noconflict\/ace.js\" type=\"text\/javascript\" charset=\"utf-8\"><\/script>\n<script type=\"text\/javascript\">\nvar e1;\nvar init=function(){\n\t\n\tvar uri=location.pathname+\"?-src\";\n\tvar xml_http;\n\tvar synchronous=true;\n\txml_http=new XMLHttpRequest;\n\txml_http.open(\"GET\",uri,!synchronous);\n\txml_http.send();\n\teditor.innerText=xml_http.responseText;\n\te1=ace.edit(\"editor\");\n\te1.setTheme(\"ace\/theme\/twilight\");\n\te1.getSession().setMode(\"ace\/mode\/javascript\");\n\te1.setOption(\"wrap\",\"free\");\n\t\/\/ e1.setOption(\"readOnly\",true);\n\te1.setFontSize(18);\n};\n<\/script>\n<\/head>\n<body onload=\"init();\">\n<pre id=\"editor\"><\/pre>\n<\/body>\n<\/html>"
	(. NS "Send" (lambda (request response)
			mime_type:((. MIME "GetType") "html")
			((. response "setHeader") "Content-Type" mime_type)
			(if (!= "HEAD" (. request "method"))
				((. response "write") htmlDocString)
				)
			((. response "end"))
			))
	))

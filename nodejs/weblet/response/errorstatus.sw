#>>==>>|nodejs|weblet.response.errorstatus|/nodejs/weblet/response/errorstatus.sw
(package "weblet.response.errorstatus" "protocol.http.status" (lambda (NS HTTPStatus)
	(. NS "Send" (lambda (response statusCode errorMessage)
			(if (! errorMessage)
				errorMessage:""
				)
			(. response "statusCode" statusCode)
			((. response "write") (+ "<html><body><h3>" statusCode " " ((. HTTPStatus "GetDescription") statusCode) "<\/h3><br><div>" errorMessage "<\/div><\/body><\/html>"))
			((. response "end"))
			))
	))

#>>==>>|nodejs|cgi.response.errorstatus|/nodejs/cgi/response/errorstatus.sw
(package "cgi.response.errorstatus" "protocol.http.status" (lambda (NS HTTPStatus)
	(. NS "Send" (lambda (Out statusCode errorMessage)
			(if (! errorMessage)
				errorMessage:""
				)
			(Out (+ "Status: " statusCode " \r\n\r\n"))
			(Out (+ "<html><body><h3>" statusCode " " ((. HTTPStatus "GetDescription") statusCode) "<\/h3><br><div>" errorMessage "<\/div><\/body><\/html>"))
			))
	))

#>>==>>|prime|protocol.http.uri.util|/prime/protocol/http/uri/util.sw
(package "protocol.http.uri.util" "protocol.http.uri" "protocol.http.uri.query" (lambda (NS HttpURI HTTPQuery)
	(. NS "GetURIParameters" (lambda (uri uri_encoding)
			uriObj:(? (== (typeof uri) "string") ((. HttpURI "Translate") uri) uri)
			(? (. uriObj "query") ((. HTTPQuery "Parse") (. uriObj "query") uri_encoding) {
					})
			))
	))

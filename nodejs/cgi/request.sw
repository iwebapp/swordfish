#>>==>>|nodejs|cgi.request|/nodejs/cgi/request.sw
(package "cgi.request" "protocol.http.uri.query" "protocol.http.body" "protocol.http.uri.util" "cgi.request.body" "io.print" "script.string" "protocol.http.header" (lambda (NS HTTPQuery HttpBody HttpUtil CGIBody Out SS HTTPHeader)
	process:(JSEval "process")
	env:(. process "env")
	require:(JSEval "require")
	GetUriParameters=(lambda (uri_encoding)
		uri:(. env "REQUEST_URI")
		((. HttpUtil "GetURIParameters") uri uri_encoding)
		)
	ReadBody:(. NS "ReadBody" (. CGIBody "Get"))
	(. NS "GetHeader" (lambda (name)
			(. env (+ "HTTP_" ((. (replace name `/-/g "_") "toUpperCase"))))
			))
	(. NS "GetHeaders" (lambda ()
			headers:{
				}
			(for env (lambda (key value)
					(cond {((. SS "StartsWith") key "HTTP_")
							_key:((. key "substr") 5)
							(. headers ((. HTTPHeader "PrettyKey") _key) value)
							}
						)
					))
			headers
			))
	(. NS "GetParameters" (lambda (uri_encoding)
			method:(. env "REQUEST_METHOD")
			body:
			params:
			contentType:(. env "CONTENT_TYPE")
			(cond {(&& (== method "POST") contentType)
					(cond {(!= ((. contentType "indexOf") "application\/x-www-form-urlencoded") -1)
							body=(ReadBody)
							((. HTTPQuery "MergeParameters") (GetUriParameters uri_encoding) ((. HTTPQuery "Parse") ((. body "toString")) uri_encoding) false uri_encoding)
							}
						{(!= ((. contentType "indexOf") "multipart\/form-data") -1)
							boundaryInfo:(match contentType `/\bboundary=(\S*)/)
							(if (! boundaryInfo)
								(throw)
								)
							boundary:(. boundaryInfo 1)
							body=(ReadBody)
							params:(GetUriParameters uri_encoding)
							bodyParams:((. HttpBody "ParseMultiPart") body boundary)
							params=((. HttpBody "MergeMultiPartParameters") params bodyParams)
							(return params)
							}
						{default
							(return (GetUriParameters uri_encoding))
							}
						)
					}
				{(|| (== method "GET") (== method "POST") (== method "PUT"))
					(return (GetUriParameters uri_encoding))
					}
				{default
					(throw)
					}
				)
			))
	))

#>>==>>|nodejs|cgi.env|/nodejs/cgi/env.sw
(package "cgi.env" "protocol.http.uri" "script.object" (lambda (NS HttpURI SObject)
	require:(JSEval "require")
	path:(require "path")
	process:(JSEval "process")
	(. NS "BuildEnv" (lambda (request uriObj document_path local_file_name server additionalPath)
			env:{
				}
			(cond {(! uriObj)
					uri:(. request "url")
					uriObj=((. HttpURI "Translate") uri)
					}
				)
			basename:((. path "basename") local_file_name)
			((. SObject "Extend") env (. process "env"))
			(cond {additionalPath
					env_path:(. env "PATH")
					(cond {(! env_path)
							env_path=""
							}
						)
					isWindows:(== ((. ((. (require "os") "platform")) "indexOf") "win") 0)
					(. env "PATH" (+ additionalPath (? isWindows ";" ":") env_path))
					}
				)
			(. env "SCRIPT_FILENAME" ((. path "resolve") local_file_name))
			(. env "REMOTE_ADDR" (. (. request "connection") "remoteAddress"))
			(. env "REMOTE_PORT" (. (. request "connection") "remotePort"))
			(. env "DOCUMENT_ROOT" document_path)
			(. env "REQUEST_URI" (. request "url"))
			(. env "REQUEST_METHOD" (. request "method"))
			(for (. request "headers") (lambda (header headerValue)
					(cond {(== header "content-length")
							(. env "CONTENT_LENGTH" headerValue)
							}
						{(== header "Content-Type")
							(. env "CONTENT_TYPE" headerValue)
							}
						{default
							(. env (+ "HTTP_" ((. ((. ((. header "toUpperCase")) "split") "-") "join") "_")) headerValue)
							}
						)
					))
			(. env "SCRIPT_NAME" (+ (. uriObj "path") "\/" basename))
			(if (. uriObj "query")
				(. env "QUERY_STRING" (. uriObj "query"))
				)
			(. env "SERVER_PROTOCOL" "HTTP\/1.1")
			(cond {server
					localAddr:((. server "address"))
					(. env "SERVER_NAME" (. localAddr "address"))
					(. env "SERVER_PORT" (. localAddr "port"))
					}
				)
			env
			))
	))

#>>==>>|nodejs|weblet.response.localfile|/nodejs/weblet/response/localfile.sw
(package "weblet.response.localfile" "weblet.response.errorstatus" "protocol.mime" "script.string" (lambda (NS ErrorStatus MIME SString)
	require:(JSEval "require")
	path:(require "path")
	D:(. path "sep")
	fs:(require "fs")
	Date:(JSEval "Date")
	parseInt:(JSEval "parseInt")
	sendErrorStatus:(. ErrorStatus "Send")
	can_keep_alive:(lambda (request)
		(|| (&& (== "1.1" (. request "httpVersion")) (== (. (. request "headers") "connection") "keep-alive")) (== (. (. request "headers") "proxy-connection") "keep-alive"))
		)
	(. NS "Send" (lambda (request response local_file_name mime_type)
			originHeader:(. (. request "headers") "origin")
			(if originHeader
				((. response "setHeader") "Access-Control-Allow-Origin" "*")
				)
			keep_alive:(can_keep_alive request)
			(if keep_alive
				((. response "setHeader") "Connection" "Keep-Alive")
				)
			((. fs "open") local_file_name "r" null (JSCallback (lambda (err fp)
						(if (! fp)
							(return (sendErrorStatus response 403))
							)
						endRequest:(lambda ()
							((. fs "close") fp)
							((. response "end"))
							)
						file_handle:fp
						((. fs "fstat") file_handle (JSCallback (lambda (err stats)
									(if ((. stats "isFile"))
										(do response_file_size=(. stats "size")
											gm_date:((. (. stats "mtime") "getTime"))
											If_Modified_Since:(. (. request "headers") "if-modified-since")
											Not_Modified:false
											(if If_Modified_Since
												(if (== ((. Date "parse") If_Modified_Since) gm_date)
													Not_Modified=true
													)
												)
											from_idx:0
											range:(. (. request "headers") "range")
											(if (&& range (> (. range "length") 7) ((. SString "StartsWith") range "bytes="))
												(do (. response "statusCode" 206)
													from_idx=(parseInt ((. range "substr") 6))
													response_file_size=(- response_file_size from_idx)
													(if (< response_file_size 0)
														(return (endRequest))
														)
													((. response "setHeader") "Content-Range" (+ "bytes " from_idx "-" (- (. stats "size") 1) "\/" (. stats "size")))
													)
												(do (. response "statusCode" (? Not_Modified 304 200))
													(if Not_Modified
														(do (if keep_alive
																((. response "setHeader") "Connection" "Keep-Alive")
																)
															(return (endRequest))
															)
														)
													)
												)
											((. response "setHeader") "Content-Length" response_file_size)
											((. response "setHeader") "Last-Modified" ((. (. stats "mtime") "toGMTString")))
											((. response "setHeader") "Accept-Ranges" "bytes")
											mime_type=(cond {(== (typeof mime_type) "string")
													mime_type
													}
												{default
													extname:((. path "extname") local_file_name)
													(cond {(== mime_type null)
															((. MIME "GetType") extname)
															}
														{default
															mime_type=(. mime_type extname)
															(if mime_type
																mime_type
																((. MIME "GetType") extname)
																)
															}
														)
													}
												)
											((. response "setHeader") "Content-Type" mime_type)
											(if (== "HEAD" (. request "method"))
												(return (endRequest))
												)
											fileReader:((. fs "createReadStream") null {"fd":fp
													"start":from_idx
													})
											((. fileReader "pipe") response)
											)
										(do ((. fs "close") fp)
											(return (sendErrorStatus response 403))
											)
										)
									)))
						)))
			))
	))

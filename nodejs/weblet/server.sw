#>>==>>|nodejs|weblet.server|/nodejs/weblet/server.sw
(package "weblet.server" "protocol.http.uri" "protocol.mime" "script.object" "weblet.response.errorstatus" "protocol.uri" "io.buffer.readline" "protocol.http.header" "protocol.http.uri.util" "script.schedule" "script.schedule.callback" "weblet.response.localfile" "weblet.response.codeview" "protocol.http.uri.decode" "io.print.error" "cgi.env" (lambda (NS HttpURI MIME SObject ErrorStatus URI BufferReadLine HTTPHeader HttpUtil Schedule ScheduleCallback ResponseLocalfile ResponseCodeview UriDecode PrintError CGIEnv)
	require:(JSEval "require")
	path:(require "path")
	D:(. path "sep")
	cp:(require "child_process")
	spawn:(. cp "spawn")
	fs:(require "fs")
	os:(require "os")
	isWindows:(== ((. ((. os "platform")) "indexOf") "win") 0)
	sendFileResponse:
	process:(JSEval "process")
	then:(. Schedule "Then")
	Suspended:(. Schedule "Suspended")
	Press:(. Schedule "Press")
	Get:(. Schedule "Get")
	Set:(. Schedule "Set")
	BuildEnv:(. CGIEnv "BuildEnv")
	sendErrorStatus:(. ErrorStatus "Send")
	sendFileResponse:(. ResponseLocalfile "Send")
	cache:{
		}
	processHttpRequest_list:(lambda (request response local_file_name isCGIFile local_folder_name canShowCGISource cgiSetting)
		method:(. request "method")
		(if (!= method "GET")
			(sendErrorStatus response 404)
			)
		((. fs "exists") local_folder_name (JSCallback (lambda (exists)
					(if (! exists)
						(sendErrorStatus response 404)
						((. fs "readdir") local_folder_name (JSCallback (lambda (err files)
									(if err
										(return (sendErrorStatus response 500))
										)
									mime_type:((. MIME "GetType") "html")
									((. response "setHeader") "Content-Type" mime_type)
									i:0
									(while (< i (. files "length"))
										fileName:(. files i)
										i=(+ i 1)
										local_file_name:(+ local_folder_name D fileName)
										stats:(try ((. fs "statSync") local_file_name)
											(lambda ()
												false
												)
											)
										(if (! stats)
											(continue)
											)
										((. response "write") "<div style=\"padding:2px;\">")
										((. response "write") (+ "<a href=\"" fileName))
										(if ((. stats "isDirectory"))
											((. response "write") "\/")
											)
										((. response "write") (+ "\"\/>" fileName))
										(if ((. stats "isDirectory"))
											((. response "write") "\/")
											)
										((. response "write") "<\/a>")
										(if ((. stats "isFile"))
											(if canShowCGISource
												(do lUri:((. URI "Translate") fileName D)
													extend:(. lUri "extend")
													(if (in extend cgiSetting)
														((. response "write") (+ "&nbsp;&nbsp;<a href=\"" fileName "?-view\">[source]<\/a>"))
														)
													)
												)
											)
										((. response "write") "<\/div>")
										)
									((. response "end"))
									)))
						)
					)))
		)
	HeadersSent:"hs"
	cgiOnData:(lambda (response data)
		schedule:this
		get:(. schedule Get)
		headersSent:(get HeadersSent)
		(if headersSent
			((. response "write") data)
			(do readLine:((. BufferReadLine "Get") data)
				line:
				deleteLF:true
				(while (!= line=(readLine deleteLF) null)
					(cond {(== line "")
							(if (! ((. response "getHeader") "content-length"))
								((. response "setHeader") "Transfer-Encoding" "chunked")
								)
							((. schedule Set) HeadersSent true)
							((. response "write") ((. readLine (. BufferReadLine "GetRemain"))))
							(break)
							}
						{default
							kvPair:((. HTTPHeader "ParseKeyValuePair") line)
							(cond {(=== kvPair line)
									(. response "statusCode" 500)
									((. schedule Set) HeadersSent true)
									((. response "write") line)
									((. response "write") "\r\n")
									((. response "write") ((. readLine (. BufferReadLine "GetRemain"))))
									(break)
									}
								{default
									key:(. kvPair 0)
									value:(. kvPair 1)
									(if (|| (== key "Status") (== key "status"))
										(. response "statusCode" ((JSEval "parseInt") value))
										((. response "setHeader") key value)
										)
									}
								)
							}
						)
					)
				)
			)
		)
	cgiOnError:(lambda (response data)
		(PrintError data)
		)
	processHttpRequest:(lambda (request response local_file_name isCGIFile uriObj document_path canShowCGISource cgiSetting server additionalPath mimeConfig)
		method:(. request "method")
		schedule:this
		(if (&& (! isCGIFile) (|| (== method "GET") (== method "HEAD")))
			(do ((. schedule then) sendFileResponse request response local_file_name mimeConfig)
				(return)
				)
			)
		(cond {canShowCGISource
				parameters:((. HttpUtil "GetURIParameters") uriObj "UTF-8")
				(cond {(!= (. parameters "-src") null)
						((. schedule then) sendFileResponse request response local_file_name ((. MIME "GetType") "txt"))
						(return)
						}
					{(!= (. parameters "-view") null)
						((. schedule then) (. ResponseCodeview "Send") request response)
						(return)
						}
					)
				}
			)
		cwd:((. path "dirname") local_file_name)
		env:(BuildEnv request uriObj document_path local_file_name server additionalPath)
		options:{"env":env
			}
		(. options "cwd" cwd)
		bin:
		cgi:
		lUri=((. URI "Translate") local_file_name D)
		extend:
		cgiexepath:undefined
		exception:false
		exceptionFun:(lambda (e)
			exception=true
			(sendErrorStatus response 500 "start sub process error.")
			)
		(cond {(!= (. cgiSetting extend:(. lUri "extend")) null)
				bin=(. cgiSetting extend)
				blankIdx:((. bin "indexOf") " ")
				cgiParams:[local_file_name]
				(cond {(> blankIdx 0)
						((. cgiParams "unshift") ((. bin "substr") (+ 1 blankIdx)))
						bin=((. bin "substring") 0 blankIdx)
						}
					)
				(cond {(! ((. path "isAbsolute") bin))
						(cond {isWindows
								binPaths:((. ((. ((. cp "execSync") (+ "where " bin)) "toString")) "split") `/[\r\n]+/)
								bin:(each binPaths (lambda (binPath)
										(if (match binPath `/\.(?:exe|cmd)$/)
											(break binPath)
											)
										))
								(if (! bin)
									(exceptionFun)
									)
								}
							{default
								}
							)
						}
					)
				(if (! exception)
					(try cgi=(spawn bin cgiParams options)
						exceptionFun
						)
					)
				}
			{default
				bin=local_file_name
				(try cgi=(spawn bin options)
					exceptionFun
					)
				}
			)
		(if exception
			(return)
			)
		((. request "pipe") (. cgi "stdin"))
		((. (. cgi "stdout") "on") "end" (JSCallback (lambda ()
					((. response "end"))
					)))
		((. schedule Set) HeadersSent false)
		onData:(bind cgiOnData schedule response)
		((. (. cgi "stdout") "on") "data" (JSCallback (lambda (data)
					(onData data)
					)))
		onError:(bind cgiOnError schedule response)
		((. (. cgi "stderr") "on") "data" (JSCallback (lambda (data)
					(onError data)
					)))
		)
	onRequest:(lambda (document_path cgiSetting canListFiles canShowCGISource server additionalPath mimeConfig request response)
		uri:(. request "url")
		uriObj:((. HttpURI "Translate") uri)
		is_index_page:(! (. uriObj "fileName"))
		_local_file_name:
		decodedPath=(UriDecode (. uriObj "path"))
		_local_path:(+ document_path ((. decodedPath "replace") `/\//g D))
		isCGIFile=(? cgiSetting (in (. uriObj "extend") cgiSetting) false)
		newSchedule:((. Schedule "Create"))
		checkExists:(lambda (exists)
			(if (! exists)
				(sendErrorStatus response 404)
				((. this then) [[processHttpRequest request response _local_file_name isCGIFile uriObj document_path canShowCGISource cgiSetting server additionalPath mimeConfig]])
				)
			)
		(if (! is_index_page)
			(do _local_file_name=(+ _local_path D (UriDecode (. uriObj "fileName")))
				((. newSchedule then) [[((. ScheduleCallback "FinallySet") fs "exists") _local_file_name] [checkExists]])
				)
			(do _local_file_name=(+ _local_path D "index.html")
				((. newSchedule then) [[((. ScheduleCallback "FinallySet") fs "exists") _local_file_name] [(lambda (exists)
								schedule:this
								(if exists
									((. schedule then) processHttpRequest request response _local_file_name false uriObj document_path canShowCGISource cgiSetting server additionalPath mimeConfig)
									(if canListFiles
										((. schedule then) processHttpRequest_list request response false isCGIFile _local_path canShowCGISource cgiSetting server additionalPath mimeConfig)
										((. schedule then) processHttpRequest request response false isCGIFile uriObj document_path canShowCGISource cgiSetting server additionalPath mimeConfig)
										)
									)
								(list)
								)]])
				)
			)
		)
	(. NS "Create" (lambda (PORT document_path cgiSetting canListFiles canShowCGISource httpsCertificatePath httpsPrivatekeyPath localAddress additionalPath mimeConfig)
			server:undefined
			(if httpsCertificatePath
				(do useHTTPSOptions:{"cert":((. fs "readFileSync") httpsCertificatePath)
						"key":((. fs "readFileSync") httpsPrivatekeyPath)
						}
					server=((. (require "https") "createServer") useHTTPSOptions)
					)
				server=((. (require "http") "createServer"))
				)
			schedule:((. Schedule "Create"))
			((. schedule then) [[((. ScheduleCallback "FinallySet") server "on" true true) "request"] [onRequest document_path cgiSetting canListFiles canShowCGISource server additionalPath mimeConfig]])
			((. server "listen") PORT localAddress)
			server
			))
	))

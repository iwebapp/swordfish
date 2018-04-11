#>>==>>|nodejs|cgi.request.body|/nodejs/cgi/request/body.sw
(package "cgi.request.body" (lambda (NS)
	require:(JSEval "require")
	fs:(require "fs")
	process:(JSEval "process")
	env:(. process "env")
	parseInt:(JSEval "parseInt")
	Buffer:(JSEval "Buffer")
	cachedRequestBody:null
	(. NS "Get" (lambda ()
			method:(. env "REQUEST_METHOD")
			contentLength:
			buffer:
			readIdx:0
			read:0
			_leftLength=2147483647
			(if (|| (== method "POST") (== method "PUT"))
				(do (if (!= cachedRequestBody null)
						(return cachedRequestBody)
						)
					contentLength=(parseInt (. env "CONTENT_LENGTH"))
					buffer=(JSNew Buffer contentLength)
					_leftLength=contentLength
					(while (> _leftLength 0)
						read=((. fs "readSync") (. (. process "stdin") "fd") buffer readIdx _leftLength)
						(if (<= read 0)
							(throw)
							)
						readIdx=(+ readIdx read)
						_leftLength=(- _leftLength read)
						)
					cachedRequestBody=buffer
					)
				null
				)
			))
	))

#>>==>>|nodejs|io.file.read|/nodejs/io/file/read.sw
(package "io.file.read" (lambda (NS)
	require:(JSEval "require")
	fs:(require "fs")
	BUFFER_SIZE:512
	Get:(lambda (filepath bufferSize)
		bufferSize=(|| bufferSize BUFFER_SIZE)
		fd:
		fpType:(typeof filepath)
		isFd:(== fpType "number")
		(cond {isFd
				fd=filepath
				}
			{(== fpType "string")
				fd=((. fs "openSync") filepath "r")
				}
			{default
				throw
				new
				Error
				()
				}
			)
		buffer:(JSNew "Buffer" bufferSize)
		cacheSize:0
		cursor:0
		readEnd:false
		fillBuffer:(lambda ()
			(if readEnd
				return
				)
			needReadNumber:(- bufferSize cacheSize)
			readNumber:((. fs "readSync") fd buffer cacheSize needReadNumber null)
			(if (< readNumber needReadNumber)
				(do readEnd=true
					(if (! isFd)
						((. fs "closeSync") fd)
						)
					)
				)
			(if (> readNumber 0)
				cacheSize=(+ cacheSize readNumber)
				)
			)
		read:(lambda ()
			(cond {(== cursor cacheSize)
					(cond {(! readEnd)
							(if (== cacheSize bufferSize)
								(do cacheSize=0
									cursor=0
									)
								)
							(fillBuffer)
							(read)
							}
						{default
							undefined
							}
						)
					}
				{(< cursor cacheSize)
					byte:((. buffer "readUInt8") cursor)
					cursor=(+ cursor 1)
					byte
					}
				{(throw)
					}
				)
			)
		read
		)
	(. NS "GetStdin" (lambda (bufferSize)
			(Get (. (. (JSEval "process") "stdin") "fd") bufferSize)
			))
	(. NS "Get" Get)
	))

#>>==>>|nodejs|io.buffer.read|/nodejs/io/buffer/read.sw
(package "io.buffer.read" (lambda (NS)
	GetRemain:(. NS "GetRemain" "gr")
	(. NS "Get" (lambda (buf)
			cursor:0
			length:(. buf "length")
			readEnd:false
			read:(lambda ()
				(cond {(== cursor length)
						undefined
						}
					{(< cursor length)
						ret:((. buf "readUInt8") cursor)
						cursor=(+ cursor 1)
						ret
						}
					{default
						(throw)
						}
					)
				)
			(. read GetRemain (lambda ()
					((. buf "slice") cursor)
					))
			read
			))
	))

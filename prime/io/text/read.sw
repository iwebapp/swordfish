#>>==>>|prime|io.text.read|/prime/io/text/read.sw
(package "io.text.read" "text.utf8" (lambda (NS BytesUTF8)
	GetFromBytes:(. NS "GetFromBytes" (lambda (bytes)
			cursor:0
			textLength:(. bytes "length")
			(lambda ()
				(cond {(== cursor textLength)
						undefined
						}
					{(< cursor textLength)
						ret:(. bytes cursor)
						cursor=(+ cursor 1)
						ret
						}
					{default
						(throw)
						}
					)
				)
			))
	(. NS "Get" (lambda (text)
			(GetFromBytes ((. BytesUTF8 "To") text))
			))
	))

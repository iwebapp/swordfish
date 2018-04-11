#>>==>>|nodejs|io.buffer.readline|/nodejs/io/buffer/readline.sw
(package "io.buffer.readline" "io.text.readline" "io.text.readchar" "io.buffer.read" (lambda (NS TextReadLine TextReadChar BufferRead)
	GetRemain:(. NS "GetRemain" (. BufferRead "GetRemain"))
	(. NS "Get" (lambda (buf)
			read:((. BufferRead "Get") buf)
			readChar:((. TextReadChar "Get") read)
			readLine:((. TextReadLine "Get") readChar)
			(. readLine GetRemain (. read GetRemain))
			readLine
			))
	))

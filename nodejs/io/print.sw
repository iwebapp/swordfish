#>>==>>|nodejs|io.print|/nodejs/io/print.sw
(package "io.print" (lambda (NS)
	FromCharCode:(JSEval "String.fromCharCode")
	Buffer:(JSEval "Buffer")
	write:(lambda (@arguments)
		stdout:(JSEval "process.stdout")
		(JSCallObject stdout "write" (catlist arguments))
		)
	Print:(lambda (write @arguments)
		data:
		i:0
		argvLen:(. arguments "length")
		(while (< i argvLen)
			data0:
			data=(. arguments i)
			dtype:(typeof data)
			(cond {(== "array" dtype)
					(cond {(&& (> (. data "length") 0) (== (typeof data0=(. data 0)) "number") (<= data0 255) (>= data0 0) (== (% data0 1) 0))
							(write (FromCharCode (catlist data)))
							}
						{default
							(write "[")
							idx:0
							d:
							dataLen:(. data "length")
							dataLastIdx:(- dataLen 1)
							(while (< idx dataLen)
								dType:
								d=(. data idx)
								(cond {(|| (== dType=(typeof d) "string") (JSInstanceof d Buffer))
										(write d)
										}
									{(== dType "array")
										(write (FromCharCode (list d)))
										}
									{default
										(throw d)
										}
									)
								(if (< idx dataLastIdx)
									(write ",")
									)
								idx=(+ idx 1)
								)
							(write "]")
							}
						)
					}
				{(|| (== dtype "string") (JSInstanceof data Buffer))
					(write data)
					}
				{default
					(write (+ "" data))
					}
				)
			i=(+ i 1)
			)
		)
	(. NS "$" (lambda (@arguments)
			(Print write (catlist arguments))
			))
	(. NS "Print" Print)
	))

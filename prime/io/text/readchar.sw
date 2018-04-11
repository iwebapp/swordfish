#>>==>>|prime|io.text.readchar|/prime/io/text/readchar.sw
(package "io.text.readchar" (lambda (NS)
	FromCharCode:(JSEval "String.fromCharCode")
	(. NS "Get" (lambda (read)
			(lambda ()
				b1:(read)
				b2:
				b3:undefined
				(cond {(== b1 null)
						undefined
						}
					{(< b1 128)
						(FromCharCode b1)
						}
					{(&& (>= b1 192) (< b1 224))
						b2=(read)
						(FromCharCode (| (<< (& b1 31) 6) (& b2 63)))
						}
					{default
						b2=(read)
						b3=(read)
						(FromCharCode (| (<< (& b1 15) 12) (<< (& b2 63) 6) (& b3 63)))
						}
					)
				)
			))
	))

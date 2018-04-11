#>>==>>|prime|text.utf8|/prime/text/utf8.sw
(package "text.utf8" (lambda (NS)
	FromCharCode:(JSEval "String.fromCharCode")
	(. NS "Get" (lambda (bytes)
			b1:
			b2:
			b3:
			ss:[]
			i:0
			len:(. bytes "length")
			(while (< i len)
				b1=(. bytes i)
				(cond {(< b1 128)
						((. ss "push") (FromCharCode b1))
						i=(+ i 1)
						}
					{(&& (>= b1 192) (< b1 224))
						b2=(. bytes (+ i 1))
						((. ss "push") (FromCharCode (| (<< (& b1 31) 6) (& b2 63))))
						i=(+ i 2)
						}
					{default
						b2=(. bytes (+ i 1))
						b3=(. bytes (+ i 2))
						((. ss "push") (FromCharCode (| (<< (& b1 15) 12) (<< (& b2 63) 6) (& b3 63))))
						i=(+ i 3)
						}
					)
				)
			((. ss "join") "")
			))
	(. NS "To" (lambda (s)
			n:0
			c:
			utf8:[]
			len:(. s "length")
			pushInUtf8:(bind (. utf8 "push") utf8)
			(while (< n len)
				c=((. s "charCodeAt") n)
				(cond {(<= c 127)
						(pushInUtf8 c)
						}
					{(&& (>= c 128) (<= c 2047))
						(pushInUtf8 (| (>> c 6) 192))
						(pushInUtf8 (| (& c 63) 128))
						}
					{default
						(pushInUtf8 (| (>> c 12) 224))
						(pushInUtf8 (| (& (>> c 6) 63) 128))
						(pushInUtf8 (| (& c 63) 128))
						}
					)
				n=(+ n 1)
				)
			utf8
			))
	))

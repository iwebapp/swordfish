#>>==>>|prime|protocol.http.uri.decode|/prime/protocol/http/uri/decode.sw
(package "protocol.http.uri.decode" "text.utf8" (lambda (NS UTF8)
	Buffer:(JSEval "Buffer")
	java:(JSEval "java")
	String:(JSEval "String")
	hasBuffer:(!= (typeof Buffer) "undefined")
	hasJava:(&& (!= (typeof java) "undefined") (. java "io"))
	parseInt:(JSEval "parseInt")
	INHEXCHAR:(lambda (a)
		a=((. a "charCodeAt") 0)
		(|| (&& (>= a 48) (<= a 57)) (&& (>= a 97) (<= a 102)) (&& (>= a 65) (<= a 70)))
		)
	(. NS "$" (lambda (str is_escape uri_encoding)
			ret:
			c:
			l:
			buf:
			i:0
			tem_ret:
			total_len:(. str "length")
			(cond {hasBuffer
					tem_ret=(JSNew Buffer (/ total_len 2))
					}
				{hasJava
					tem_ret=(JSNew "java.io.ByteArrayOutputStream")
					}
				{default
					tem_ret=[]
					}
				)
			tem_ret_idx:0
			(if (== str null)
				(return str)
				)
			ret=""
			clearTemRet:(lambda ()
				(cond {hasBuffer
						(if (> tem_ret_idx 0)
							(do ret=(+ ret ((. tem_ret "toString") uri_encoding 0 tem_ret_idx))
								tem_ret_idx=0
								)
							)
						}
					{hasJava
						((. tem_ret "close"))
						ret=(+ ret (JSNew String ((JSNew "java.lang.String" ((. tem_ret "toByteArray")) uri_encoding))))
						((. tem_ret "reset"))
						}
					{default
						tem_ret=[]
						}
					)
				)
			(while (< i total_len)
				c=((. str "charAt") i)
				(cond {(== c "%")
						(cond {(&& (< i (- total_len 5)) (|| (== ((. str "charAt") (+ i 1)) "u") (== ((. str "charAt") (+ i 1)) "U")) (INHEXCHAR ((. str "charAt") (+ i 2))) (INHEXCHAR ((. str "charAt") (+ i 3))) (INHEXCHAR ((. str "charAt") (+ i 4))) (INHEXCHAR ((. str "charAt") (+ i 5))))
								(clearTemRet)
								buf=((. str "substr") (+ i 2) 4)
								l=(parseInt buf 16)
								ret=(+ ret ((. String "fromCharCode") l))
								i=(+ i 5)
								}
							{(&& (< i (- total_len 2)) (INHEXCHAR ((. str "charAt") (+ i 1))) (INHEXCHAR ((. str "charAt") (+ i 2))))
								buf=((. str "substr") (+ i 1) 2)
								l=(parseInt buf 16)
								(cond {hasBuffer
										((. tem_ret "writeUInt8") l tem_ret_idx)
										tem_ret_idx=(+ tem_ret_idx 1)
										}
									{hasJava
										((. tem_ret "write") l)
										}
									{default
										((. tem_ret "push") l)
										}
									)
								i=(+ i 2)
								}
							{default
								(clearTemRet)
								ret=(+ ret c)
								}
							)
						}
					{(== c "+")
						(clearTemRet)
						(if is_escape
							ret=(+ ret c)
							ret=(+ ret " ")
							)
						}
					{default
						(clearTemRet)
						ret=(+ ret c)
						}
					)
				i=(+ i 1)
				)
			(clearTemRet)
			ret
			))
	))

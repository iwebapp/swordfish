#>>==>>|prime|protocol.mime.base64|/prime/protocol/mime/base64.sw
(package "protocol.mime.base64" (lambda (NS)
	(. NS "Create" (lambda (base64codeString endChar)
			AssignEqual:((. endChar "charCodeAt") 0)
			base64:((lambda ()
					bytes:[]
					base64code=base64codeString
					n:0
					len:(. base64code "length")
					(while (< n len)
						((. bytes "push") ((. base64code "charCodeAt") n))
						n=(+ n 1)
						)
					bytes
					))
			[(lambda (reader writer)
					b64:[]
					i:0
					cc:
					ccc:
					c:(reader)
					(while (!= c null)
						(. b64 0 (. base64 (>> c 2)))
						cc=(reader)
						(cond {(!= cc null)
								(. b64 1 (. base64 (| (<< (& c 3) 4) (>> cc 4))))
								ccc=(reader)
								(cond {(!= ccc null)
										(. b64 2 (. base64 (| (<< (& cc 15) 2) (>> ccc 6))))
										(. b64 3 (. base64 (& ccc 63)))
										(writer b64)
										c=(reader)
										}
									{default
										(. b64 2 (. base64 (<< (& cc 15) 2)))
										(. b64 3 AssignEqual)
										(writer b64)
										(break)
										}
									)
								}
							{default
								(. b64 1 (. base64 (<< (& c 3) 4)))
								(. b64 2 AssignEqual)
								(. b64 3 AssignEqual)
								(writer b64)
								(break)
								}
							)
						)
					) (lambda (reader writer)
					r0:
					r1:
					r2:
					r3:
					d0:
					d1:
					d2:
					d3:
					b:
					shortgroup:0
					(while true
						r0=(reader)
						(if (== r0 null)
							(break)
							)
						r1=(reader)
						r2=(reader)
						r3=(reader)
						(if (== r3 null)
							(throw "Truncated BASE64 text.")
							)
						d0=((. base64 "indexOf") r0)
						d1=((. base64 "indexOf") r1)
						(cond {(== r2 AssignEqual)
								d2=0
								shortgroup=(+ shortgroup 1)
								}
							{default
								d2=((. base64 "indexOf") r2)
								}
							)
						(cond {(== r3 AssignEqual)
								d3=0
								shortgroup=(+ shortgroup 1)
								}
							{default
								d3=((. base64 "indexOf") r3)
								}
							)
						b=[]
						(. b 0 (& (| (<< d0 2) (>> d1 4)) 255))
						(cond {(< shortgroup 2)
								(. b 1 (& (| (<< d1 4) (>> d2 2)) 255))
								(if (< shortgroup 1)
									(. b 2 (& (| (<< d2 6) d3) 255))
									)
								}
							)
						(writer b)
						)
					)]
			))
	defaultEngine:((. NS "Create") "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+\/" "=")
	(. NS "Encode" (. defaultEngine 0))
	(. NS "Decode" (. defaultEngine 1))
	))

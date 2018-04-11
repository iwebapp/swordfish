#>>==>>|prime|protocol.http.header|/prime/protocol/http/header.sw
(package "protocol.http.header" "script.string" (lambda (NS SString)
	ParseKeyValuePair:(. NS "ParseKeyValuePair" (lambda (headerLine)
			idx:((. headerLine "indexOf") ":")
			(if (== idx -1)
				headerLine
				(do key:((. SString "Trim") ((. headerLine "substring") 0 idx))
					value:((. SString "Trim") ((. headerLine "substr") (+ idx 1)))
					[key value]
					)
				)
			))
	(. NS "Parse" (lambda (readLine callback)
			line:undefined
			(while (!= line=(readLine) null)
				kv:(ParseKeyValuePair line)
				(if (=== kv line)
					(callback kv)
					(callback (. kv 0) (. kv 1))
					)
				)
			))
	(. NS "PrettyKey" (lambda (_key)
			len:(. _key "length")
			ret:[]
			i:0
			st:true
			(while (< i len)
				ki:(. _key i)
				(cond {st
						((. ret "push") ((. ki "toUpperCase")))
						st=false
						}
					{default
						(cond {(|| (== ki "-") (== ki "_"))
								st=true
								((. ret "push") "-")
								}
							{default
								((. ret "push") ((. ki "toLowerCase")))
								}
							)
						}
					)
				i=(+ i 1)
				)
			((. ret "join") "")
			))
	))

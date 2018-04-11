#>>==>>|prime|protocol.http.uri.query|/prime/protocol/http/uri/query.sw
(package "protocol.http.uri.query" "protocol.http.uri.decode" (lambda (NS UriDecode)
	String:(JSEval "String")
	java:(JSEval "java")
	(. NS "MergeParameters" (lambda (params newAddedParams needDecodeNewParams uri_encoding)
			addedKey:
			addedValue:
			newKey:
			pValue:undefined
			(for newAddedParams (lambda (addedKey addedValue)
					i:0
					newKey=(? needDecodeNewParams (UriDecode addedKey false uri_encoding) addedKey)
					pValue=(. params newKey)
					(cond {(== (typeof pValue) "string")
							(cond {(== (typeof addedValue) "string")
									(. params newKey [pValue (? needDecodeNewParams (UriDecode addedValue false uri_encoding) addedValue)])
									}
								{(== (typeof addedValue) "array")
									(. params newKey [])
									((. (. params newKey) "push") pValue)
									(while (< i (. addedValue "length"))
										((. (. params newKey) "push") (? needDecodeNewParams (UriDecode (. addedValue i) false uri_encoding) (. addedValue i)))
										i=(+ i 1)
										)
									}
								)
							}
						{(== (typeof pValue) "array")
							(cond {(== (typeof addedValue) "string")
									((. pValue "push") (? needDecodeNewParams (UriDecode addedValue false uri_encoding) addedValue))
									}
								{(== (typeof addedValue) "array")
									(while (< i (. addedValue "length"))
										((. pValue "push") (? needDecodeNewParams (UriDecode (. addedValue i) false uri_encoding) (. addedValue i)))
										i=(+ i 1)
										)
									}
								)
							}
						{default
							(cond {(== (typeof addedValue) "string")
									(. params newKey (? needDecodeNewParams (UriDecode addedValue false uri_encoding) addedValue))
									}
								{(== (typeof addedValue) "array")
									(. params newKey [])
									(while (< i (. addedValue "length"))
										(. (. params newKey) i (? needDecodeNewParams (UriDecode (. addedValue i) false uri_encoding) (. addedValue i)))
										i=(+ i 1)
										)
									}
								)
							}
						)
					))
			params
			))
	(. NS "Parse" (lambda (originalQueryString uri_encoding)
			(cond {(&& (!= (typeof java) "undefined") (JSInstanceof originalQueryString "java.lang.String"))
					originalQueryString=(JSNew String originalQueryString)
					}
				{(|| (== (typeof originalQueryString) "string") (JSInstanceof originalQueryString String))
					}
				{((. ((. originalQueryString "getClass")) "isArray"))
					originalQueryString=(JSNew String (JSNew "java.lang.String" originalQueryString "ISO8859-1"))
					}
				{default
					(throw)
					}
				)
			length:(. originalQueryString "length")
			idx:0
			status:0
			buf:""
			key:
			value:
			originalParams:{
				}
			params:{
				}
			i:
			pValue:
			newKey:
			newValue:
			temValueArray:
			pushKeyValue:(lambda ()
				pValue=(. originalParams key)
				(cond {(== (typeof pValue) "string")
						(. originalParams key [pValue value])
						}
					{(== (typeof pValue) "array")
						((. pValue "push") value)
						}
					{default
						(. originalParams key value)
						}
					)
				)
			(while (< idx length)
				c=((. originalQueryString "charAt") idx)
				idx=(+ idx 1)
				(cond {(== status 0)
						(cond {(== c "=")
								status=1
								key=buf
								buf=""
								}
							{default
								buf=(+ buf c)
								}
							)
						}
					{(== status 1)
						(cond {(== c "&")
								value=buf
								status=2
								buf=""
								}
							{default
								buf=(+ buf c)
								}
							)
						}
					{(== status 2)
						(cond {(== c "&")
								value=(+ value "&" buf)
								buf=""
								}
							{(== c "=")
								(pushKeyValue)
								key=buf
								status=1
								buf=""
								}
							{default
								buf=(+ buf c)
								}
							)
						}
					)
				)
			(cond {(== status 1)
					value=buf
					(pushKeyValue)
					}
				{(== status 2)
					value=(+ value buf)
					(pushKeyValue)
					}
				{(== status 0)
					value=""
					key=buf
					(pushKeyValue)
					}
				)
			((. NS "MergeParameters") params originalParams true uri_encoding)
			params
			))
	))

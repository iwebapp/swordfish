#>>==>>|nodejs|protocol.http.body|/nodejs/protocol/http/body.sw
(package "protocol.http.body" "data.bytes.search" "data.readline" "script.string" (lambda (NS BytesSearch DataReadLine SString)
	RegExp:(JSEval "RegExp")
	parseField:(lambda (bodyBuffer fromIdx params nextBoundaryBuffer)
		readLine:((. DataReadLine "Get") bodyBuffer fromIdx)
		line:
		fieldName:
		fileName:
		nextBoundaryIndex:
		fieldValueBeginIndex:
		valueBuffer:
		fieldValue:
		oldFieldValue:
		nextBoundaryBufferLength:(. nextBoundaryBuffer "length")
		(while line=((. SString "Trim") (readLine))
			(if (match line `/name=\"(.+?)\"/)
				fieldName=(. RegExp "$1")
				)
			(if (match line `/filename=\"(.+?)\"/)
				fileName=(. RegExp "$1")
				)
			)
		fieldValueBeginIndex=(. readLine "cursor")
		nextBoundaryIndex=(BytesSearch bodyBuffer nextBoundaryBuffer fieldValueBeginIndex 0 0 0)
		(if (== nextBoundaryIndex -1)
			(throw)
			)
		fieldValue=(cond {fileName
				valueBuffer=(JSNew "Buffer" (- nextBoundaryIndex fieldValueBeginIndex))
				((. bodyBuffer "copy") valueBuffer 0 fieldValueBeginIndex nextBoundaryIndex)
				valueBuffer
				}
			{default
				((. bodyBuffer "toString") "UTF-8" fieldValueBeginIndex nextBoundaryIndex)
				}
			)
		(if (!= (. params fieldName) null)
			(if (== "array" (typeof (. params fieldName)))
				((. (. params fieldName) "push") fieldValue)
				(do oldFieldValue=(. params fieldName)
					(. params fieldName [oldFieldValue fieldValue])
					)
				)
			(. params fieldName fieldValue)
			)
		(cond {(|| (>= (+ nextBoundaryIndex nextBoundaryBufferLength) (- (. bodyBuffer "length") 2)) (>= (+ nextBoundaryIndex nextBoundaryBufferLength) (- (. bodyBuffer "length") (. nextBoundaryBuffer "length") 2)) (&& (== (. bodyBuffer (+ nextBoundaryBufferLength nextBoundaryIndex)) 45) (== (. bodyBuffer (+ nextBoundaryBufferLength nextBoundaryIndex 1)) 45)))
				}
			{(&& (== (. bodyBuffer nextBoundaryIndex) 13) (== (. bodyBuffer (+ nextBoundaryIndex 1)) 10))
				(parseField bodyBuffer (+ nextBoundaryIndex nextBoundaryBufferLength 2) params nextBoundaryBuffer)
				}
			{default
				(throw)
				}
			)
		)
	(. NS "ParseMultiPart" (lambda (bodyBuffer boundary)
			params:{
				}
			beginBoundaryBuffer:(JSNew "Buffer" (+ "--" boundary "\r\n"))
			beginBoundaryBufferLength:(. beginBoundaryBuffer "length")
			boundaryIndex:(BytesSearch bodyBuffer beginBoundaryBuffer 0 0 0 0)
			fromIdx:(+ boundaryIndex beginBoundaryBufferLength)
			nextBoundaryBuffer:(JSNew "Buffer" (+ "\r\n--" boundary ""))
			(if (&& (>= fromIdx 0) (<= fromIdx (. bodyBuffer "length")))
				(parseField bodyBuffer fromIdx params nextBoundaryBuffer)
				)
			params
			))
	(. NS "MergeMultiPartParameters" (lambda (params newAddedParams uri_encoding)
			addedKey:
			addedValue:
			newKey:
			pValue:
			i:0
			(for newAddedParams (lambda (addedKey addedValue)
					newKey=addedKey
					pValue=(. params newKey)
					(cond {(== (typeof pValue) "string")
							(cond {(|| (== (typeof addedValue) "string") (JSInstanceof addedValue "Buffer"))
									(. params newKey [pValue addedValue])
									}
								{(JSInstanceof addedValue "Array")
									(. params newKey [])
									((. (. params newKey) "push") pValue)
									i=0
									(while (< i (. addedValue "length"))
										((. (. params newKey) "push") (. addedValue i))
										i=(+ i 1)
										)
									}
								)
							}
						{(JSInstanceof pValue "Array")
							(cond {(|| (== (typeof addedValue) "string") (JSInstanceof addedValue "Buffer"))
									((. pValue "push") addedValue)
									}
								{(JSInstanceof addedValue "Array")
									i=0
									(while (< i (. addedValue "length"))
										((. pValue "push") (. addedValue i))
										i=(+ i 1)
										)
									}
								)
							}
						{default
							(cond {(|| (== (typeof addedValue) "string") (JSInstanceof addedValue "Buffer"))
									(. params newKey addedValue)
									}
								{(JSInstanceof addedValue "Array")
									(. params newKey [])
									i=0
									(while (< i (. addedValue "length"))
										(. (. params newKey) i (. addedValue i))
										i=(+ i 1)
										)
									}
								)
							}
						)
					))
			params
			))
	))

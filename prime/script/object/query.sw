#>>==>>|prime|script.object.query|/prime/script/object/query.sw
(package "script.object.query" "script.stddef" (lambda (NS STDDEF)
	$length:(. STDDEF "$length")
	Undefined:(. STDDEF "Undefined")
	Zero:(. STDDEF "Zero")
	$number:(. STDDEF "$number")
	$string:(. STDDEF "$string")
	$pop:(. STDDEF "$pop")
	$shift:(. STDDEF "$shift")
	One:(. STDDEF "One")
	(. NS "Get" (lambda (obj @arguments)
			ret:
			i:
			o:obj
			key:
			argLength:(. arguments $length)
			(if (< argLength 1)
				ret=Undefined
				(do i=Zero
					(while (< i argLength)
						key=(. arguments i)
						(if (in key o)
							o=(. o key)
							(return Undefined)
							)
						i=(+ i 1)
						)
					ret=o
					)
				)
			ret
			))
	_Set:(lambda (o keys value)
		key:
		i:Zero
		(if (!= (typeof keys) "array")
			keys=[keys]
			)
		argLength:(. keys $length)
		(while (< i argLength)
			key=(. keys i)
			keyType:(typeof key)
			(if (&& (!= keyType $string) (!= keyType $number))
				(throw)
				)
			(if (== i (- argLength One))
				(do (. o key value)
					(return)
					)
				)
			(if (in key o)
				()
				(. o key {
						})
				)
			o=(. o key)
			i=(+ i 1)
			)
		)
	(. NS "BulkSetArray" (lambda (data array)
			key:
			value:
			keyType:
			length:(. array $length)
			i:Zero
			(while (< i length)
				key=(. array i)
				value=(. array (+ i One))
				keyType=(typeof key)
				(cond {(== keyType $string)
						(. data key value)
						}
					{(== keyType "array")
						(_Set data key value)
						}
					{default
						(throw)
						}
					)
				i=(+ i 2)
				)
			data
			))
	(. NS "Set" (lambda (@keys)
			argLength:(. keys $length)
			(if (< argLength 3)
				(throw)
				)
			obj:((. keys $shift))
			value:((. keys $pop))
			(_Set obj keys value)
			))
	))

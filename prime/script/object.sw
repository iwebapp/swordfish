#>>==>>|prime|script.object|/prime/script/object.sw
(package "script.object" (lambda (NS)
	(. NS "ObjSize" (lambda (o includeHiddenProperty)
			l:0
			(for o (lambda (p)
					(if (== ((. p "indexOf") ".") 0)
						(if includeHiddenProperty
							l=(+ l 1)
							)
						l=(+ l 1)
						)
					))
			l
			))
	Extend:(. NS "Extend" (lambda (destination source notReplace)
			(if source
				(for source (lambda (property value)
						(if (! notReplace)
							(. destination property value)
							(if (== (typeof (. destination property)) "undefined")
								(. destination property value)
								)
							)
						))
				)
			destination
			))
	(. NS "Merge" (lambda (objs notReplace)
			obj:{
				}
			len:(objs "length")
			i:0
			(while (< i len)
				(Extend obj (. objs i) notReplace)
				i=(+ i 1)
				)
			obj
			))
	))

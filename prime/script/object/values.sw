#>>==>>|prime|script.object.values|/prime/script/object/values.sw
(package "script.object.values" "script.object.keys" (lambda (NS ObjKeys)
	iterator:(lambda (item i keys obj selector)
		value:(. obj item)
		(if selector
			(if (selector value)
				value
				(continue)
				)
			value
			)
		)
	(. NS "Get" (lambda (obj selector keySelector)
			keys:((. ObjKeys "Get") obj keySelector)
			(each keys iterator true obj selector)
			))
	))

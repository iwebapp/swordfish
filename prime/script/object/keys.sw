#>>==>>|prime|script.object.keys|/prime/script/object/keys.sw
(package "script.object.keys" (lambda (NS)
	Object:(JSEval "Object")
	HasOwnProperty:(. (. Object "prototype") "hasOwnProperty")
	hasKeys=(== (typeof (. Object "keys")) "function")
	hasDontEnumBug:(! ((. {"toString":null
					} "propertyIsEnumerable") "toString"))
	dontEnums:["toString" "toLocaleString" "valueOf" "hasOwnProperty" "isPrototypeOf" "propertyIsEnumerable" "constructor"]
	dontEnumsLength:(. dontEnums "length")
	(. NS "Get" (lambda (obj selector)
			(if (&& (! selector) hasKeys)
				(return ((. Object "keys") obj))
				)
			(if (|| (&& (!= (typeof obj) "object") (!= (typeof obj) "function")) (=== obj null))
				(throw (JSNew "TypeError" "Object.keys called on non-object"))
				)
			result:[]
			pushKeys:(lambda (_prop)
				(if selector
					(if (selector _prop)
						((. result "push") _prop)
						)
					((. result "push") _prop)
					)
				)
			objHasOwnProperty:(bind HasOwnProperty obj)
			(for obj (lambda (_prop)
					(if (objHasOwnProperty _prop)
						(pushKeys _prop)
						)
					))
			(cond {hasDontEnumBug
					i:0
					(while (< i dontEnumsLength)
						(if (objHasOwnProperty (. dontEnums i))
							(pushKeys (. dontEnums i))
							)
						i=(i + 1)
						)
					}
				)
			result
			))
	(. NS "ExcludeHiddenItemSelector" (lambda (key)
			(!= ((. key "indexOf") ".") 0)
			))
	))

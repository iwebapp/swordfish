#>>==>>|prime|script.object.list|/prime/script/object/list.sw
(package "script.object.list" "script.object.query" (lambda (NS ObjQuery)
	(. NS "FromArray" (lambda (array)
			((. ObjQuery "BulkSetArray") {
					} array)
			))
	(. NS "From" (lambda (@argv)
			((. NS "FromArray") argv)
			))
	))

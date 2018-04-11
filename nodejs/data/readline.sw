#>>==>>|nodejs|data.readline|/nodejs/data/readline.sw
(package "data.readline" (lambda (NS)
	(. NS "Get" (lambda (bodyBuffer fromIdx)
			fromIdx=(|| fromIdx 0)
			fun:(lambda ()
				buffer:[]
				(if (>= (. fun "cursor") (. bodyBuffer "length"))
					(return undefined)
					)
				from:(. fun "cursor")
				i:from
				(while (< i (. bodyBuffer "length"))
					b:(. bodyBuffer i)
					(if (== b 10)
						(do (. fun "cursor" (+ i 1))
							(return ((. bodyBuffer "toString") "UTF-8" from (. fun "cursor")))
							)
						)
					i=(+ i 1)
					)
				(. fun "cursor" (. bodyBuffer "length"))
				((. bodyBuffer "toString") "UTF-8" from (. fun "cursor"))
				)
			(. fun "cursor" fromIdx)
			fun
			))
	))

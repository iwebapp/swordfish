#>>==>>|prime|script.string.hash|/prime/script/string/hash.sw
(package "script.string.hash" "math.int32" (lambda (NS Int32)
	SignedMax:(. Int32 "SignedMax")
	(. NS "GetInt" (lambda (str)
			str=(|| str this)
			len:(. str "length")
			h:0
			i:0
			(while (< i len)
				h=(+ (* 31 h) ((. str "charCodeAt") i))
				(if (> h SignedMax)
					h=(% h SignedMax)
					)
				i=(+ i 1)
				)
			h
			))
	))

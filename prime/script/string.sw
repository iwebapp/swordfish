#>>==>>|prime|script.string|/prime/script/string.sw
(package "script.string" (lambda (NS)
	regTrim:`/^(\s|\u00A0)+|(\s|\u00A0)+$/g
	regJs:`/(?:<script.*?>)(?:\n|\r|.)*?(?:<\/script>)/img
	regJsCode:`/(?:<script.*?>)((?:\n|\r|.)*?)(?:<\/script>)/img
	regJsCodeC1:`/<\/?script.*?>/gi
	String:(JSEval "String")
	StringPrototype:(. String "prototype")
	(. NS "Trim" (lambda (text)
			(if (in "trim" StringPrototype)
				((. text "trim"))
				((. (|| text "") "replace") regTrim "")
				)
			))
	(. NS "GetHTMLText" (lambda (text)
			((. text "replace") regJs "")
			))
	(. NS "GetScriptText" (lambda (text)
			all:((. text "match") regJsCode)
			t:""
			i:0
			allLen:(. all "length")
			(if all
				(while (< i allLen)
					t=(+ t ((. (. all i) "replace") regJsCodeC1 "") "\n")
					i=(+ i 1)
					)
				)
			t
			))
	(. NS "StartsWith" (lambda (str ch fromIndex caseInsensitive)
			fromIndex=(|| fromIndex 0)
			(cond {caseInsensitive
					str=((. ((. str "substr") fromIndex (. ch "length")) "toUpperCase"))
					(== str ((. ch "toUpperCase")))
					}
				{default
					(if (in "startsWith" StringPrototype)
						((. str "startsWith") ch fromIndex)
						(== ((. str "indexOf") ch) fromIndex)
						)
					}
				)
			))
	(. NS "EndsWith" (lambda (str ch fromIndex caseInsensitive)
			(if (|| (== fromIndex null) (=== fromIndex false))
				fromIndex=(. str "length")
				)
			(cond {caseInsensitive
					str=((. ((. str "substring") (- fromIndex (. ch "length")) fromIndex) "toUpperCase"))
					(== str ((. ch "toUpperCase")))
					}
				{default
					(cond {(in "endsWith" StringPrototype)
							((. str "endsWith") ch fromIndex)
							}
						{default
							idx:((. str "lastIndexOf") ch fromIndex)
							(? (!= idx -1) (== idx (- fromIndex (. ch "length"))) false)
							}
						)
					}
				)
			))
	(. NS "Chomp" (lambda (str ch fromBegin)
			idx:((. str (? fromBegin "indexOf" "lastIndexOf")) ch)
			(if (!= idx -1)
				(do (if fromBegin
						(if (== idx 0)
							(return ((. str "substr") (. ch "length")))
							)
						(if (== idx (- (. str "length") (. ch "length")))
							(return ((. str "substring") 0 idx))
							)
						)
					)
				)
			(return str)
			))
	))

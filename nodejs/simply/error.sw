#>>==>>|nodejs|simply.error|/nodejs/simply/error.sw
(package "simply.error" (lambda (NS)
	(. NS "$" (lambda (@arguments)
			((. console "error") (catlist arguments))
			))
	))

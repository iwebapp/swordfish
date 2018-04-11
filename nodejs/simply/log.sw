#>>==>>|nodejs|simply.log|/nodejs/simply/log.sw
(package "simply.log" (lambda (NS)
	(. NS "$" (lambda (@arguments)
			((. console "log") (catlist arguments))
			))
	))

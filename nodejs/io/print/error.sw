#>>==>>|nodejs|io.print.error|/nodejs/io/print/error.sw
(package "io.print.error" (lambda (NS)
	(. NS "$" (lambda (@arguments)
			i:0
			data:
			len:(. arguments "length")
			(while (< i len)
				data=(. arguments i)
				((. (JSEval "process.stderr") "write") data (? (== (typeof data) "string") "UTF-8" null))
				i=(+ i 1)
				)
			))
	))

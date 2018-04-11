#>>==>>|nodejs|io.file.readtext|/nodejs/io/file/readtext.sw
(package "io.file.readtext" (lambda (NS)
	require:(JSEval "require")
	fs:(require "fs")
	cacheByFilename:{
		}
	fun_get_impl:(lambda (filename asynchronousCallback)
		synchronous:(! asynchronousCallback)
		(if (! synchronous)
			(throw)
			)
		contentCache=((. fs "readFileSync") filename {"encoding":"UTF-8"
				})
		(. cacheByFilename filename contentCache)
		contentCache
		)
	(. NS "Get" (lambda (filename canUseCache asynchronousCallback)
			(if canUseCache
				(do contentCache=(. cacheByFilename filename)
					(if (! contentCache)
						(fun_get_impl filename asynchronousCallback)
						(if asynchronousCallback
							(asynchronousCallback contentCache)
							contentCache
							)
						)
					)
				(fun_get_impl filename asynchronousCallback)
				)
			))
	))

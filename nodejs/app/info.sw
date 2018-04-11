#>>==>>|nodejs|app.info|/nodejs/app/info.sw
(package "app.info" (lambda (NS)
	require:(JSEval "require")
	path:(require "path")
	(. NS "Dump" (lambda ()
			process:(JSEval "process")
			Envkey:
			info:(+ "Process[" (. process "pid") "]:" "\n" "Current directory:" ((. process "cwd")) "\n" "Arguments:\n")
			argv:(. process "argv")
			i:0
			(while (< i (. argv "length"))
				info=(+ info i ":" (. argv i) "\n")
				i=(+ i 1)
				)
			info=(+ info "Environment:\n")
			(for (. process "env") (lambda (EnvKey EnvValue EnvObj)
					info=(+ info EnvKey ":" EnvValue "\n")
					))
			info
			))
	(. NS "GetExeFilePath" (lambda (onlyPath)
			src:(GetScriptURI global)
			(if onlyPath
				((. path "dirname") src)
				src
				)
			))
	(. NS "GetArguments" (lambda ()
			(. global "arguments")
			))
	))

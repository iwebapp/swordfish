#>>==>>|prime|io.text.readline|/prime/io/text/readline.sw
(package "io.text.readline" (lambda (NS)
	(. NS "Get" (lambda (readChar)
			gangR:false
			buffer:[]
			isEnd:false
			(lambda (deleteLF)
				(if isEnd
					(return undefined)
					)
				ret:
				ch:(readChar)
				(while true
					(cond {(== ch null)
							isEnd=true
							(if (== (. buffer "length") 0)
								(return undefined)
								(return ((. buffer "join") ""))
								)
							}
						{(== ch "\r")
							(if gangR
								(do ret=((. buffer "join") "")
									buffer=[]
									)
								)
							(if deleteLF
								()
								((. buffer "push") ch)
								)
							gangR=true
							(if (!= ret null)
								(return ret)
								)
							}
						{(== ch "\n")
							(if deleteLF
								()
								((. buffer "push") ch)
								)
							gangR=false
							ret=((. buffer "join") "")
							buffer=[]
							(return ret)
							}
						{default
							(if gangR
								(do ret=((. buffer "join") "")
									buffer=[]
									gangR=false
									)
								)
							((. buffer "push") ch)
							(if (!= ret null)
								(return ret)
								)
							}
						)
					ch=(readChar)
					)
				)
			))
	))

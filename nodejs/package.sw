((lambda (NS)
	Use:
	PackageNameKey:"#"
	StaticCall:"$"
	BlankPackage:{
		}
	createBlankPackage:(lambda ()
		pack:{
			}
		(. pack "__proto__" BlankPackage)
		pack
		)
	createPackage:(lambda ()
		(lambda (@arguments)
			Call:(. callee StaticCall)
			(if Call
				(Call (catlist arguments))
				(throw (+ "package \"" (. callee PackageNameKey) "\" is not \"" StaticCall "\" operator."))
				)
			)
		)
	getPackage:(lambda (packageName)
		names:((. packageName "split") ".")
		ns:global
		name:
		property:
		i:0
		len:(. names "length")
		initPack:(lambda (oldPackage)
			pack:(createPackage)
			(. pack PackageNameKey packageName)
			(. ns name pack)
			(if oldPackage
				(for oldPackage (lambda (oldPropertyKey oldPropertyValue)
						(. pack oldPropertyKey oldPropertyValue)
						))
				(do
					)
				)
			)
		(while (< i len)
			name=(. names i)
			notLastName:(< i (- len 1))
			existingPack:(. ns name)
			(if (=== existingPack undefined)
				(if notLastName
					(. ns name (createBlankPackage))
					(initPack)
					)
				(if notLastName
					(do
						)
					(if (=== (. existingPack "__proto__") BlankPackage)
						(initPack existingPack)
						(do
							)
						)
					)
				)
			ns:(. ns name)
			i=(+ i 1)
			)
		ns
		)
	package:(lambda (packageName @arguments)
		NS:(getPackage packageName)
		dependPackages:[]
		packageBlock:null
		len:(. arguments "length")
		i:0
		(while (< i len)
			arg:(. arguments i)
			i:(+ i 1)
			type:(typeof arg)
			(if (== type "string")
				((. dependPackages "push") arg)
				(if (== type "lambda")
					(if (== (JSTypeof (. arg PackageNameKey)) "string")
						((. dependPackages "push") arg)
						(do packageBlock:arg
							break
							)
						)
					(throw)
					)
				)
			)
		(if (! packageBlock)
			(throw)
			)
		(if (> (. dependPackages "length") 0)
			((. Use "All") dependPackages (lambda (@arguments)
					args:[]
					arg:
					i:0
					argsLen:(. arguments "length")
					((. args "push") NS)
					(while (< i argsLen)
						arg=(. arguments i)
						((. args "push") arg)
						i=(+ i 1)
						)
					(packageBlock (catlist args))
					))
			(packageBlock NS)
			)
		NS
		)
	(. NS "package" package)
	Use=(package "use" (lambda (NS)
			Array:(JSEval "Array")
			require:(JSEval "require")
			path:(require "path")
			D:(. path "sep")
			(. NS "INC" ["."])
			((lambda ()
					baseSrc:(GetScriptURI)
					incPath:((. path "dirname") baseSrc)
					(. (. NS "INC") 0 incPath)
					))
			(. NS "PushINC" (lambda (Additional_relativeINC baseSrc highPriority)
					method:(if highPriority
						"unshift"
						"push"
						)
					(if (=== true baseSrc)
						((. (. NS "INC") method) Additional_relativeINC)
						(do baseSrc=(|| baseSrc (GetScriptURI))
							incPath:((. path "dirname") baseSrc)
							_path:((. path "normalize") (+ incPath D Additional_relativeINC))
							((. (. NS "INC") method) _path)
							)
						)
					))
			(. NS "GetModuleNames" (lambda (moduleName)
					((. moduleName "split") ".")
					))
			(. NS "GetModuleExpression" (lambda (names)
					moduleNameBuf:[]
					(if (JSInstanceof names Array)
						()
						names=((. NS "GetModuleNames") names)
						)
					i:0
					len:(. names "length")
					(while (< i len)
						(if (== i 0)
							((. moduleNameBuf "push") (. names i))
							(do ((. moduleNameBuf "unshift") "(. ")
								((. moduleNameBuf "push") (+ " \"" (. names i) "\")"))
								)
							)
						i=(+ i 1)
						)
					ret:((. moduleNameBuf "join") "")
					ret
					))
			(. NS "GetModulePath" (lambda (INC names includeFileName)
					buf:[]
					(if (JSInstanceof names Array)
						()
						names=((. NS "GetModuleNames") names)
						)
					(if INC
						((. buf "push") INC)
						()
						)
					i:0
					len:(- (. names "length") 1)
					(while (< i len)
						((. buf "push") D)
						((. buf "push") (. names i))
						i=(+ i 1)
						)
					(if includeFileName
						(do ((. buf "push") D)
							((. buf "push") (. names i))
							((. buf "push") ".sw")
							)
						)
					((. buf "join") "")
					))
			(. NS "GetAllModulePath" (lambda (names includeFileName)
					endPath:((. NS "GetModulePath") null names includeFileName)
					i:0
					INC:(. NS "INC")
					incLen:(. INC "length")
					paths:[]
					(while (< i incLen)
						(. paths i (+ (. INC i) endPath))
						i=(+ i 1)
						)
					paths
					))
			SinglUSE:(lambda (moduleName callBack)
				type:(JSTypeof moduleName)
				(cond {(== type "string")
						module:
						src:
						srcs:
						checkedSrcs:[]
						loadSuccess:false
						canReturn:false
						names:((. NS "GetModuleNames") moduleName)
						moduleExpression:(+ "" ((. NS "GetModuleExpression") names) "")
						(try module=(eval global moduleExpression)
							(if (!= (JSTypeof (. module PackageNameKey)) "string")
								module=null
								)
							(lambda (e)
								module=null
								)
							)
						(if module
							(do (if callBack
									(callBack module moduleName true)
									)
								(return module)
								)
							)
						srcs=((. NS "GetAllModulePath") names true)
						src=((. srcs "shift"))
						(while src
							loadSuccess=((. NS "LoadScript") src true null)
							(if loadSuccess
								(do module=(eval global moduleExpression)
									(if (! module)
										(throw (+ "packagename define error: at " moduleName))
										)
									(. module "src" src)
									(if callBack
										(callBack module moduleName false)
										)
									canReturn=true
									)
								(do ((. checkedSrcs "push") src)
									src=((. srcs "shift"))
									(if (! src)
										canReturn=true
										)
									)
								)
							(if canReturn
								(if (! loadSuccess)
									(throw (+ "Failed to load:" moduleName " from:" checkedSrcs))
									(return module)
									)
								)
							)
						}
					{(== type "function")
						(if (== (. moduleName PackageNameKey) "string")
							(do (callBack moduleName (. moduleName PackageNameKey) true)
								(return moduleName)
								)
							(throw)
							)
						}
					{default
						(throw)
						}
					)
				)
			(. NS "All" (lambda (namesList callBack isEachCallBack)
					idx:0
					modules:[]
					namesLen:(. namesList "length")
					_callback:(lambda (module moduleName)
						(if isEachCallBack
							(if callBack
								(callBack module moduleName)
								)
							)
						(if (! module)
							(throw moduleName)
							)
						idx=(+ idx 1)
						((. modules "push") module)
						(if (< idx namesLen)
							(SinglUSE (. namesList idx) _callback)
							(if callBack
								(do (callBack (catlist modules))
									)
								)
							)
						)
					(if (== namesLen 0)
						(do (if callBack
								(callBack (catlist modules))
								)
							(return)
							)
						)
					(SinglUSE (. namesList idx) _callback)
					))
			(. NS "$" (lambda (@arguments)
					i:0
					len:(. arguments "length")
					packages:[]
					callback:null
					(while (< i len)
						arg:(. arguments i)
						i=(+ i 1)
						type:(typeof arg)
						(cond {(== type "string")
								((. packages "push") arg)
								}
							{(== type "lambda")
								(if (== (JSTypeof (. arg PackageNameKey)) "string")
									((. packages "push") arg)
									(do callback=arg
										(break)
										)
									)
								}
							{default
								(throw)
								}
							)
						)
					(if (! callback)
						(throw)
						)
					((. NS "All") packages callback)
					))
			(. NS "LoadedResources" {
					})
			(. NS "HasLoaded" (lambda (src)
					(== (. (. NS "LoadedResources") src) 1)
					))
			(. NS "LoadScript" (lambda (src synchro callBack isFlush)
					(if (! synchro)
						(throw "Donot support asynchronous load script.")
						)
					(if (&& (! isFlush) ((. NS "HasLoaded") src))
						(if callBack
							(callBack true true)
							(return true)
							)
						)
					loadOK:(try (load src)
						(lambda (e)
							(if (&& (== (typeof e) "object") (== (. e "loaderror") true))
								()
								((. console "log") e)
								)
							(if callBack
								(callBack false)
								)
							(return false)
							)
						)
					(if (! loadOK)
						(return false)
						)
					(. (. NS "LoadedResources") src 1)
					(if callBack
						(callBack true)
						)
					true
					))
			))
	) (getscope))

#>>==>>|prime|protocol.uri|/prime/protocol/uri.sw
(package "protocol.uri" (lambda (NS)
	Path:(. NS "Path" "path")
	UriPath:(. NS "UriPath" "uriPath")
	Scheme:(. NS "Scheme" "scheme")
	IsWindows:(. NS "IsWindows" "isWindows")
	FilePath:(. NS "FilePath" "filePath")
	Mark:(. NS "Mark" "mark")
	Query:(. NS "Query" "query")
	FileName:(. NS "FileName" "fileName")
	Extend:(. NS "Extend" "extend")
	Name:(. NS "Name" "name")
	UriHost:(. NS "UriHost" "uriHost")
	Domain:(. NS "Domain" "domain")
	Port:(. NS "Port" "port")
	Translate:undefined
	RegExp:(JSEval "RegExp")
	(. NS "GetBasePath" (lambda (uri pathSeparator)
			(. (Translate uri pathSeparator) Path)
			))
	schemeRegExp:`/^([a-z-]+):\/\//i
	windowFileRegExp:`/^[a-z]:\\/i
	_windowFileRegExpForURL:`/^\/[a-z]:\//i
	(. NS "IsAbsolutePath" (lambda (uri pathSeparator isWindows)
			pathSeparator=(|| pathSeparator (? isWindows "\\" "\/"))
			(cond {(== ((. uri "indexOf") pathSeparator) 0)
					true
					}
				{isWindows
					((. windowFileRegExp "test") uri)
					}
				{default
					false
					}
				)
			))
	GetScheme:(. NS "GetScheme" (lambda (uri)
			ma:((. schemeRegExp "exec") uri)
			(if ma
				((. (. ma 1) "toLowerCase"))
				null
				)
			))
	(. NS "IsAbsoluteURI" (lambda (uri)
			(!= (GetScheme uri) null)
			))
	normalizeArray:(lambda (parts allowAboveRoot)
		up:0
		i:(- (. parts "length") 1)
		(while (>= i 0)
			last:(. parts i)
			(cond {(== last ".")
					((. parts "splice") i 1)
					}
				{(== last "..")
					((. parts "splice") i 1)
					up=(+ up 1)
					}
				{up
					((. parts "splice") i 1)
					up=(- up 1)
					}
				)
			i=(- i 1)
			)
		(if allowAboveRoot
			(while up
				((. parts "unshift") "..")
				up=(- up 1)
				)
			)
		parts
		)
	(. NS "GetURIPath" (lambda (r)
			(if (. r Scheme)
				(. r UriPath)
				(. r Path)
				)
			))
	SetURIPath:(. NS "SetURIPath" (lambda (r path)
			(if (. r Scheme)
				(. r UriPath path)
				(. r Path path)
				)
			))
	(. NS "Normalize" (lambda (uri pathSeparator isWindows)
			paths:
			path:
			obj:(Translate uri pathSeparator)
			scheme:(. obj Scheme)
			(cond {(&& (== scheme "file") (. obj IsWindows))
					_filePath:(. obj FilePath)
					disk:((. _filePath "substring") 0 2)
					dpath:((. _filePath "substr") 2)
					paths=((. dpath "split") "\\")
					paths=(normalizeArray paths false)
					path=((. paths "join") pathSeparator)
					(SetURIPath obj (+ pathSeparator disk path))
					}
				{default
					path=(. NS "GetURIPath" obj)
					absolute:((. NS "IsAbsolutePath") path pathSeparator isWindows)
					paths=((. path "split") pathSeparator)
					paths=(normalizeArray paths (! absolute))
					path=((. paths "join") pathSeparator)
					(SetURIPath obj path)
					}
				)
			((. NS "Build") obj pathSeparator)
			))
	Translate=(. NS "Translate" (lambda (uri pathSeparator)
			r:{
				}
			scheme:(GetScheme uri)
			idx:((. uri "indexOf") "#")
			(cond {(!= idx -1)
					(. r Mark ((. uri "substring") (+ idx 1)))
					uri=((. uri "substring") 0 idx)
					}
				)
			idx=((. uri "indexOf") "?")
			(cond {(!= idx -1)
					(. r Query ((. uri "substring") (+ idx 1)))
					uri=((. uri "substring") 0 idx)
					}
				)
			idx=((. uri "lastIndexOf") pathSeparator)
			(cond {(&& (!= scheme null) (< idx (+ (. scheme "length") 3)))
					(. r Path uri)
					(. r FileName "")
					}
				{default
					(. r Path (? (== idx -1) "" ((. uri "substring") 0 idx)))
					(. r FileName (? (== idx -1) uri ((. uri "substring") (+ idx 1))))
					}
				)
			(cond {(. r FileName)
					idx=((. (. r FileName) "lastIndexOf") ".")
					(if (!= idx -1)
						(do (. r Extend ((. (. r FileName) "substring") (+ idx 1)))
							(. r Name ((. (. r FileName) "substring") 0 idx))
							)
						(. r Name (. r FileName))
						)
					}
				)
			(cond {((. schemeRegExp "exec") (. r Path))
					rc:(. RegExp "rightContext")
					scheme:(. r Scheme ((. (. RegExp "$1") "toLowerCase")))
					(if (== scheme "file")
						(do (. r UriPath rc)
							(if ((. _windowFileRegExpForURL "test") rc)
								(do (. r FilePath ((. ((. rc "substr") 1) "replace") pathSeparator "\\"))
									(. r IsWindows true)
									)
								(. r FilePath rc)
								)
							)
						(do uriHost:
							idx=((. rc "indexOf") pathSeparator)
							(cond {(!= idx -1)
									(. r UriPath ((. rc "substr") idx))
									uriHost=(. r UriHost ((. rc "substring") 0 idx))
									}
								{default
									(. r UriPath "")
									uriHost=(. r UriHost rc)
									}
								)
							_idx:((. uriHost "indexOf") ":")
							(if (!= _idx -1)
								(do (. r Domain ((. uriHost "substring") 0 _idx))
									(. r Port ((. uriHost "substr") (+ _idx 1)))
									)
								(. r Domain uriHost)
								)
							)
						)
					}
				)
			r
			))
	BuildURIPath02:(lambda (r pathSeparator)
		buf:""
		scheme:(. r Scheme)
		(if (. r Name)
			(do (if (|| (. r Path) (. r UriPath))
					buf=(+ buf pathSeparator)
					)
				buf=(+ buf (. r Name))
				)
			(cond {(&& scheme (! (. r UriPath)))
					buf=(+ buf pathSeparator)
					}
				{(. r UriPath)
					buf=(+ buf pathSeparator)
					}
				)
			)
		(if (. r Extend)
			buf=(+ buf "." (. r Extend))
			)
		(if (. r Query)
			buf=(+ buf "?" (. r Query))
			)
		buf
		)
	(. NS "BuildI" (lambda (r)
			(+ (. r UriPath) (BuildURIPath02 r "\/"))
			))
	BuildSchemeH0:(lambda (r)
		buf:""
		(cond {(. r UriHost)
				buf=(+ buf (. r UriHost))
				}
			{(. r Domain)
				buf=(+ buf (. r Domain))
				(if (. r Port)
					buf=(+ buf ":" (. r Port))
					)
				}
			{default
				(throw)
				}
			)
		buf
		)
	(. NS "BuildSchemeH" (lambda (r)
			buf:""
			scheme:(. r Scheme)
			(cond {scheme
					buf=(+ buf scheme)
					buf=(+ buf ":\/\/")
					buf=(+ buf (BuildSchemeH0 r))
					}
				{default
					(throw)
					}
				)
			buf
			))
	(. NS "Build" (lambda (r pathSeparator noMark)
			buf:""
			scheme:(. r Scheme)
			(if scheme
				(do buf=(+ buf scheme)
					buf=(+ buf ":\/\/")
					(if (== scheme "file")
						buf=(+ buf (. r UriPath))
						(do buf=(+ buf (BuildSchemeH0 r))
							buf=(+ buf (. r UriPath))
							)
						)
					)
				(if (. r Path)
					buf=(+ buf (. r Path))
					)
				)
			buf=(+ buf (BuildURIPath02 r pathSeparator))
			(if (&& (! noMark) (. r Mark))
				buf=(+ buf "#" (. r Mark))
				)
			buf
			))
	))

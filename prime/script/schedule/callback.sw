#>>==>>|prime|script.schedule.callback|/prime/script/schedule/callback.sw
(package "script.schedule.callback" "script.schedule" (lambda (NS Schedule)
	Suspended:(. Schedule "Suspended")
	Press:(. Schedule "Press")
	Get:(. Schedule "Get")
	Set:(. Schedule "Set")
	ThenListIdx:(. Schedule "ThenListIdx")
	ThisObj:(. NS "ThisObj" "to")
	ApiReturnValue:"apiReturnValue"
	(. NS "GetThis" (lambda (schedule)
			get:(. schedule Get)
			thenListIdx:(get ThenListIdx)
			(get ThisObj (- thenListIdx 1))
			))
	(. NS "GetReturnValue" (lambda (schedule)
			get:(. schedule Get)
			thenListIdx:(get ThenListIdx)
			(get ApiReturnValue (- thenListIdx 1))
			))
	(. NS "FinallySet" (lambda (thisObj callApi nonDisposable isJavascriptCallback)
			apiFuntion:
			isJavascriptCallback=(? (== isJavascriptCallback null) true isJavascriptCallback)
			isFun:(lambda (type)
				(|| (== type "function") (== type "lambda"))
				)
			type:(typeof callApi)
			(cond {(== type "string")
					apiFuntion=(. thisObj callApi)
					(if (! (isFun (typeof apiFuntion)))
						(throw)
						)
					}
				{(isFun type)
					apiFuntion=callApi
					}
				{default
					(throw)
					}
				)
			(lambda (@argv)
				schedule:this
				returnValues:
				hasCall:false
				hasReturn:false
				get:(. schedule Get)
				set:(. schedule Set)
				thenListIdx:(get ThenListIdx)
				callback:(lambda (@argv)
					hasCall=true
					thisObj:this
					(if (!= thisObj null)
						(set ThisObj thenListIdx thisObj)
						)
					(if hasReturn
						(if nonDisposable
							(do forkSchedule:((. Schedule "Fork") schedule (+ thenListIdx 1))
								((. forkSchedule Press) (catlist argv))
								)
							((. schedule Press) (catlist argv))
							)
						@returnValues=(catlist argv)
						)
					)
				(if isJavascriptCallback
					callback=(JSCallback callback)
					)
				((. argv "push") callback)
				apiReturnValue:((bind apiFuntion thisObj) (catlist argv))
				(set ApiReturnValue thenListIdx apiReturnValue)
				hasReturn=true
				(cond {hasCall
						(catlist returnValues)
						}
					{default
						Suspended
						}
					)
				)
			))
	))

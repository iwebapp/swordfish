#>>==>>|prime|script.schedule|/prime/script/schedule.sw
(package "script.schedule" "script.object.query" "script.object.list" "package.userdata" (lambda (NS ObjQuery ObjList UserData)
	Then:(. NS "Then" "then")
	ThenListIdx:(. NS "ThenListIdx" "tlidx")
	Press:(. NS "Press" "press")
	Suspended:(. NS "Suspended" {
			})
	Get:(. NS "Get" "get")
	Set:(. NS "Set" "set")
	(. NS "Anchor" (. bind "Anchor"))
	(. NS "Anchors" (. bind "Anchors"))
	GetData:(. NS "GetData" "getData")
	GetFrames:(. NS "GetFrames" "getFrames")
	Reset:(. NS "Reset" "reset")
	Delay:(. NS "Delay" "delay")
	GetThenIndex:(. NS "GetThenIndex" "getIdx")
	CompleteStop:(. NS "CompleteStop" "stop")
	_Running:"r"
	SuspendedKey:"suspended"
	setTimeout:(JSEval "setTimeout")
	Is:(. NS "Is" (lambda (obj)
			((. UserData "IsClass") obj NS)
			))
	Schedule:(lambda (data delay thenList thenListIdx)
		completeStop:false
		(if (Is data)
			data=((. data GetData))
			)
		data=(|| data {
				})
		(if (! thenList)
			(do thenList=[]
				thenListIdx=0
				)
			(if (>= thenListIdx 0)
				(if (> thenListIdx (. thenList "length"))
					thenListIdx=(. thenList "length")
					)
				thenListIdx=0
				)
			)
		schedule:{
			}
		((. UserData "SetClass") schedule NS)
		(. schedule _Running (? delay true false))
		(. schedule Delay (lambda ()
				(. schedule _Running true)
				thenListIdx
				))
		lastReturnValue:
		lastIsSync:false
		set:(. schedule Set (lambda (@argv)
				((. ObjQuery "Set") data (catlist argv))
				))
		pushSchedule:
		timerId:null
		press:(. schedule Press (lambda (@runtimeArgv)
				(if timerId
					timerId=null
					)
				argv:(. thenList thenListIdx)
				(if (&& argv (! completeStop))
					(do (set ThenListIdx thenListIdx)
						(. schedule _Running true)
						fun:(. argv 0)
						argvPattern:((. argv "slice") 1)
						(if lastIsSync
							(if (> (. runtimeArgv "length") 0)
								(throw)
								runtimeArgv=lastReturnValue
								)
							)
						@ret:((bind fun schedule (catlist argvPattern)) (catlist runtimeArgv))
						thenListIdx=(+ thenListIdx 1)
						(cond {(&& (== (. ret "length") 1) (=== (. ret 0) Suspended))
								lastIsSync=false
								}
							{default
								(. schedule _Running false)
								lastReturnValue=ret
								lastIsSync=true
								(pushSchedule)
								}
							)
						)
					(. schedule _Running false)
					)
				))
		pushSchedule=(lambda ()
			(if (! (. schedule _Running))
				(cond {(! timerId)
						timerId=(setTimeout (JSCallback press) 0)
						}
					)
				)
			)
		then:(. schedule Then (lambda (@argv)
				(cond {(&& (== (. argv "length") 1) (== (typeof (. argv 0)) "array"))
						argv=(. argv 0)
						i:0
						leng:(. argv "length")
						(while (< i leng)
							arg:(. argv i)
							(cond {(!= (typeof (. arg 0)) "lambda")
									(throw)
									}
								{default
									((. thenList "push") arg)
									}
								)
							i:(+ i 1)
							)
						}
					{(!= (typeof (. argv 0)) "lambda")
						(throw)
						}
					{default
						((. thenList "push") argv)
						}
					)
				(pushSchedule)
				schedule
				))
		(. schedule GetData (lambda ()
				data
				))
		(. schedule GetFrames (lambda ()
				thenList
				))
		(. schedule Get (lambda (@argv)
				((. ObjQuery "Get") data (catlist argv))
				))
		(. schedule GetThenIndex (lambda ()
				thenListIdx
				))
		(. schedule Reset (lambda (idx)
				thenListIdx=(? (>= idx 0) idx 0)
				completeStop=false
				))
		(. schedule SuspendedKey Suspended)
		(. schedule CompleteStop (lambda ()
				completeStop=true
				))
		schedule
		)
	(. NS "Create" (lambda (@argv)
			data:
			delay:
			len:(. argv "length")
			v0:(. argv 0)
			v0Type:(typeof v0)
			(cond {(== len 0)
					}
				{(== len 1)
					(if (== v0Type "boolean")
						delay=(. argv 0)
						data=(. argv 0)
						)
					}
				{(== len 2)
					(if (== v0Type "boolean")
						(do delay=((. argv "shift"))
							data=((. argv "shift"))
							)
						(next)
						)
					}
				{default
					(if (== v0Type "boolean")
						delay=((. argv "shift"))
						)
					data=((. ObjList "FromArray") argv)
					}
				)
			(Schedule data delay)
			))
	(. NS "Fork" (lambda (trunkSchedule thenListIdx)
			(Schedule trunkSchedule true ((. trunkSchedule GetFrames)) thenListIdx)
			))
	(. NS "ReturnList" list)
	(. NS "CreateVar" lazy)
	))

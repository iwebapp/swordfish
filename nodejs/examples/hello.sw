#!/usr/local/bin/swordfish
/**
*	"$PATH_SWORDFISH/nodejs/test/hello.sw"
*	這是一個簡單的完整示例程式.
*	輸出＂　Hello Word　＂．
*/

;導入 nodejs 中的　require 和　path.sep.
require:(JSEval "require")
path   :(require "path")
D      :(.path "sep")

// 設定第一個　swordfish　模塊管理器 package.sw 所在目錄
// 同時也是以文件級別模塊（包）加載的第一個　Include Path 搜索路徑．
// 它只儲存　swordfish 平臺相關的 SWordFish 代碼文件．
nodejs: (JSCallObject [$PATH_SWORDFISH "nodejs"] "join" D)
(load (+ nodejs D "package.sw"))


#　設定第二個　Include Path 搜索路徑, 
# 相對於上邊的 $PATH_SWORDFISH/nodejs　package.sw 所在目錄.
; prime:  (JSCallObject [".." "prime"] "join" D)
; ((. use "PushINC") prime)
# 如果相對於代碼所在的路徑，就要再這樣加一個參數.
#　明確相對於誰．(GetScriptURI) 是本代碼的文件路徑．
; ((. use "PushINC") prime (GetScriptURI)).

prime:(JSCallObject [$PATH_SWORDFISH "prime"] "join" D)
((. use "PushINC") prime true)
#　設定當前文件所在的路徑
((. use "PushINC") "." (GetScriptURI))


; //使用 use 操作所有導入依包之後回調(callback)主邏輯過程函數．
(use "app.info" "simply.log" (lambda (AppInfo print)

	/*---  主邏輯過程函數體開始  ---*/
	
	//你可把 print　設到全局變量 L 上
	//這樣可以用來方便打 Log 來 debug.
	(. global "L" print); ;一不小心多一個分號，不過這裏沒副作用．
	;因爲它被作空白字符了，但到行尾是一種註釋．等同代碼
	; L=print ; 用賦值未定義的標號，就會爲全局設變量．不過不提倡．

	;通過模塊 app.info 獲取命令行參數的方法．
	arguments:((. AppInfo "GetArguments"))
	
	(print "!!! Hello World !!!"
"
|-----------------------------*|
|* 這是一個經典的世界您好程式 *|
|-----------------------------*|
您當前的命令參數爲: ",arguments);

	/*---  主邏輯過程函數體終止  ---*/
	))

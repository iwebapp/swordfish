#!/usr/bin/env swordfish

; 在當前作用域內定義名稱變量　(　Definition　)：
number:42
opposite:true
; 變量賦值　(　Assignment　)：
number=42
opposite=true

; 函數　(　Functions　)：
square:(lambda (x)
	(* x x)
)

; 數組　(　Arrays　):
array:[1,2,3,4,5]

; 對象　(　Objects　)：

obj:{
	field:"name"
	method:(lambda() field)
}

; 正則表達式　(　Regular Expression　):
regExp:`/^swordfish$/ig

"array":[1 2 3 4 5 6]
array:[1 2 3 4 5]

#!/usr/bin/env swordfish
# 這些是以　" # "　開始的註釋行，符合作爲　bash　文件的一般用法
; 這是以　" ; "　開始的註釋行,　一些lisp語言用這種方法來註釋行．
// 這是以兩個 " / " 斜槓開始的行註釋，javascript　和類 C 語法的語言都有這種註釋．
/*
	還有這種 C 語言風格的代碼塊註釋．
*/

; (operation param1 param2)
(lambda (x,y)
	x:(+ x 1)
	y:(+ y 1)
	(list x y)
)

fun1:(lambda (x,y)
	x:(+ x 1)
	y:(+ y 1)
	(list x y)
)
fun2:(lambda (a,b)
	(+ a b)
)
(fun2 (fun1 1 2))

a:b:c:(list 1 2 3)

a:1
b:2
c:3

a:
b:
c:123

a:undefined
b:undefined
c:123

d:@ret:c:(list 1 2 3)
((. console "log")  ret d c)

(lambda (a,b,c,@others)
	
	)

(lambda (@arguments)
	)

"＼b \t \v \f \" \' \r \n \\ 　\a "

OldJSON:{
	"key":"Hello\nWorld"
}

NewJSON:{
	"key":"Hello
World"
}

`/^swordfish$/ig

1234 #十進制整數
-0xF6 #十六進制負整數
072 #八進制整數
3.14 #浮點數
-3.04e+2 #科學計數法


+ - * %

(if true
	"This is true"
	"This is false"
)


//javascript://a=true?1:2;
A:(? true 1 2)

i:8
(while (> i 0)
	(+ "while i:" i)
	i:(- i 1)
)

i:8
exp:(while (> i 0)
	((. console "log") "while i:" i)
	i:(- i 1)
	(if (< i 5)
		(break i)))
((. console "log") "while expression 's value is" exp)

fun:(lambda ()
	i:8
	(while (> i 0)
		i:(- i 1)
		(if (< i 5)
			(return i))
		((. console "log") "i:" i)))
((. console "log") "fun value is" (fun))

(cond
	{false,"true 1"}
	{(> 1 2),"true 2"}
	{false,"true 3"}
	{default}
)

(cond
	{true
		((. console "log") "Hello")
		(next)
	}{default,
		((. console "log") "Defaut")
		}
	)
(try
	1234
	(throw "exception 1")
	4567
	(lambda(e)
		((. console "log") "===== Throw Exception ====\nthrow value:" e )
		))

(eval "{a:1,b:2}")

true
false
null
undefined
global

obj1={
	"key1":"value1"
}
obj2={
	"key2":"value2"
	"__proto__":obj1
}
(for obj2 (lambda (key value)
	((. console "log") key value)
	))
((. console "log") (in "key1" obj2))
((. console "log") (in "key1" obj2 true))

c:true
(if c
	(do 
		1
		2
		3
	)
	(do
		4
		5
		6
	)
)

(catlist 1 [2,3] 4)

(match "abc" `/abc/)

(replace "abc" `/\S/g "A1")

(replace "abc" `/\S/g (lambda($0)
		(+ $0 "=")
))

(+ 1 2 3) # 6
(+ "1" 2 3) # "123"

((.console "log") "Hello" " " "World" "\n") #> Hello World 

print:(bind (.console "log") console)
value:(JSEval "({\"p1\":1})")
(print (. value "p1") "\n")
(print (JSCall (. value "toString") value) "\n")
(print (JSCallObject value "toString") "\n")
value=(JSNew "Array" 5)
(print (. value "length") "\n")
(print (JSInstanceof value (JSEval "String")) "\n")
(print (JSTypeof value) "\n")


array:[1,2,3,4]
((. array "forEach") (JSCallback (lambda (item)
	((. console "log") "Hi:" item)
	)))

(. obj "key")
(. obj "key" value)

(. obj "setValue" (lambda (v)
	(. this "value" v)
	))

((. obj "setValue") value)
(delete obj "key")


fun1:(lambda (a,b,c,d)
	((. console "log") this a b c d)
)

//函數 fun1 ,綁定 this 到一個對象 obj1．
obj1:{"name":"obj1"}
newFun1:(bind fun1 obj1);
//然後調用它：

(newFun1)

//結果爲: { name: 'obj1' } undefined undefined undefined undefined
//再加其他參數調用：

(newFun1 1 2 3 4)

//結果爲: { name: 'obj1' } 1 2 3 4
; 這就是 bind 操作的一般用法．
; 對於參數位置可調，有兩種站位符，它們是 bind 的屬性 "Anchor" 與 "Anchors", 分別表示站一個參數位與站後續所有參數位．
; 我們先在代碼裏手動命名兩個易用的變量．
A:(. bind "Anchor")
S:(. bind "Anchors")
fun2:(lambda (@argv)
	((. console "log") argv)
)
;我先把 bind 操作參數稱爲　"參數的模板(argvPattern)"
; bind 之後實際運行時的參數爲　"運行時參數(runtimeArgv)"
;那真正作用的在被 bind 的函數參數是實際參數 (argv)．
newFun2:(bind fun2 obj1 "a" A "b" A "ohters" S "END")
(newFun2 1 2 3 4)
;結果爲 : [ 'a', 1, 'b', 2, 'ohters', 3, 4, 'END' ]

name:(lazy)
(name "hello")
((. console "log") (name) )


i:0
y: (lazy (lambda ()
	i=(+ i 1)
	) true)
fun3:(lambda (x,y)
	((. console "log") x y ))
newFun3:(bind fun3 null "hello" y)
(newFun3)
(newFun3)
(newFun3)
(newFun3)

savedScope:
getCountFun:(lambda()
	savedScope=(getscope)
	count:1
	(lambda()
		count;
	)
)
getCount:(getCountFun)
((. console "log") (getCount)) # 1
(eval savedScope "count:2")
((. console "log") (getCount)) # 2

(getscope 1)
(try
	(load "include_script_file.sw")
	(lambda (e)
		((. console "log") e)
		)
	)


(GetScriptURI)

(GetScriptURI global)

array:[1,2,3,4]
((. array "forEach") (JSCallback (lambda (item)
	((. console "log") "Hi:" item)
	)))

(each array (lambda (item)
	((. console "log") "Hi:" item)
	))

array:[1,2,3,4,5,6]
newArray:(each array (lambda (item,idx,array,@ohters)
	(cond {(== idx 1)
		(continue)
	}{(== idx 4)
		(break)
	})
	((. console "log") "Hi==:" item ohters)
	item=(- item)
	),true,"this" "is" "others")

((. console "log") "<<<<<==newArray:" newArray)



"'" #單引號
'"' #雙引號

((. console "log") 
"--|\u5fc3|\067|\x37|\u0037|--
==============")

" This is first line .
This is second line .
"

`"
This is HereDoc.
This is second line .
\t\r\n ,all are not been translated.
"

`"StrEND
This is HereDoc.
This is second line .
\t\r\n ,all are not been translated.
"StrEND

`10
abcdefghij

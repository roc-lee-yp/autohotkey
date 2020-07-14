; 定时发微信信息AHK脚本 v0.9 by 李弱可
;
; 关于AutoHotKey脚本：
; 这是一个AutoHotKey脚本，使用它的方法分成三步：
; 【一】 安装AutoHotKey后在文件系统位置（比如桌面）通过右键新建一个 autohotkey script 文件； 
; 【二】 通过右键用记事本打开这个文件，将里面的内容替换成你写的脚本代码或者从别处复制来的脚本代码，并保存。
; 【三】 双击运行这个脚本文件，即可实现其功能。
; 
; 这个脚本的功能：
; 这个脚本的功能是在你选择的时间（具体到分钟）给你指定的某个微信好友发送一条你写好的文字消息。
; 
; 这个脚本的使用方法：
; 【一、前提】
; 必须打开微信PC端，且不能最小化到托盘（可以最小化到任务栏）
; 必须保持PC在运行状态（如果电脑进入休眠或睡眠状态就无法完成任务了）
;
; 【二、操作方法】
; 【1】通过 Win键 + m 组合键，打开信息输入界面，
;	根据提示输入对方微信ID，要发送的时间和内容等信息；
; 	然后持续等待就行了；
;	如果要添加一个定时发送任务，再按 Win + m 就行了。
;
; 【2】可以通过 Win + n 组合键，查看已输入且尚未执行的所有任务。
; 
; 【3】按 Win + b 组合键，可以通过输入序号删除某个定时发送任务。
; 	（序号可以先通过 Win + n 查询）
; 
; 免责声明：这个脚本代码杂乱功能简陋，主要是因为我懒导致的。建议自测可用性。敢批评我我就打文科生牌。（意思是我是文科生（逃

Gui, Font, s14
Gui, Add, Link, cBlue, <a href="https://www.zhihu.com/people/roc_lee">李弱可</a> 写的这个AutoHotKey脚本可以实现`n在PC端定时发送微信消息。
Gui, Add, Button, x+20, 查看使用说明
Gui, Add, Button, x15, 查看当前所有任务
Gui, Add, Button, x+20, 选择删除单条任务
Gui, Add, Button, x+20, 删除所有任务
Gui, Add, Text, x15, 输入对方的微信昵称：
Gui, Add, edit, vWeChatID0, %LastWeChatID%
Gui, Add, Text, , 搜索这个微信昵称的结果中，对方排第几位？
Gui, Add, ComboBox, vWeChatIDRank0, 1||2|3|4|5
Gui, Add, Text, , 输入想要发送的文字消息：
Gui, Add, edit, R10 W550 vMessageContent0
Gui, Add, Text, , 选择信息发送时间（通过键盘的上下键修改）
Gui, Add, DateTime, vMyDateTime, HH:mm yyyy/MM/dd ; 输入定时时间保存到 MyDateTime 变量
Gui, Add, Button, Default, OK

TaskIndex = 0

Loop
{

TaskExecutionIndex = 0 ; 准备把任务状态为 ready 的任务执行掉

Loop, %TaskIndex%
{
	TaskExecutionIndex := TaskExecutionIndex + 1
	If ( TaskStatus%TaskExecutionIndex% = "ready" )
		gosub SendWeChatMessage
	    Sleep 200
	
	CheckIndex = 0 ; 检查陈列的序号

	Loop, %TaskIndex%
	{
		CheckIndex := CheckIndex + 1
		FormatTime, CurrentDateTime, , HH:mm yyyy/MM/dd ; 当前时间保存到变量 CurrentDateTime
		TargetDateTime := TargetDateTime%CheckIndex%
		If ( TargetDateTime = CurrentDateTime ) ; 如果发现目标时间与当前时间一致
		{
		TaskStatus%CheckIndex% = ready　 ; 把当前任务状态设置为 ready
		
		SameTimeCheck = 0
		Loop, %TaskIndex%
		{
			SameTimeCheck := SameTimeCheck + 1
				If ( TargetDateTime%SameTimeCheck% = TargetDateTime )
					TaskStatus%SameTimeCheck% = ready ; 把所有与当前任务的目标时间一致的其他任务的状态改为 ready
		}
		}
	}

}

}

return



#m:: ; 通过 Windows + m 组合键启动输入界面
TaskIndex := TaskIndex + 1
  TaskStatus%TaskIndex% =
  Gui, Show, x800 y800
  GuiControl, Focus, WeChatID0
  Send ^a
Return

ButtonOK:
Gui, Submit
WeChatID%TaskIndex% := WeChatID0
WeChatIDRank%TaskIndex% := WeChatIDRank0
MessageContent%TaskIndex% := MessageContent0
LastWeChatID := WeChatID%TaskIndex%

FormatTime, TargetDateTime%TaskIndex%, %MyDateTime%, HH:mm yyyy/MM/dd
; 以下是按时间给任务排序
CompareIndex = 1
CompareTimes := TaskIndex - 1
Loop, %CompareTimes%
{
CompareXDate := TargetDateTime%TaskIndex%
CompareYDate := TargetDateTime%CompareIndex%
; 下面两行是把要比较的时间变成yyyyMMddHHmm的格式，方便比较大小
x := substr(CompareXDate, 7, 4)substr(CompareXDate, 12, 2)substr(CompareXDate, 15, 2)substr(CompareXDate, 1, 2)substr(CompareXDate, 4, 2)
y := substr(CompareYDate, 7, 4)substr(CompareYDate, 12, 2)substr(CompareYDate, 15, 2)substr(CompareYDate, 1, 2)substr(CompareYDate, 4, 2)

If ( CompareDateTime(x, y) = "true")
{
TargetDateTime0 := TargetDateTime%TaskIndex%
TargetDateTime%TaskIndex% := TargetDateTime%CompareIndex%
TargetDateTime%CompareIndex% := TargetDateTime0
TargetDateTime0 =

WeChatID0 := WeChatID%TaskIndex%
WeChatID%TaskIndex% := WeChatID%CompareIndex%
WeChatID%CompareIndex% := WeChatID0
WeChatID0 =

WeChatIDRank0 := WeChatIDRank%TaskIndex%
WeChatIDRank%TaskIndex% := WeChatIDRank%CompareIndex%
WeChatIDRank%CompareIndex% := WeChatIDRank0
WeChatIDRank0 =

MessageContent0 := MessageContent%TaskIndex%
MessageContent%TaskIndex% := MessageContent%CompareIndex%
MessageContent%CompareIndex% := MessageContent0
MessageContent0 =
}
CompareIndex := CompareIndex + 1
}
; 排序结束
return

Button查看使用说明:
Gosub Instruction
return

Button查看当前所有任务:
Sleep 200
Send #n
return

Button选择删除单条任务:
gosub DeleteOneTask
return

Button删除所有任务:
MsgBox, 1, 警告！！！, 选择 【 确定 】 将删除所有已录入的任务！
IfMsgBox Yes
Reload
return

SendWeChatMessage:
ClipboardOld := ClipboardAll
WeChatID := WeChatID%TaskExecutionIndex%
WeChatIDRank := WeChatIDRank%TaskExecutionIndex%
MessageContent := MessageContent%TaskExecutionIndex%
SplashTextOn, 400, 400, 注意, 定时发送微信消息任务即将开始，请停止一切手动操作！
Sleep 3000
SplashTextOff
Sleep 200
IfWinNotExist, ahk_exe WeChat.exe
  MsgBox, , 微信PC端没有打开哦，任务失败……
Else
{
	SplashTextOn, 400, 400, , 找到微信程序, 处于打开状态
	Sleep 1000
	SplashTextOff
IfWinNotActive, ahk_exe WeChat.exe
WinActivate, ahk_exe WeChat.exe
Sleep 100
WinWaitActive, ahk_exe WeChat.exe
Sleep 200
			SplashTextOn, 400, 400, , 找到微信程序后, 理论上刚刚把微信窗口激活了
WinMinimize, ahk_exe WeChat.exe
Sleep 2500
WinMaximize, ahk_exe WeChat.exe
			SplashTextOff
	Sleep 200
Send ^f
Clipboard = %WeChatID%
Sleep 500
Send ^v
WeChatIDRank := WeChatIDRank - 1
Loop, %WeChatIDRank%
{
Send {Down}
Sleep 200
}
Sleep 200
Send {Enter}
Clipboard = %MessageContent%
Sleep 500
Send ^v
Sleep 500
Send {Enter}
Clipboard := ClipboardOld
}
TaskStatus%TaskExecutionIndex% =
WeChatID%TaskExecutionIndex% =
WeChatIDRank%TaskExecutionIndex% =
MessageContent%TaskExecutionIndex% =
TargetDateTime%TaskExecutionIndex% =

return

#n::
TaskListAll = 当前任务列表：`n
TaskListIndex = 0
Loop, %TaskIndex%
{
 TaskListIndex := TaskListIndex + 1
 If ( StrLen(TargetDateTime%TaskListIndex%) > 4 )
	{
	TargetDateTime4List := TargetDateTime%TaskListIndex%
	WeChatID4List := WeChatID%TaskListIndex%
	WeChatIDRank4List := WeChatIDRank%TaskListIndex%
	MessageContent4List := MessageContent%TaskListIndex%
	TaskListAll = %TaskListAll%`n第【%TaskListIndex%】组，`n于%A_Space%%TargetDateTime4List%`n向微信ID「%WeChatID4List%」（在搜索结果排第%WeChatIDRank4List%位）`n发送消息:「%MessageContent4List%」`n
	}
}
Clipboard = %TaskListAll%
Run, Notepad
WinWaitActive, ahk_exe notepad.exe
Sleep 500
Send ^v
return

#b::
Gosub DeleteOneTask
return

DeleteOneTask:
InputBox, Task2Delete, 想要删除哪一组任务？, 输入想要删除的任务序号：
If (Task2Delete < TaskListIndex)
{
TransferTimes := TaskListIndex - Task2Delete
TaskLow := Task2Delete
Loop, %TransferTimes%
{
TaskHigh := TaskLow + 1
TaskStatus%TaskLow% := TaskStatus%TaskHigh%
WeChatID%TaskLow% := WeChatID%TaskHigh%
WeChatIDRank%TaskLow% := WeChatIDRank%TaskHigh%
MessageContent%TaskLow% := MessageContent%TaskHigh%
TargetDateTime%TaskLow% := TargetDateTime%TaskHigh%
TaskLow := TaskLow + 1
}
TaskStatus%TaskListIndex% =
WeChatID%TaskListIndex% =
WeChatIDRank%TaskListIndex% =
MessageContent%TaskListIndex% =
TargetDateTime%TaskListIndex% =
}
else
{
TaskStatus%Task2Delete% =
WeChatID%Task2Delete% =
WeChatIDRank%Task2Delete% =
MessageContent%Task2Delete% =
TargetDateTime%Task2Delete% =
}
return

Instruction:
MsgBox, , 使用说明, 定时发微信信息AHK脚本 v0.9 by 李弱可`n`n▂▃▅▆█ 功能 █▆▅▃▂`n这个脚本的功能是在你选择的时间（具体到分钟）给你指定的某个微信好友发送一条你写好的文字消息。`n`n▂▃▅▆█ 使用方法 █▆▅▃▂`n【一、前提】 `n必须打开微信PC端，且不能最小化到系统托盘（可以最小化到任务栏）`n必须保持PC在运行状态（如果电脑进入休眠或睡眠状态就无法完成任务了）`n`n【二、操作方法】`n【1】通过 Win键 + m 组合键，打开信息输入界面，`n根据提示输入对方微信ID，要发送的时间和内容等信息；`n然后持续等待就行了；`n如果要再添加一个定时发送任务，再按 Win + m 就行了。`n`n【2】可以通过 Win + n 组合键，查看已输入且尚未执行的所有任务。`n`n【3】按 Win + b 组合键，可以通过输入序号删除某个定时发送任务。`n（序号可以先通过 Win + n 查询）`n`n免责声明：这个脚本代码杂乱功能简陋，主要是因为我懒导致的。`n建议自测可用性。敢批评我我就打文科生牌。（意思是我是文科生（逃
return

CompareDateTime(xTime, yTime)
{
	If ( xTime < yTime )
		xTimeEarly = true
	else
		xTimeEarly = false
return xTimeEarly
}
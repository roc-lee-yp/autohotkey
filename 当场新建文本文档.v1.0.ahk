; 【 Windows当场新建文本文档的三种方法.v1.0.by.李弱可 】

; 方法1：直接调用右键菜单。前提是右键菜单里的新建文本文档已经设置了快捷键。
; 右键菜单设置新建文本文档快捷键的方法据知乎回答如下：
; ███ 以下为引文 ███
; 此方法在win10中测试过，重启后不会丢失。
; 按下win+r组合键呼出运行,输入regedit点击运行打开注册表,
; 定位到HKEY_CLASSES_ROOT\Local Settings\MuiCache\407\AAF68885@%SystemRoot%\system32\notepad.exe,-469
; 双击此键值，在 文本文档 后加上“ (&T)” ，
; 以后你右键+w+t就新建文档了。
; PS:别忘了括号前面的那个空格(-:
; 作者：夕海 链接：https://www.zhihu.com/question/31618244/answer/96199679
; ███ 以上为引文 ███

#b::
sleep 200
Click Right
sleep 50
Send w
sleep 50
Send t
return

; 方法2：通过地址栏获取路径，新建文本文档。
; 隐患：在桌面无法通过此方法完成，所以需要更全能的方法3。

#m::
TempClipboard := Clipboard
InputBox, TxtTitle, 请输入要新建的文本文档的文件名, , , , , , , , , 新建文本文档_%A_Now%
sleep 200
Send !d
sleep 50
Send ^c
FileAppend, , %clipboard%\%TxtTitle%.txt
Run %clipboard%\%TxtTitle%.txt
clipboard := TempClipboard
return

; 方法3：新建文件夹，通过文件夹属性获取路径，再在路径下新建文本文档，然后再删除新建的文件夹。

#n::
TempClipboard := Clipboard
InputBox, TxtTitle, 请输入要新建的文本文档的文件名, , , , , , , , , 新建文本文档_%A_Now%
Sleep 200
Send ^+n
Sleep 50
Clipboard := A_Now
Send ^v
Send {Enter 2}
Sleep 2000
Send !d
Sleep 50
Send ^c
TempDIR := clipboard
StringTrimRight, TargetDIR, clipboard, 15
FileAppend, , %TargetDIR%\%TxtTitle%.txt
clipboard := TempClipboard
FileRemoveDir, %TempDIR%
Run %TargetDIR%\%TxtTitle%.txt
return

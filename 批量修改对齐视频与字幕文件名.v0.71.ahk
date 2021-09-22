; autohotkey
; 批量修改对齐视频与字幕文件名 v0.71 by 李弱可
; 请将脚本与视频、字幕放入同一文件夹使用。

Gui, Font, s14
Gui, Add, Text, x18, 请正确输入视频与字幕文件的扩展名
Gui, Add, Text, x18, 视频格式为 .
Gui, Add, edit, x+0 vVideoFormat, mkv
Gui, Add, Text, x18, 字幕格式为 .
Gui, Add, edit, x+0 vSubFormat, ass
Gui, Add, Button, Default, OK
Gui, Show, x900 y400, 输入扩展名

return

ButtonOK:
Gui, Submit
Loop, *.%VideoFormat%
{
 StringTrimRight, Filename, A_LoopFileName,  StrLen(A_LoopFileExt)
 FileAppend, %Filename%`n, VideoFileNames.txt
}

n := 1
Loop, *.%SubFormat%
{
 StringTrimRight, Filename, A_LoopFileName,  StrLen(A_LoopFileExt)
 FileAppend, %Filename%`n, SubFileNames.txt
 FileReadLine, VideoFileName, VideoFileNames.txt, %n%
 FileAppend, %VideoFileName%`,%Filename%`n, FileNameEquation.csv
 FileAppend, %VideoFileName%%VideoFormat%对应为`n%Filename%%SubFormat%`n, FileNameEquation.txt
 n := n + 1
}

FileRead, FileNameEquation, FileNameEquation.txt,
Gui, New
Gui, Font, s14
Gui, Add, Button, x18, 开始批量对齐文件名
Gui, Add, Button, x+10, 放弃修改并退出
Gui, Add, Text, x18, 下方列表如未完整显示文件对应信息：
Gui, Add, Button, x+10, 查看完整文件对应信息
Loop, Read, FileNameEquation.txt,
{
 Gui, Add, text, x18, %A_LoopReadLine%
}

Gui, Show, w900 h400
return

Button开始批量对齐文件名:
Loop, Read, FileNameEquation.csv
{
 StringSplit, MyArray, A_LoopReadLine, `,
 FileMove, %MyArray2%%SubFormat%, %MyArray1%%SubFormat%
 FileDelete, %MyArray2%%SubFormat%
}
FileDelete, FileNameEquation.txt
FileDelete, FileNameEquation.csv
FileDelete, VideoFileNames.txt
FileDelete, SubFileNames.txt
Gui, destroy
ExitApp 
return

Button放弃修改并退出:
FileDelete, FileNameEquation.txt
FileDelete, FileNameEquation.csv
FileDelete, VideoFileNames.txt
FileDelete, SubFileNames.txt
Gui, destroy
ExitApp 
return

Button查看完整文件对应信息:
Run FileNameEquation.txt
return
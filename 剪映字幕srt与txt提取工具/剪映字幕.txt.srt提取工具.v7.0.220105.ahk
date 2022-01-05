SoftVersion = 剪映json字幕提取工具（txt/srt） v7.0.220105 by李弱可
; 用剪映自动识别字幕后，提取字幕文本
; 暂时还没做.srt导出功能

Menu, Tray, NoMainWindow
Menu, Tray, Add, 打开主窗口

Gui, Font, s14

Gui, Add, Button, , 【0】使用说明
Gui, Add, Button, , 【1】选择剪映draft_content.json文件
Gui, Add, Button, , 【2】提取字幕内容（分行）
Gui, Add, Button, , 【3】提取字幕内容（不分行）
Gui, Add, Button, , 【4】生成.srt字幕文件
Gui, Add, Button, x+20, 打开字幕文件所在文件夹
Gui, Add, Button, x17, 【5】设置剪映草稿文件夹位置（设置一次即可）

Gui, show, w500, %SoftVersion%

return

Button【0】使用说明:
MsgBox, , 使用说明, 第一次使用时，用【5】进行设置，`n设置界面有路径提示；`n用【1】选择相应草稿的draft_content.Json文件，`n草稿通常在以日期命名的文件夹中；`n接下来可选择【2】或【3】或【4】生成所需文件，`n【2】可提取字幕内容，一条条分行，适用于微调断句等场合，`n【3】可提取不分行的字幕文本，适用于整理文稿，`n【4】则可直接导出.srt字幕文件。`n建议用【2】或【3】导出自动识别的文本，修正内容和断句后，`n使用剪映【文稿匹配】功能重做字幕，`n再用【4】生成srt文件。

return

打开主窗口:
Gui, show, w500, %SoftVersion%
return

Button【1】选择剪映draft_content.json文件:
IniRead, Path, 剪映json字幕转txt.ini, ProjectPath, Path,
FileSelectFile, JsonFilePath, , %Path%
FileCreateDir, 生成字幕
return

Button打开字幕文件所在文件夹:
Run, 生成字幕
return

Button【5】设置剪映草稿文件夹位置（设置一次即可）:
FileSelectFolder, Path, , , 通常位于C:\Users/用户\你的用户名\AppData\Local\JianyingPro\User Data\Projects\com.lveditor.draft
IniWrite, %Path%, 剪映json字幕转txt.ini, ProjectPath, Path
return

Button【3】提取字幕内容（不分行）:
FileEncoding, UTF-8
FileRead, WholeText, %JsonFilePath%
Loop
{
StringGetPos, ContentPos, WholeText, content`"`:`"
; 搜索字幕文字前面的标识字符
	if (ErrorLevel = 0)
	{
	ContentPos := ContentPos + 10

	StringTrimLeft, WholeText, WholeText, %ContentPos%
	; 将字幕文字前面的部分删去

	StringGetPos, FontPos, WholeText, `"`,`"font
	; 搜索字幕文字后面的标识字符

	StringLeft, UsefulPart, WholeText, %FontPos%
	; 提取一条字幕文字

	TargetText = %TargetText%%UsefulPart%
	; 并入字幕文字合辑

	}
	else
	break	
}

CurrentTime := A_Now
FileAppend, %TargetText%, 生成字幕\字幕稿(不分行)%CurrentTime%.txt, UTF-8
Run, 生成字幕\字幕稿(不分行)%CurrentTime%.txt

TargetText :=

return

Button【2】提取字幕内容（分行）:
FileEncoding, UTF-8
FileRead, WholeText, %JsonFilePath%
Loop
{
StringGetPos, ContentPos, WholeText, content`"`:`"
; 搜索字幕文字前面的标识字符
	if (ErrorLevel = 0)
	{
	ContentPos := ContentPos + 10

	StringTrimLeft, WholeText, WholeText, %ContentPos%
	; 将字幕文字前面的部分删去

	StringGetPos, FontPos, WholeText, `"`,`"font
	; 搜索字幕文字后面的标识字符

	StringLeft, UsefulPart, WholeText, %FontPos%
	; 提取一条字幕文字

	TargetText = %TargetText%`n%UsefulPart%
	; 并入字幕文字合辑

	}
	else
	break	
}

CurrentTime := A_Now
FileAppend, %TargetText%, 生成字幕\字幕稿（分行）%CurrentTime%.txt, UTF-8
Run, 生成字幕\字幕稿（分行）%CurrentTime%.txt
TargetText :=

return

Button【4】生成.srt字幕文件:
FileEncoding, UTF-8
FileRead, WholeText, %JsonFilePath%
SubtitleIteration := 1
Loop
{
StringGetPos, ContentPos, WholeText, content`"`:`"
; 搜索字幕文字前面的标识字符
	if (ErrorLevel = 0)
	{
	ContentPos := ContentPos + 10

	StringTrimLeft, WholeText, WholeText, %ContentPos%
	; 将字幕文字前面的部分删去

	StringGetPos, IDPos, WholeText, `"id`"
	; 搜索这条字幕的id
	
	IDPos := IDPos + 5
	
	StringTrimLeft, IDText, WholeText, %IDPos%
	; 将ID前面的部分删去
	
	StringGetPos, IDEndPos, IDText, initial_scale
	; 搜索ID后面的标识字符
	
	StringTrimLeft, IDwithTime, IDText, %IDEndPos%
	; 剩余部分文字里该ID只出现一次，与时间信息一起
	
	IDEndPos := IDEndPos - 3
	
	StringLeft, IDText, IDText, %IDEndPos%
	; 获取最后的ID

	StringGetPos, IDPos2, IDwithTime, %IDtext%
	
	StringTrimLeft, IDwithTime, IDwithTime, %IDPos2%
	; 文本截至到ID处，所以下面第一条时间信息是该ID的时间信息
	
	x = duration`"`:
	y = `,`"start`"`:
	
	DurationNumber := StringSelect(x, y, IDwithTime)
	
	x = `}
	StartNumber := StringSelect(y, x, IDwithTime)
	
	EndNumber := StartNumber + DurationNumber
	
	StartTime := JianYingTimeFormat(StartNumber)
	EndTime := JianYingTimeFormat(EndNumber)
	
	TimeCode = %StartTime%%A_Space%-->%A_Space%%EndTime%

	StringGetPos, FontPos, WholeText, `"`,`"font
	; 搜索字幕文字后面的标识字符

	StringLeft, UsefulPart, WholeText, %FontPos%
	; 提取一条字幕文字

	TargetText = %TargetText%%SubtitleIteration%`n%TimeCode%`n%UsefulPart%`n`n
	; 并入字幕文字合辑
	
	SubtitleIteration := SubtitleIteration + 1
	}
	else
	break	
}

CurrentTime := A_Now
FileAppend, %TargetText%, 生成字幕\字幕%CurrentTime%.txt
FileAppend, %TargetText%, 生成字幕\字幕%CurrentTime%.srt
Run, 生成字幕\字幕%CurrentTime%.txt
TargetText :=

return

; 选取x与y之间文本函数示例
; x = `:
; y = is_
; z = asdg`:agdsagis_aglq
StringSelect(x, y, z)
{
		StringGetPos, Xpos, z, %x%
		Xpos := Xpos + StrLen(x)
		StringTrimLeft, z1, z, %Xpos%
		StringGetPos, Ypos, z1, %y%
		StringLeft, z2, z1, %Ypos%
		return z2
}

; 把剪映里的时间码变成srt的时间码格式
JianYingTimeFormat(x)
{
	x := Round(x, -2)
	StringTrimRight, x, x, 3
	StringRight, MiliSec, x, 3
	StringTrimRight, x, x, 3
	Second := Mod(x, 60)
	Minute := Floor(x/60)
	Minute := Mod(Minute, 60)
	If (x > 3600)
	Hour := Floor(x/3600)
	else Hour = 00
	
	Hour := TwoDigits(Hour)
	Minute := TwoDigits(Minute)
	Second := TwoDigits(Second)
	
	TimeFormat = %Hour%`:%Minute%`:%Second%`,%MiliSec%
	return TimeFormat
	
}

; 如果数字不足两位，就在前面加一位0
TwoDigits(x)
{
	If (StrLen(x) < 2)
			x = 0%x%
	return x
}
Menu, tray, Icon, 5.ico

#d::
sleep 200
WinGetTitle, whattitle, A
TitleSearchGoal = idope
IfInString, whattitle, %TitleSearchGoal%
{
Send ^f
Sleep 100
Clipboard := "magnet:?xt="
Send ^v
Sleep 100
Send {Enter}
Sleep 200
Send {Escape}
Sleep 100
Send +{End}
sleep 100
Send ^c
}


IfWinExist, ahk_exe 115chrome.exe
{
	WinActivate
	CoordMode, Pixel
	CoordMode, Mouse
	sleep 500

	ImageSearch, OutputVarX, OutputVarY, 0, 0, A_ScreenWidth, A_ScreenHeight, upload.bmp
	If (ErrorLevel = 1)
	return
	OutPutVarX := OutPutVarX + 1
	OutPutVarY := OutPutVarY + 13
	Sleep 50
	MouseMove, OutputVarX, OutputVarY
	Sleep 200
	OutPutVarX := OutPutVarX + 4
	OutPutVarY := OutPutVarY + 50
	MouseMove, OutputVarX, OutputVarY
	Click
	Sleep 200
	Send ^v
	Sleep 100
	Send {Tab 4}
	Sleep 100
	Send {Enter}
	Sleep 1000
	WinMinimize


}
return
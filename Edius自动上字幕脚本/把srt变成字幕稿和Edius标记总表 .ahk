; 把srt变成字幕稿和Edius标记总表 v1.0 by 李弱可
FileSelectFile, TargetSrt, , E:\roc.short.videos\神奇女侠1984欢送特朗普\输出\, , srt字幕文件(*.srt)
SplitPath, TargetSrt, , SrtFilesFolder, , SrtFileName,
OriginalWorkingDir := A_WorkingDir
SetWorkingDir, %SrtFilesFolder%
FolderNameTime := A_Now
SrtFolderName = %SrtFileName%%FolderNameTime%
FileCreateDir, %SrtFolderName%
FileAppend, , %SrtFolderName%/字幕稿.txt, UTF-16
MarkListHead = # EDIUS Marker list`n# Format Version 3`n# Created Date : Mon Nov 06 04:41:45 2017`n#`n# No, Anchor, Position, Duration, Comment`n
FileAppend, , %SrtFolderName%/入点标记列表.csv, UTF-8-RAW
FileAppend, %MarkListHead%, %SrtFolderName%/入点标记列表.csv, UTF-8-RAW
FileAppend, , %SrtFolderName%/出点标记列表.csv, UTF-8-RAW
FileAppend, %MarkListHead%, %SrtFolderName%/出点标记列表.csv, UTF-8-RAW
FileAppend, , %SrtFolderName%/标记总表.csv, UTF-8-RAW
FileAppend, %MarkListHead%, %SrtFolderName%/标记总表.csv, UTF-8-RAW

TitleIndex := 1
StartCopying = false

SrtInTimeIndex := 1
SrtOutTimeIndex := 1
CurrentOutTimeCodeMark =
SkipCollisionTimeMark := 0
SrtTimeMarkTotal := 1

Loop, Read, %TargetSrt%
{
	If (A_LoopReadLine = 1)
		StartCopying = true
	If (StartCopying = "true")
	{
		If (A_LoopReadLine = TitleIndex) ; 是序号行
		{
			TitleIndex := TitleIndex + 1
			NewTitle = true
		}
		else ; 不是序号行的情况
		{
					TimeCodeLine = false
				If (StrLen(A_LoopReadLine) > 28)
				{
					IfInString, A_LoopReadLine, -->
					TimeCodeLine = true
				
					If not (SubStr(A_LoopReadLine, 9, 1) = ",")
					TimeCodeLine = false
				
				
					If not (SubStr(A_LoopReadLine, 6, 1) = ":")
					TimeCodeLine = false
				
					If not (SubStr(A_LoopReadLine, 3, 1) = ":")
					TimeCodeLine = false
					
				}
				
				If (TimeCodeLine = "true")
				{
					; 保存入点时间码：
					SrtInHour := SubStr(A_LoopReadLine, 1, 2)
					SrtInMin := SubStr(A_LoopReadLine, 4, 2)
					SrtInSec := SubStr(A_LoopReadLine, 7, 2)
					SrtInFrame := SubStr(A_LoopReadLine, 10, 3)
					SrtInFrameFloor := Floor(SrtInFrame*24/1000)/100
					StringLeft, SrtInFrameFloor, SrtInFrameFloor, 4
					StringRight, SrtInFrame, SrtInFrameFloor, 2


					
					; 如果新入点跟上一个出点不重叠，直接添加出点到标记列表。
					SrtCollision = true
					
					If (SrtOutHour != SrtInHour)
						SrtCollision = false
					
					If (SrtOutMin != SrtInMin)
						SrtCollision = false
					
					If (SrtOutSec != SrtInSec)
					SrtCollision = false
					
					If (SrtOutFrame != SrtInFrame)
					SrtCollision = false
					
					
					If ( SrtCollision = "true" ) ; 否则修改入点，推迟一帧
						{
						SkipCollisionTimeMark := SkipCollisionTimeMark + 1
							If ( SrtInFrame > 22 )
								{
								SrtOutFrame := SrtOutFrame - 1
								If ( Strlen(SrtOutFrame) = 1 )
								SrtOutFrame = 0%SrtOutFrame%
								}
							else
								{
								SrtInFrame := SrtInFrame + 1
								If ( Strlen(SrtInFrame) = 1 )
								SrtInFrame = 0%SrtInFrame%
								}
						
						}
						
						
					If ( StrLen(SrtOutHour) > 0 )	; 如果出点信息已存在，把上一个出点信息添入标记总表
					{
					CurrentSrtTimeMarkTotal = %SrtTimeMarkTotal%, ON, %SrtOutHour%:%SrtOutMin%:%SrtOutSec%:%SrtOutFrame%, ,"out"`n
					FileAppend, %CurrentSrtTimeMarkTotal%, %SrtFolderName%/标记总表.csv, UTF-8-RAW
					SrtTimeMarkTotal := SrtTimeMarkTotal + 1	
					}	
						
						
					CurrentInTimeCodeMark = %SrtInTimeIndex%, ON, %SrtInHour%:%SrtInMin%:%SrtInSec%:%SrtInFrame%, ,""`n
					FileAppend, %CurrentInTimeCodeMark%, %SrtFolderName%/入点标记列表.csv, UTF-8-RAW
					SrtInTimeIndex := SrtInTimeIndex + 1
					
					CurrentSrtTimeMarkTotal = %SrtTimeMarkTotal%, ON, %SrtInHour%:%SrtInMin%:%SrtInSec%:%SrtInFrame%, ,"in"`n
					FileAppend, %CurrentSrtTimeMarkTotal%, %SrtFolderName%/标记总表.csv, UTF-8-RAW
					SrtTimeMarkTotal := SrtTimeMarkTotal + 1							
					

					; 保存出点时间码：
					SrtOutHour := SubStr(A_LoopReadLine, 18, 2)
					SrtOutMin := SubStr(A_LoopReadLine, 21, 2)
					SrtOutSec := SubStr(A_LoopReadLine, 24, 2)
					SrtOutFrame := SubStr(A_LoopReadLine, 27, 3)
					SrtOutFrameFloor := Floor(SrtOutFrame*24/1000)/100
					StringLeft, SrtOutFrameFloor, SrtOutFrameFloor, 4
					StringRight, SrtOutFrame, SrtOutFrameFloor, 2
					CurrentOutTimeCodeMark = %SrtOutTimeIndex%, ON, %SrtOutHour%:%SrtOutMin%:%SrtOutSec%:%SrtOutFrame%, ,""`n
					
					FileAppend, %CurrentOutTimeCodeMark%, %SrtFolderName%/出点标记列表.csv, UTF-8-RAW
					SrtOutTimeIndex := SrtOutTimeIndex + 1			
					

				}
				else
				{
				; 如果NewTitle是true，在字幕稿里加`n分行再粘A_LoopReadLine
				; 粘完第一行把NewTitle改为false,
				;
					if (NewTitle = "true")
					{
					
						if (TitleIndex = 2)  ; 如果是全稿第一行
						{
						FileAppend, %A_LoopReadLine%, %SrtFolderName%/字幕稿.txt, UTF-16
						NewTitle = false
						}
						else
						{
					; 如果不是全稿第一行，只是当前字幕条的第一行
						FileAppend, `n%A_LoopReadLine%, %SrtFolderName%/字幕稿.txt, UTF-16
						NewTitle = false
						}
					
					}
					else
					{
					If (StrLen(A_LoopReadLine) > 0)
					FileAppend, ``n%A_LoopReadLine%, %SrtFolderName%/字幕稿.txt, UTF-16
					}
				
				}
			
			}
		}
	}
	
					CurrentSrtTimeMarkTotal = %SrtTimeMarkTotal%, ON, %SrtOutHour%:%SrtOutMin%:%SrtOutSec%:%SrtOutFrame%, ,"out"`n
					FileAppend, %CurrentSrtTimeMarkTotal%, %SrtFolderName%/标记总表.csv, UTF-8-RAW
	
FileRead, AllCsv, %SrtFolderName%/标记总表.csv
Loop, read, %SrtFolderName%/字幕稿.txt
{
		StringReplace, AllCsv, AllCsv, "in", "%A_LoopReadLine%"
}
FileAppend, %AllCsv%, %SrtFolderName%/标记总表带字幕注示.csv



Run, %A_WorkingDir%/%SrtFolderName%
SetWorkingDir, %OriginalWorkingDir%


return

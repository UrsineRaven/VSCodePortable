SetBatchLines -1
#NoEnv
Version=1.0.0-beta.2
AppRoot=%A_ScriptDir%\..\..
FileCreateDir, %AppRoot%\Data\Settings
FileCreateDir, %AppRoot%\Data\Temp

;; TODO: add GUI back in
;; TODO: update script to use latest AutoHotkey standards (probably need to look at documentation of all used commands)
;; TODO: refactor to use classes and functions
;; TODO: use progress bar instead of tooltips

Name=vscode
Name2=VSCode
Name3=Code
DownloadURL=https://update.code.visualstudio.com/latest/win32-x64-archive/stable
UpdateURL=https://code.visualstudio.com/updates
SearchText=/win32-x64-user/stable">User</a>

;; =====Install if it doesn't exist=====
FileCreateDir, %AppRoot%\App\%Name2%
IfNotExist, %AppRoot%\App\%Name2%\%Name3%.exe
{
	Gosub DownloadAndInstall
	Return
}

;; =====Check For Updates=====
TrayTip,,Checking %Name2% for updates...
UpdateExists=0

;; Get Local Version Number
FileGetVersion, LocalV,%AppRoot%\App\%Name2%\%Name3%.exe
StringSplit, LV, LocalV,.
LocalV=%LV1%.%LV2%.%LV3%

;; Get Online Version Number
Gosub GetOnlineVersion
OV := StrSplit(Found, "visualstudio.com/")
OV := StrSplit(OV[2], "/")
OnlineV := OV[1]

;; Compare Version Numbers
StringSplit, L, LocalV,.
StringSplit, I, OnlineV,.
If (Abs(L1)!=Abs(I1) || Abs(L2)!=Abs(I2) || Abs(L3)!=Abs(I3))
	UpdateExists=1
	
TrayTip ;; Prior to Windows 10, you could dismiss tray ToolTips this way...

;; Prompt User To Install Update
If UpdateExists
	If (LocalV Not="" or OnlineV Not="")
	{
		MsgBox, 4,, New Update Found For %Name2%. Update Now?`nCurrentVersion: %LocalV%`nNewVersion: %OnlineV%
		ifmsgbox Yes
		{
			;; Install Update
			TrayTip,,Removing old install of %Name2%...
			Loop, %AppRoot%\App\%Name2%\*, 1
				If A_LoopFileName not= "data"
				{
					FileDelete, %A_LoopFileFullPath%
					FileRemoveDir, %A_LoopFileFullPath%, 1
				}
			Gosub DownloadAndInstall
		}
	}
Else
	TrayTip,,%Name2% is up to date!
Return

GetOnlineVersion:
urldownloadtofile, %UpdateURL%, %AppRoot%\Data\Temp\%Name2%.htm
Loop, Read, %AppRoot%\Data\Temp\%Name2%.htm
    Loop, parse, A_LoopReadLine, `n
	{
	    If A_LoopField =
			Continue
		If A_LoopField contains %SearchText%
			Found = %A_LoopField%
	}
FileDelete, %AppRoot%\Data\Temp\%Name2%.htm
Return

DownloadAndInstall:
TrayTip,,Downloading %Name2%...
urldownloadtofile, %DownloadURL%, %AppRoot%\Data\Temp\%Name%.zip
;; TODO: Handle errors
TrayTip,,Extracting %Name2%...
RunWait, %AppRoot%\App\Bin\7za.exe x "%AppRoot%\Data\Temp\%Name%.zip" -o"%AppRoot%\App\%Name2%,, Hide
TrayTip ;; Prior to Windows 10, you could dismiss tray ToolTips this way...
FileCreateDir, %AppRoot%\App\%Name2%\data
FileCreateDir, %AppRoot%\App\%Name2%\data\tmp
FileDelete %AppRoot%\Data\Temp\%Name%.zip
Return

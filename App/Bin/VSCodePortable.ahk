SetBatchLines -1
#NoEnv
FileCreateDir, %A_ScriptDir%\..\..\Data\Settings
FileCreateDir, %A_ScriptDir%\..\..\Data\Temp

;; TODO: add GUI back in
;; TODO: update script to use latest AutoHotkey standards (probably need to look at documentation of all used commands)
;; TODO: refactor to use classes and functions
;; TODO: use progress bar instead of tooltips

Name=vscode
Name2=VSCode
Name3=Code
DownloadURL=https://update.code.visualstudio.com/latest/win32-x64-archive/stable
UpdateURL=https://code.visualstudio.com/updates
Look=/win32-x64-user/stable">User</a>

FileCreateDir, %A_ScriptDir%\..\..\App\%Name2%
IfNotExist, %A_ScriptDir%\..\..\App\%Name2%\%Name3%.exe
{
	Gosub Dialogs
	Return
}

TrayTip,,Checking %Name2% for updates...
FileGetVersion, LocalV,%A_ScriptDir%\..\..\App\%Name2%\%Name3%.exe
UpdateExists=0
;; Get version number from LocalV if it's not the whole thing
StringSplit, LV, LocalV,.
LocalV=%LV1%.%LV2%.%LV3%
Gosub GetOnlineVersion
V := StrSplit(Found, "visualstudio.com/")
V := StrSplit(V[2], "/")
Number := V[1]
StringSplit, L, LocalV,.
StringSplit, I, Number,.
If (Abs(L1)!=Abs(I1) || Abs(L2)!=Abs(I2) || Abs(L3)!=Abs(I3))
	UpdateExists=1
	
TrayTip
If UpdateExists
	If (LocalV Not="" or Number Not="")
	{
		MsgBox, 4,, New Update Found For %Name2%. Update Now?`nCurrentVersion: %LocalV%`nNewVersion: %Number%
		ifmsgbox Yes
		{
			TrayTip,,Backing up the settings for %Name2%...
			FileRemoveDir, %A_ScriptDir%\..\..\Data\Settings\%Name2%\data, 1
			;;FileRemoveDir, %A_ScriptDir%\..\..\App\%Name2%\data\tmp, 1	; TODO: make this an option (maybe allow keeping certain folders inside)
			FileMoveDir, %A_ScriptDir%\..\..\App\%Name2%\data, %A_ScriptDir%\..\..\Data\Settings\%Name2%\data, 2
			FileRemoveDir, %A_ScriptDir%\..\..\App\%Name2%, 1
			FileCreateDir, %A_ScriptDir%\..\..\App\%Name2%
			Gosub Dialogs
			TrayTip,,Restoring the settings for %Name2%...
			FileCopyDir, %A_ScriptDir%\..\..\Data\Settings\%Name2%\data, %A_ScriptDir%\..\..\App\%Name2%\data, 1
			;; TODO: make option to delete settings backup after restore
		}
	}
Else
	TrayTip,,%Name2% is up to date!
Return

GetOnlineVersion:
urldownloadtofile, %UpdateURL%, %A_ScriptDir%\..\..\Data\Temp\%Name2%.htm
Loop, Read, %A_ScriptDir%\..\..\Data\Temp\%Name2%.htm
    Loop, parse, A_LoopReadLine, `n
	{
	    If A_LoopField =
			Continue
		If A_LoopField contains %look%
			Found = %A_LoopField%
	}
FileDelete, %A_ScriptDir%\..\..\Data\Temp\%Name2%.htm
Return

Dialogs:
SetBatchLines -1
TrayTip,,Downloading %Name2%...
urldownloadtofile, %DownloadURL%, %A_ScriptDir%\..\..\Data\Temp\%Name%.zip
;; Handle errors
TrayTip,,Extracting %Name2%...
RunWait, %A_ScriptDir%\..\..\App\Bin\7za.exe x "%A_ScriptDir%\..\..\Data\Temp\%Name%.zip" -o"%A_ScriptDir%\..\..\App\%Name2%,, Hide
FileCreateDir, %A_ScriptDir%\..\..\App\%Name2%\data
FileCreateDir, %A_ScriptDir%\..\..\App\%Name2%\data\tmp
TrayTip
FileDelete %A_ScriptDir%\..\..\Data\Temp\%Name%.zip
Return

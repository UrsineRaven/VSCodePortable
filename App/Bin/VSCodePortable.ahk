SetBatchLines -1
#NoEnv

global Program := "VSCodePortable"
global Version := "1.0.0-beta.3"
global AppRoot := A_ScriptDir . "\..\.."
FileCreateDir, %AppRoot%\Data\Settings
FileCreateDir, %AppRoot%\Data\Temp

;; TODO: add GUI back in
;; TODO: Maybe use classes to make it easier to reuse this on other apps in the future
;; TODO: Double check some of the old logic that I don't remember the purpose of

;; =====Main=====
Progress, M2 T W400, %A_Space%, %A_Space%, %Program% %Version%
AppInfo := GetAppInfo()
Installed := InstallIfMissing(AppInfo)
If Installed
	Return
UpdateExists := CheckForUpdates(AppInfo)
If UpdateExists
{
	InstallNow := PromptUserAboutUpdate(AppInfo.Name, UpdateExists.LocalVersion, UpdateExists.OnlineVersion)
	If InstallNow
	{
		UninstallApp(AppInfo.Name)
		DownloadAndInstall(AppInfo.Name, AppInfo.AltName . "-" . UpdateExists.OnlineVersion, AppInfo.DownloadUrl)
		UpdateExists := "" ;; free object since we're done with it
		Progress,100,% "Successfully updated " AppInfo.Name . "!"
	}
	Else
		Progress, 100, User declined update.
}
Else
	Progress,100,% AppInfo.Name . " is up to date!"
AppInfo := ""	;; Isn't necessary, but doing it to remember to free object other times that they are used
Sleep, 2000
Return

;; =====Functions=====

;; Initialize App Info
GetAppInfo() {
	AppInfo := { Name: "VSCode"
		, AltName: "vscode"
		, ExeName: "Code"
		, DownloadUrl: "https://update.code.visualstudio.com/latest/win32-x64-archive/stable"
		, UpdateUrl: "https://code.visualstudio.com/updates"
		, SearchText: "/win32-x64-user/stable"">User</a>" }
	Return AppInfo
}

;; Install App if it doesn't exist
InstallIfMissing(AppInfo) {
	AppName := AppInfo.Name
	Progress,10,Checking installation status..., %AppName%
	Progress, Show
	AppFolder := Format("{1}\App\{2}", AppRoot, AppInfo.Name)
	ExePath := Format("{1}\{2}.exe", AppFolder, AppInfo.ExeName)
	FileCreateDir, %AppFolder%
	If !FileExist(ExePath)
	{
		DownloadAndInstall(AppInfo.Name, AppInfo.ZipName, AppInfo.DownloadUrl)
		Return True
	}
	Else Return False
}

;; Download app and Install it
DownloadAndInstall(AppName, ZipName, DownloadUrl) {
	;; Download Zip
	Progress,70,Downloading update...
	UrlDownloadToFile, %DownloadUrl%, %AppRoot%\Data\Temp\%ZipName%.zip
	
	;; TODO: Handle errors

	;; Extract Zip
	Progress,80,Extracting update...
	RunWait, %AppRoot%\App\Bin\7za.exe x "%AppRoot%\Data\Temp\%ZipName%.zip" -o"%AppRoot%\App\%AppName%,, Hide
	TrayTip ;; Prior to Windows 10, you could dismiss tray ToolTips this way...
	
	;; Make Sure VSCode is in portable mode
	FileCreateDir, %AppRoot%\App\%AppName%\data
	FileCreateDir, %AppRoot%\App\%AppName%\data\tmp

	;; Remove Install Zip
	Progress,90,Cleaning up...
	FileDelete %AppRoot%\Data\Temp\%ZipName%.zip
	Return
}

;; Check if an update exists
CheckForUpdates(AppInfo) {
	Progress,20,% "Checking for updates..."
	ExePath := Format("{1}\App\{2}\{3}.exe", AppRoot, AppInfo.Name, AppInfo.ExeName)

	;; Get Local Version Number
	FileGetVersion, LocalV,%ExePath%
	LV := StrSplit(LocalV, ".")
	LocalV := Format("{}.{}.{}",LV[1],LV[2],LV[3])

	;; Get Online Version Number
	FoundText := GetOnlineVersion(AppInfo.Name, AppInfo.UpdateUrl, AppInfo.SearchText)
	OV := StrSplit(FoundText, "visualstudio.com/",,3)
	OV := StrSplit(OV[2], "/",,2)
	OnlineV := OV[1]

	;; Compare Version Numbers
	L := StrSplit(LocalV, ".")
	O := StrSplit(OnlineV, ".")
	TrayTip ;; Prior to Windows 10, you could dismiss tray ToolTips this way...
	If (Abs(L[1])!=Abs(O[1]) || Abs(L[2])!=Abs(O[2]) || Abs(L[3])!=Abs(O[3])) ;; I don't remember why I wasn't just string comparing the versions, but I'm sure there was a good reason...
		Return {LocalVersion: LocalV, OnlineVersion: OnlineV}
	Return False
}

;; Retrieve the app's latest version from online
GetOnlineVersion(AppName, UpdateUrl, SearchText) {
	Progress,25
	FoundText=
	UrlDownloadToFile, %UpdateUrl%, %AppRoot%\Data\Temp\%AppName%.htm
	Loop, Read, %AppRoot%\Data\Temp\%AppName%.htm
		Loop, parse, A_LoopReadLine, `n
		{
			If A_LoopField =
				Continue
			If A_LoopField contains %SearchText%
				FoundText = %A_LoopField%
		}
	FileDelete, %AppRoot%\Data\Temp\%AppName%.htm
	Return FoundText
}

;; Ask the user if they want to install the update now
PromptUserAboutUpdate(AppName, LocalVersion, OnlineVersion) {
	Progress,30,Prompt user about update...
	If (LocalVersion != "" or OnlineVersion != "") ;; don't remember why I used this logic...
	{
		MsgBox, 4100,, New Update Found For %AppName%. Update Now?`nCurrentVersion: %LocalVersion%`nNewVersion: %OnlineVersion%
		IfMsgBox Yes
			Return True
	}
	Return False
}

;; Uninstall App (and preserves VSCodes settings/extensions/etc)
UninstallApp(AppName) {
	prog := 40
	Progress,%prog%,Removing the old install...
	Loop, Files, %AppRoot%\App\%AppName%\*, FD
		If (A_LoopFileName != "data")
		{
			prog++
			Progress,%prog%
			FileDelete, %A_LoopFileFullPath%
			FileRemoveDir, %A_LoopFileFullPath%, 1
		}
}

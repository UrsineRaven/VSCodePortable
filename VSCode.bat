@echo off
TITLE VSCode Update Checker/Installer
echo Checking for updates...
App\Bin\AutoHotkeyA32.exe App\Bin\VSCodePortable.ahk|rem
echo Launching Visual Studio Code...
START "" "App\VSCode\Code.exe"
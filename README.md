# VSCodePortable

A launcher for Visual Studio Code in portable mode that checks for (and optionally installs) updates at startup. It installs Visual Studio Code in portable mode on the first run.  

Obviously, Visual Studio Code belongs to Microsoft. Hopefully, since I'm not distributing any of their files, this is legal and they don't ruin me. :sweat_smile:

## Usage

Just double click the VSCode.bat file.  

It will:

1. Check for updates
1. Alert you of any updates, allowing you to choose to update
1. Install any updates that you have chosen to install (preserving your settings)
1. Launch Visual Studio Code

## How it works

The bat file launches an AutoHotkey script which parses a page from Visual Studio's website and extracts the latest version. It then compares that to the local version of Code. If you choose to update, it downloads the new version and updates your local copy. The bat file then launches the portable copy of Code.

## To-Dos

* [ ] Check licensing for 7-zip and AutoHotkey and add any license files necessary
* [ ] Package bat as an exe
    - [ ] check licensing for VSCode's logo, and see if I can use it for exe
* [ ] Add versioning somewhere
* [ ] Clean up code (currently just chunks of an old script I had, that I copied and pasted into a working order)
* [ ] Add Options
    - [ ] choose whether to store VSCode temp files in data directory instead of %AppData%
    - [ ] choose whether to delete temp files on update (to save time on backup and restore of settings)
    - [ ] choose whether to delete the settings backup after an update (to save disk space)
* [ ] Check into Visual Studio Code licensing and provide any necessary license files
* [ ] Add GUI back (my old script that I pulled most of this from had a GUI for settings and whatnot)
* [ ] Update script to use latest AutoHotkey standards (probably need to look at documentation of all used commands, because the script I pulled code from is ~7 years old)
* [ ] Use Progress bar instead of ToolTip's to indicate progress
* [ ] Instead of: backing up data folder, deleting VSCode, re-installing VSCode, and restoring data folder; I should just delete everything in VSCode except the data folder, and then exract over it...

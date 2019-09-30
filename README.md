# VSCodePortable

A launcher for (Windows, 64-bit) [Visual Studio Code](https://code.visualstudio.com/) in [portable mode](https://code.visualstudio.com/docs/editor/portable) that checks for (and optionally installs) updates at startup. It installs Visual Studio Code in portable mode on the first run.  

Obviously, Visual Studio Code belongs to Microsoft. Hopefully, since I'm not distributing any of their files, this is legal and they don't ruin me. :sweat_smile:

## Installation

Snag the zip from the [latest release](https://github.com/UrsineRaven/VSCodePortable/releases/latest) and extract it where you want it.

### Migrating an existing install to VSCodePortable

1. Read all the steps here before following any links
1. Run this once to install it (see [Usage](#usage))
1. Follow [Microsoft's guide on migration to portable version](https://code.visualstudio.com/docs/editor/portable#_migrate-to-portable-mode)
    - Skip the first few steps about installation and creating data folder.
    - The data folder you need to copy to is App\VSCode\data
    - You can overwrite anything in the data folder, since it was just auto-generated after you launched the program in step 2

### Updating VSCodePortable

It's in the plans to give this script/"application" the functionality to update itself, but for now, you need to check github for a new release, go get the zip from the [latest release](https://github.com/UrsineRaven/VSCodePortable/releases/latest), and extract it over your existing install.

## Usage

Just double click the VSCode.bat file.  

It will:

1. Check for updates
1. Alert you of any updates, allowing you to choose to update
1. Install any updates that you have chosen to install (preserving your settings)
1. Launch Visual Studio Code

## How it works

The bat file launches an AutoHotkey script which parses a page from Visual Studio's website and extracts the latest version. It then compares that to the version of the local copy of Visual Studio Code. If you choose to update, it downloads the new version and updates your local copy. The bat file then launches the local copy.

## Issues/Requests/Source

Please report issues or submit feature requests in the [*Issues*](https://github.com/UrsineRaven/VSCodePortable/issues) section of [this project on GitHub](https://github.com/UrsineRaven/VSCodePortable).

The source is obviously on GitHub, but you can also find the bulk of the code in the ahk file in the App/Bin directory.  

Also, the programs used by VSCodePortable ([AutoHotkey](https://www.autohotkey.com/) and [7-zip](https://www.7-zip.org/)) are both open source. You can find their source online somewhere.

## To-Do's

* [ ] Check into Visual Studio Code licensing and provide any necessary license files
* [ ] Check licensing for 7-zip and AutoHotkey and add any license files necessary
* [X] ~~*Instead of: backing up data folder, deleting VSCode, re-installing VSCode, and restoring data folder; I should just delete everything in VSCode except the data folder, and then exract over it...*~~ [2019-09-27]
* [X] ~~*Clean up code (currently just chunks of an old script I had, that I copied and pasted into a working order)*~~ [2019-09-27]
* [X] ~~*Add versioning somewhere*~~ [2019-09-27]
* [X] ~~*Update script to use latest AutoHotkey standards (probably need to look at documentation of all used commands, because the script I pulled code from is ~7 years old)*~~ [2019-09-27]
* [X] ~~*Prioritize my To-Do's*~~ [2019-09-27]
* [X] ~~*Use Progress bar instead of TrayTips to indicate progress*~~ [2019-09-27]
* [ ] Introduce a way to update VSCodePortable itself
* [ ] Do ~~more~~ error checking
* [ ] Add Options
    - [ ] choose whether to store VSCode temp files in data directory instead of %AppData%
    - [X] ~~*choose whether to delete temp files on update (to save time on backup and restore of settings)*~~ [2019-09-27] **Now Irrelevant**
    - [X] ~~*choose whether to delete the settings backup after an update (to save disk space)*~~ [2019-09-27] **Now Irrelevant**
* [ ] Write script that automates generating a release
* [ ] Package bat as an exe
    - [ ] check licensing for VSCode's logo, and see if I can use it for exe
* [ ] Add GUI back (my old script that I pulled most of this from had a GUI for settings and whatnot)
* [ ] Maybe move the To-Do's out of the readme
* [ ] Maybe package it with PortableApps.com installation tool
* [ ] Write a script that detects if the website version detection or download link breaks
* [ ] Maybe write a script that maintains latest versions at a dedicated uri
    - This script would no longer be responsible for the website scraping
    - Could also use another uri for the version of this script itself
    - Wouldn't necessarily have to make people update this "app" if the structure of the website changes
    - Downside is that update detection would be dependent on the uptime of my server and that the server would likely only scrape once or twice a day, adding somewhat of a lag to updates
* [ ] Look into submitting a pull to Visual Studio Code to allow the data folder to be outside the program directory, but still be in portable mode. (maybe still have the data directory, but put a text file with the relative path to the data directory?)
    - This would make updating a lot simpler
    - Data could just stay in the Data folder
* [X] ~~Maybe just convert to a PowerShell script to remove executable dependencies (may make it not work as well on random computers due to PowerShell permissions)~~ **Not going to do**

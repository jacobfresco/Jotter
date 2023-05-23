# Jotter
A small note taking app for anyone to use as they see fit. It autosaves every 45 milliseconds to ensure no data is ever lost. It supports reminders, a dark mode and transparancy. 

## Changelog

### Release 0.2.2

* Removed logging option
* Dark mode
* Change in dropdown list
* Bugfixes with the INI file
* Do not store empty files
* Save to single file
* UX is now a separate file (ux.au3)
* Added transparancy option via .ini

## Installation
Jotter is compiled as a standalone executable, therefore requiring no installation. Just download the latest [release](https://github.com/jacobfresco/jotter/releases/tag/0.2.2) and copy the files anywhere you want them. Create a jotter.ini, launch the app and start taking notes!

## Configuring jotter.ini
```
[main]
title=Jotter

[system]
SavePath=[Path where Jotter saves the file(s)]
SingleFile=[true|false]
SaveFileName=%DD-%MM-%YYYY
# SaveFileName=singlesave
EditOldNotes=[true|false]
FontSize=12
Darkmode=[true|false]
NoEmptySave=[true|false]

[Reminders]
Active=[true|false]
Tag=[@]
Title=[The title showing on the reminder]

[Window]
Xpos=[A point on the screen]
Ypos=[Another point on the screen]
Transparancy=[A value between 0 and 250]
```
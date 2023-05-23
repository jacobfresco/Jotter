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

## Creating new files with a default content
If you wish to create new files with a default content, please create a file called 'default.txt' in the same directory as the executables. The content of that file will be the default content of new files created by Jotter. If a file already exists (i.e. if you use the single file option), the default.txt will be ignored

## Using reminders from within Jotter
You can set a reminder using the below syntax on a new line in Jotter
```
[@] HH:MM The text for the reminder
```
The reminder will be shown on the time set and show the text after the time. Please note; this is the default syntax. You're able to set a custom tag for reminders. Please see [jotter.ini](https://github.com/jacobfresco/jotter#configuring-jotterini) on how to do so. 
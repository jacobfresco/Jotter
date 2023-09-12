# Jotter
A small note taking app for anyone to use as they see fit. It autosaves every 45 milliseconds to ensure no data is ever lost. It supports reminders, a dark mode and transparancy. 

## Changelog

### Release 0.3.0

* Current developement release
* Added option to delete or archive old notes

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
ArchivePath=[Path where Jotter archives old notes]
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

### Files and filenames
You can decide where you want to store your Jotter file(s). You can edit 'SavenPath' for this path. The default value is %USERPROFILE%\Documents\Jotter. 
If you wish to use Jotter with daily files, please make sure to add the following sections to the filename:
- %DD - will be replaced with a two-digit number, representing the day of the month
- %MM - will be replaced with a two-digit number, representing the month
- %YYYY - will be replaced with a four-digit number, representing the year

The .txt-extension is added automatically by the app when creating the file. You can also use Jotter with a single file for storing data. If so, please replace the %DD-%MM-%YYYY in the filename with a static filename (again, without .txt) and set 'SingleFile' to 'true'

### To edit or not to edit old notes
If you wish to be able to edit older notes, please set 'EditOldNotes' to 'true'. The default setting for this option is false. You will still be able to read the notes, but not edit them. 

### Darkmode
Jotter has a darkmode for those of you who wish to use such a feature. Set the value to 'true' for darkmode to be enabled.

### Do not save empty files
If you set the option NoEmptySave to 'true', Jotter will delete files that are empty when you exit the app. Setting the value to false will keep the file, even if it's empty.

### Using reminders from within Jotter
You can set a reminder using the below syntax on a new line in Jotter
```
[@] HH:MM The text for the reminder
```
The reminder will be shown on the time set and show the text after the time. Please note; this is the default syntax. You're able to set a custom tag for reminders. Please see [jotter.ini](https://github.com/jacobfresco/jotter#configuring-jotterini) on how to do so. 

### Tranparancy
You can make the Jotter window more or less transparant by setting a value in [jotter.ini](https://github.com/jacobfresco/jotter#configuring-jotterini). The value needs to be between 0 and 250. Please note that setting the value too low (i.e below 150) will result in a nearly invisible window and a unusable app. The recommended value for this setting is 220

## Creating new files with a default content
If you wish to create new files with a default content, please create a file called 'default.txt' in the same directory as the executables. The content of that file will be the default content of new files created by Jotter. If a file already exists (i.e. if you use the single file option), the default.txt will be ignored

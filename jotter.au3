#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=jotter.ico
#AutoIt3Wrapper_Outfile=jotter.exe
#AutoIt3Wrapper_Outfile_x64=jotter_64.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Compile_Both=y
#AutoIt3Wrapper_Res_Description=Jotter
#AutoIt3Wrapper_Res_Fileversion=0.3.0
#AutoIt3Wrapper_Res_ProductName=Jotter
#AutoIt3Wrapper_Res_ProductVersion=0.3.0
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

# Version of Jotter
Global $JotterVersion = "0.3.0"

# Changelog v0.3.0
# Added: possibility to delete or archive old notes
# Added: Modern UI
# Added: automatically archive jots after older then a specific number of days
# Added: color setting for the window
# Added: Zoom in and out ($Notitie)


# Changelog v0.2.2
# Removed logging option
# Dark mode
# Change in dropdown list
# Bugfixes with the INI file
# Do not store empty files
# Save to single file
# UX is now a separate file (ux.au3)
# Added transparancy option via .ini


# Changelog v0.2.1
# Sort dropdown selectbox by date (last modified)
# New config for versioning
# Added scrollbar to dropdown list
# Show limited items in dropdown (10)


# Changelog v0.2
# Added reminders to the text


# Changelog v0.1.1
# Changed filenames to %DD-%MM-%YYY.txt


# Changelog v0.1
# First release

# File: jotter.au3

#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <ButtonConstants.au3>
#include <GuiRichEdit.au3>
#include <GuiButton.au3>
#include <WindowsConstants.au3>
#include <Date.au3>
#include <MsgBoxConstants.au3>
#include <Array.au3>
#include <GuiStatusBar.au3>
#include <File.au3>
#include <functions.au3>
#include <TrayConstants.au3>
#include <FileConstants.au3>
#include <FontConstants.au3>
#include <GuiComboBoxEx.au3>
#include <ux.au3>
#include <WinAPIGdi.au3>
#include <WinAPIHObj.au3>
#include <WinAPISys.au3>

# NL: Creeer de variabelen voor eerste gebruik
# EN: Create variables for first use

Dim $inifile, $Title, $Version, $SavePath, $SaveFilePattern, $EditOldNotes, $NotesList
Dim $SaveFile, $cachefile, $RemStart, $txtfile, $RemindersTitle, $SavePath, $Notitie
Dim $frmmain, $FormTitlem, $SingleFile, $ReminderStart, $xpos, $ypos, $transparancy, $ReminderTitle
Dim $bgColor, $txtColor, $FontName, $n, $FontSize
Dim $ArchiveToPath, $ArchiveNumDays

Dim $notificationCounter = 0

Global $frmmain

# NL: Lees de INI file
# EN: Parse the INI file
Local $iniFile = "jotter.ini"

If @error > 0 then
	MsgBox($MB_SYSTEMMODAL, "Error while reading", "Error reading " & $inifile & ". Press OK to create a default INI-file")
	Exit
EndIf

Local $Title = INiRead($iniFile, "Main", "Title", "Jotter")
Local $Version = $JotterVersion

Global $SavePath = INiRead($iniFile, "system", "SavePath", EnvGet("USERPROFILE") & "\documents\jotter")
Local $ArchiveToPath = IniRead($inifile, "system", "ArchivePath", EnvGet("USERPROFILE") & "\documents\jotter\Archive")
local $AutoArchive = IniRead($inifile, "system", "AutoArchive", "false" )
local $ArchiveNumDays = IniRead($inifile, "system", "ArchiveNumDays", "14" )
Local $SaveFilePattern = INiRead($iniFile, "system", "SaveFileName", "%DD-%MM-%YYYY")
Local $SingleFile = INiRead($iniFile, "system", "SingleFile", "false")
Local $EditOldNotes = INiRead($iniFile, "system", "EditOldNotes", "False")

Local $Darkmode = INIRead($iniFile, "system", "Darkmode", "false")
Local $NoEmptySave = INIRead($iniFile, "system", "NoEmptySave", "false")

Local $RemindersActive = INIRead($iniFile, "Reminders", "Active", "false")

if $RemindersActive = "true" Then
	Global $RemindersTitle = "ON"
Else
	Global $RemindersTitle = "OFF"
EndIf

Local $ReminderStart = INIRead($inifile, "Reminders", "Tag", "[@]")
Global $ReminderTitle = INIRead($inifile, "Reminders", "Title", "Jotter Reminder!")

Local $xpos = INIRead($iniFile, "Window", "Xpos", "100")
Local $ypos = INIRead($iniFile, "Window", "ypos", "100")
Local $transparancy = INIRead($iniFile, "Window", "Transparancy", "250")
Local $bgColor = INIRead($iniFile, "Window", "bgColor", "#FFFFFF")
Local $txtColor = INIRead($iniFile, "Window", "txtColor", "#000000")
Global $FontName = INIRead($iniFile, "Window", "Font", "Segoe UI")
Global $FontSize = INIRead($iniFile, "Window", "FontSize", "10")

# Definieer de te gebruiken bestandsnamen
if $Singlefile = "false" then
	$TodayFile = _ConvertFileName($SaveFilePattern) & ".TXT"
	$SaveFile = _ConvertFileName($SaveFilePattern) & ".TXT"
Else
	$TodayFile = $SaveFilePattern & ".TXT"
	$SaveFile = $SaveFilePattern & ".TXT"
EndIf

# NL: Controleer of het bestand voor vandaag al bestaat
# EN: Check if the file for today already exists
_CheckFileExist($SavePath & "\" & $SaveFile)


# NL: Archiveer oude bestanden indien $AutoArchive = True
# EN: Archive old files if $AutoArchive = true 
If $AutoArchive = "true" Then
	_ArchiveonStartup($SavePath, $ArchiveToPath, $ArchiveNumDays)
EndIf


# NL: Bouw de interface op
# EN: Create the GUI
_CreateUX($Darkmode, $FontName)


# NL: Lees de bestaande bestanden in
# EN: Parse existing files
if $Singlefile = "false" then
	_PopulateListBox($SavePath)
Else
	GUICtrlSetData($NotesList, $TodayFile, $TodayFile)
	GUICtrlSetState($NotesList, 128)
	GUICtrlSetState($btnArchive, $GUI_DISABLE)
	GUICtrlSetState($btnDelete, $GUI_DISABLE)
EndIf


# NL: Open het bestand van vandaag en toon de inhoud
# EN: Open the file for today and show the content
_OpenFile($SavePath & "\" & $SaveFile)
GUICtrlSetState($btnArchive, $GUI_DISABLE)
GUICtrlSetState($btnDelete, $GUI_DISABLE)


# NL: Stel de timer in voor autosave (45ms)
# EN: Set a timer for autosave (45ms)
AdlibRegister("TimerSaveFile", 45)


# NL: Activeer reminders als $RemindersActive is ingesteld op true
# EN: Activate reminders if $RemindersActive is set to true
If $RemindersActive = "true" then
	AdLibRegister("TimerReminderCheck", 490)
Endif


# NL: Registreer de Ctrl-Scrollwheel om de zoom aan te zetten in $Notitie
# EN: Register CTRL-Scrollwheel to enable zoom in $Notitie
GUIRegisterMsg($WM_MOUSEWHEEL, "_ScrollZoom")
$n = $FontSize


While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE, $btnClose
			If $NoEmptySave = "true" Then
				_FileCheckOnExit(GUICtrlRead($Notitie), $SavePath & "\" & $TodayFile)
			EndIf
			Exit

		case $NotesList
			$SelectedFile = GUICtrlRead($NotesList)
			AdlibUnRegister("TimerSaveFile")
			AdLibUnRegister("TimerReminderCheck")
			# ConsoleWrite("Today's file: " & $TodayFile & chr(10) & "Selected file: " & $SelectedFile & chr(10) & chr(10))
			If $SelectedFile = $TodayFile Then
				_OpenFile($SavePath & "\" & $TodayFile)
				GuiCtrlSendMsg($Notitie, $EM_SETREADONLY, 0, 0)
				$SaveFile = $TodayFile
				AdlibRegister("TimerSaveFile", 45)
				AdLibRegister("TimerReminderCheck", 490)
				# ConsoleWrite("Hit the right function (if then else)")
				GUICtrlSetData($FormTitle, _SetFormTitle("ON", "ON", $RemindersTitle))
				GUICtrlSetState($btnArchive, $GUI_DISABLE)
				GUICtrlSetState($btnDelete, $GUI_DISABLE)
			Else
				_OpenFile($SavePath & "\" & $SelectedFile)
				GUICtrlSetState($btnArchive, $GUI_ENABLE)
				GUICtrlSetState($btnDelete, $GUI_ENABLE)
				If $EditOldNotes = "False" Then
					GuiCtrlSendMsg($Notitie, $EM_SETREADONLY, 1, 0)
					$SaveFile = $SelectedFile
					GUICtrlSetData($FormTitle, _SetFormTitle("OFF", "OFF",$RemindersTitle))
				Else
					GuiCtrlSendMsg($Notitie, $EM_SETREADONLY, 0, 0)
					$SaveFile = $SelectedFile
					AdlibRegister("TimerSaveFile", 45)
					GUICtrlSetData($FormTitle, _SetFormTitle("ON", "ON", $RemindersTitle))
				EndIf
			Endif

		case $btnDelete
			$SelectedFile = GUICtrlRead($NotesList)
			AdlibUnRegister("TimerSaveFile")
			AdLibUnRegister("TimerReminderCheck")
			_DeleteViaButton($SavePath, $SelectedFile)
			$SaveFile = $TodayFile
			GUICtrlSetData($NotesList, "")
			_PopulateListBox($SavePath)
			_OpenFile($SavePath & "\" & $TodayFile)
			GUICtrlSetData($FormTitle, _SetFormTitle("ON", "ON", $RemindersTitle))
			GUICtrlSetState($btnArchive, $GUI_DISABLE)
			GUICtrlSetState($btnDelete, $GUI_DISABLE)
			AdlibRegister("TimerSaveFile", 45)
			AdLibRegister("TimerReminderCheck", 490)
		
		case $btnArchive
			$SelectedFile = GUICtrlRead($NotesList)
			AdlibUnRegister("TimerSaveFile")
			AdLibUnRegister("TimerReminderCheck")
			_ArchiveViaButton($SavePath, $SelectedFile, $ArchiveToPath)
			$SaveFile = $TodayFile
			GUICtrlSetData($NotesList, "")
			_PopulateListBox($SavePath)
			_OpenFile($SavePath & "\" & $TodayFile)
			GUICtrlSetData($FormTitle, _SetFormTitle("ON", "ON", $RemindersTitle))
			GUICtrlSetState($btnArchive, $GUI_DISABLE)
			GUICtrlSetState($btnDelete, $GUI_DISABLE)
			AdlibRegister("TimerSaveFile", 45)
			AdLibRegister("TimerReminderCheck", 490)
	EndSwitch

WEnd

#Region 
	#AutoIt3Wrapper_Icon=jotter.ico
	#AutoIt3Wrapper_Outfile_x64=jotter_64.exe
	#AutoIt3Wrapper_Compile_Both=y
	#AutoIt3Wrapper_UseX64=y
#EndRegion 

# Changelog v0.3.0
# Added: possibility to delete or archive old notes
# Added: Modern UI
# Added: automatically archive jots after older then a specific number of days
# Added: color setting for the window


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

# File: functions.au3

# NL: Creeer de variabelen voor eerste gebruik
# EN: Create variables for first use

Dim $inifile, $Title, $Version, $SavePath, $SaveFilePattern, $EditOldNotes, $NotesList
Dim $SaveFile, $cachefile, $RemStart, $txtfile, $RemindersTitle, $SavePath, $Notitie
Dim $frmmain, $FormTitlem, $SingleFile, $ReminderStart, $xpos, $ypos, $transparancy, $ReminderTitle

Func _ArchiveJot($PathToLook, $FileToArchive, $ArchivePath)

	# NL: Archiveer $FileToArchive vanuit $PathToLook naar $ArchivePath
	# EN: Archive $FileToArchive from $PathToLook to $ArchivePath

EndFunc

Func _CheckFileExist($FileToCheck)

	# NL: Controleer of het bestand voor vandaag al bestaat. Zo niet, maak het aan.
	# EN: Check if the file for today already exists. If not, creat it.

	If Not FileExists($FileToCheck) Then
		$hFileOpen = FileOpen($FileToCheck, 2)
		If @error > 0 then
			MsgBox($MB_SYSTEMMODAL, "Error while writing", "Error writing " & $FileToCheck & " in " & $SavePath & ". Exiting...")
			Exit
		EndIf
		If FileExists("default.txt") Then
			$hdefaultOpen = FileOpen("default.txt", 0)
			$defaultTXT = FileRead("default.txt")
		Else
			$defaultTXT = ""
		EndIf
		FileWriteLine($hFileOpen, $defaultTXT)
		FileClose($hFileOpen)
	Endif

EndFunc


Func _CheckForReminders($RemStart, $txtfile)

	# NL: Controleert of er nog niet verwerkte reminders in de tekst staan.
	# EN: Checks if there are active reminders within the text 

	AdlibUnRegister("TimerSaveFile")
	$CheckForReminders = FileOpen($txtfile, $FO_READ)
	$NewTxt = ""
	$Reminded = "false"
	For $i = 1 to _FileCountLines($CheckForReminders)
		$line = FileReadLine($CheckForReminders, $i)
		if StringLeft($line, StringLen($RemStart)) = $RemStart Then
			if StringMid($line, StringLen($RemStart)+2, 5) = _NowTime(4) Then
				AdLibUnRegister("TimerReminderCheck")
				$Message = stringRight($line, StringLen($line) - stringLen($RemStart) - 7)
				Traytip($ReminderTitle, _NowTime(4) & " | " & $Message, 30, 1)
				ConsoleWrite(_NowTime(4) & " | " & $Message & @CRLF)
				# _WinAPI_MessageBeep(2)
				$line = StringReplace($line, $RemStart, "[Reminded!]")
				$Reminded = "true"
			EndIf
		EndIf
		if $i = 1 then
			$NewTxt = $line
		Else
			$NewTxt = $NewTxt & @crlf & $line
		EndIf

	Next
	FileClose($txtfile)
	if $Reminded = "true" Then
		GUICtrlSetData($Notitie, $NewTxt)
	EndIf
	AdlibRegister("TimerSaveFile", 45)
	AdLibRegister("TimerReminderCheck", 490)
EndFunc


Func _ConvertFileName($Pattern)

	# NL: Bepaal de bestandsnaam voor vandaag op basis van het %Pattern% uit de INI-file
	# EN: Determine the filename for today based on the %Pattern% from in the INI-File 

	Local $dag, $tijd

	Local $datum = _DateTimeSplit(_DateTimeFormat(_NowCalc(), 2), $dag, $tijd)

	if stringlen($dag[1]) = 2 Then
		$Filename = StringReplace($Pattern, "%DD", $dag[1])
	Else
		$Filename = StringReplace($Pattern, "%DD", "0" & $dag[1])
	EndIf

	if stringlen($dag[2]) = 2 Then
		$FileName = StringReplace($Filename, "%MM", $dag[2])
	Else
		$FileName = StringReplace($Filename, "%MM", "0" & $dag[2])
	EndIf

	$FileName = StringReplace($Filename, "%YYYY", $dag[3])

	Return $Filename

EndFunc

Func _FileCheckOnExit($Content, $TodayFileVar)

	# NL: Als de jot leeg is, verwijder het bestand bij afsluiten (optie in the INI)
	# EN: If the jot is empty, delete the corresponding file on exit (option in the INI)

	If $Content = "" Then
		FileDelete($TodayFileVar)
	EndIf

EndFunc

Func _GetFileLastModifiedDate($sFilename)

	# NL: Bepaalt de Laatst aangepast datum van een bestand 
	# EN: Determines the last modified date of a file

	Return Number(FileGetTime($SavePath & "\" & $sFilename, 0, 1))
	
EndFunc


Func _OpenFile($FileToOpen)

	# NL: Open het bestand en toon de inhoud in de Editbox
	# EN: Open the file and show the content within the Editbox 

	$hFileOpen = FileOpen($FileToOpen,0)
	If @error > 0 then
		MsgBox($MB_SYSTEMMODAL, "Error while opening ", "Error opening " & $FileToOpen & " in " & $SavePath & ". Exiting...")
		Exit
	EndIf
	$txtNote = FileRead($hFileOpen)
	If @error > 0 then
		MsgBox($MB_SYSTEMMODAL, "Error while reading", "Error reading " & $FileToOpen & " in " & $SavePath & ". Exiting...")
		Exit
	EndIf
	FileClose($hFileOpen)
	GUICtrlSetData($Notitie, $txtNote)
EndFunc


Func _PopulateListBox($PathToLook)

	# NL: Vult de dropdownbox (gebruikt hierbij ook _Sort())
	# EN: Populates the dropdown (uses _Sort())

	Local $aFileList = _FileListToArray($PathToLook, "*.txt",0,0)
	If @error = 1 Then
        Msgbox($MB_SYSTEMMODAL, "Error while reading", "Path (" & $PathToLook & ") is invalid. Exiting...")
        Exit
    EndIf
    If @error = 4 Then
        MsgBox($MB_SYSTEMMODAL, "Error while reading", "No file(s) were found in " & $PathToLook & ". Exiting...")
        Exit
    EndIf

	_ArrayDelete($aFileList, 0)
	_Sort($aFileList)

	For $File in $aFileList
		if StringUpper($File) = $SaveFile then
			GUICtrlSetData($NotesList, $File, $File)
		Else
			GUICtrlSetData($NotesList, $File)
		Endif
	Next

EndFunc


Func _Sort(ByRef $aArray)

	# NL: Sorteert de bestanden op Laatst aangepast in de dropdown (gebruikt _GetFileLastModifiedDate())
	# EN: Sorts the files based on Last Modified Date in the dropdown (uses _GetFileLastModifiedDate())

    For $i = UBound($aArray) - 1 To 1 Step -1
        For $j = 1 To $i
			If _GetFileLastModifiedDate($aArray[$j - 1]) >_GetFileLastModifiedDate($aArray[$j]) Then
                $temp = $aArray[$j - 1]
                $aArray[$j - 1] = $aArray[$j]
                $aArray[$j] = $temp
            EndIf
        Next
    Next
    Return $aArray
EndFunc


Func _SaveFile($FileToSave)

	# NL: Sla het bestand op in het aangegeven bestand
	# EN: Save the file in the given filename

	$NoteToSave = GUICtrlRead($Notitie)

	$hFileOpen = FileOpen($FileToSave, 2)
	If @error > 0 then
		MsgBox($MB_SYSTEMMODAL, "Error while saving", "Error saving " & $FileToSave & " in " & $SavePath & ". Exiting...")
		Exit
	EndIf
	FileWrite($hFileOpen, $NoteToSave)
	If @error > 0 then
		MsgBox($MB_SYSTEMMODAL, "Error while saving", "Error saving " & $FileToSave & " in " & $SavePath & ". Exiting...")
		Exit
	EndIf
	FileClose($hFileOpen)
EndFunc


Func _ScrollZoom($hWnd,$iMsg, $iwParam, $ilParam)
	# NL: Gebruik de combinatie CTRL-scrollwheel om in- en uit te zoomen (Fontsize)
	# EN: Use the combo CTRL-scrollwheel to zoom in and out (Fontsize)

    #forceref $hwnd, $iMsg, $ilParam
    Local $a = GUIGetCursorInfo($frmmain)
    If $a[4] = $Notitie Then 
		Local $iDelta = BitShift($iwParam, 16) 
        If $iDelta > 0 Then $n += 1
        If $iDelta < 0 Then $n -= 1
		$FontSize = $n
        GUICtrlSetFont($Notitie, $FontSize)
    EndIf
    Return $GUI_RUNDEFMSG
EndFunc


Func _SetFormTitle($Edit, $AutoSave, $Reminders)

	# NL: Bepaal de titel van het window en maak deze actief 
	# EN: Determine the window title and set it
	# DEBUG: not working after the second change in the dropdown box 
	# Issue: https://github.com/jacobfresco/jotter/issues/1

	$formTitle = $Title & " " & $Version & " | " & $SaveFile
	if $Singlefile = "false" Then
		$formTitle = $formTitle & " | Edit " & $Edit & " | Autosave " & $AutoSave & " | Reminders " & $Reminders
	Else
		$formTitle = $formTitle & " | Mode: Single File" & " | Reminders " & $Reminders
	EndIf

	Return $formTitle

EndFunc

Func TimerSaveFile()
	# NL: Kapstokfunctie voor het automatisch saven van de notitie met AdlibRegister
	# EN: Helicopter function for automatically saving notes with AdlibRegister

	_SaveFile($SavePath & "\" & $SaveFile)
EndFunc


Func TimerReminderCheck()
	# NL: Kapstopfunctie voor het automatisch starten van de Check op reminders
	# EN: Helicopterfunction for automatically starting the check for reminders 

	_CheckForReminders($ReminderStart, $SavePath & "\" & $SaveFile)
EndFunc





#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=jotter.ico
#AutoIt3Wrapper_Outfile_x64=jotter_64.exe
#AutoIt3Wrapper_Compile_Both=y
#AutoIt3Wrapper_UseX64=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

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


Func _CheckFileExist($FileToCheck)

	# Controleer of het bestand voor vandaag al bestaat. Zo niet, maak het aan.
	$DefaultTXT = ""
	If Not FileExists($FileToCheck) Then
		$hFileOpen = FileOpen($FileToCheck, 2)
		If @error > 0 then
			MsgBox($MB_SYSTEMMODAL, "Error while writing", "Error writing " & $FileToCheck & " in " & $SavePath & ". Exiting...")
			Exit
		EndIf
		If FileExists("default.txt") Then
			$hdefaultOpen = FileOpen("default.txt", 0)
			$defaultTXT = FileRead("default.txt")
		EndIf
		FileWriteLine($hFileOpen, $defaultTXT)
		FileClose($hFileOpen)
	Endif

EndFunc


Func _CheckForReminders($RemStart, $txtfile)
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

	# Bepaal de bestandsnaam voor vandaag op basis van het %Pattern% uit de INI-file
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
	If $Content = "" Then
		FileDelete($TodayFileVar)
	EndIf

EndFunc

Func _GetFileLastModifiedDate($sFilename)
	Return Number(FileGetTime($SavePath & "\" & $sFilename, 0, 1))
EndFunc


Func _OpenFile($FileToOpen)
	# Open het bestand en toon de inhoud in de Editbox
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

	# Sla het bestand op in het aangegeven bestand
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

Func _SetFormTitle($Edit, $AutoSave, $Reminders)

	$formTitle = $Title & " " & $Version & " | " & $SaveFile
	if $Singlefile = "false" Then
		$formTitle = $formTitle & " | Edit " & $Edit & " | Autosave " & $AutoSave & " | Reminders " & $Reminders
	Else
		$formTitle = $formTitle & " | Mode: Single File" & " | Reminders " & $Reminders
	EndIf

	Return $formTitle

EndFunc

Func TimerSaveFile()
	# Kapstokfunctie voor het automatisch saven van de notitie met AdlibRegister
	_SaveFile($SavePath & "\" & $SaveFile)
EndFunc


Func TimerReminderCheck()
	# Kapstopfunctie voor het automatisch starten van de Check op reminders
	_CheckForReminders($ReminderStart, $SavePath & "\" & $SaveFile)
EndFunc






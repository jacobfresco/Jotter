# Changelog v0.3.0
# Added: possibility to delete or archive old notes

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

# File: ux.au3

# Creeer het form

Func _CreateUX($Darkmode)
	#Region 
		Opt("GUICoordMode", 1)
		$frmmain = GUICreate(_SetFormTitle("ON", "ON", $RemindersTitle), 627, 530, $ypos, $xpos, BitOR($WS_SYSMENU, $WS_SIZEBOX, $WS_EX_WINDOWEDGE))
		WinSetTrans($frmmain, "", $transparancy)
		if $Darkmode = "true" then
			GUISetBkColor(0x000000)
		EndIf
		GUISetIcon("jotter.ico", -1)
		$NotesList = GUICtrlCreateCombo("", 0, 0, 625, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL,$WS_BORDER),BitOR($WS_EX_CLIENTEDGE,$WS_EX_STATICEDGE))
		if $Darkmode = "true" then
			GUICtrlSetColor($NotesList, 0xFFFFFF)
			GUICtrlSetBkColor($NotesList, 0x303018)
		EndIf
		GUICtrlSendMsg($NotesList, $CB_SETMINVISIBLE, 10, 0)
		$Notitie = GUICtrlCreateEdit("", 0, 22, 625, 483, BitOR($ES_AUTOVSCROLL,$ES_WANTRETURN,$WS_VSCROLL))
		if $Darkmode = "true" then
			GUICtrlSetColor($Notitie, 0xFFFFFF)
			GUICtrlSetBkColor($Notitie, 0x303018)
		EndIf
		GUISetState(@SW_SHOW)
	#EndRegion
EndFunc
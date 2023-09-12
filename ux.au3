# Changelog v0.3.0
# Added: possibility to delete or archive old notes
# Added: Modern UI


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

# Creeer global vars

Global $ui_width = 826
Global $ui_height = 474

Global $left_margin = 20
Global $top_margin = 20

# Global $cUI = 0xFFFFFF, $cContent = 0xEEEEEE, $cSearch = 0x6A1B9A ;colors

Func _CreateUX($Darkmode, $FontName)
	#Region
		# Opt("GUICoordMode", 1)
		$frmmain = GUICreate("", $ui_width, $ui_height, $xpos, $ypos, $WS_POPUP, $WS_EX_CONTROLPARENT)

		GUICtrlSetFont(-1, 10, 500, Default, $Fontname, 5)
		WinSetTrans($frmmain, "", $transparancy)
		if $Darkmode = "true" then
			GUISetBkColor(0x000000, $frmMain)
			GUICtrlSetColor($frmMain, 0xFFFFFF)
		Else
			GUISetBkColor(0xFFFFFF, $frmMain)
			GUICtrlSetColor($frmMain, 0x000000)
		EndIf

		$FormIcon = GUICtrlCreateIcon("jotter.ico", Default, 3, 2, 16, 16)

		$FormTitle = GUICtrlCreateLabel(_SetFormTitle("ON", "ON", $RemindersTitle), 22, 2, $ui_width-3, 25,-1,$GUI_WS_EX_PARENTDRAG )
		GUICtrlSetFont(-1, 10, 500, Default, $Fontname, 5)
		if $Darkmode = "true" then
			GUICtrlSetColor($FormTitle, 0xFFFFFF)
		Endif

		$NotesList = GUICtrlCreateCombo("", 4, 25, 300, 29, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
		GUICtrlSetFont(-1, 10, 500, Default, $Fontname, 5)
		if $Darkmode = "true" then
			GUICtrlSetColor($NotesList, 0xFFFFFF)
			GUICtrlSetBkColor($NotesList, 0x000000)
		EndIf
		GUICtrlSendMsg($NotesList, $CB_SETMINVISIBLE, 10, 0)

		$Notitie = GUICtrlCreateEdit("", 4, 52, $ui_width-8, $ui_height-56, BitOR($ES_AUTOVSCROLL,$ES_WANTRETURN,$WS_VSCROLL,$WS_EX_WINDOWEDGE))
		GUICtrlSetFont(-1, 11, 500, Default, $Fontname, 5)
		if $Darkmode = "true" then
			GUICtrlSetColor($Notitie, 0xFFFFFF)
			GUICtrlSetBkColor($Notitie, 0x000000)
		EndIf
		GUISetState(@SW_SHOW)
	#EndRegion
EndFunc
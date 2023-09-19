# Changelog v0.3.0
# Added: possibility to delete or archive old notes
# Added: Modern UI
# Added: automatically archive jots after older then a specific number of days


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
Global $assets = @ScriptDir & "\assets\"
Global $ui_width = 826
Global $ui_height = 474
Global $left_margin = 20
Global $top_margin = 20

Func _CreateUX($Darkmode, $FontName)
	#Region
		Opt("GUICoordMode", 1)
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

		$FormIcon = GUICtrlCreateIcon($assets & "jotter.ico", Default, 3, 2, 16, 16)

		Global $FormTitle = GUICtrlCreateLabel(_SetFormTitle("ON", "ON", $RemindersTitle), 22, 2, $ui_width-40, 25,-1,$GUI_WS_EX_PARENTDRAG )
		GUICtrlSetFont(-1, 10, 500, Default, $Fontname, 5)
		if $Darkmode = "true" then
			GUICtrlSetColor($FormTitle, 0xFFFFFF)
		Endif

	    Global $btnClose = GUICtrlCreateButton("", $ui_width-21, 2, 20, 20, BitOR($BS_ICON,$BS_FLAT,$BS_VCENTER))
		GUICtrlSetImage($btnClose, $assets & "close.ico")


		$NotesList = GUICtrlCreateCombo("", 4, 25, 300, 29, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
		GUICtrlSetFont(-1, 10, 500, Default, $Fontname, 5)
		if $Darkmode = "true" then
			GUICtrlSetColor($NotesList, 0xFFFFFF)
			GUICtrlSetBkColor($NotesList, 0x000000)
		EndIf
		GUICtrlSendMsg($NotesList, $CB_SETMINVISIBLE, 10, 0)

		Global $btnArchive = GUICtrlCreateButton("", 308, 29, 16,16, BitOR($BS_ICON,$BS_FLAT,$BS_VCENTER))
		GUICtrlSetImage($btnArchive, $assets & "archive.ico")

		Global $btnDelete = GUICtrlCreateButton("", 332, 29, 16,16, BitOR($BS_ICON,$BS_FLAT,$BS_VCENTER))
		GUICtrlSetImage($btnDelete, $assets & "delete.ico")

		$Notitie = GUICtrlCreateEdit("", 4, 52, $ui_width-8, $ui_height-56, BitOR($ES_AUTOVSCROLL,$ES_WANTRETURN,$WS_VSCROLL,$WS_EX_WINDOWEDGE))
		GUICtrlSetFont(-1, 11, 500, Default, $Fontname, 5)
		if $Darkmode = "true" then
			GUICtrlSetColor($Notitie, 0xFFFFFF)
			GUICtrlSetBkColor($Notitie, 0x000000)
		EndIf
		GUISetState(@SW_SHOW)
	#EndRegion
EndFunc
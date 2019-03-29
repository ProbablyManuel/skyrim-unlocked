 ScriptName TT_SkyrimUnlockedMCMScript Extends SKI_ConfigBase
{MCM for Skyrim Unlocked}

TT_UnlockerScript Property Unlocker Auto

Quest Property C05 Auto
Quest Property CW02A Auto
Quest Property CW02B Auto
Quest Property DB10 Auto
Quest Property MG01 Auto
Quest Property MG05 Auto
Quest Property MQ202 Auto
Quest Property MQ106 Auto
Quest Property TG08A Auto
Quest Property TT_Quest_Skuldafn Auto

Bool ToggleIrkngthand = False
Bool ToggleSaarthal = False
Bool ToggleLabyrinthian = False
Bool ToggleKatariah = False
Bool ToggleThalmorEmbassy = False
Bool ToggleKorvanjund = False
Bool ToggleSkuldafn = False
Bool ToggleSkuldafnHint = False
Bool ToggleSkyHavenTemple = False
Bool ToggleYsgramorsTomb = False

Int OIDIrkngthand
Int OIDSaarthal
Int OIDLabyrinthian
Int OIDKatariah
Int OIDThalmorEmbassy
Int OIDSkuldafn
Int OIDSkuldafnHint
Int OIDKorvanjund
Int OIDSkyHavenTemple
Int OIDYsgramorsTomb


Event OnPageReset(String Page)
	SetCursorFillMode(TOP_TO_BOTTOM)
	AddHeaderOption("$Irkngthand")
	If (TG08A.IsCompleted())
		OIDIrkngthand = AddToggleOption("$Unlock Irkngthand", ToggleIrkngthand, OPTION_FLAG_DISABLED)
	Else
		OIDIrkngthand = AddToggleOption("$Unlock Irkngthand", ToggleIrkngthand)
	EndIf
	AddEmptyOption()
	AddHeaderOption("$Saarthal")
	If (MG01.IsCompleted())
		OIDSaarthal = AddToggleOption("$Unlock Saarthal", ToggleSaarthal, OPTION_FLAG_DISABLED)
	Else
		OIDSaarthal = AddToggleOption("$Unlock Saarthal", ToggleSaarthal)
	EndIf
	AddEmptyOption()
	AddHeaderOption("$Labyrinthian")
	If (MG05.IsCompleted())
		OIDLabyrinthian = AddToggleOption("$Unlock Labyrinthian", ToggleLabyrinthian, OPTION_FLAG_DISABLED)
	Else
		OIDLabyrinthian = AddToggleOption("$Unlock Labyrinthian", ToggleLabyrinthian)
	EndIf
	AddEmptyOption()
	AddHeaderOption("$The Katariah")
	If (DB10.IsCompleted())
		OIDKatariah = AddToggleOption("$Unlock The Katariah", ToggleKatariah, OPTION_FLAG_DISABLED)
	Else
		OIDKatariah = AddToggleOption("$Unlock The Katariah", ToggleKatariah)
	EndIf
	AddEmptyOption()
	AddHeaderOption("$Ysgramor's Tomb")
	If (C05.IsCompleted())
		OIDYsgramorsTomb = AddToggleOption("$Unlock Ysgramor's Tomb", ToggleYsgramorsTomb, OPTION_FLAG_DISABLED)
	Else
		OIDYsgramorsTomb = AddToggleOption("$Unlock Ysgramor's Tomb", ToggleYsgramorsTomb)
	EndIf
	SetCursorPosition(1)
	AddHeaderOption("$Thalmor Embassy")
	If (MQ106.IsCompleted())
		OIDThalmorEmbassy = AddToggleOption("$Unlock Thalmor Embassy", ToggleThalmorEmbassy, OPTION_FLAG_DISABLED)
	Else
		OIDThalmorEmbassy = AddToggleOption("$Unlock Thalmor Embassy", ToggleThalmorEmbassy)
	EndIf
	AddEmptyOption()
	AddHeaderOption("$Sky Haven Temple")
	If (MQ202.IsCompleted())
		OIDSkyHavenTemple = AddToggleOption("$Unlock Sky Haven Temple", ToggleSkyHavenTemple, OPTION_FLAG_DISABLED)
	Else
		OIDSkyHavenTemple = AddToggleOption("$Unlock Sky Haven Temple", ToggleSkyHavenTemple)
	EndIf
	AddEmptyOption()
	AddHeaderOption("$Skuldafn")
	If (TT_Quest_Skuldafn.GetStage() >= 20)
		OIDSkuldafn = AddToggleOption("$Unlock Skuldafn", ToggleSkuldafn, OPTION_FLAG_DISABLED)
	Else
		OIDSkuldafn = AddToggleOption("$Unlock Skuldafn", ToggleSkuldafn)
	EndIf
	If (TT_Quest_Skuldafn.GetStage() >= 20 || !ToggleSkuldafn)
		OIDSkuldafnHint = AddToggleOption("$Reveal location of the item", ToggleSkuldafnHint, OPTION_FLAG_DISABLED)
	Else
		OIDSkuldafnHint = AddToggleOption("$Reveal location of the item", ToggleSkuldafnHint)
	EndIf
	AddHeaderOption("$The Jagged Crown")
	If (CW02A.IsCompleted() || CW02B.IsCompleted())
		OIDKorvanjund = AddToggleOption("$Unmark Jagged Crown as quest item", ToggleKorvanjund, OPTION_FLAG_DISABLED)
	Else
		OIDKorvanjund = AddToggleOption("$Unmark Jagged Crown as quest item", ToggleKorvanjund)
	EndIf
EndEvent


Event OnOptionSelect(Int Option)
	If (Option == OIDIrkngthand)
		ToggleIrkngthand = !ToggleIrkngthand
		SetToggleOptionValue(OIDIrkngthand, ToggleIrkngthand)
		If (ToggleIrkngthand)
			Unlocker.UnlockIrkngthand()
		Else
			Unlocker.LockIrkngthand()
		EndIf
	ElseIf (Option == OIDSaarthal)
		ToggleSaarthal = !ToggleSaarthal
		SetToggleOptionValue(OIDSaarthal, ToggleSaarthal)
		If (ToggleSaarthal)
			If (ShowMessage("$TT_ConfirmationCollege"))
				Unlocker.UnlockSaarthal()
			Else
				ToggleSaarthal = !ToggleSaarthal
				SetToggleOptionValue(OIDSaarthal, ToggleSaarthal)
			EndIf
		Else
			Unlocker.LockSaarthal()
		EndIf
	ElseIf (Option == OIDLabyrinthian)
		ToggleLabyrinthian = !ToggleLabyrinthian
		SetToggleOptionValue(OIDLabyrinthian, ToggleLabyrinthian)
		If (ToggleLabyrinthian)
			If (ShowMessage("$TT_ConfirmationCollege"))
				Unlocker.UnlockLabyrinthian()
			Else
				ToggleLabyrinthian = !ToggleLabyrinthian
				SetToggleOptionValue(OIDLabyrinthian, ToggleLabyrinthian)
			EndIf
		Else
			Unlocker.LockLabyrinthian()
		EndIf
	ElseIf (Option == OIDKatariah)
		ToggleKatariah = !ToggleKatariah
		SetToggleOptionValue(OIDKatariah, ToggleKatariah)
		If (ToggleKatariah)
			If (ShowMessage("$TT_ConfirmationDarkBrotherhood"))
				Unlocker.UnlockKatariah()
			Else
				ToggleKatariah = !ToggleKatariah
				SetToggleOptionValue(OIDKatariah, ToggleKatariah)
			EndIf
		Else
			Unlocker.LockKatariah()
		EndIf
	ElseIf (Option == OIDThalmorEmbassy)
		ToggleThalmorEmbassy = !ToggleThalmorEmbassy
		SetToggleOptionValue(OIDThalmorEmbassy, ToggleThalmorEmbassy)
		If (ToggleThalmorEmbassy)
			If (ShowMessage("$TT_ConfirmationMainQuest"))
				Unlocker.UnlockThalmorEmbassy()
			Else
				ToggleThalmorEmbassy = !ToggleThalmorEmbassy
				SetToggleOptionValue(OIDThalmorEmbassy, ToggleThalmorEmbassy)
			EndIf
		Else
			Unlocker.LockThalmorEmbassy()
		EndIf
	ElseIf (Option == OIDSkyHavenTemple)
		ToggleSkyHavenTemple = !ToggleSkyHavenTemple
		SetToggleOptionValue(OIDSkyHavenTemple, ToggleSkyHavenTemple)
		If (ToggleSkyHavenTemple)
			Unlocker.UnlockSkyHavenTemple()
		Else
			Unlocker.LockSkyHavenTemple()
		EndIf
	ElseIf (Option == OIDSkuldafn)
		ToggleSkuldafn = !ToggleSkuldafn
		SetToggleOptionValue(OIDSkuldafn, ToggleSkuldafn)
		If (ToggleSkuldafn)
			If (ShowMessage("$TT_ConfirmationMainQuest"))
				Unlocker.UnlockSkuldafn()
			Else
				ToggleSkuldafn = !ToggleSkuldafn
				SetToggleOptionValue(OIDSkuldafn, ToggleSkuldafn)
			EndIf
		Else
			Unlocker.LockSkuldafn()
		EndIf
	ElseIf (Option == OIDSkuldafnHint)
		ToggleSkuldafnHint = !ToggleSkuldafnHint
		SetToggleOptionValue(OIDSkuldafnHint, ToggleSkuldafnHint)
		If (ToggleSkuldafnHint)
			TT_Quest_Skuldafn.SetStage(5)
		EndIf
	ElseIf (Option == OIDKorvanjund)
		ToggleKorvanjund = !ToggleKorvanjund
		SetToggleOptionValue(OIDKorvanjund, ToggleKorvanjund)
		If (ToggleKorvanjund)
			If (ShowMessage("$TT_ConfirmationCivilWar"))
				Unlocker.UnlockKorvanjund()
			Else
				ToggleKorvanjund = !ToggleKorvanjund
				SetToggleOptionValue(OIDKorvanjund, ToggleKorvanjund)
			EndIf
		Else
			Unlocker.LockKorvanjund()
		EndIf
	ElseIf (Option == OIDYsgramorsTomb)
		ToggleYsgramorsTomb = !ToggleYsgramorsTomb
		SetToggleOptionValue(OIDYsgramorsTomb, ToggleYsgramorsTomb)
		If (ToggleYsgramorsTomb)
			If (ShowMessage("$TT_ConfirmationCompanions"))
				Unlocker.UnlockYsgramorsTomb()
			Else
				ToggleYsgramorsTomb = !ToggleYsgramorsTomb
				SetToggleOptionValue(OIDYsgramorsTomb, ToggleYsgramorsTomb)
			EndIf
		Else
			Unlocker.LockYsgramorsTomb()
		EndIf
	EndIf
EndEvent


Event OnOptionHighlight(Int Option)
	If (Option == OIDIrkngthand)
		SetInfoText("$TT_InfoIrkngthand")
	ElseIf (Option == OIDSaarthal)
		SetInfoText("$TT_InfoSaarthal")
	ElseIf (Option == OIDLabyrinthian)
		SetInfoText("$TT_InfoLabyrinthian")
	ElseIf (Option == OIDKatariah)
		SetInfoText("$TT_InfoKatariah")
	ElseIf (Option == OIDThalmorEmbassy)
		SetInfoText("$TT_InfoThalmorEmbassy")
	ElseIf (Option == OIDSkuldafn)
		SetInfotext("$TT_InfoSkuldafn")
	ElseIf (Option == OIDKorvanjund)
		SetInfoText("$TT_InfoKorvanjund")
	ElseIf (Option == OIDSkyHavenTemple)
		SetInfoText("$TT_InfoSkyHavenTemple")
	ElseIf (Option == OIDYsgramorsTomb)
		SetInfoText("$TT_InfoYsgramorsTomb")
	EndIf
EndEvent

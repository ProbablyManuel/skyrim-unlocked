 scriptname TTSkyrimUnlockedMCMScript extends SKI_ConfigBase
{MCM for Skyrim Unlocked.}

Actor property TitusMedeIIRef auto

ActorBase property Elenwen auto

Bool ToggleIrkngthand = false
Bool ToggleSaarthal = false
Bool ToggleLabyrinthian = false
Bool ToggleKatariah = false
Bool ToggleThalmorEmbassy = false
Bool ToggleKorvanjund = false
Bool ToggleSkuldafn = false
Bool ToggleSkuldafnHint = false
Bool ToggleUninstall = false

Cell property DustmansCairn01 auto
Cell property DustmansCairn02 auto
Cell property Mzulft01 auto
Cell property Mzulft02 auto
Cell property Mzulft03 auto

Faction property MQ201ThalmorCombatFaction auto
Faction property PlayerFaction auto

Int OIDIrkngthand
Int OIDSaarthal
Int OIDLabyrinthian
Int OIDKatariah
Int OIDThalmorEmbassy
Int OIDSkuldafn
Int OIDSkuldafnHint
Int OIDKorvanjund
Int OIDUninstall

Location property DustmansCairnLocation auto
Location property MzulftLocation auto

ObjectReference property AbandonedShackExteriorDoorRef auto
ObjectReference property AbandonedShackInteriorDoorRef auto
ObjectReference property ArmorBoneCrownRef auto
ObjectReference property dunKilkreathCrystalPedestalREF01 auto
ObjectReference property dunKilkreathCrystalPedestalREF02 auto
ObjectReference property dunKilkreathCrystalPedestalREF03 auto
ObjectReference property dunKilkreathCrystalPedestalREF04 auto
ObjectReference property dunKilkreathCrystalPedestalREF05 auto
ObjectReference property dunKilkreathCrystalPedestalREF06 auto
ObjectReference property dunKilkreathCrystalPedestalREF07 auto
ObjectReference property IrkngthandExtUpperToInt auto
ObjectReference property KatariahEnableMarker auto
ObjectReference property MG02AmuletTrigger auto
ObjectReference property MQ201barBackroomDoor auto
ObjectReference property MQ201barBackroomDoorOut auto
ObjectReference property NorLabyrinthianActivatedDoor auto
ObjectReference property TG08BridgeEnableRef auto
ObjectReference property ThalmorEmbassyGate auto
ObjectReference property ThalmorEmbassyFrontDoor auto

Quest property C01 auto
Quest property CW02A auto
Quest property CW02B auto
Quest property DB02 auto
Quest property DB10 auto
Quest property MG01 auto
Quest property MG05 auto
Quest property MG06 auto
Quest property MQ106 auto
Quest property TG08A auto
Quest property TTSkuldafnQuest auto

ReferenceAlias property Alias_ArmorBoneCrown auto


Event OnPageReset(String Page)
	SetCursorFillMode(TOP_TO_BOTTOM)
	AddHeaderOption("Irkngthand")
	if (TG08A.IsCompleted() || ToggleUninstall)
		OIDIrkngthand = AddToggleOption("Unlock Irkngthand", ToggleIrkngthand, OPTION_FLAG_DISABLED)
	else
		OIDIrkngthand = AddToggleOption("Unlock Irkngthand", ToggleIrkngthand)
	endif
	AddEmptyOption()
	AddHeaderOption("Saarthal")
	if (MG01.IsCompleted() || ToggleUninstall)
		OIDSaarthal = AddToggleOption("Unlock Saarthal", ToggleSaarthal, OPTION_FLAG_DISABLED)
	else
		OIDSaarthal = AddToggleOption("Unlock Saarthal", ToggleSaarthal)
	endif
	AddEmptyOption()
	AddHeaderOption("Labyrinthian")
	if (MG05.IsCompleted() || ToggleUninstall)
		OIDLabyrinthian = AddToggleOption("Unlock Labyrinthian", ToggleLabyrinthian, OPTION_FLAG_DISABLED)
	else
		OIDLabyrinthian = AddToggleOption("Unlock Labyrinthian", ToggleLabyrinthian)
	endif
	AddEmptyOption()
	AddHeaderOption("The Katariah")
	if (DB10.IsCompleted() || ToggleUninstall)
		OIDKatariah = AddToggleOption("Unlock The Katariah", ToggleKatariah, OPTION_FLAG_DISABLED)
	else
		OIDKatariah = AddToggleOption("Unlock The Katariah", ToggleKatariah)
	endif
	SetCursorPosition(1)
	AddHeaderOption("Thalmor Embassy")
	if (MQ106.IsCompleted() || ToggleUninstall)
		OIDThalmorEmbassy = AddToggleOption("Unlock Thalmor Embassy", ToggleThalmorEmbassy, OPTION_FLAG_DISABLED)
	else
		OIDThalmorEmbassy = AddToggleOption("Unlock Thalmor Embassy", ToggleThalmorEmbassy)
	endif
	AddEmptyOption()
	AddHeaderOption("Skuldafn")
	if (TTSkuldafnQuest.GetCurrentStageID() >= 20 || ToggleUninstall)
		OIDSkuldafn = AddToggleOption("Unlock Skuldafn", ToggleSkuldafn, OPTION_FLAG_DISABLED)
	else
		OIDSkuldafn = AddToggleOption("Unlock Skuldafn", ToggleSkuldafn)
	endif
	if (TTSkuldafnQuest.GetCurrentStageID() >= 20 || !ToggleSkuldafn)
		OIDSkuldafnHint = AddToggleOption("Reveal the location of the item", ToggleSkuldafnHint, OPTION_FLAG_DISABLED)
	else
		OIDSkuldafnHint = AddToggleOption("Reveal the location of the item", ToggleSkuldafnHint)
	endif
	AddHeaderOption("The Jagged Crown")
	if (CW02A.IsCompleted() || CW02B.IsCompleted() || ToggleUninstall)
		OIDKorvanjund = AddToggleOption("Unmark Jagged Crown as quest item", ToggleKorvanjund, OPTION_FLAG_DISABLED)
	else
		OIDKorvanjund = AddToggleOption("Unmark Jagged Crown as quest item", ToggleKorvanjund)
	endif
	AddEmptyOption()
	AddHeaderOption("Uninstallation")
	OIDUninstall = AddToggleOption("Uninstall Mod", ToggleUninstall)
EndEvent


Event OnOptionSelect(Int Option)
	if (Option == OIDIrkngthand)
		ToggleIrkngthand = !ToggleIrkngthand
		SetToggleOptionValue(OIDIrkngthand, ToggleIrkngthand)
		if (ToggleIrkngthand)
			TG08BridgeEnableRef.Enable()
			IrkngthandExtUpperToInt.SetLockLevel(0)
			IrkngthandExtUpperToInt.Lock(false)
		else
			TG08BridgeEnableRef.Disable()
			IrkngthandExtUpperToInt.SetLockLevel(255)
			IrkngthandExtUpperToInt.Lock()
		endif
	elseif (Option == OIDSaarthal)
		ToggleSaarthal = !ToggleSaarthal
		SetToggleOptionValue(OIDSaarthal, ToggleSaarthal)
		if (ToggleSaarthal)
			MG02AmuletTrigger.Enable()
			Debug.MessageBox("You are about to BREAK the College of Winterhold questline! If you want to complete said questline on this save game untick this option right now.")
		else
			MG02AmuletTrigger.Disable()
		endif
	elseif (Option == OIDLabyrinthian)
		ToggleLabyrinthian = !ToggleLabyrinthian
		SetToggleOptionValue(OIDLabyrinthian, ToggleLabyrinthian)
		if (ToggleLabyrinthian)
			NorLabyrinthianActivatedDoor.Disable()
			Debug.MessageBox("You are about to BREAK the College of Winterhold questline! If you want to complete said questline on this save game untick this option right now.")
		else
			NorLabyrinthianActivatedDoor.Enable()
		endif
	elseif (Option == OIDKatariah)
		ToggleKatariah = !ToggleKatariah
		SetToggleOptionValue(OIDKatariah, ToggleKatariah)
		if (ToggleKatariah)
			KatariahEnableMarker.Enable()
			TitusMedeIIRef.Enable()
			Debug.MessageBox("You are about to BREAK the Dark Brotherhood questline! If you want to complete said questline on this save game untick this option right now.")
		else
			KatariahEnableMarker.Disable()
			TitusMedeIIRef.Disable()
		endif
	elseif (Option == OIDThalmorEmbassy)
		ToggleThalmorEmbassy = !ToggleThalmorEmbassy
		SetToggleOptionValue(OIDThalmorEmbassy, ToggleThalmorEmbassy)
		if (ToggleThalmorEmbassy)
			ThalmorEmbassyGate.SetLockLevel(50)
			ThalmorEmbassyFrontDoor.SetLockLevel(0)
			MQ201barBackroomDoor.SetLockLevel(0)
			MQ201barBackroomDoorOut.SetLockLevel(0)
			ThalmorEmbassyFrontDoor.Lock(false)
			MQ201barBackroomDoor.Lock(false)
			MQ201barBackroomDoorOut.Lock(false)
			Elenwen.SetEssential(false)
			MQ201ThalmorCombatFaction.SetEnemy(PlayerFaction)
			Debug.MessageBox("You are about to BREAK the main questline! If you want to complete said questline on this save game untick this option right now.")
		else
			ThalmorEmbassyGate.SetLockLevel(255)
			ThalmorEmbassyFrontDoor.SetLockLevel(255)
			MQ201barBackroomDoor.SetLockLevel(255)
			MQ201barBackroomDoorOut.SetLockLevel(255)
			ThalmorEmbassyGate.Lock()
			ThalmorEmbassyFrontDoor.Lock()
			MQ201barBackroomDoor.Lock()
			MQ201barBackroomDoorOut.Lock()
			Elenwen.SetEssential()
			MQ201ThalmorCombatFaction.SetEnemy(PlayerFaction, True, True)
		endif
	elseif (Option == OIDSkuldafn)
		ToggleSkuldafn = !ToggleSkuldafn
		SetToggleOptionValue(OIDSkuldafn, ToggleSkuldafn)
		if (ToggleSkuldafn)
			Debug.MessageBox("You are about to BREAK the main questline! If you want to complete said questline on this save game untick this option right now.")
			TTSkuldafnQuest.Start()
			ForcePageReset()
		else
			TTSkuldafnQuest.SetStage(99)
		endif
	elseif (Option == OIDSkuldafnHint)
		ToggleSkuldafnHint = !ToggleSkuldafnHint
		SetToggleOptionValue(OIDSkuldafnHint, ToggleSkuldafnHint)
		if (ToggleSkuldafnHint)
			TTSkuldafnQuest.SetStage(5)
		endif
	elseif (Option == OIDKorvanjund)
		ToggleKorvanjund = !ToggleKorvanjund
		SetToggleOptionValue(OIDKorvanjund, ToggleKorvanjund)
		if (ToggleKorvanjund)
			Alias_ArmorBoneCrown.Clear()
			Debug.MessageBox("You are about to BREAK the Civil War questline! If you want to complete said questline on this save game untick this option right now.")
		else
			Alias_ArmorBoneCrown.ForceRefTo(ArmorBoneCrownRef)
		endif
	elseif (Option == OIDUninstall)
		ToggleUninstall = !ToggleUninstall
		SetToggleOptionValue(OIDUninstall, ToggleUninstall)
		if (ToggleUninstall)
			AbandonedShackExteriorDoorRef.BlockActivation(false)
			AbandonedShackInteriorDoorRef.BlockActivation(false)
			dunKilkreathCrystalPedestalREF01.BlockActivation(false)
			dunKilkreathCrystalPedestalREF02.BlockActivation(false)
			dunKilkreathCrystalPedestalREF03.BlockActivation(false)
			dunKilkreathCrystalPedestalREF04.BlockActivation(false)
			dunKilkreathCrystalPedestalREF05.BlockActivation(false)
			dunKilkreathCrystalPedestalREF06.BlockActivation(false)
			dunKilkreathCrystalPedestalREF07.BlockActivation(false)
			if (!C01.IsStageDone(30))
				DustmansCairn01.Reset()
				DustmansCairn02.Reset()
				DustmansCairnLocation.SetCleared(false)
			endif
			if (!MG06.IsStageDone(20))
				Mzulft01.Reset()
				Mzulft02.Reset()
				Mzulft03.Reset()
				MzulftLocation.SetCleared(false)
			endif
			if (TTSkuldafnQuest.IsRunning())
				TTSkuldafnQuest.Stop()
			endif
			ForcePageReset()
		else
			AbandonedShackExteriorDoorRef.BlockActivation()
			AbandonedShackInteriorDoorRef.BlockActivation()
			ForcePageReset()
		endif
	endif
EndEvent


Event OnOptionHighlight(Int Option)
	if (Option == OIDIrkngthand)
		SetInfoText("Grants access to the interior of Irkngthand.\nThis doesn't break any quest but it's still not recommend to use this option if you plan to complete the Thieves Guild questline. It can lead to illogical scenes in Irkngthand.")
	elseif (Option == OIDSaarthal)
		SetInfoText("Allows to take the Ancient Amulet in Saarthal and therefore grants access to the full dungeon.\nThis will BREAK the College of Winterhold questline.")
	elseif (Option == OIDLabyrinthian)
		SetInfoText("Grants access to the interior of Labyrinthian.\nThis will BREAK the College of Winterhold questline.")
	elseif (Option == OIDKatariah)
		SetInfoText("Enables the Katariah.\nThis will BREAK the Dark Brotherhood questline.")
	elseif (Option == OIDThalmorEmbassy)
		SetInfoText("Grants access to the Thalmor Embassy.\nThis will BREAK the main questline.")
	elseif (Option == OIDSkuldafn)
		SetInfotext("Places an item somewhere in Skyrim that can bring you to Skuldafn.\nThis will BREAK the main questline.")
	elseif (Option == OIDSkuldafnHint)
		SetInfoText("Reveals the location of the item.")
	elseif (Option == OIDKorvanjund)
		SetInfoText("Allows to remove the Jagged Crown from the inventory.\nDO NOT USE this option if you plan to finish the Civil War questline.")
	elseif (Option == OIDUninstall)
		SetInfoText("Prepares uninstallation of the mod.")
	endif
EndEvent

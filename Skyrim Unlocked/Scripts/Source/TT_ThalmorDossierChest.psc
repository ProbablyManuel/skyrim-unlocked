ScriptName TT_ThalmorDossierChest Extends ObjectReference
{Adds Esbern's Dossier to the chest if the player chose not to do the main quest}

Book Property EsbernDossier Auto
GlobalVariable Property TT_GV_ThalmorEmbassy Auto
{Non-zero if the player chose not to do the main quest}


Event OnCellAttach()
	If (TT_GV_ThalmorEmbassy.GetValue())
		Self.AddItem(EsbernDossier)
	EndIf
	GoToState("Done")
EndEvent


State Done
	Event OnCellAttach()
		; Do nothing
	EndEvent
EndState

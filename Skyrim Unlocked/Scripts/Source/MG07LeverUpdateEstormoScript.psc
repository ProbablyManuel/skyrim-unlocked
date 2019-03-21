ScriptName MG07LeverUpdateEstormoScript Extends ObjectReference  

Quest Property MG07 Auto

ReferenceAlias Property MG07Estormo Auto


Event OnActivate(ObjectReference ActionRef)
	If (ActionRef == Game.GetPlayer() && MG07.IsRunning())
		MG07QuestScript QuestScript = MG07 As MG07QuestScript
		If (QuestScript.EstormoUpdate == 0)
			QuestScript.EstormoUpdate = 1
			MG07Estormo.GetActorReference().EvaluatePackage()
		EndIf
	EndIf
EndEvent

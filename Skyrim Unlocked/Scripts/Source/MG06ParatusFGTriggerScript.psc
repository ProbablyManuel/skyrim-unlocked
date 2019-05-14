ScriptName MG06ParatusFGTriggerScript Extends ObjectReference

Quest Property MG06 Auto

ReferenceAlias Property MG06Paratus Auto


Event OnTriggerEnter(ObjectReference akActionRef)
	If (akActionRef == Game.GetPlayer() && MG06.IsStageDone(30))
		MG06QuestScript QuestScript = MG06 As MG06QuestScript
		If (QuestScript.MG06ParatusTracker == 0)
			QuestScript.MG06ParatusTracker = 1
			MG06Paratus.GetActorReference().EvaluatePackage()
		EndIf
	Endif
EndEvent

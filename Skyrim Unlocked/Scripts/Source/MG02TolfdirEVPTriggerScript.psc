ScriptName MG02TolfdirEVPTriggerScript Extends ObjectReference  

ReferenceAlias Property MG02Tolfdir Auto


Event OnTriggerEnter(ObjectReference ActionRef)
	If (ActionRef == Game.GetPlayer())
		If (MG02Tolfdir.GetOwningQuest().IsRunning())
			MG02Tolfdir.GetActorReference().EvaluatePackage()
			Disable()
		EndIf
	EndIf
EndEvent

ScriptName MQ201TrapDoorScript Extends ReferenceAlias  
{Block trap door prior to getting information about the dragons returning}

Event OnLoad()
	If (!GetOwningQuest().GetStageDone(220))
		GetReference().BlockActivation(True)
	EndIf
EndEvent


Event OnActivate(ObjectReference akActionRef)
	If (GetReference().IsActivationBlocked() && akActionRef == Game.GetPlayer())
		If (GetOwningQuest().GetStageDone(220))
			GetReference().BlockActivation(False)
			GetReference().Activate(akActionRef)
		Else
			Debug.Notification("I still need to search for information...")
		EndIf
	EndIf
EndEvent

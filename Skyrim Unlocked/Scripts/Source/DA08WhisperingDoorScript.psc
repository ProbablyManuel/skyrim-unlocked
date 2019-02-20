ScriptName DA08WhisperingDoorScript Extends ReferenceAlias  

ReferenceAlias Property DA08WhisperingDoorTalkingActivator Auto
ReferenceAlias Property WhisperingName Auto
ReferenceAlias Property MysteriousName Auto


Event OnActivate(ObjectReference akActivator)
; 	Debug.Trace("DA08: Activating door. Activation blocked? -- " + GetReference().IsActivationBlocked())
	If (GetReference().IsActivationBlocked())
		DA08WhisperingDoorTalkingActivator.GetReference().Activate(akActivator)
	EndIf
EndEvent

Event OnLockStateChanged()
	If (!Self.GetReference().IsLocked())
		DA08WhisperingDoorTalkingActivator.GetReference().Disable()
		GetOwningQuest().SetStage(50)
	EndIf
EndEvent

Function RenameToWhispering()
	WhisperingName.ForceRefTo(Self.GetReference())
	MysteriousName.Clear()
EndFunction

Function RenameToMysterious()
	MysteriousName.ForceRefTo(Self.GetReference())
	WhisperingName.Clear()
EndFunction

Function Redirect()
	GetReference().BlockActivation()
EndFunction

Function UndoRedirect()
	GetReference().BlockActivation(False)
EndFunction

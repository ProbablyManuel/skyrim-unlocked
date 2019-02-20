ScriptName MG02Stage60TolfdirTriggerScript Extends ObjectReference Conditional

Int Property DoOnce Auto Conditional
ObjectReference Property DraugrTrigger Auto
Quest Property MG02 Auto
ReferenceAlias Property Tolfdir Auto


Event OnTriggerEnter(ObjectReference akActionRef)
	If (MG02.IsRunning())
		If (akActionRef == Tolfdir.GetReference())
			If (MG02.GetStage() >= 50)
				If (DoOnce == 0)
					DoOnce = 1
					Activate(Self)
					Disable()
				EndIf
			EndIf
		EndIf
	Else
		If (akActionRef == Game.GetPlayer())
			Activate(Self)
			Disable()
		EndIf
	EndIf
EndEvent

ScriptName TG07BarScript Extends ObjectReference
{Handles the bars in Riftweald Manor during and after "The Pursuit"}

Message Property TG07BarDoorOpenMSG Auto
Quest Property TG08B Auto


Event OnLoad()
	If (TG08B.IsCompleted())
		; Disable() doesn't work because of the enable parent
		SetPosition(0.0, 0.0, 0.0)
	Else
		BlockActivation()
	EndIf
EndEvent


Event OnActivate(ObjectReference akActionRef)
	If (IsActivationBlocked() && akActionRef == Game.GetPlayer())
		TG07BarDoorOpenMSG.Show()
	EndIf
EndEvent

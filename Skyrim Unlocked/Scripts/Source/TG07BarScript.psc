scriptname TG07BarScript extends ObjectReference
{Handles the bars in Riftweald Manor during and after TG07 "The Pursuit".}

Actor property PlayerREF auto
Message property TG07BarDoorOpenMSG auto
Quest property TG08B auto


Event OnLoad()
	BlockActivation()
	if (TG08B.IsCompleted())	;Once Mercer is dead these bars have no longer any use.
		SetPosition(0.0, 0.0, 0.0) ;Disable() doesn't work here because of the Enable Parents.
	endif
EndEvent


Event OnActivate(ObjectReference akActionRef)
	if (akActionRef == PlayerREF && IsActivationBlocked())
		TG07BarDoorOpenMSG.Show()
	endif
EndEvent 
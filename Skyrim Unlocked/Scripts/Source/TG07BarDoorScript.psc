scriptname TG07BarDoorScript extends ObjectReference Conditional
{Handles Riftweald Manor during TG07 "The Pursuit".}

Actor property PlayerREF auto
Message property barredDoorMSG auto
Quest property TG08B auto
Quest property TG05 auto


Event OnLoad()
	
	if (TG05.IsCompleted())
		BlockActivation()	;Mercer will block the doors to Riftweald Manor, after the player will have found out what he really did.
	endif

	if (TG08B.IsCompleted())
		BlockActivation(false)	;Once Mercer is dead, the doors will be unblocked again.
	endif
EndEvent


Event OnActivate(ObjectReference akActionRef)
	if (akActionRef == PlayerREF && IsActivationBlocked())
		barredDoorMSG.Show()
	endif
EndEvent 
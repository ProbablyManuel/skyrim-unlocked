scriptname TTWhisperingDoor extends ObjectReference
{Handles the Whispering Door during the quest.}

Actor property PlayerREF auto
Message property TTWhisperingDoorMessage auto
Quest property DA08 auto


Event OnInit()
	if (DA08.IsStageDone(40) == false)
		BlockActivation()	;Blocks the door until the quest has started.
	endif
EndEvent


Event OnActivate(ObjectReference akActionRef)
	if (akActionRef == PlayerREF)
		if (IsActivationBlocked())
			if (DA08.IsStageDone(20) == false)	;after stage 20 the quest controls the door.
				TTWhisperingDoorMessage.Show()	;explains why the player can't activate the door.
			elseif (DA08.IsStageDone(25))
				BlockActivation(false)	;picking the door is now allowed.
				Activate(PlayerREF)	;Activate again because the first activation failed.
			endif
		endif
		if (DA08.GetCurrentStageID() == 25 || DA08.GetCurrentStageID() == 30)
			Utility.Wait(0.3)
			if (IsLocked() == false)	;The player opens the door without the key.
				DA08.SetStage(40)	;Advances the quest as if the door was opened with the key.
				DA08.SetStage(50)
			endif
		endif
	endif
EndEvent 
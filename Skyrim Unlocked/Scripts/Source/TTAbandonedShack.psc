scriptname TTAbandonedShack extends ObjectReference
{Blocks the Abandoned Shack prior to and during "With Friends Like These...". Has no real use besides immersion.}

Actor property PlayerREF auto
Bool property IsInside auto		;True on the interior door, false on the exterior.
Message property TTAbandonedShackMessage auto
Quest property DB02 auto


Event OnInit()
	BlockActivation()
EndEvent


Event OnLoad()
	if (DB02.GetStageDone(40) || DB02.GetStageDone(220))	;After any of these stages the player is allowed to leave the shack.
		if (IsActivationBlocked())
			BlockActivation(false)	;Unblocks the door.
		endif
	endif
EndEvent


Event OnActivate(ObjectReference akActionRef)
	if (akActionRef == PlayerREF && IsActivationBlocked())
		if (IsInside)
			if (DB02.GetStageDone(40) || DB02.GetStageDone(220))	;After any of these stages the player is allowed to leave the shack.
				BlockActivation(false)	;Unblocks the door.
			else
				TTAbandonedShackMessage.Show()	;The player shouldn't be able to open the door.
			endif
		else
			TTAbandonedShackMessage.Show()	;This property is set to barredDoorMSG and NOT the actual TTAbandonedShackMessage.
		endif
	endif
EndEvent 
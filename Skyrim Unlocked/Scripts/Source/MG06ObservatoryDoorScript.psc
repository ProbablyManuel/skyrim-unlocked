Scriptname MG06ObservatoryDoorScript extends ObjectReference
{Starts Paratus' scence at the Observatory door in Mzulft.}

Actor property PlayerREF auto
Actor property MG06ParatusRef01 auto
Quest property MG06 auto
Scene property MG06ParatusScene auto 

Int DoOnce


Event OnActivate(ObjectReference ActionRef)
; Debug.Trace("Door Activated")
	if (DoOnce == 0 && ActionRef == PlayerREF && MG06.IsStageDone(30))	;We do nothing if the player isn't here for MG06.
		MG06ParatusScene.Start()
		DoOnce = 1
	endif
EndEvent 
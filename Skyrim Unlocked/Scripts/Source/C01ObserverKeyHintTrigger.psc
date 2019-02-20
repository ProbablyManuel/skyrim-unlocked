Scriptname C01ObserverKeyHintTrigger extends ObjectReference
{Hint scence for the not-so-bright-player.} 

Actor property PlayerREF auto
Key property CairnKey auto
ObjectReference property TheDoor auto
Quest property C01 auto
Scene property HintScene auto


auto State WaitingForPlayer
	Event OnTriggerEnter(ObjectReference akActivator)
		if (akActivator == PlayerREF && C01.IsStageDone(30))	;We do nothing if the player isn't here for C01.
			RegisterForUpdate(15)
			GoToState("PlayerTriggered")
		endif
	EndEvent
EndState


State PlayerTriggered
EndState


Event OnUpdate()
	if (C01.IsCompleted() || PlayerREF.GetItemCount(CairnKey) >= 1 || TheDoor.IsLocked() == false)	;Unregister as soon as the player has the key or the door has been unlocked.
		UnregisterForUpdate()
		Disable()
		Delete()
	else
		HintScene.Start()
	endif
EndEvent

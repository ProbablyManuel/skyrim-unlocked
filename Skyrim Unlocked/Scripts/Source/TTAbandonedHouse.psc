scriptname TTAbandonedHouse extends ObjectReference
{Blocks activation of the basement door in the Abandoned House in Markarth if the quest hasn't yet started.}

Actor property PlayerREF auto
Bool property ShouldBlock auto
Message property TTAbandonedHouseMessage auto
Quest property DA10 auto


Event OnInit()
	if (ShouldBlock && DA10.GetStage() < 70)
		BlockActivation()
	endif
EndEvent


Event OnActivate(ObjectReference akActionRef)
	if (IsActivationBlocked() && akActionRef == PlayerREF)
		TTAbandonedHouseMessage.Show()
	endif
EndEvent 
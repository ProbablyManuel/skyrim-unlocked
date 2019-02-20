Scriptname TTSaarthalAmuletTrigger extends ObjectReference
{Allows the player to take the Saarthal Amulet without starting "Under Saarthal".}

Actor property PlayerREF auto
Armor property MG02Amulet auto
ObjectReference property SpikeTrigger auto
ObjectReference property MG02Wall auto
Quest property MG02 auto

Bool DoOnce = true


Event OnActivate(objectReference ActionRef)
	if (MG02.IsStageDone(10) == false)	;We do nothing if "Under Saarthal" has been started. The quest already handles everyting.
		if (ActionRef == PlayerREF && DoOnce)
			DoOnce = false
			MG02Wall.PlayAnimation("Take")
			PlayerREF.AddItem(MG02Amulet)
			SpikeTrigger.Activate(PlayerREF)
			Disable()
		endif
	endif
EndEvent 
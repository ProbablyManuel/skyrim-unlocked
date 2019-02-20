scriptname TTShrineOfAzura extends ObjectReference
{Attached to a trigger box at the Shrine of Azura. Not the most elegant way, but this prevents editing the quest.}

Actor  property PlayerREF auto
ObjectReference property DA01AzurasStarBrokenREF auto
Quest property DA01 auto


Event OnTrigger(ObjectReference akActionRef)
	if (akActionRef == PlayerREF && DA01.IsStageDone(10) && DA01.IsStageDone(50) == false && PlayerREF.GetItemCount(DA01AzurasStarBrokenREF))
		DA01.SetStage(30)	;Advances the quest if the player already has the Star when he talks to Aranea.
		DA01.SetStage(50)
		Disable()
	endif
EndEvent 
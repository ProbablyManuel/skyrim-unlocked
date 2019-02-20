scriptname TTShrinePeryite extends ObjectReference
{Attached to a trigger box at the Shrine of Peryite. Not the most elegant way, but this prevents editing the quest.}

Actor property PlayerREF auto
Actor property DA13Orchender auto
Quest property DA13 auto


Event OnTrigger(ObjectReference akActionRef)
	if (akActionRef == PlayerREF && DA13.GetStageDone(40) && DA13Orchender.IsDead())
		;Advances the quest, if the player communicates with Peryite for the first time AFTER he had killed Orchendor.
		DA13.SetStage(75)
		Disable()
	endif
EndEvent 
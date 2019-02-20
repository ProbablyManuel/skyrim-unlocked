scriptname TTEnableQuestContent extends ObjectReference
{Used to enable temporarily disabled quest content as soon as the quest starts.}

Int property RequiredQuestStage auto
Quest property MyQuest auto


Event OnCellAttach()
	if (MyQuest.IsStageDone(RequiredQuestStage))
		Enable()
		GoToState("Done")
	endif
EndEvent


State Done
	Event OnCellAttach()
		;Do nothing.
	EndEvent
EndState 
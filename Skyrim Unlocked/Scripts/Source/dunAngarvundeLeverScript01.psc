Scriptname dunAngarvundeLeverScript01 extends ReferenceAlias 

Event OnActivate(ObjectReference TriggerRef)
	;if Lever02 is flipped first
	if (GetOwningQuest().GetStageDone(55) == true && GetOwningQuest().GetStageDone(60) == false)
		GetOwningQuest().SetStage(60)
		GetOwningQuest().SetStage(61)
	;if Lever03 is flipped first
	elseif (GetOwningQuest().GetStageDone(56) == true && GetOwningQuest().GetStageDone(60) == false)
	GetOwningQuest().SetStage(60)
	GetOwningQuest().SetStage(62)
	;Lever02 if flipped second
	elseif (GetOwningQuest().GetStageDone(65) == true && GetOwningQuest().GetStageDone(60) == true)
		if (GetOwningQuest().GetStageDone(50))
			GetOwningQuest().SetStage(70)
		else
			GetOwningQuest().SetStage(71)
		endif
	;Lever03 is flipped second
	elseif (GetOwningQuest().GetStageDone(66) == true && GetOwningQuest().GetStageDone(60) == true)
		if (GetOwningQuest().GetStageDone(50))
			GetOwningQuest().SetStage(70)
		else
			GetOwningQuest().SetStage(71)
		endif
	endif
EndEvent

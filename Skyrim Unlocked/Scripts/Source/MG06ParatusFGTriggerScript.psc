Scriptname MG06ParatusFGTriggerScript extends ObjectReference

Quest Property MG06 auto
ReferenceAlias Property MG06Paratus auto

Event OnTriggerEnter(ObjectReference ActionRef)

	MG06QuestScript QuestScript = MG06 as MG06QuestScript

	if (ActionRef == Game.GetPlayer() && MG06.IsStageDone(30))	;We do nothing if the player isn't here for MG06.
		if (QuestScript.MG06ParatusTracker == 0)
			QuestScript.MG06ParatusTracker=1
			MG06Paratus.GetActorReference().EvaluatePackage()
		endif
	endif

EndEvent 
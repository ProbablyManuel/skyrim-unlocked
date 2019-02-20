Scriptname MG02Cell02TolfdirMoveTriggerScript extends ObjectReference  
{When the player hits this trigger, we move Tolfdir to a marker around the corner and have him catch up.}

ReferenceAlias property MG02TolfdirAlias auto
Quest property MG02 auto
Scene property MoveScene auto
ObjectReference property Marker auto


Event OnTriggerEnter (ObjectReference ActionRef)

	MG02QuestScript QuestScript = MG02 as MG02QuestScript

	if (MG02.IsStageDone(10))	;Added by Skyrim Unlocked. We do nothing if the player isn't here for MG02.
		if (ActionRef == Game.GetPlayer())
			if (QuestScript.Cell02TolfdirMove == 0)
				QuestScript.Cell02TolfdirMove = 1
				MG02TolfdirAlias.GetReference().MoveTo(Marker)
				MG02TolfdirAlias.GetActorReference().EvaluatePackage()
				MoveScene.Start()
			endif
		endif
	endif

EndEvent 
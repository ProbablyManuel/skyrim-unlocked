ScriptName MG02Cell02TolfdirMoveTriggerScript Extends ObjectReference  
{When the player hits this trigger, we move Tolfdir to a marker around the corner and have him catch up}

ReferenceAlias Property MG02TolfdirAlias Auto
Quest Property MG02 Auto
Scene Property MoveScene Auto
ObjectReference Property Marker Auto


Event OnTriggerEnter(ObjectReference ActionRef)
	If (MG02.IsRunning())
		If (ActionRef == Game.GetPlayer())
			MG02QuestScript QuestScript = MG02 As MG02QuestScript
			If (QuestScript.Cell02TolfdirMove == 0)
				QuestScript.Cell02TolfdirMove = 1
				MG02TolfdirAlias.GetReference().MoveTo(Marker)
				MG02TolfdirAlias.GetActorReference().EvaluatePackage()
				MoveScene.Start()
			EndIf
		EndIf
	EndIf
EndEvent

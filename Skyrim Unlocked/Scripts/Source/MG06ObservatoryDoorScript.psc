ScriptName MG06ObservatoryDoorScript Extends ObjectReference

Scene Property MG06ParatusScene Auto 


Event OnLoad()
	If (MG06ParatusScene.GetOwningQuest().GetStage() > 0)
		Lock()
	Else
		Lock(False)
	EndIf
EndEvent

Event OnActivate(ObjectReference akActionRef)
	If (akActionRef == Game.GetPlayer() && MG06ParatusScene.GetOwningQuest().GetStage() == 30)
		GoToState("Done")
		MG06ParatusScene.Start()
	EndIf
EndEvent


State Done
	Event OnLoad()
		; Do nothing
	EndEvent

	Event OnActivate(ObjectReference akActionRef)
		; Do nothing
	EndEvent
EndState

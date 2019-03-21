ScriptName MG07WaveTriggerScript Extends ObjectReference  

Message Property MG07TestWaveMessage Auto

ObjectReference Property TauntMarker Auto

Quest Property MG07 Auto


Event OnTriggerEnter(ObjectReference akActionRef)
	Actor Player = Game.GetPlayer()
	If (akActionRef == Player && MG07.IsRunning())
		GoToState("Done")
		GetLinkedRef().PlayAnimation("PlayAnim02")
		TauntMarker.MoveTo(Player)
		Player.DamageActorValue("Magicka", Player.GetActorValue("Magicka"))
		(MG07 as MG07QuestScript).WaveTrigger += 1
		Utility.Wait(1.5)
		GetLinkedRef().PlayAnimation("PlayAnim01")
		Utility.Wait(0.75)
		GetLinkedRef().Disable()
		Disable()
	EndIf
EndEvent


State Done
	Event OnTriggerEnter(ObjectReference akActionRef)
		; Do nothing
	EndEvent
EndState

ScriptName MG02Saarthal01LeverScript Extends ObjectReference  

Bool Property SpikeChain Auto
Bool Property GateChain Auto
Quest Property MG02 Auto
ObjectReference Property CollisionVolume Auto
ObjectReference Property SpikeMarker Auto
ObjectReference Property GateMarker Auto
ReferenceAlias Property MG02TolfdirAlias Auto

Bool leverOnce = True
Int DoOnce = 0


Event OnActivate(ObjectReference akActionRef)
	If (akActionRef == Game.GetPlayer())
		If (MG02.IsRunning())
			If (DoOnce == 0)
				DoOnce == 1
				MG02QuestScript QuestScript = MG02 As MG02QuestScript
				QuestScript.MG02Saarthal01LeverCount += 1
				If (QuestScript.MG02Saarthal01LeverCount != 2)
					MG02TolfdirAlias.GetActorReference().EvaluatePackage()
				EndIf
			EndIf
		EndIf
		If (LeverOnce)
			If (SpikeChain)
				If (SpikeMarker.IsEnabled())
					SpikeMarker.Disable()
				Else
					SpikeMarker.Enable()
				EndIf
			EndIf
			If (GateChain)
				If (GateMarker.IsEnabled())
					GateMarker.Disable()
				Else
					GateMarker.Enable()
				EndIf
			EndIf
			If (SpikeMarker && GateMarker)
				If (SpikeMarker.IsEnabled() && GateMarker.IsEnabled())
					CollisionVolume.Disable()
					LeverOnce = False
				EndIf
			EndIf
		EndIf
	EndIf
EndEvent

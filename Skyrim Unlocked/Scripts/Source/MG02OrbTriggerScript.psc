ScriptName MG02OrbTriggerScript Extends ObjectReference  

Quest Property MG02 Auto
Scene Property MG02TolfdirEyeScene Auto


Event OnTriggerEnter(ObjectReference akActionRef)
	If (akActionRef == Game.GetPlayer())
		If (MG02.IsRunning())
			(MG02 As MG02QuestScript).OrbFound = 1
			MG02TolfdirEyeScene.Start()
			Disable()
		EndIf
	EndIf
EndEvent

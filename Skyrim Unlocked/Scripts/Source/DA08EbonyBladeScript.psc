ScriptName DA08EbonyBladeScript Extends ObjectReference  

Quest Property DA08 Auto
Scene Property InitialPickup Auto

Event OnContainerChanged(ObjectReference akNewContainer, ObjectReference akOldContainer)
	If (akNewContainer == Game.GetPlayer())
		; Debug.Trace("DA08: Player got Ebony Blade.")
		InitialPickup.Start()
	EndIf
EndEvent

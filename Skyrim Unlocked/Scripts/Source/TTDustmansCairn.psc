scriptname TTDustmansCairn extends ObjectReference
{Displays a message when activated. If there's a vanilla script which does the same, please let me know.}

Message property TTYsgramorsBladePieceMessage auto


Event OnActivate(ObjectReference akActionRef)
	TTYsgramorsBladePieceMessage.Show()
EndEvent 
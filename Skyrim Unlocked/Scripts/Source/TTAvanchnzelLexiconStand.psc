scriptname TTAvanchnzelLexiconStand extends ObjectReference
{Opens the final door in Avanchnzel when the players places the Lexicon.}

Actor property PlayerRef auto
ObjectReference property TTAvanchnzelDoorTrigger auto	;The final door has this trigger as an activate parent.
Quest property MS04 auto


Event OnActivate(ObjectReference akActionRef)
	if (akActionRef == PlayerREF && MS04.GetStageDone(750) && MS04.GetStageDone(900) == false)
		RegisterForAnimationEvent(Self,"Done")	;We wait until the Lexicon is actually placed.
	endif
EndEvent


Event OnAnimationEvent(ObjectReference akSource, String asEventName)
	if (akSource == Self && asEventName == "Done")
		TTAvanchnzelDoorTrigger.Activate(Self)	;Opens the door.
		UnregisterForAnimationEvent(Self,"Done")
	endif
EndEvent 
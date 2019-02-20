Scriptname dunKilkreathBeamStart extends ObjectReference  
{Completely rewritten dunKilkreathBeamStart for Skyrim Unlocked.}

ObjectReference property BeamTarget auto

Quest property DA09 auto

Spell property dunKilkreathlightBeam auto	;BASEOBJECT: pointer to beam spell


Event OnCellLoad()
	if (DA09.IsStageDone(300))
		dunKilkreathlightBeam.Cast(self, BeamTarget)
	endif
EndEvent 
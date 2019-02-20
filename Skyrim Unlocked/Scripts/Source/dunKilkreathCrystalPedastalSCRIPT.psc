Scriptname dunKilkreathCrystalPedastalSCRIPT extends ObjectReference  
{Completely rewritten dunKilkreathCrystalPedastalSCRIPT for Skyrim Unlocked.}

Import Utility
Import Game

Bool property IsTriggered = false auto hidden

ObjectReference property Crystal auto hidden
ObjectReference property NextToActivate auto	;If you want the next node in line to shoot, set it here
ObjectReference property BeamTarget auto	;what you want the beam to shoot at
ObjectReference property Door01 auto	;First Door to be unlocked/opened
ObjectReference property Door02 auto	;Second Door to be unlocked/opened
ObjectReference property LoadDoor auto	;Load Door to be unlocked/opened
ObjectReference property EnableMarker auto	;enables a marker that will enable other objects in the world
ObjectReference property BeamSource auto	;source of the light beam

Quest property DA09 auto

Spell property dunKilkreathlightBeam auto	;BASEOBJECT: pointer to beam spell

Sound property QSTDA09LightBeamOn auto


Event OnCellLoad()
	Crystal = GetLinkedRef()
	;Debug.Trace("dunKilkreathCrystalPedastalSCRIPT Crystal:" + Crystal)
	if (IsTriggered)
		FireBeam()
	endif
	if (DA09.IsStageDone(300) == false)
		BlockActivation()
	elseif (IsActivationBlocked())
		BlockActivation(false)
	endif
EndEvent
 
Event OnActivate(ObjectReference akActionRef)
	if (DA09.IsStageDone(300) && IsTriggered == false)
		IsTriggered = true
		ShakeCamera(afStrength = 0.1, afDuration = 1.8)
		Wait(1.5)
		FireBeam()
		if (EnableMarker)
			EnableMarker.Enable()
		endif
		Wait(0.5)
		if (NextToActivate)
			NextToActivate.Activate(self)
		endif
		Wait(0.5)
		UnlockOpenDoor(Door01)
		UnlockOpenDoor(Door02)
		UnlockDoor(LoadDoor)
	endif
EndEvent
 
Function FireBeam()
	if (BeamSource && BeamSource.Is3DLoaded() && BeamTarget)
		dunKilkreathlightBeam.Cast(BeamSource, BeamTarget)
		QSTDA09LightBeamOn.Play(self)  
	endif
EndFunction     
 
Function UnlockOpenDoor(ObjectReference DoorRef)
	if (DoorRef)
		DoorRef.Enable()
		DoorRef.Lock(false,true)
		DoorRef.Activate(self)
	endif
EndFunction

Function UnlockDoor(ObjectReference DoorRef)
	if (DoorRef)
		DoorRef.Enable()
		DoorRef.Lock(false,true)
	endif
EndFunction 
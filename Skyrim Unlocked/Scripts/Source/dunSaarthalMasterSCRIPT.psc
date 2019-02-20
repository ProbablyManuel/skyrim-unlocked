Scriptname dunSaarthalMasterSCRIPT extends Actor  
{Handles Jyrik and the Eye of Magnus in Saarthal. Modified and cleaned up by Skyrim Unlocked.}

Import Utility

; Jyrik variables
Spell property FlameAbility auto
Spell property FrostAbility auto
Spell property StormAbility auto
Spell property TTEyeOfMagnusBuff auto
Location property SaarthalLocation auto

; barrier stuff
ObjectReference property BarrierDisableSound auto  
ObjectReference property BarrierCage auto
ObjectReference property BarrierCollision auto
EffectShader property BarrierEffect auto

; // Jyrik's current form
; // 0 - Normal
; // 1 - Fire
; // 2 - Frost
; // 3 - Storm
Int CurrentForm=0
Int RandHolder=0
Int FormCounter=0

Bool PowerOff = true
Bool ContinuingToUpdate = false

Quest property MG02 auto	;Under Saarthal


Event OnCellAttach()
	if (GetCurrentLocation() == SaarthalLocation)
		Wait(0.5)								;USKP 2.0.1 - Short delay added to let 3D catch up.
		BarrierEffect.Play(BarrierCage)
		BarrierEffect.Play(Self)
	endif

	if (MG02 && MG02.IsStageDone(10) == false)	;The player decided to explore Saarthal without joining the College of Winterhold.
		SetGhost(false)							;Removes Jyrik's invulnerability.
		if (!HasSpell(TTEyeOfMagnusBuff))		;Prevents adding the spell more than once.
			AddSpell(TTEyeOfMagnusBuff)			;Adds a buff to Jyrik to compensate his lost invulnerability.
		endif
	else										;Vanilla quest progression.
		SetGhost()								;Makes Jyrik invulnerable, so the vanilla quest can progress as intended.
		if (TTEyeOfMagnusBuff)					;sanity check.
			RemoveSpell(TTEyeOfMagnusBuff)		;Jyrik is already invulnerable, so he doesn't need the buff anymore.
		endif
	endif

	ContinuingToUpdate = true
	RegisterForSingleUpdate(1)
EndEvent


Event OnCellDetach()
	ContinuingToUpdate = true
	UnregisterForUpdate()
EndEvent


Event OnUpdate()
	if (Self.GetAV("variable07") == 1)
		
		if (PowerOff)
			BarrierEffect.Stop(Self)
			SetGhost(false)
			PowerOff = false
			FormSelect()
		endif
		
		if (FormCounter == 10)
			FormSelect()
			FormCounter = 0
		else
			FormCounter+=1
		endif
		
	endif
	
	if (ContinuingToUpdate)
		RegisterForSingleUpdate(1)
	endif
EndEvent


Event OnDying(Actor akKiller)
	BarrierDisableSound.Enable()
	Wait(0.2)
	BarrierCage.Disable()
	BarrierCollision.Disable()
	BarrierEffect.Stop(Self)
	ContinuingToUpdate = false
	UnregisterForUpdate()
EndEvent


Function FormSelect()

	RandHolder = RandomInt(1,3)

	if(RandHolder == 1)
		Self.RemoveSpell(FrostAbility)
		Self.RemoveSpell(StormAbility)
		Self.AddSpell(FlameAbility, false)
		CurrentForm = 1
	elseif(RandHolder == 2)
		Self.RemoveSpell(FlameAbility)
		Self.RemoveSpell(StormAbility)
		Self.AddSpell(FrostAbility, false)
		CurrentForm = 2
	elseif(RandHolder == 3)
		Self.RemoveSpell(FrostAbility)
		Self.RemoveSpell(StormAbility)
		Self.AddSpell(StormAbility, false)
		CurrentForm = 3
	endif
	
	RandHolder=0

EndFunction

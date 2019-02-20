ScriptName TT_SaarthalWall Extends ObjectReference
{Allows the player to destroy the wall blocking the rest of Saarthal without starting "Under Saarthal"}

Armor Property MG02Amulet Auto
ObjectReference Property SpikeTrigger Auto
ObjectReference Property MG02AmuletResonanceRef Auto
Quest Property MG02 Auto


Event OnMagicEffectApply(ObjectReference akCaster, MagicEffect akEffect)
	ProcessHit(akCaster)
EndEvent

Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, Bool abPowerAttack, Bool abSneakAttack, Bool abBashAttack, Bool abHitBlocked)
	ProcessHit(akAggressor)
EndEvent

Function ProcessHit(ObjectReference akAttacker)
	If (MG02.IsCompleted())
		GoToState("Done")
	ElseIf (!MG02.IsRunning())
		Actor Player = Game.GetPlayer()
		If (akAttacker == Player && Player.IsEquipped(MG02Amulet))
			MG02AmuletResonanceRef.PlayAnimation("PlayAnim01")
			PlayAnimation("Open")
			SpikeTrigger.Activate(Player)
			; Non-zero value causes the Saarthal Amulet to no longer trigger its animation
			(MG02 as MG02QuestScript).TolfdirUpdate = -1
			GoToState("Done")
		EndIf
	EndIf
EndFunction


State Done
	Event OnMagicEffectApply(ObjectReference akCaster, MagicEffect akEffect)
		; Do nothing
	EndEvent
	
	Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, Bool abPowerAttack, Bool abSneakAttack, Bool abBashAttack, Bool abHitBlocked)
		; Do nothing
	EndEvent
EndState

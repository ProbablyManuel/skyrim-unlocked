Scriptname TTSaarthalWall extends ObjectReference
{Allows the player to destroy the door blocking the dungeon without starting "Under Saarthal".}

Actor property PlayerREF auto
Armor property MG02Amulet auto
Keyword property WeapTypeWarhammer auto
ObjectReference property SpikeTrigger auto
ObjectReference property MG02AmuletResonanceRef auto
Quest property MG02 auto


Event OnMagicEffectApply(ObjectReference AkCaster, MagicEffect AkEffect)
	if (MG02.IsStageDone(10) == false)	;We do nothing if "Under Saarthal" has been started. The quest already handles everyting.
		if (AkCaster == PlayerREF && PlayerREF.IsEquipped(MG02Amulet))
			Mg02AmuletResonanceRef.PlayAnimation("PlayAnim01")
			PlayAnimation("Open")
			SpikeTrigger.Activate(PlayerREF)
			(MG02 as MG02QuestScript).TolfdirUpdate = 42	;Nonsense value that isn't equal 0.
		endif
	endif
EndEvent


Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, Bool abPowerAttack, Bool abSneakAttack, Bool abBashAttack, Bool abHitBlocked)
	if (MG02.IsStageDone(10) == false)	;We do nothing if "Under Saarthal" has been started. The quest already handles everyting.
		if (akAggressor == PlayerREF && PlayerREF.IsEquipped(MG02Amulet))
			if (akSource.HasKeyword(WeapTypeWarhammer))	;It's now possible to smash the wall with a warhammer.
				MG02AmuletResonanceRef.PlayAnimation("PlayAnim01")
				PlayAnimation("Open")
				SpikeTrigger.Activate(PlayerREF)
				(MG02 as MG02QuestScript).TolfdirUpdate = 42	;Nonsense value that isn't equal 0.
			endif
		endif
	endif
EndEvent 
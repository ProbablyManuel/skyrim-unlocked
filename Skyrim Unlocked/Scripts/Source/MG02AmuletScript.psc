scriptname MG02AmuletScript extends ObjectReference
{The script attached to the Saarthal Amulet.}

Message property pMG02TestWallMessage auto
ObjectReference property MG02AmuletResonanceRef auto
Quest property pMG02QuestScript auto
ReferenceAlias property MG02WallAlias auto
Scene property MG02TolfdirAmuletScene auto
Spell property AmuletSpell auto
Int DoOnce


Event OnEquipped(Actor AkActor)

		MG02QuestScript QuestScript = pMG02QuestScript as MG02QuestScript

	if (pMG02QuestScript.IsStageDone(10))	;We do nothing if the player isn't here for MG02.

		if (DoOnce == 0)
			MG02TolfdirAmuletScene.Start()
			DoOnce=1
		endif

	endif
	if (QuestScript.TolfdirUpdate == 0)
		MG02AmuletResonanceRef.PlayAnimation("PlayAnim02")
	endif
EndEvent


Event OnUnequipped(Actor AkActor)

	MG02AmuletResonanceRef.PlayAnimation("PlayAnim01")

EndEvent 
ScriptName MG02AmuletScript Extends ObjectReference

Message Property pMG02TestWallMessage Auto
ObjectReference Property MG02AmuletResonanceRef Auto
Quest Property pMG02QuestScript Auto
ReferenceAlias Property MG02WallAlias Auto
Scene Property MG02TolfdirAmuletScene Auto
Spell Property AmuletSpell Auto

Int DoOnce = 0


Event OnEquipped(Actor AkActor)
	If (pMG02QuestScript.IsRunning())
		If (DoOnce == 0)
			MG02TolfdirAmuletScene.Start()
			DoOnce = 1
		EndIf
	Endif
	If ((pMG02QuestScript As MG02QuestScript).TolfdirUpdate == 0)
		MG02AmuletResonanceRef.PlayAnimation("PlayAnim02")
	EndIf
EndEvent

Event OnUnequipped(Actor AkActor)
	MG02AmuletResonanceRef.PlayAnimation("PlayAnim01")
EndEvent

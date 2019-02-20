Scriptname MG07WaveTriggerScript extends ObjectReference  

Message property MG07TestWaveMessage auto
ObjectReference property TauntMarker auto  
Quest property MG07 auto

int DoOnce
float PlayerMagickaVal



Event OnTriggerEnter(ObjectReference AkActionRef)

	if (AkActionRef == Game.GetPlayer() && MG07.IsStageDone(20))	;We do nothing if the player isn't here for MG07.

		if DoOnce == 0
			getLinkedRef().PlayAnimation("PlayAnim02")
			TauntMarker.MoveTo(Game.GetPlayer())
			PlayerMagickaVal = Game.GetPlayer().GetAV("Magicka")
			PlayerMagickaVal = 0 - PlayerMagickaVal
			Game.GetPlayer().DamageAV("Magicka", PlayerMagickaVal)
			DoOnce=1
			(MG07 as MG07QuestScript).WaveTrigger +=  1


			utility.wait(1.5)
			getLinkedRef().PlayAnimation("PlayAnim01")
			utility.wait(0.75)
			getLinkedRef().disable()
			Disable()
		endif
	endif

EndEvent 
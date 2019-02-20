scriptname TTAncientPotionScript extends ActiveMagicEffect
{This starts the quest which will send the player to Skuldafn when he drinks the Ancient Potion.}

Actor property PlayerREF auto
Quest property TTSkuldafnQuest auto


Event OnEffectStart(Actor akTarget, Actor akCaster)
	if (akTarget == PlayerREF)
		TTSkuldafnQuest.SetObjectiveCompleted(10)
		TTSkuldafnQuest.SetStage(20)	;This teleports the player to Skuldafn.
	endif
EndEvent 
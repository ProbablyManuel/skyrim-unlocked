Scriptname MG02AmuletTriggerScript extends ReferenceAlias  


Armor property MG02Amulet auto
ObjectReference property SpikeTrigger auto
ObjectReference property MG02TrapCollision01Ref auto
Quest property MG02 auto
ReferenceAlias property MG02WallAlias auto
ReferenceAlias property MG02AmuletAlias  Auto  

bool DoOnce = False


Event OnActivate(ObjectReference ActionRef)
	if (ActionRef == Game.GetPlayer())
		if (MG02.IsStageDone(30)) ;This prevents that the player rushes in and triggers the amulet too early.
			if DoOnce == False
				DoOnce = True
				MG02WallAlias.GetReference().PlayAnimation("Take")
				Game.GetPlayer().AddItem(MG02AmuletAlias.GetReference(), 1)
				MG02TrapCollision01Ref.Enable()
				SpikeTrigger.Activate(Game.GetPlayer())
				MG02.SetStage(40)
				if MG02.IsObjectiveDisplayed(30)
				(MG02 as MG02QuestScript).VCount()
				endif
				Self.GetReference().Disable()
			endif
		endif
	endif
EndEvent

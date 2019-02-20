ScriptName TT_SaarthalAmuletTrigger Extends ObjectReference
{Allows the player to take the Saarthal Amulet without starting "Under Saarthal"}

Armor Property MG02Amulet Auto
ObjectReference Property SpikeTrigger Auto
ObjectReference Property MG02Wall Auto
Quest Property MG02 Auto


Event OnActivate(ObjectReference akActionRef)
	Actor Player = Game.GetPlayer()
	If (akActionRef == Player)
		If (!MG02.IsRunning())
			MG02Wall.PlayAnimation("Take")
			Player.AddItem(MG02Amulet)
			SpikeTrigger.Activate(Player)
			Disable()
		EndIf
	EndIf
EndEvent

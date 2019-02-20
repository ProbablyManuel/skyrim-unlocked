ScriptName TT_FakeBarredLoadDoor Extends ObjectReference
{Blocks activation of a load door by pretending the other side is barred.
When the other side is activated by the player, normal behaviour resumes.}

Message Property BarredDoorMSG Auto
ObjectReference Property BarredDoorRef Auto
Bool Property ShouldBlock = False Auto


Event OnLoad()
	If (ShouldBlock)
		BlockActivation()
	EndIf
EndEvent

Event OnActivate(ObjectReference akActionRef)
	If (akActionRef == Game.GetPlayer())
		If (Self == BarredDoorRef)
			If (ShouldBlock && IsActivationBlocked())
				BarredDoorMSG.Show()
			EndIf
		Else
			(BarredDoorRef As TT_FakeBarredLoadDoor).ShouldBlock = False
			BarredDoorRef.BlockActivation(False)
		EndIf
	EndIf
EndEvent

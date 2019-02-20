ScriptName TT_Quest_ThalmorEmbassy_Script Extends Quest


Bool Property ElenwenDisabled = False Auto

LocationAlias Property Alias_Location Auto


Bool Function TryToPrepareForKillOff(ReferenceAlias akActor, Float afAggression)
	Actor Ref = akActor.GetActorReference()
	If (Ref)
		; Only proceed if the actor is currently in the quest's location
		If (Ref.IsInLocation(Alias_Location.GetLocation()))
			If (Ref.GetActorBase().IsEssential())
				Ref.GetActorBase().SetEssential(False)
			EndIf
			If (Ref.GetCrimeFaction())
				Ref.SetCrimeFaction(None)
			EndIf
			If (Ref.GetActorValue("Aggression") != afAggression)
				Ref.SetActorValue("Aggression", afAggression)
			EndIf
			Return True
		EndIf
	EndIf
	Return False
EndFunction

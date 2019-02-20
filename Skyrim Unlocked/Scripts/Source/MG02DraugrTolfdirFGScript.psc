ScriptName MG02DraugrTolfdirFGScript Extends ObjectReference  
{Increment quest script var every time one of these guys dies. When all 4 are dead have Tolfdir EVP}

Quest Property MG02 Auto
ReferenceAlias Property MG02TolfdirAlias Auto

Int DoOnce = 0


Event OnDeath(Actor AkKiller)
	If (MG02.IsRunning())
		MG02QuestScript QuestScript = MG02 As MG02QuestScript
		If (DoOnce == 0)
			QuestScript.MG02DraugrTolfdirCount += 1
			If (QuestScript.MG02DraugrTolfdirCount == 4)
				MG02TolfdirAlias.GetActorReference().EvaluatePackage()
			EndIf
			DoOnce = 1
		EndIf
	EndIf
EndEvent

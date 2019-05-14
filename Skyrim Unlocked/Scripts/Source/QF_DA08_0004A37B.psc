;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 37
Scriptname QF_DA08_0004A37B Extends Quest Hidden

;BEGIN ALIAS PROPERTY Balgruuf
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Balgruuf Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY BalgruufEssential
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_BalgruufEssential Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Dagny
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Dagny Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY EbonyBlade
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_EbonyBlade Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY EbonyBladeQuestItem
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_EbonyBladeQuestItem Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Farengar
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Farengar Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Frothar
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Frothar Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Karinda
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Karinda Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY KarindaEssential
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_KarindaEssential Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY MephalaInYourHead
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_MephalaInYourHead Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY MysteriousDoorName
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_MysteriousDoorName Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Nelkir
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Nelkir Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY WhisperingDoor
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_WhisperingDoor Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY WhisperingDoorName
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_WhisperingDoorName Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY WhisperingDoorTA
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_WhisperingDoorTA Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_14
Function Fragment_14()
;BEGIN CODE
SetObjectiveDisplayed(10)

if (DA08RumorPointer.GetStage() == 10)
	DA08RumorPointer.SetStage(20)
endif
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_16
Function Fragment_16()
;BEGIN CODE
(Alias_WhisperingDoor as DA08WhisperingDoorScript).RenameToMysterious()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_18
Function Fragment_18()
;BEGIN CODE
SetObjectiveCompleted(10)
SetObjectiveDisplayed(20)
 
(Alias_WhisperingDoor as DA08WhisperingDoorScript).Redirect()
(Alias_WhisperingDoor as DA08WhisperingDoorScript).RenameToWhispering()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_19
Function Fragment_19()
;BEGIN CODE
SetObjectiveCompleted(25)
SetObjectiveDisplayed(30)

Alias_Balgruuf.GetRef().AddItem(WhisperingDoorKey, 1)
Alias_Farengar.GetRef().AddItem(WhisperingDoorKey, 1)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_20
Function Fragment_20()
;BEGIN CODE
SetObjectiveCompleted(25)
SetObjectiveCompleted(30)
SetObjectiveDisplayed(40)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_21
Function Fragment_21()
;BEGIN CODE
; Fail previous objectives if the player simply picked the lock
If (!IsObjectiveCompleted(10))
	SetObjectiveFailed(10)
EndIf
If (!IsObjectiveCompleted(20))
	SetObjectiveFailed(20)
EndIf
If (!IsObjectiveCompleted(25))
	SetObjectiveFailed(25)
EndIf
If (!IsObjectiveCompleted(30))
	SetObjectiveFailed(30)
EndIf
SetObjectiveDisplayed(40)
SetObjectiveCompleted(40)
SetObjectiveDisplayed(50)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_22
Function Fragment_22()
;BEGIN CODE
SetObjectiveCompleted(50)
AchievementsQuest.IncDaedricQuests()
AchievementsQuest.IncDaedricArtifacts()
BladeTracker.Start()
Alias_EbonyBladeQuestItem.Clear()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_30
Function Fragment_30()
;BEGIN CODE
SetStage(60)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_32
Function Fragment_32()
;BEGIN AUTOCAST TYPE DA08QuestScript
Quest __temp = self as Quest
DA08QuestScript kmyQuest = __temp as DA08QuestScript
;END AUTOCAST
;BEGIN CODE
; setup
; Debug.Trace("DA08: Setting stage 1.")
MQ105.SetStage(0)
kmyQuest.PlayerGotRumor = true
WhiterunGateQuest.SetStage(10)
WhiterunGate.Lock(False)
Game.GetPlayer().MoveTo(StartMarker)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_33
Function Fragment_33()
;BEGIN CODE
SetObjectiveCompleted(20)
SetObjectiveDisplayed(25)

(Alias_WhisperingDoor as DA08WhisperingDoorScript).UndoRedirect()
(Alias_WhisperingDoor as DA08WhisperingDoorScript).RenameToMysterious()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_35
Function Fragment_35()
;BEGIN CODE
SetObjectiveCompleted(50)
AchievementsQuest.IncDaedricQuests()
AchievementsQuest.IncDaedricArtifacts()
Alias_EbonyBladeQuestItem.Clear()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_36
Function Fragment_36()
;BEGIN CODE
Stop()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

ObjectReference Property StartMarker  Auto  

Quest Property MQ105  Auto  

Quest Property DA08RumorPointer  Auto  

Key Property WhisperingDoorKey  Auto  

Quest Property WhiterunGateQuest  Auto  

ObjectReference Property WhiterunGate  Auto  

Quest Property BladeTracker  Auto  

AchievementsScript Property AchievementsQuest  Auto  

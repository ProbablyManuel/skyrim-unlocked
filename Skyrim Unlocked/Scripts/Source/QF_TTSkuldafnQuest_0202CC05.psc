;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 12
Scriptname QF_TTSkuldafnQuest_0202CC05 Extends Quest Hidden

;BEGIN ALIAS PROPERTY TTPortalToSkyhavenTemple
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_TTPortalToSkyhavenTemple Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY TTdunSkuldafnNahkriin
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_TTdunSkuldafnNahkriin Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY DiamondClaw
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_DiamondClaw Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY DraugrWithClaw
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_DraugrWithClaw Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY TTAncientPotion
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_TTAncientPotion Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY SkuldafnLocation
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias_SkuldafnLocation Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY TTSkyhavenTempleMasterChest
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_TTSkyhavenTempleMasterChest Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_5
Function Fragment_5()
;BEGIN CODE
;Nahkriin has died.
(MQ303SovngardePortalREF as FXSkuldafnPortal).OpenPortal(Alias_TTdunSkuldafnNahkriin.GetRef())
SetObjectiveCompleted(20)
SetObjectiveDisplayed(40)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_11
Function Fragment_11()
;BEGIN CODE
;The quest has been disabled in the MCM.
FailAllObjectives()
Stop()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
;Setup stage
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_8
Function Fragment_8()
;BEGIN CODE
;The player has found the ancient potion.
if IsObjectiveDisplayed(5)
SetObjectiveCompleted(5)
endif
SetObjectiveDisplayed(10)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_6
Function Fragment_6()
;BEGIN CODE
;The player has entered final exterior section of Skuldafn.
Alias_TTdunSkuldafnNahkriin.GetRef().Enable()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_4
Function Fragment_4()
;BEGIN CODE
;The player has been teleported back to Skyhaven Temple.
CompleteAllObjectives()
Stop()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_3
Function Fragment_3()
;BEGIN CODE
;The player has drunken the ancient potion.
MQ303DoorToSovngarde.SetPosition(0.0,0.0,0.0)
MQ303OdahviingREF.Disable()
(MQ303SovngardePortalREF as FXSkuldafnPortal).ClosePortal()
PlayerREF.MoveTo(MQ303SkuldafnStartMarker)
SetObjectiveDisplayed(20)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_7
Function Fragment_7()
;BEGIN CODE
;The player has entered the portal.
SetObjectiveCompleted(40)
PlayerREF.Moveto(MQ203PuzzleRing1Ref)
SetStage(100)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_9
Function Fragment_9()
;BEGIN CODE
;the location of the ancient potion has been revealed to the player.
SetObjectiveDisplayed(5)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Actor Property PlayerRef  Auto  

ObjectReference Property MQ303DoorToSovngarde  Auto  

ObjectReference Property MQ303OdahviingRef  Auto  

ObjectReference Property MQ303SkuldafnStartMarker  Auto  

ObjectReference Property MQ303SovngardePortalREF  Auto  

ObjectReference Property MQ203PuzzleRing1Ref  Auto  

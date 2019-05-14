;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 7
Scriptname QF_TT_Quest_ThalmorEmbassy_06056E09 Extends Quest Hidden

;BEGIN ALIAS PROPERTY Brelas
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Brelas Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY CourtyardGuard1
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_CourtyardGuard1 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY CourtyardGuard2
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_CourtyardGuard2 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Elenwen
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Elenwen Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY ExteriorGuardDay1
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_ExteriorGuardDay1 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY ExteriorGuardDay2
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_ExteriorGuardDay2 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY ExteriorGuardDay3
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_ExteriorGuardDay3 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY ExteriorGuardDay4
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_ExteriorGuardDay4 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY ExteriorGuardNight1
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_ExteriorGuardNight1 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY ExteriorGuardNight2
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_ExteriorGuardNight2 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY ExteriorGuardNight3
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_ExteriorGuardNight3 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY ExteriorGuardNight4
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_ExteriorGuardNight4 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Gissur
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Gissur Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY InsideSolarGuard
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_InsideSolarGuard Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY InteriorGuard
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_InteriorGuard Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Malborn
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Malborn Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY PartyGuard1
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_PartyGuard1 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY PartyGuard2
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_PartyGuard2 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Razelan
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Razelan Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Rulindil
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Rulindil Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY SolarGuard
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_SolarGuard Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY ThalmorEmbassyLocation
;ALIAS PROPERTY TYPE LocationAlias
LocationAlias Property Alias_ThalmorEmbassyLocation Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY TortureChamberGuard
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_TortureChamberGuard Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY Tsavani
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Tsavani Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY chattyGuard1
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_chattyGuard1 Auto
;END ALIAS PROPERTY

;BEGIN ALIAS PROPERTY chattyGuard2
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_chattyGuard2 Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
; The player has entered the ground of the Thalmor Embassy

ThalmorEmbassyFaction.SetPlayerEnemy(True)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_1
Function Fragment_1()
;BEGIN CODE
; The player has exited the kitchen

; Enable enemies after the party room and in the courtyard
MQ201EnableCombatGuardsMarker.Enable()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_3
Function Fragment_3()
;BEGIN AUTOCAST TYPE TT_Quest_ThalmorEmbassy_Script
Quest __temp = self as Quest
TT_Quest_ThalmorEmbassy_Script kmyQuest = __temp as TT_Quest_ThalmorEmbassy_Script
;END AUTOCAST
;BEGIN CODE
; The player has left the Thalmor Embassy location

ThalmorEmbassyFaction.SetPlayerEnemy(False)
If (kmyQuest.ElenwenDisabled)
	Alias_Elenwen.TryToEnable()
EndIf

; Remove keys from torture chamber guard to prevent duplicates later
; New keys will be generated when the player reenters the Thalmor Embassy
Actor TortureChamberGuardRef = Alias_TortureChamberGuard.GetActorReference()
If (TortureChamberGuardRef)
	Int KeyCount = TortureChamberGuardRef.GetItemCount(MQ201InterrogationExitKey)
	If (KeyCount > 0)
		TortureChamberGuardRef.RemoveItem(MQ201InterrogationExitKey, KeyCount)	
	EndIf
EndIf
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_4
Function Fragment_4()
;BEGIN AUTOCAST TYPE TT_Quest_ThalmorEmbassy_Script
Quest __temp = self as Quest
TT_Quest_ThalmorEmbassy_Script kmyQuest = __temp as TT_Quest_ThalmorEmbassy_Script
;END AUTOCAST
;BEGIN CODE
; The player has entered the Thalmor Embassy location

; Unlock all doors
MQ201barBackroomDoor.SetLockLevel(0)
MQ201barBackroomDoorOut.SetLockLevel(0)
MQ201PartyFinalDoorLocked.SetLockLevel(0)
MQ201PartyFinalDoorNew.SetLockLevel(0)
ThalmorEmbassyFrontDoor.SetLockLevel(0)
ThalmorEmbassyBarracksDoor.SetLockLevel(0)
ThalmorEmbassyGate.SetLockLevel(50)
MQ201barBackroomDoor.Lock(False)
MQ201barBackroomDoorOut.Lock(False)
MQ201PartyFinalDoorLocked.Lock(False)
MQ201PartyFinalDoorNew.Lock(False)
ThalmorEmbassyFrontDoor.Lock(False)
ThalmorEmbassyBarracksDoor.Lock(False)

; The fake door in the party room is disabled by default to ensure compatibility with LAL
MQ201FakeDoorNeverOpenNoNavmesh.Enable()

; Disable enemies after the party room and in the courtyard to prevent going aggressive too early
MQ201EnableCombatGuardsMarker.Disable()

; Prepare unique NPCs who are currently in the Thalmor Embassy to be killed off
kmyQuest.TryToPrepareForKillOff(Alias_Malborn, 0)
kmyQuest.TryToPrepareForKillOff(Alias_Tsavani, 0)
kmyQuest.TryToPrepareForKillOff(Alias_Gissur, 0)
kmyQuest.TryToPrepareForKillOff(Alias_Rulindil, 1)
kmyQuest.TryToPrepareForKillOff(Alias_Brelas, 0)
; If the main quest is completed or the player has chosen not to complete it, Elenwen can be killed off
If (TT_GV_ThalmorEmbassy.GetValue() || MQ305.IsCompleted())
	kmyQuest.TryToPrepareForKillOff(Alias_Elenwen, 1)
	Alias_Elenwen.TryToMoveTo(ElenwenChair)
Else  ; Disable her until the player leaves the Thalmor Embassy to prevent interfering with the main quest
	kmyQuest.ElenwenDisabled = Alias_Elenwen.TryToDisable()
EndIf

; If Razelan is still in the Thalmor Embassy, disable him
; There is no reason why he should be there except for the party
Actor RazelanRef = Alias_Razelan.GetActorReference()
If (RazelanRef)
	If (RazelanRef.IsInLocation(Alias_ThalmorEmbassyLocation.GetLocation()))
		RazelanRef.Disable()
	EndIf
EndIf

; The guards in the party room don't attack the player on their own and get disabled during the main quest
Actor PartyGuard1Ref = Alias_PartyGuard1.GetActorReference()
If (PartyGuard1Ref)
	PartyGuard1Ref.SetActorValue("Aggression", 1)
	PartyGuard1Ref.Enable()
EndIf
Actor PartyGuard2Ref = Alias_PartyGuard2.GetActorReference()
If (PartyGuard2Ref)
	PartyGuard2Ref.SetActorValue("Aggression", 1)
	PartyGuard2Ref.Enable()
EndIf
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_6
Function Fragment_6()
;BEGIN CODE
; One or more exterior guards have been killed
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Faction Property ThalmorEmbassyFaction  Auto  

GlobalVariable Property TT_GV_ThalmorEmbassy  Auto  

Key Property MQ201InterrogationExitKey  Auto  

ObjectReference Property ElenwenChair  Auto  

ObjectReference Property MQ201barBackroomDoor  Auto  

ObjectReference Property MQ201barBackroomDoorOut  Auto  

ObjectReference Property MQ201EnableCombatGuardsMarker  Auto  

ObjectReference Property MQ201FakeDoorNeverOpenNoNavmesh  Auto  

ObjectReference Property MQ201PartyFinalDoorLocked  Auto  

ObjectReference Property MQ201PartyFinalDoorNEW  Auto  

ObjectReference Property ThalmorEmbassyBarracksDoor  Auto  

ObjectReference Property ThalmorEmbassyFrontDoor  Auto  

ObjectReference Property ThalmorEmbassyGate  Auto  

Quest Property MQ305  Auto  

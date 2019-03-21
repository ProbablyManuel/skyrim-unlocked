ScriptName TT_UnlockerScript Extends Quest
{Handles complex unlocking of content}

Actor Property TitusMedeIIRef Auto
Actor Property JyrikGauldursonRef Auto

GlobalVariable Property TT_GV_ThalmorEmbassy Auto

ObjectReference Property ArmorBoneCrownRef Auto
ObjectReference Property IrkngthandExtUpperToInt Auto
ObjectReference Property KatariahEnableMarker Auto
ObjectReference Property MG02AmuletTrigger Auto
ObjectReference Property NorLabyrinthianActivatedDoor Auto
ObjectReference Property SkyHavenExteriorCollisionRef Auto
ObjectReference Property SkyHavenHeadDoor Auto
ObjectReference Property TG08BridgeEnableRef Auto
ObjectReference Property CollegeArchMageArcanaeumDoor Auto
ObjectReference Property CollegeArchMageElementsDoor Auto
ObjectReference Property CollegeArchMageRoofDoor1 Auto
ObjectReference Property CollegeArchMageRoofDoor2 Auto
ObjectReference Property BreezehomeFrontDoor Auto
ObjectReference Property HoneysideFrontDoor Auto
ObjectReference Property HoneysideBackDoor Auto
ObjectReference Property ProudspireManorFrontDoor Auto
ObjectReference Property ProudspireManorBackDoor Auto
ObjectReference Property ProudspireManorStreetDoor Auto
ObjectReference Property VlindrelHallFrontDoor Auto

Quest Property TT_Quest_Skuldafn Auto

ReferenceAlias Property Alias_ArmorBoneCrown Auto


Function UnlockIrkngthand()
	TG08BridgeEnableRef.Enable()
	IrkngthandExtUpperToInt.SetLockLevel(0)
	IrkngthandExtUpperToInt.Lock(False)	
EndFunction

Function LockIrkngthand()
	TG08BridgeEnableRef.Disable()
	IrkngthandExtUpperToInt.SetLockLevel(255)
	IrkngthandExtUpperToInt.Lock()
EndFunction

Function UnlockSaarthal()
	MG02AmuletTrigger.Enable()
	JyrikGauldursonRef.SetGhost(False)
	JyrikGauldursonRef.ModActorValue("Health", 500)
EndFunction

Function LockSaarthal()
	MG02AmuletTrigger.Disable()
	JyrikGauldursonRef.SetGhost()
	JyrikGauldursonRef.ModActorValue("Health", -500)
EndFunction

Function UnlockLabyrinthian()
	NorLabyrinthianActivatedDoor.Enable()
EndFunction

Function LockLabyrinthian()
	NorLabyrinthianActivatedDoor.Disable()
EndFunction

Function UnlockKatariah()
	KatariahEnableMarker.Enable()
	TitusMedeIIRef.Enable()
EndFunction

Function LockKatariah()
	KatariahEnableMarker.Disable()
	TitusMedeIIRef.Disable()
EndFunction

Function UnlockThalmorEmbassy()
	TT_GV_ThalmorEmbassy.SetValue(1)
EndFunction

Function LockThalmorEmbassy()
	TT_GV_ThalmorEmbassy.SetValue(0)
EndFunction

Function UnlockSkyHavenTemple()
	SkyHavenExteriorCollisionRef.Disable()
	SkyHavenHeadDoor.SetOpen(True)
EndFunction

Function LockSkyHavenTemple()
	SkyHavenExteriorCollisionRef.Enable()
	SkyHavenHeadDoor.SetOpen(False)
EndFunction

Function UnlockSkuldafn()
	TT_Quest_Skuldafn.Start()
EndFunction

Function LockSkuldafn()
	TT_Quest_Skuldafn.SetStage(99)
EndFunction

Function UnlockKorvanjund()
	Alias_ArmorBoneCrown.Clear()
EndFunction

Function LockKorvanjund()
	Alias_ArmorBoneCrown.ForceRefTo(ArmorBoneCrownRef)
EndFunction

Function UnlockArchMageQuarters()
	CollegeArchMageArcanaeumDoor.SetLockLevel(100)
	CollegeArchMageElementsDoor.SetLockLevel(100)
	CollegeArchMageRoofDoor1.SetLockLevel(0)
	CollegeArchMageRoofDoor2.SetLockLevel(0)
	CollegeArchMageRoofDoor1.Lock(False)
	CollegeArchMageRoofDoor2.Lock(False)
EndFunction

Function LockArchMageQuarters()
	CollegeArchMageArcanaeumDoor.SetLockLevel(255)
	CollegeArchMageElementsDoor.SetLockLevel(255)
	CollegeArchMageRoofDoor1.SetLockLevel(255)
	CollegeArchMageRoofDoor2.SetLockLevel(255)
	CollegeArchMageRoofDoor1.Lock()
	CollegeArchMageRoofDoor2.Lock()
	CollegeArchMageArcanaeumDoor.Lock()
	CollegeArchMageElementsDoor.Lock()
EndFunction

Function UnlockBreezehome()
	BreezehomeFrontDoor.SetLockLevel(75)
EndFunction

Function LockBreezehome()
	BreezehomeFrontDoor.SetLockLevel(255)
EndFunction

Function UnlockHoneyside()
	HoneysideFrontDoor.SetLockLevel(75)
	HoneysideBackDoor.SetLockLevel(75)
EndFunction

Function LockHoneyside()
	HoneysideFrontDoor.SetLockLevel(255)
	HoneysideBackDoor.SetLockLevel(255)
EndFunction

Function UnlockProudspire()
	ProudspireManorFrontDoor.SetLockLevel(75)
	ProudspireManorBackDoor.SetLockLevel(75)
	ProudspireManorStreetDoor.SetLockLevel(75)
EndFunction

Function LockProudspire()
	ProudspireManorFrontDoor.SetLockLevel(255)
	ProudspireManorBackDoor.SetLockLevel(255)
	ProudspireManorStreetDoor.SetLockLevel(255)
EndFunction

Function UnlockVlindrelHall()
	VlindrelHallFrontDoor.SetLockLevel(75)
EndFunction

Function LockVlindrelHall()
	VlindrelHallFrontDoor.SetLockLevel(255)
EndFunction

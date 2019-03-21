;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname QF_TT_SU_Patch20000_0612673F Extends Quest Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
(Unlocker As TT_UnlockerScript).UnlockArchMageQuarters()
(Unlocker As TT_UnlockerScript).UnlockBreezehome()
(Unlocker As TT_UnlockerScript).UnlockHoneyside()
(Unlocker As TT_UnlockerScript).UnlockProudspire()
(Unlocker As TT_UnlockerScript).UnlockVlindrelHall()
Stop()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Quest Property Unlocker  Auto  

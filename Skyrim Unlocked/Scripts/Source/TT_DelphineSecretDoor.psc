ScriptName TT_DelphineSecretDoor Extends ObjectReference
{Controls the door to Delphine's Secret Room}

ObjectReference Property MQDelphineSecretDoor Auto
ObjectReference Property MQDelphineSecretPanel Auto
Key Property MQDelphineSecretDoorKey Auto

Int InTrigger  ; Counts how many people are inside the secret room


Event OnCellAttach()
	InTrigger = GetTriggerObjectCount()
	; Close the door and lock it with a master level lock
	MQDelphineSecretDoor.SetOpen(False)
	MQDelphineSecretPanel.SetOpen(False)
	MQDelphineSecretDoor.SetLockLevel(100)
	MQDelphineSecretDoor.Lock()
	; Unlock the door if someone (likely Delphine) is inside to ensure they can be reached
	If (InTrigger > 0)
		MQDelphineSecretDoor.Lock(False)
	EndIf
EndEvent


Event OnTriggerEnter(ObjectReference akTriggerRef)
	InTrigger += 1
EndEvent


Event OnTriggerLeave(ObjectReference akTriggerRef)
	InTrigger -= 1
	If (InTrigger == 0 && akTriggerRef.GetItemCount(MQDelphineSecretDoorKey) > 0)
		; The last person who leaves the room locks the door if they have the key
		MQDelphineSecretDoor.SetOpen(False)
		MQDelphineSecretPanel.SetOpen(False)
		MQDelphineSecretDoor.Lock()
	EndIf
EndEvent

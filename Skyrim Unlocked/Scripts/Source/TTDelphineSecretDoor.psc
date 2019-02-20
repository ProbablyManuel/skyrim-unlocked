scriptname TTDelphineSecretDoor extends ObjectReference
{Locks the door to Delphine's Secret Room, whenever the last person leaves the room.}

ObjectReference property MQDelphineSecretDoor auto
ObjectReference property MQDelphineSecretPanel auto

Int InTrigger = 0	;Counts how many people are inside the "secret" room.


Event OnTriggerEnter(ObjectReference akTriggerRef)
	InTrigger += 1
EndEvent


Event OnTriggerLeave(ObjectReference akTriggerRef)
	InTrigger -= 1
	if (InTrigger == 0)
		;We pretend that the last, who leaves the "secret" room, closes the secret panel and locks the door.
		MQDelphineSecretDoor.SetOpen(false)
		MQDelphineSecretPanel.SetOpen(false)
		MQDelphineSecretDoor.Lock()
	endif
EndEvent 
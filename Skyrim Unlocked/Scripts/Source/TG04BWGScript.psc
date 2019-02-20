Scriptname TG04BWGScript extends ObjectReference


Actor property PlayerREF auto
Quest property TG04 auto

Event OnTriggerEnter(ObjectReference akActionRef)
	if (akActionRef == PlayerREF && TG04.IsStageDone(40))
		TG04.SetStage(50)
		Disable()
	endif
endEvent 
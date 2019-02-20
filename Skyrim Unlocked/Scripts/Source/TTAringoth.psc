scriptname TTAringoth extends ReferenceAlias
{Attached to Aringots' Alias. Removes his essential status during TG02.}

Quest property TG02 auto


Event OnLoad()
	if (TG02.IsRunning())
		Clear()	;Make him mortal.
	endif
EndEvent 
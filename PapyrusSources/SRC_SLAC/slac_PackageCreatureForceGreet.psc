;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname slac_PackageCreatureForceGreet Extends Package Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(Actor akActor)
;BEGIN CODE
	; Clear ForcedRef
	;CreatureRef.ForceRefTo(ForcedRef.GetActorRef() as ObjectReference)
	Utility.Wait(0.1)
	ForcedRef.Clear()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

ReferenceAlias Property ForcedRef Auto
ReferenceAlias Property CreatureRef Auto

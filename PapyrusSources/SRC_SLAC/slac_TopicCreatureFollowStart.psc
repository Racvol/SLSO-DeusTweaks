;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname slac_TopicCreatureFollowStart Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
	; Activate follow package on creature alias
	;CreatureDialogueQuest.Reset()
	slac_CreatureDialogueSignal.SetValue(10)
	slacConfig.CreatureDialogueLastStartTime = Utility.GetCurrentRealTime()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

slac_Config Property slacConfig Auto
Quest Property CreatureDialogueQuest Auto
GlobalVariable Property slac_CreatureDialogueSignal Auto

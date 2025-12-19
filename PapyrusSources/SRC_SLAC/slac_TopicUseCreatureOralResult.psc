;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname slac_TopicUseCreatureOralResult Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
	; UseCreatureOralResult
	FollowerRef.ForceRefTo(akSpeakerRef as ObjectReference)
	FollowerDialogueQuest.SetStage(40)
	slacConfig.FollowerDialogueLastStartTime = Utility.GetCurrentRealTime()
	FollowerDialogueScene.Stop()
	FollowerDialogueScene.Start()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

slac_Config Property slacConfig Auto
Quest Property FollowerDialogueQuest Auto
Scene Property FollowerDialogueScene Auto
ReferenceAlias Property FollowerRef Auto

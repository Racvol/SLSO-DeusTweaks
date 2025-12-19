;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 2
Scriptname slac_TopicUseCreatureNormalResult Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_1
Function Fragment_1(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
	; UseCreatureNormalResult
	FollowerRef.ForceRefTo(akSpeakerRef as ObjectReference)
	FollowerDialogueQuest.SetStage(20)
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

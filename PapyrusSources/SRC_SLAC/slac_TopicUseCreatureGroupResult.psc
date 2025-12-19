;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname slac_TopicUseCreatureGroupResult Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
	; UseCreatureGroupResult
	Actor Creature = CreatureRef.GetActorRef()
	
	; Find additional creatures
	Actor[] otherCreatures = PapyrusUtil.ActorArray(3)
	otherCreatures = slacUtility.FindExtraCreatures(Creature, akSpeaker, MaxExtras = 3, ArousalMin = slacConfig.inviteArousalMin, Invitation = True)
	Int oci = 0
	Int otherCreaturesCount = 0
	
	While oci < otherCreatures.length
		If otherCreatures[oci]
			If otherCreaturesCount == 0
				CreatureRef2.ForceRefTo(otherCreatures[oci])
			ElseIf otherCreaturesCount == 1
				CreatureRef3.ForceRefTo(otherCreatures[oci])
			ElseIf otherCreaturesCount == 2
				CreatureRef4.ForceRefTo(otherCreatures[oci])
			EndIf
			otherCreaturesCount += 1
		EndIf
		oci += 1
	EndWhile
			
	FollowerRef.ForceRefTo(akSpeakerRef as ObjectReference)
	FollowerDialogueQuest.SetStage(50)
	slacConfig.FollowerDialogueLastStartTime = Utility.GetCurrentRealTime()
	FollowerDialogueScene.Stop()
	FollowerDialogueScene.Start()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

slac_Config Property slacConfig Auto
slac_Utility Property slacUtility Auto
Quest Property FollowerDialogueQuest Auto
Scene Property FollowerDialogueScene Auto
ReferenceAlias Property FollowerRef Auto
ReferenceAlias Property CreatureRef Auto
ReferenceAlias Property CreatureRef2 Auto
ReferenceAlias Property CreatureRef3 Auto
ReferenceAlias Property CreatureRef4 Auto

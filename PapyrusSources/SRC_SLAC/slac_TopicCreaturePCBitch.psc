;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname slac_TopicCreaturePCBitch Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
	; PC allows dog to use force
	Actor Creature = CreatureRef.GetActorRef()
	String CreatureNameRef = ""
	If slacConfig.debugSLAC
		CreatureNameRef = slacUtility.GetActorNameRef(Creature)
	EndIf
	
	If !slacUtility.TestCreature(Creature, invited = True) || !slacUtility.TestVictim(PlayerRef,Creature, inviting = True)
		slacConfig.debugSLAC && slacUtility.Log("PC Creature Dialogue Aggressive dog test failure for " + CreatureNameRef)
		slacUtility.slacData.SetSignalBool(PlayerRef, "RoughConsensual", True)
		slacNotify.Show("TestFail", PlayerRef, Creature, Consensual = True, Group = False)
		slacUtility.slacData.ClearSignal(PlayerRef, "RoughConsensual")
		Return
	EndIf

	; Indicate inviting status to block other engagements via TestCreature/TestVictim
	PlayerRef.AddToFaction(slacConfig.slac_InvitingFaction)
	Creature.AddToFaction(slacConfig.slac_InvitedFaction)
	
	If slacConfig.inviteAnimationPC
		slacUtility.StripActor(PlayerRef)
		slacUtility.PlayInviteAnimation(PlayerRef,Creature)
		Utility.Wait(3.0)
	EndIf
	
	If slacUtility.StartCreatureSex(PlayerRef, Creature, nonConsensual = False, requireTags = "Aggressive", rejectTags = "Oral")
		slacConfig.debugSLAC && slacUtility.Log("PC Creature Dialogue Aggressive dog start sex with " + CreatureNameRef)
		slacNotify.Show("SexStart", PlayerRef, Creature, Consensual = True, Group = False)
	Else
		slacUtility.UnstripActor(PlayerRef)
		slacUtility.StopInviteAnimation(PlayerRef,Creature)
		slacConfig.debugSLAC && slacUtility.Log("PC Creature Dialogue Aggressive dog failed start sex with " + CreatureNameRef)
		slacUtility.slacData.SetSignalBool(PlayerRef, "RoughConsensual", True)
		slacNotify.Show("SexStartFail", PlayerRef, Creature, Consensual = True, Group = False)
		slacUtility.slacData.ClearSignal(PlayerRef, "RoughConsensual")
	EndIf
	
	; Reset inviting status
	PlayerRef.RemoveFromFaction(slacConfig.slac_InvitingFaction)
	Creature.RemoveFromFaction(slacConfig.slac_InvitedFaction)
	slacConfig.slac_CreatureDialogueSignal.SetValue(0)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

ReferenceAlias Property CreatureRef Auto
Quest Property CreatureDialogueQuest Auto
Actor Property PlayerRef Auto
slac_Utility Property slacUtility Auto
slac_Config Property slacConfig Auto
slac_Notify Property slacNotify Auto

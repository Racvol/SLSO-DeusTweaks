;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname slac_TopicCreaturePCConsent Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
	; Player wants creature to play nice
	Actor Victim = Game.GetPlayer()
	Actor Creature = CreatureRef.GetActorRef()
	String CreatureNameRef = ""
	If slacConfig.debugSLAC
		CreatureNameRef = slacUtility.GetActorNameRef(Creature)
	EndIf
	
	If !slacUtility.TestCreature(Creature, invited = True) || !slacUtility.TestVictim(PlayerRef,Creature, inviting = True)
		slacNotify.Show("TestFail", Victim, Creature, Consensual = True, Group = False)
		slacConfig.debugSLAC && slacUtility.Log("PC Creature Dialogue Consensual test failure for " + CreatureNameRef)
		Return
	EndIf
	
	; Indicate inviting status to block other engagements via TestCreature/TestVictim
	PlayerRef.AddToFaction(slacConfig.slac_InvitingFaction)
	Creature.AddToFaction(slacConfig.slac_InvitedFaction)
	
	If slacConfig.inviteAnimationPC
		slacUtility.StripActor(PlayerRef)
		slacUtility.PlayInviteAnimation(PlayerRef,Creature)
		slacConfig.inviteAnimationPC && Utility.Wait(3.0)
	EndIf
	
	If slacUtility.StartCreatureSex(PlayerRef, Creature, False, rejectTags = "Oral")
		slacNotify.Show("SexStart", Victim, Creature, Consensual = True, Group = False)
		slacConfig.debugSLAC && slacUtility.Log("PC Creature Dialogue Consensual sex start with " + CreatureNameRef)
	Else
		slacUtility.UnstripActor(PlayerRef)
		slacUtility.StopInviteAnimation(PlayerRef,Creature)
		slacNotify.Show("SexStart", Victim, Creature, Consensual = True, Group = False)
		slacConfig.debugSLAC && slacUtility.Log("PC Creature Dialogue Consensual sex start failure for " + CreatureNameRef)
	EndIf
	
	; Reset inviting status
	PlayerRef.RemoveFromFaction(slacConfig.slac_InvitingFaction)
	Creature.RemoveFromFaction(slacConfig.slac_InvitedFaction)
	slacConfig.slac_CreatureDialogueSignal.SetValue(0)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Quest Property CreatureDialogueQuest Auto
ReferenceAlias Property CreatureRef Auto
Actor Property PlayerRef Auto
slac_Utility Property slacUtility Auto
slac_Config Property slacConfig Auto
slac_Notify Property slacNotify Auto

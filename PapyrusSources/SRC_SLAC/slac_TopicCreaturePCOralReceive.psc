;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname slac_TopicCreaturePCOralReceive Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE

	; Creature performs oral sex on player
	Actor Creature = CreatureRef.GetActorRef()
	String CreatureName = CreatureRef.GetActorRef().GetLeveledActorBase().GetName()
	
	If !slacUtility.TestCreature(Creature, invited = True) || !slacUtility.TestVictim(PlayerRef,Creature, inviting = True)
		slacConfig.debugSLAC && slacUtility.Log("Creature Dialogue give oral: creature and/oe player failed tests " + slacUtility.GetActorNameRef(Creature))
		If slacUtility.TreatAsSex(PlayerRef,Creature) == 1
			slacUtility.slacData.SetSignalBool(PlayerRef,"GettingCunnilingus",True)
		Else
			slacUtility.slacData.SetSignalBool(PlayerRef,"GettingBlowJob",True)
			slacUtility.slacData.SetSignalBool(Creature,"CreatureVictim",True)
		EndIf
		slacNotify.Show("TestFail", PlayerRef, Creature, Consensual = True, Group = False)
		slacUtility.slacData.ClearSignal(PlayerRef,"GettingBlowJob")
		slacUtility.slacData.ClearSignal(Creature,"CreatureVictim")
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
	
	String ReqTags = slacConfig.CondString(slacUtility.TreatAsSex(playerRef,Creature) == 1,"Cunnilingus","BlowJob")
	If slacUtility.StartCreatureSex(PlayerRef, Creature, False, requireTags = ReqTags)
		; Success: Start sex with reject tags
		slacConfig.debugSLAC && slacUtility.Log("Creature Dialogue give oral: success for " + slacUtility.GetActorNameRef(Creature))
		slacNotify.Show("SexStart", PlayerRef, Creature, Consensual = True, Group = False)

	Else
		; Failure
		slacUtility.UnstripActor(PlayerRef)
		slacUtility.StopInviteAnimation(PlayerRef,Creature)
		slacConfig.debugSLAC && slacUtility.Log("Creature Dialogue give oral: No oral animations available for " + slacUtility.GetActorNameRef(Creature))
		
		If slacUtility.TreatAsSex(PlayerRef,Creature) == 1
			slacUtility.slacData.SetSignalBool(PlayerRef,"GettingCunnilingus",True)
		Else
			slacUtility.slacData.SetSignalBool(PlayerRef,"GettingBlowJob",True)
			slacUtility.slacData.SetSignalBool(Creature,"CreatureVictim",True)
		EndIf
		slacNotify.Show("SexStartFail", PlayerRef, Creature, Consensual = True, Group = False)
		slacUtility.slacData.ClearSignal(PlayerRef,"GettingBlowJob")
		slacUtility.slacData.ClearSignal(Creature,"CreatureVictim")

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
;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname slac_TopicCreaturePCAnal Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
	; PC receives anal sex from creature
	Actor Creature = CreatureRef.GetActorRef()
	String CreatureName = CreatureRef.GetActorRef().GetLeveledActorBase().GetName()
	
	If !slacUtility.TestCreature(Creature, invited = True) || !slacUtility.TestVictim(PlayerRef,Creature, inviting = True)
		slacUtility.Log("Creature Dialogue anal: creature and/or player failed tests " + slacUtility.GetActorNameRef(Creature))
		If slacUtility.TreatAsSex(PlayerRef) == 0
			slacUtility.slacData.SetSignalBool(PlayerRef,"GivingAnal",True)
		Else
			slacUtility.slacData.SetSignalBool(PlayerRef,"GettingAnal",True)
		EndIf
		slacNotify.Show("TestFail", PlayerRef, Creature, Consensual = True, Group = False)
		slacUtility.slacData.ClearSignal(PlayerRef,"GivingAnal")
		slacUtility.slacData.ClearSignal(PlayerRef,"GettingAnal")

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

	; Get anal sex from male creature or perform anal sex on female creature
	If slacUtility.StartCreatureSex(PlayerRef, Creature, False, requireTags = "Anal")
		; Success: Start sex with tags
		slacConfig.debugSLAC && slacUtility.Log("Creature Dialogue anal: success for " + slacUtility.GetActorNameRef(Creature))
		slacNotify.Show("SexStart", PlayerRef, Creature, Consensual = True, Group = False)

	Else
		; Failure
		slacUtility.UnstripActor(PlayerRef)
		slacUtility.StopInviteAnimation(PlayerRef,Creature)
		
		slacConfig.debugSLAC && slacUtility.Log("Creature Dialogue anal: no anal animations available for " + slacUtility.GetActorNameRef(Creature))
		If slacUtility.TreatAsSex(PlayerRef) == 0
			slacUtility.slacData.SetSignalBool(PlayerRef,"GivingAnal",True)
		Else
			slacUtility.slacData.SetSignalBool(PlayerRef,"GettingAnal",True)
		EndIf
		slacNotify.Show("SexStartFail", PlayerRef, Creature, Consensual = True, Group = False)
		slacUtility.slacData.ClearSignal(PlayerRef,"GivingAnal")
		slacUtility.slacData.ClearSignal(PlayerRef,"GettingAnal")

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
;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname slac_TopicCreaturePCGroup Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
; Start group animation	; PC allows dog to use force
	Actor Victim = Game.GetPlayer()
	Actor Creature = CreatureRef.GetActorRef()
	String CreatureNameRef = ""
	If slacConfig.debugSLAC
		CreatureNameRef = slacUtility.GetActorNameRef(Creature)
	EndIf
	Actor[] otherCreatures = PapyrusUtil.ActorArray(3)
	
	If !slacUtility.TestCreature(Creature, invited = True) || !slacUtility.TestVictim(PlayerRef,Creature, inviting = True)
		slacNotify.Show("TestFail", Victim, Creature, Consensual = True, Group = True)
		slacConfig.debugSLAC && slacUtility.Log("PC Creature Dialogue Group test failure for " + CreatureNameRef)
		Return
	EndIf
	
	; Indicate inviting status to block other engagements via TestCreature/TestVictim
	PlayerRef.AddToFaction(slacConfig.slac_InvitingFaction)
	Creature.AddToFaction(slacConfig.slac_InvitedFaction)
	
	; Play invite animation
	If slacConfig.inviteAnimationPC
		slacUtility.StripActor(PlayerRef)
		slacUtility.PlayInviteAnimation(PlayerRef,Creature)
		;Utility.Wait(2.0)
	EndIf
	
	; Find additional creatures
	otherCreatures = slacUtility.FindExtraCreatures(Creature, PlayerRef, MaxExtras = 3, ArousalMin = slacConfig.inviteArousalMin, Invitation = True)
	Int oci = 0
	Int otherCreaturesCount = 0
	While oci < otherCreatures.length
		If otherCreatures[oci]
			; Add creatures to aliases with follow packages so they move toward the player while SL spins up
			If otherCreaturesCount == 0
				CreatureRef2.ForceRefTo(otherCreatures[oci] as ObjectReference)
			ElseIf otherCreaturesCount == 1
				CreatureRef3.ForceRefTo(otherCreatures[oci] as ObjectReference)
			ElseIf otherCreaturesCount == 2
				CreatureRef4.ForceRefTo(otherCreatures[oci] as ObjectReference)
			EndIf
			otherCreaturesCount += 1
		EndIf
		oci += 1
	EndWhile
	slacConfig.slac_CreatureDialogueSignal.SetValue(10)
	
	If slacUtility.StartCreatureSex(PlayerRef, Creature, nonConsensual = False, otherAttacker2 = otherCreatures[0], otherAttacker3 = otherCreatures[1], otherAttacker4 = otherCreatures[2])
		If otherCreaturesCount > 0
			slacNotify.Show("SexStart", Victim, Creature, Consensual = True, Group = True)
			slacConfig.debugSLAC && slacUtility.Log("PC Creature Dialogue Group sex start for " + CreatureNameRef + " and " + otherCreaturesCount + "others")
		Else
			slacNotify.Show("SexStart", Victim, Creature, Consensual = True, Group = False)
			slacConfig.debugSLAC && slacUtility.Log("PC Creature Dialogue Group sex start for " + CreatureNameRef + " alone")
		EndIf
	Else
		slacUtility.UnstripActor(PlayerRef)
		slacUtility.StopInviteAnimation(PlayerRef,Creature)
		slacNotify.Show("SexStartFail", Victim, Creature, Consensual = True, Group = True)
		slacConfig.debugSLAC && slacUtility.Log("PC Creature Dialogue Group sex start failure for " + CreatureNameRef + " and " + otherCreaturesCount + "others")
	EndIf
	
	; Reset inviting status
	PlayerRef.RemoveFromFaction(slacConfig.slac_InvitingFaction)
	Creature.RemoveFromFaction(slacConfig.slac_InvitedFaction)
	
	CreatureRef2.Clear()
	CreatureRef3.Clear()
	CreatureRef4.Clear()
	
	slacConfig.slac_CreatureDialogueSignal.SetValue(0)

;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

ReferenceAlias Property CreatureRef Auto
ReferenceAlias Property CreatureRef2 Auto
ReferenceAlias Property CreatureRef3 Auto
ReferenceAlias Property CreatureRef4 Auto
Quest Property CreatureDialogueQuest Auto
Actor Property PlayerRef Auto
slac_Utility Property slacUtility Auto
slac_Config Property slacConfig Auto
slac_Notify Property slacNotify Auto

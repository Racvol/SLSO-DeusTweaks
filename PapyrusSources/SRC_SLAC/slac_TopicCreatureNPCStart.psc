;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname slac_TopicCreatureNPCStart Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
	; Command creature to approach NPC
	Actor Victim = VictimRef.GetActorRef()
	Actor Creature = CreatureRef.GetActorRef()
	
	If Victim && Creature
		Int VictimSex = slacUtility.TreatAsSex(Victim)
		Int CreatureSex = slacUtility.GetSex(Creature)
		
		;If !slacUtility.TestCreature(Creature) || !slacUtility.TestVictim(Victim,Creature)
		;	slacUtility.Log(CreatureName + " has no interested in " + VictimName,False,slacConfig.showNotifications)
		;	CreatureDialogueNPCScene.Stop()
		;	slac_CreatureDialogueSignal.SetValue(0)
		;	Return
		;EndIf

		If CreatureDialogueNPCScene.IsPlaying()
			; Creature dialogue pursuit already in use
			slac_CreatureDialogueSignal.SetValue(0)
			slacNotify.Show("SexReject", Victim, Creature, Consensual = True, Group = False)
			slacConfig.debugSLAC && slacUtility.Log("Creature Dialogue NPC scene is already playing for " + slacUtility.GetActorNameRef(Victim) + " and " + slacUtility.GetActorNameRef(Creature))
			Return
		
		ElseIf CreatureSex % 2 == 1 && VictimSex == 0 && slacUtility.GetActorArousal(Victim) < slacConfig.followerCommandThreshold
			; Female creatures can only engage aroused male NPCs
			slac_CreatureDialogueSignal.SetValue(0)
			slacNotify.Show("SexReject", Victim, Creature, Consensual = True, Group = False)
			slacConfig.debugSLAC && slacUtility.Log("Creature Dialogue NPC is not aroused " + slacUtility.GetActorNameRef(Victim) + " and " + slacUtility.GetActorNameRef(Creature))
			Return

		ElseIf CreatureSex % 2 == 0 && slacUtility.GetActorArousal(Victim) < slacConfig.followerCommandThreshold
			slac_CreatureDialogueSignal.SetValue(30)
			slacConfig.debugSLAC && slacUtility.Log("Creature Dialogue start aggressive scene for " + slacUtility.GetActorNameRef(Victim) + " and " + slacUtility.GetActorNameRef(Creature))
		
		Else
			slac_CreatureDialogueSignal.SetValue(20)
			slacConfig.debugSLAC && slacUtility.Log("Creature Dialogue start consensual scene for " + slacUtility.GetActorNameRef(Victim) + " and " + slacUtility.GetActorNameRef(Creature))
		
		EndIf
		
		; Start Scene
		CreatureRef1.ForceRefTo(CreatureRef.GetRef())
		CreatureDialogueNPCScene.Start()
		slacConfig.CreatureDialogueLastStartTime = Utility.GetCurrentRealTime()

		; This may be a redirected suitor
		slacUtility.RemoveSuitor(Creature)

		If CreatureDialogueNPCScene.IsPlaying()
			slacConfig.debugSLAC && slacUtility.Log("Creature Dialogue NPC scene started for " + slacUtility.GetActorNameRef(Victim) + " and " + slacUtility.GetActorNameRef(Creature))
		Else
			slacConfig.debugSLAC && slacUtility.Log("Creature Dialogue NPC scene could not be started for " + slacUtility.GetActorNameRef(Victim) + " and " + slacUtility.GetActorNameRef(Creature))
		EndIf
	Else
		; If there is no victim or creature then the scene cannot be running and should not be started
		CreatureDialogueNPCScene.Stop()
		slac_CreatureDialogueSignal.SetValue(0)
		slacConfig.debugSLAC && slacUtility.Log("Creature Dialogue missing actors (" + slacUtility.GetActorNameRef(Victim) + " " + slacUtility.GetActorNameRef(Creature) + "), not starting")
	EndIf
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Quest Property CreatureDialogueQuest Auto
Scene Property CreatureDialogueNPCScene  Auto  
GlobalVariable Property slac_CreatureDialogueSignal Auto
ReferenceAlias Property CreatureRef Auto
ReferenceAlias Property CreatureRef1 Auto
ReferenceAlias Property VictimRef Auto
ReferenceAlias Property TargetRef Auto
slac_Config Property slacConfig Auto
slac_Utility Property slacUtility Auto
slac_Notify Property slacNotify Auto

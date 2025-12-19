;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 3
Scriptname slac_SceneCreatureDialogue Extends Scene Hidden

;BEGIN FRAGMENT Fragment_7
Function Fragment_7()
;BEGIN CODE
	; Creature Capture
	
	; AC and SL spin-up can take time, so make sure the scene is not treated as overrunning during this
	slacConfig.CreatureDialogueLastStartTime = Utility.GetCurrentRealTime()
	
	Actor Victim = VictimRef.GetActorRef()
	Actor Creature = CreatureRef1.GetActorRef()
	Int CreatureGender = slacUtility.GetSex(Creature)
	Bool Consent = (slac_CreatureDialogueSignal.GetValue() == 20)
	Bool Success = False

	If slacUtility.TestVictim(Victim,Creature,failOnPursuit = False, inviting = True)

		; play invite animation
		If Consent && slacUtility.TreatAsSex(Victim,Creature) == 1 && slacConfig.inviteAnimationNPC
			; Invite animation
			slacUtility.StripActor(Victim)
			slacUtility.PlayInviteAnimation(Victim,Creature)
			Creature.ClearLookAt()
			Utility.Wait(3.0)
		EndIf
		
		If slacUtility.StartCreatureSex(Victim, Creature, !Consent)
			; Success
			Success = True
			slacNotify.Show("SexStart", Victim, Creature, Consensual = Consent, Group = False)
			slacConfig.debugSLAC && slacUtility.Log("Creature Dialogue start sex: victim " + slacUtility.GetActorNameRef(Victim) + ", creature " + slacUtility.GetActorNameRef(Creature))
		Else
			; Failure
			If !slacUtility.SexLab.IsActorActive(Victim)
				slacUtility.UnstripActor(Victim)
				slacUtility.StopInviteAnimation(Victim,Creature)
			EndIf
			slacNotify.Show("SexStartFail", Victim, Creature, Consensual = Consent, Group = False)
			slacConfig.debugSLAC && slacUtility.Log("Creature Dialogue start sex fail: victim " + slacUtility.GetActorNameRef(Victim) + ", creature " + slacUtility.GetActorNameRef(Creature))
		EndIf
	Else
		; Failed Creature Scene tests
		slacNotify.Show("PursuitFail", Victim, Creature, Consensual = Consent, Group = False)
		slacConfig.debugSLAC && slacUtility.Log("Creature Dialogue actor tests failed: victim " + slacUtility.GetActorNameRef(Victim) + ", creature " + slacUtility.GetActorNameRef(Creature))

	EndIf
	
	slacUtility.EndPursuitQuest(GetOwningQuest(), !Success)
	slac_CreatureDialogueSignal.SetValue(0)
	Stop()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
	Bool Consent = (slac_CreatureDialogueSignal.GetValue() == 20)

	; Stagger victim
	If !Consent && VictimRef
		VictimRef.GetActorRef().PlayIdle(StaggerBack)
		Utility.Wait(1.0)
	EndIf
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_4
Function Fragment_4()
;BEGIN CODE
	; NPC Escape
	Actor Victim = VictimRef.GetActorRef()
	Actor Creature = CreatureRef1.GetActorRef()
	Bool Consent = (slac_CreatureDialogueSignal.GetValue() == 20)
	
	slacNotify.Show("PursuitEscape", Victim, Creature, Consensual = Consent, Group = False)
	slacConfig.debugSLAC && slacUtility.Log("Creature Dialogue NPC escaped: npc " + slacUtility.GetActorNameRef(Victim) + ", creature " + slacUtility.GetActorNameRef(Creature))

	slac_CreatureDialogueSignal.SetValue(0)
	Stop()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

ReferenceAlias Property CreatureRef Auto
ReferenceAlias Property CreatureRef1 Auto
ReferenceAlias Property VictimRef Auto
GlobalVariable Property slac_CreatureDialogueSignal Auto
Idle Property StaggerBack Auto
slac_Utility Property slacUtility Auto
slac_Config Property slacConfig Auto
slac_Notify Property slacNotify Auto
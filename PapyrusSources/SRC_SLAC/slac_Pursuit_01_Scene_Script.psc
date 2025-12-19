;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 42
Scriptname slac_Pursuit_01_Scene_Script Extends Scene Hidden

;BEGIN FRAGMENT Fragment_16
Function Fragment_16()
;BEGIN CODE
	; Female Victim escaped
	Actor akAttacker = AttackerRef.GetActorRef()
	Actor akAttacker2 = Attacker2Ref.GetActorRef()
	Actor akAttacker3 = Attacker3Ref.GetActorRef()
	Actor akAttacker4 = Attacker4Ref.GetActorRef()
	Actor akVictim = VictimRef.GetActorRef()
	Bool otherAttackers = akAttacker2 != None || akAttacker3 != None || akAttacker4 != None
	
	; Notify escape result
	slacNotify.Show("PursuitEscape", akVictim, akAttacker, Consensual = False, Group = otherAttackers)
	slacConfig.debugSLAC && slacUtility.Log("NPC Pursuit escape for female NPC: victim " + slacUtility.GetActorNameRef(akVictim) + ", pursuer " + slacUtility.GetActorNameRef(akAttacker) + slacConfig.CondString(otherAttackers," and others"))

	slacUtility.EndPursuitQuest(GetOwningQuest())
	slacUtility.UpdateFailedPursuitTime(akAttacker)
	slacUtility.UpdateLastEngageTime()
	Stop()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_1
Function Fragment_1()
;BEGIN CODE
	Actor akVictim = VictimRef.GetActorRef()
	
	; Update random value
	slacUtility.SetRandomValue()
	
	; Stagger victim
	If akVictim && !slacUtility.SexLab.IsActorActive(akVictim)
		slacConfig.debugSLAC && slacUtility.Log("NPC Pursuit stagger " + slacUtility.GetActorNameRef(VictimRef.GetActorRef()))
		akVictim.PlayIdle(StaggerBack)
		Utility.Wait(1.0)
	EndIf
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_38
Function Fragment_38()
;BEGIN CODE
	;Start non-consensual sex for male NPC
	
	; Make sure scene is not ended too soon
	slacConfig.pursuit01LastStartTime = Utility.GetCurrentRealTime()
	
	Actor akAttacker = AttackerRef.GetActorRef()
	Actor akAttacker2 = Attacker2Ref.GetActorRef()
	Actor akAttacker3 = Attacker3Ref.GetActorRef()
	Actor akAttacker4 = Attacker4Ref.GetActorRef()
	Actor akVictim = VictimRef.GetActorRef()
	Bool otherAttackers = akAttacker2 != None || akAttacker3 != None || akAttacker4 != None
	Bool Success = False

	If !slacUtility.TestCreature(akAttacker,False) || !slacUtility.TestVictim(akVictim,akAttacker,False)
		; Failed actor tests
		slacNotify.Show("PursuitFail", akVictim, akAttacker, Consensual = False, Group = otherAttackers)
		slacUtility.Log("NPC Pursuit Failed to actor tests after male NPC: victim " + slacUtility.GetActorNameRef(akAttacker) + slacConfig.CondString(otherAttackers," and others") + ", pursuer " + slacUtility.GetActorNameRef(akVictim))
	ElseIf slacUtility.StartCreatureSex(akVictim,akAttacker,true,"","", akAttacker2, akAttacker3, akAttacker4)
		; Success
		Success = True
		slacNotify.Show("SexStart", akVictim, akAttacker, Consensual = False, Group = otherAttackers)
		slacConfig.debugSLAC && slacUtility.Log("NPC Pursuit start sex: victim " + slacUtility.GetActorNameRef(akAttacker) + slacConfig.CondString(otherAttackers," and others") + ", pursuer " + slacUtility.GetActorNameRef(akVictim))
	Else
		; Failed animation test
		slacNotify.Show("SexStartFail", akVictim, akAttacker, Consensual = False, Group = otherAttackers)
		slacUtility.Log("NPC Pursuit Failed start sex for male NPC: victim " + slacUtility.GetActorNameRef(akAttacker) + slacConfig.CondString(otherAttackers," and others") + ", pursuer " + slacUtility.GetActorNameRef(akVictim))
	EndIf

	slacUtility.EndPursuitQuest(GetOwningQuest(),!Success)
	slacUtility.UpdateLastEngageTime()
	Stop()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
	; End pursuit
	getOwningQuest().Stop()
	slacUtility.Pursuit01Active = false
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_40
Function Fragment_40()
;BEGIN CODE
	; Male NPC gives up
	Actor akAttacker = AttackerRef.GetActorRef()
	Actor akAttacker2 = Attacker2Ref.GetActorRef()
	Actor akAttacker3 = Attacker3Ref.GetActorRef()
	Actor akAttacker4 = Attacker4Ref.GetActorRef()
	Actor akVictim = VictimRef.GetActorRef()
	Bool otherAttackers = akAttacker2 != None || akAttacker3 != None || akAttacker4 != None
	
	; Notify escape result
	slacNotify.Show("PursuitEscape", akVictim, akAttacker, Consensual = False, Group = otherAttackers)
	slacConfig.debugSLAC && slacUtility.Log("NPC Pursuit escape for male NPC: victim " + slacUtility.GetActorNameRef(akVictim) + ", pursuer " + slacUtility.GetActorNameRef(akAttacker) + slacConfig.CondString(otherAttackers," and others"))
	
	slacUtility.EndPursuitQuest(GetOwningQuest())
	slacUtility.UpdateLastEngageTime()
	Stop()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_3
Function Fragment_3()
;BEGIN CODE
	; Start female non-consensual sex
	
	; Make sure scene is not ended too soon
	slacConfig.pursuit01LastStartTime = Utility.GetCurrentRealTime()
	
	Actor akAttacker = AttackerRef.GetActorRef()
	Actor akAttacker2 = Attacker2Ref.GetActorRef()
	Actor akAttacker3 = Attacker3Ref.GetActorRef()
	Actor akAttacker4 = Attacker4Ref.GetActorRef()
	Actor akVictim = VictimRef.GetActorRef()
	Bool otherAttackers = akAttacker2 != None || akAttacker3 != None || akAttacker4 != None
	Bool Success = False

	If !slacUtility.TestCreature(akAttacker,False) || !slacUtility.TestVictim(akVictim,akAttacker,False)
		; Failed actor tests
		slacNotify.Show("PursuitFail", akVictim, akAttacker, Consensual = False, Group = otherAttackers)
		slacConfig.debugSLAC && slacUtility.Log("NPC Pursuit Failed actor tests for female NPC: victim " + slacUtility.GetActorNameRef(akVictim) + ", pursuer " + slacUtility.GetActorNameRef(akAttacker) + slacConfig.CondString(otherAttackers," and others"))
	ElseIf slacUtility.StartCreatureSex(akVictim,akAttacker,true,"","", akAttacker2, akAttacker3, akAttacker4)
		; Success
		Success = True
		slacNotify.Show("SexStart", akVictim, akAttacker, Consensual = False, Group = otherAttackers)
		slacConfig.debugSLAC && slacUtility.Log("NPC Pursuit female start sex: victim " + slacUtility.GetActorNameRef(akVictim) + ", pursuer " + slacUtility.GetActorNameRef(akAttacker) + slacConfig.CondString(otherAttackers," and others"))
	Else
		; Failed animation test
		slacNotify.Show("SexStartFail", akVictim, akAttacker, Consensual = False, Group = otherAttackers)
		slacConfig.debugSLAC && slacUtility.Log("NPC Pursuit Failed to start sex for female NPC: victim " + slacUtility.GetActorNameRef(akVictim) + ", pursuer " + slacUtility.GetActorNameRef(akAttacker) + slacConfig.CondString(otherAttackers," and others"))
	EndIf

	slacUtility.EndPursuitQuest(GetOwningQuest(),!Success)
	slacUtility.UpdateLastEngageTime()
	Stop()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_5
Function Fragment_5()
;BEGIN CODE
	; Start consensual sex
	
	; Make sure scene is not ended too soon
	slacConfig.pursuit01LastStartTime = Utility.GetCurrentRealTime()
	
	Actor akAttacker = AttackerRef.GetActorRef()
	Actor akAttacker2 = Attacker2Ref.GetActorRef()
	Actor akAttacker3 = Attacker3Ref.GetActorRef()
	Actor akAttacker4 = Attacker4Ref.GetActorRef()
	Actor akVictim = VictimRef.GetActorRef()
	Bool otherAttackers = akAttacker2 != None || akAttacker3 != None || akAttacker4 != None
	Bool Success = False

	If !slacUtility.TestCreature(akAttacker,False) || !slacUtility.TestVictim(akVictim,akAttacker,False)
		; Failed actor tests
		slacConfig.debugSLAC && slacUtility.Log("NPC Pursuit (consensual) failed actor tests for female NPC: victim " + slacUtility.GetActorNameRef(akVictim) + ", pursuer " + slacUtility.GetActorNameRef(akAttacker) + slacConfig.CondString(otherAttackers," and others"))
		slacNotify.Show("PursuitFail", akVictim, akAttacker, Consensual = True, Group = otherAttackers)
	Else
		; Play invite animation for females
		If slacUtility.GetSex(akVictim) == 1 && slacConfig.inviteAnimationNPC
			slacUtility.StripActor(akVictim, False)
			slacUtility.PlayInviteAnimation(akVictim,akAttacker)
			Utility.Wait(3.0)
		EndIf
	
		If slacUtility.StartCreatureSex(akVictim,akAttacker,false,"","", akAttacker2, akAttacker3, akAttacker4)
			; Success
			Success = True
			slacNotify.Show("SexStart", akVictim, akAttacker, Consensual = True, Group = otherAttackers)
			slacConfig.debugSLAC && slacUtility.Log("NPC Pursuit (consensual) female start sex: victim " + slacUtility.GetActorNameRef(akVictim) + ", pursuer " + slacUtility.GetActorNameRef(akAttacker) + slacConfig.CondString(otherAttackers," and others"))
		Else
			; Failure
			If !slacUtility.SexLab.IsActorActive(akVictim)
				slacUtility.UnstripActor(akVictim, False)
				slacUtility.StopInviteAnimation(akVictim,akAttacker)
			EndIf

			slacNotify.Show("SexStartFail", akVictim, akAttacker, Consensual = True, Group = otherAttackers)
			slacConfig.debugSLAC && slacUtility.Log("NPC Pursuit (consensual) failed for female start sex: victim " + slacUtility.GetActorNameRef(akVictim) + ", pursuer " + slacUtility.GetActorNameRef(akAttacker) + slacConfig.CondString(otherAttackers," and others"))
		EndIf
	EndIf

	slacUtility.EndPursuitQuest(GetOwningQuest(),!Success)
	slacUtility.UpdateLastEngageTime()
	Stop()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_13
Function Fragment_13()
;BEGIN CODE
	; Fail consensual pursuit
	Actor akAttacker = AttackerRef.GetActorRef()
	Actor akAttacker2 = Attacker2Ref.GetActorRef()
	Actor akAttacker3 = Attacker3Ref.GetActorRef()
	Actor akAttacker4 = Attacker4Ref.GetActorRef()
	Actor akVictim = VictimRef.GetActorRef()
	Bool otherAttackers = akAttacker2 != None || akAttacker3 != None || akAttacker4 != None
	
	slacNotify.Show("PursuitFail", akVictim, akAttacker, Consensual = False, Group = otherAttackers)

	slacUtility.EndPursuitQuest(GetOwningQuest())
	slacUtility.UpdateFailedPursuitTime(akAttacker)
	slacUtility.UpdateLastEngageTime()
	Stop()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

slac_Config Property slacConfig  Auto  
slac_Utility Property slacUtility  Auto  
slac_Notify Property slacNotify Auto
ReferenceAlias Property VictimRef  Auto  
ReferenceAlias Property AttackerRef  Auto  
ReferenceAlias Property Attacker2Ref  Auto  
ReferenceAlias Property Attacker3Ref  Auto  
ReferenceAlias Property Attacker4Ref  Auto 
Idle Property StaggerBack  Auto  

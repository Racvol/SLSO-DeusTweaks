;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 50
Scriptname slac_Pursuit_00_Scene_Script Extends Scene Hidden

;BEGIN FRAGMENT Fragment_44
Function Fragment_44()
;BEGIN CODE
	; Reached escape distance
	Actor akAttacker = AttackerRef.GetActorRef()
	Actor akAttacker2 = Attacker2Ref.GetActorRef()
	Actor akAttacker3 = Attacker3Ref.GetActorRef()
	Actor akAttacker4 = Attacker4Ref.GetActorRef()
	Bool otherAttackers = akAttacker2 != None || akAttacker3 != None || akAttacker4 != None
	Bool Consensual = slacConfig.slac_Pursuit00Type.GetValue() as Int == 20

	; Notify escape result
	slacNotify.Show("PursuitEscape", slacUtility.PlayerRef, akAttacker, Consensual, otherAttackers)
	slacConfig.debugSLAC && slacUtility.Log("Pursuit escape for PC: victim player, pursuer " + slacUtility.GetActorNameRef(akAttacker) + slacConfig.CondString(otherAttackers," and others"))
	
	; End Pursuit quest
	slacUtility.EndPursuitQuest(GetOwningQuest())
	slacUtility.UpdateFailedPursuitTime(akAttacker)
	slacUtility.UpdateLastEngageTime()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_23
Function Fragment_23()
;BEGIN CODE
	; Attacker reaches victim
	
	; Make sure scene is not ended too soon
	slacConfig.pursuit00LastStartTime = Utility.GetCurrentRealTime()
						
	Actor akAttacker = AttackerRef.GetActorRef()
	Actor akAttacker2 = Attacker2Ref.GetActorRef()
	Actor akAttacker3 = Attacker3Ref.GetActorRef()
	Actor akAttacker4 = Attacker4Ref.GetActorRef()
	Actor akVictim = slacUtility.PlayerRef
	Bool otherAttackers = akAttacker2 != None || akAttacker3 != None || akAttacker4 != None
	Bool Consent = slacConfig.slac_Pursuit00Type.GetValue() as Int == 20
	Bool success = False

	; Prevent Player being knocked out of running animation
	If slacUtility.SexLab.IsActorActive(akVictim)
		slacUtility.EndPursuitQuest(GetOwningQuest())
		slacNotify.Show("PursuitFail", akVictim, akAttacker, Consent, otherAttackers)
		slacConfig.debugSLAC && slacUtility.Log("Pursuit failure for PC: Player already engaged. Pursuer " + slacUtility.GetActorNameRef(akAttacker) + slacConfig.CondString(otherAttackers," and others"))
		Return
	EndIf

	; Invite animation
	If Consent
		slacUtility.StopPlayer()
		slacUtility.StripActor(akVictim, False)
		If slacConfig.pursuitInviteAnimationPC > 0
			slacUtility.PlayInviteAnimation(akVictim,akAttacker)
		EndIf
	EndIf		
	
	If slacUtility.TestVictim(akVictim, akAttacker, failOnpursuit = False, inviting = False) && slacUtility.TestCreature(akAttacker,False)
		; Engage the victim
		If slacUtility.StartCreatureSex(akVictim,akAttacker,!Consent, "", "", akAttacker2, akAttacker3, akAttacker4)
			; Success
			success = True
			slacNotify.Show("SexStart", slacUtility.PlayerRef, akAttacker, Consent, otherAttackers)
			slacConfig.debugSLAC && slacUtility.Log("Pursuit start sex for PC: victim player, pursuer " + slacUtility.GetActorNameRef(akAttacker) + slacConfig.CondString(otherAttackers," and others"))

		Else
			; Failure
			; Notify start sex failure
			slacNotify.Show("SexStartFail", slacUtility.PlayerRef, akAttacker, Consent, otherAttackers)
			slacConfig.debugSLAC && slacUtility.Log("Pursuit start sex failure for PC: victim player, pursuer " + slacUtility.GetActorNameRef(akAttacker) + slacConfig.CondString(otherAttackers," and others"))

		EndIf
	Else
		; Exit pursuit without engagement
		; Notify test failure
		slacNotify.Show("PursuitFail", slacUtility.PlayerRef, akAttacker, Consent, otherAttackers)
		slacConfig.debugSLAC && slacUtility.Log("Pursuit actor tests failure for PC: victim player, pursuer " + slacUtility.GetActorNameRef(akAttacker) + slacConfig.CondString(otherAttackers," and others"))
		
		slacUtility.EndPursuitQuest(GetOwningQuest())
		slacUtility.UpdateLastEngageTime()
	EndIf
	
	If !success
		slacUtility.StopInviteAnimation(akVictim,akAttacker)
		slacUtility.UnstripActor(akVictim, False)
		slacUtility.StartPlayer()
	EndIf
	
	Stop()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_18
Function Fragment_18()
;BEGIN CODE
	; Capture victim start
	Actor akVictim = slacUtility.PlayerRef
	Actor akAttacker = AttackerRef.GetActorRef()
	Actor akAttacker2 = Attacker2Ref.GetActorRef()
	Actor akAttacker3 = Attacker3Ref.GetActorRef()
	Actor akAttacker4 = Attacker4Ref.GetActorRef()
	Bool otherAttackers = akAttacker2 != None || akAttacker3 != None || akAttacker4 != None
	Bool Consent = slacConfig.slac_Pursuit00Type.GetValue() as Int == 20

	; This is a pretty messy solution for capturing an escape scenario and should be 
	; done in Scene Phase conditions but that has proven more complex then expected
	Float captureRadius = slacConfig.slac_PursuitCaptureRadiusPCSafe.GetValue()
	Bool capture = False
	If akAttacker && akVictim.GetDistance(akAttacker) < captureRadius
		capture = True
	ElseIf akAttacker2 && akVictim.GetDistance(akAttacker2) < captureRadius
		capture = True
	ElseIf akAttacker3 && akVictim.GetDistance(akAttacker3) < captureRadius
		capture = True
	ElseIf akAttacker4 && akVictim.GetDistance(akAttacker4) < captureRadius
		capture = True
	EndIf
	Bool group = akAttacker2 || akAttacker3 || akAttacker4
	
	If !capture
		; Failure
		
		; Notify pursuit escape
		slacNotify.Show("PursuitEscape", slacUtility.PlayerRef, akAttacker, Consent, group)
		slacConfig.debugSLAC && slacUtility.Log("Pursuit escape for PC: victim player, pursuer " + slacUtility.GetActorNameRef(akAttacker) + slacConfig.CondString(otherAttackers," and others"))

		; Stop pursuit quest
		slacUtility.EndPursuitQuest(GetOwningQuest())
		slacUtility.UpdateFailedPursuitTime(akAttacker)
		slacUtility.UpdateLastEngageTime()
		
	ElseIf !Consent
		; Stagger victim
		slacConfig.debugSLAC && slacUtility.Log("Stagger player " + slacConfig.slac_Pursuit00Type.GetValue())
		Utility.Wait(1.0)
		!slacUtility.MenuOpen("ForceAll") && !slacUtility.SexLab.IsActorActive(akVictim) && akVictim.Playidle(StaggerIdle)
		
	EndIf
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
	; End pursuit
	slacUtility.Pursuit00Active = false
	GetOwningQuest().Stop()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

slac_Config Property slacConfig  Auto
slac_Utility Property slacUtility Auto
slac_Notify Property slacNotify Auto
ReferenceAlias Property VictimRef  Auto
ReferenceAlias Property AttackerRef  Auto
ReferenceAlias Property Attacker2Ref  Auto
ReferenceAlias Property Attacker3Ref  Auto
ReferenceAlias Property Attacker4Ref  Auto
Idle Property StaggerIdle  Auto

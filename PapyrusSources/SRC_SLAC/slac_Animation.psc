Scriptname slac_Animation Extends Quest  
{Animation functions for SexLab Aroused Creatures including invite animation selection}

; SLAC
slac_Config Property slacConfig Auto
slac_Utility Property slacUtility Auto

; SexLab
SexLabFramework Property SexLab Auto


; Play Invite Animation - the animation may be distorted by reapplication of head tracking by the game or other mods
; Actor @inviter	 The NPC actor that will be playing the invite animation
; Actor @invited   (Optional) the invited actor that the animation will be rotated to address.
Function PlayInviteAnimation(Actor inviter, Actor invited = none)
	; Don't want to bug out the player controls in crafting menus
	If slacUtility.MenuOpen()
		Return
	EndIf
	
	; Calculate face away angle
	Float offsetRotation = 10.0
	If invited
		offsetRotation += inviter.GetHeadingAngle(invited)
	EndIf

	; Rotation offsets for SRB_Invitation_F_01 animation
	; We don't do this for the PC because of the performance hit for SetAngle()
	inviter != slacUtility.playerRef && inviter.SetAngle(inviter.GetAngleX(), inviter.GetAngleY(), inviter.GetAngleZ() + offsetRotation)
	; Play animation
	Debug.SendAnimationEvent(inviter as ObjectReference,"SRB_Invitation_F_01")
	
	slacConfig.debugSLAC && slacUtility.Log("Playing invite animation on " + slacUtility.GetActorNameRef(inviter))
	
	; Have target respond
	If invited
		invited.SetLookAt(inviter as ObjectReference, abPathingLookAt = True)
	EndIf
	
	; Disable head tracking
	ClearIK(inviter)
EndFunction

; Stop Invite Animation
Function StopInviteAnimation(Actor inviter, Actor invited = None)
	; Re-enable head tracking
	RestoreIK(inviter)

	; Reset animation so long as the actor is not in a critical animation state or the pc is in a menu
	ResetAnimation(inviter)
	
	slacConfig.debugSLAC && slacUtility.Log("Stopping invite animation on " + slacUtility.GetActorNameRef(inviter))
	
	If invited && invited != None
		invited.ClearLookAt()
	EndIf
EndFunction

; Send animation reset
Function ResetAnimation(Actor akActor)
	; Reset animation so long as the actor is not in a critical animation state
	; or the pc is in a menu as this could lock up the NPC AI or even the player controls
	(akActor != slacUtility.PlayerRef || \
	!slacUtility.MenuOpen("ForceAll")) && \
	!akActor.IsOnMount() && \
	akActor.GetSitState() < 1 && \
	akActor.GetSleepState() < 1 && \
	!akActor.IsBeingRidden() && \
	Debug.SendAnimationEvent(akActor as ObjectReference,"IdleForceDefaultState")
EndFunction

; Clear IK animation features that might distort running animations
Function ClearIK(Actor akActor)
	If !akActor
		slacUtility.Log("Clear IK: no actor")
		Return
	EndIf
	akActor.ClearLookAt()
	(akActor as ObjectReference).SetAnimationVariableBool("bHeadTrackSpine", False) ; this might stop the actor's spine from twisting during head tracking.
	If akActor != slacUtility.PlayerRef
		(akActor as ObjectReference).SetAnimationVariableInt("IsNPC", 0) ; <- this was the key to disabling NPC head tracking
		akActor.SetHeadTracking(False)
	EndIf
EndFunction

; Reapply IK animation features
Function RestoreIK(Actor akActor)
	If !akActor
		slacUtility.Log("Restore IK: no actor")
		Return
	EndIf
	akActor.ClearLookAt()
	(akActor as ObjectReference).SetAnimationVariableBool("bHeadTrackSpine", True)
	If akActor != slacUtility.PlayerRef
		(akActor as ObjectReference).SetAnimationVariableInt("IsNPC", 1)
		akActor.SetHeadTracking(True)
	EndIf
EndFunction

; NOT CURRENTLY USED

; Animation used between chained animations
Function PlayWaitAnimation(Actor Victim, Actor Attacker = none, Bool Aggressive = True)
	ClearIK(Victim)
	If Aggressive
		; Play protective / exhausted animation 
	Else
		; Play pensive / eager animation
	EndIf
EndFunction
Function StopWaitAnimation(Actor Victim, Actor Attacker = none)
	RestoreIK(Victim)
EndFunction

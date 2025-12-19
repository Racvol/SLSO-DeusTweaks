;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 3
Scriptname slac_TopicCreatureDialogueMountHorse Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_2
Function Fragment_2(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
	Actor PlayerRef = Game.GetPlayer()
	; Mount Horse
	If akSpeaker
		If slacUtility.slacConfig.creatureDialogueAllowSteal || (akSpeaker.GetActorOwner() == None || akSpeaker.GetActorOwner() == PlayerRef.GetActorBase() || PlayerRef.IsSneaking())
			; The horse belongs to the player or to no one or stealing is allowed
			slacUtility.slacConfig.debugSLAC && slacUtility.Log("Mounting horse via dialogue " + akSpeaker)
			If slacUtility.EnableActorActivation(akSpeaker)
				slacUtility.slacConfig.debugSLAC && slacUtility.Log("Script activation of horse " + akSpeaker + " (Activation Blocked:" + akSpeaker.IsActivationBlocked() + ")")
				akSpeaker.Activate(PlayerRef as ObjectReference)
			Else
				slacUtility.slacConfig.debugSLAC && slacUtility.Log("Failed to enable activation for horse " + akSpeaker + " (Activation Blocked:" + akSpeaker.IsActivationBlocked() + ")")
			EndIf
		Else
			slacUtility.slacConfig.debugSLAC && slacUtility.Log("Horse theft blocked for " + akSpeaker)
		EndIf
	Else
		slacUtility.slacConfig.debugSLAC && slacUtility.Log("Unable to mount horse via dialogue, missing speaker")
	EndIf
	slacUtility.slacConfig.slac_CreatureDialogueSignal.SetValue(0)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

ReferenceAlias Property CreatureRef  Auto
slac_Utility Property slacUtility Auto

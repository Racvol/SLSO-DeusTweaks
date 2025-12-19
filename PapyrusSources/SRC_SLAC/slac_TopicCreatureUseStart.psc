;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 2
Scriptname slac_TopicCreatureUseStart Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_1
Function Fragment_1(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
	; Initialise dialogue
	
	; Clean up forced dialogue
	Actor ForceGreetCreature = ForcedRef.GetActorRef()
	ForcedRef.Clear()
	If ForceGreetCreature
		slacUtility.EnableActorActivation(ForceGreetCreature)
		ForceGreetCreature.EvaluatePackage()
	EndIf
	
	slac_CreatureDialogueSignal.SetValue(0)
	CreatureRef.ForceRefTo(akSpeakerRef as ObjectReference)
	Actor Creature = CreatureRef.GetActorRef()
	String CreatureName = Creature.GetLeveledActorBase().GetName()
	String CreatureNameRef = slacUtility.GetActorNameRef(Creature)
	
	If VictimRef.GetActorRef()
		Actor Victim = VictimRef.GetActorRef()
		String VictimName = Victim.GetLeveledActorBase().GetName()
		String VictimNameRef = slacUtility.GetActorNameRef(Victim)
		Int VictimSex = slacUtility.TreatAsSex(Victim, Creature)

		; Female victim does not need arousal check but males must be aroused
		If VictimSex == 1 || slacUtility.GetActorArousal(Victim) >= slacConfig.followerCommandThreshold
			slacUtility.Log("Creature Dialogue victim " + VictimNameRef + " selected for " + CreatureNameRef)
		Else
			slacNotify.Show("TestFail", Victim, Creature)
		EndIf
	Else
		slacUtility.Log("Creature Dialogue no victim for " + CreatureName)
	EndIf
	
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Quest Property CreatureDialogueQuest Auto
ReferenceAlias Property CreatureRef  Auto  
ReferenceAlias Property TargetRef  Auto  
ReferenceAlias Property VictimRef  Auto  
ReferenceAlias Property ForcedRef  Auto  
GlobalVariable Property slac_CreatureDialogueSignal Auto
slac_Config Property slacConfig Auto
slac_Utility Property slacUtility Auto
slac_Notify Property slacNotify Auto
;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 20
Scriptname slac_SceneFollowerDialogue Extends Scene Hidden

;BEGIN FRAGMENT Fragment_18
Function Fragment_18()
;BEGIN CODE
	Actor Follower = FollowerRef.GetActorRef()
	Actor Creature = CreatureRef.GetActorRef()
	
	; Begin approach
	slacConfig.FollowerDialogueLastStartTime = Utility.GetCurrentRealTime()
	
	; Just in case there are creatures left from a previous engagement
	If GetOwningQuest().GetStage() != 50
		CreatureRef2.Clear()
		CreatureRef3.Clear()
		CreatureRef4.Clear()
	EndIf

	slacConfig.debugSLAC && slacUtility.Log("Follower Dialogue Scene start approach: " + slacUtility.GetActorNameRef(Follower) + ", " + slacUtility.GetActorNameRef(Creature))

;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_20
Function Fragment_20()
;BEGIN CODE
	; Follower reaches creature
	
	; Make sure the scene is not ended too soon
	slacConfig.FollowerDialogueLastStartTime = Utility.GetCurrentRealTime()
	
	Actor Follower = FollowerRef.GetActorRef()
	Actor Creature = CreatureRef.GetActorRef()
	Int FollowerGender = slacUtility.TreatAsSex(Follower,Creature)
	Int signalStage = GetOwningQuest().GetStage()
	Bool normal = (signalStage == 20)
	Bool aggressive = (signalStage == 30)
	Bool oral = (signalStage == 40)
	Bool group = (signalStage == 50)
	Bool animStarted = False
	
	If slacUtility.TestCreature(Creature,failOnPursuit = False,invited = True) && slacUtility.TestVictim(Follower,Creature,failOnPursuit = False,inviting = True)
		slacConfig.debugSLAC && slacUtility.Log("Follower Dialogue Scene End: " + slacUtility.GetActorNameRef(Follower) + ", " + slacUtility.GetActorNameRef(Creature))
		
		; Invite animation
		If slacConfig.inviteAnimationNPC && slacUtility.TreatAsSex(Follower,Creature) == 1
			slacUtility.StripActor(Follower)
			slacUtility.PlayInviteAnimation(Follower,Creature)
			Utility.Wait(3.0)
		EndIf
		
		If oral
			slacConfig.debugSLAC && slacUtility.Log("Follower Dialogue Scene oral result: " + slacUtility.GetActorNameRef(Follower) + ", " + slacUtility.GetActorNameRef(Creature))
			String ReqTags = slacConfig.CondString(slacUtility.GetSex(Creature) == 0, "BlowJob", "Cunnilingus")
			If slacUtility.StartCreatureSex(Follower, Creature, nonConsensual = False, requireTags = ReqTags, rejectTags = "Anal,Vaginal")
				animStarted = True
			EndIf

		ElseIf aggressive
			slacConfig.debugSLAC && slacUtility.Log("Follower Dialogue Scene aggressive result: " + slacUtility.GetActorNameRef(Follower) + ", " + slacUtility.GetActorNameRef(Creature))
			If slacUtility.StartCreatureSex(Follower, Creature, nonConsensual = FollowerGender == 0, requireTags = "Aggressive")
				animStarted = True
			EndIf
			
		ElseIf group
			Actor Creature2 = CreatureRef2.GetActorRef()
			Actor Creature3 = CreatureRef3.GetActorRef()
			Actor Creature4 = CreatureRef4.GetActorRef()
			slacConfig.debugSLAC && slacUtility.Log("Follower Dialogue Scene group result: " + slacUtility.GetActorNameRef(Follower) + ", " + slacUtility.GetActorNameRef(Creature) + ", " + slacUtility.GetActorNameRef(Creature2) + ", " + slacUtility.GetActorNameRef(Creature3) + ", " + slacUtility.GetActorNameRef(Creature4))
			If slacUtility.StartCreatureSex(Follower, Creature, nonConsensual = False, otherAttacker2 = Creature2, otherAttacker3 = Creature3, otherAttacker4 = Creature4)
				animStarted = True
			EndIf
			
		Else
			slacConfig.debugSLAC && slacUtility.Log("Follower Dialogue Scene normal result: " + slacUtility.GetActorNameRef(Follower) + ", " + slacUtility.GetActorNameRef(Creature))
			If slacUtility.StartCreatureSex(Follower, Creature, nonConsensual = False, rejectTags="Oral")
				animStarted = True
			EndIf
			
		EndIf
		
		If animStarted
			slacConfig.debugSLAC && slacUtility.Log("Follower Dialogue Scene animation started: " + slacUtility.GetActorNameRef(Follower) + ", " + slacUtility.GetActorNameRef(Creature))

			; Apply persuasion / intimidate / bribe effects
			Int signal = slac_FollowerDialogueSignal.GetValue() as Int
			If signal == 1
				; Persuade
				Follower.SetFactionRank(slac_LastPersuadeDayFaction, slac_CurrentGameTimeModulo.GetValue() as Int)
				DialogueFavorGeneric.Persuade(Follower)
				slacConfig.debugSLAC && slacUtility.Log("Follower Dialogue Scene: " + slacUtility.GetActorNameRef(Follower) + " persuaded")
			ElseIf signal == 2
				; Intimidate
				Follower.SetFactionRank(slac_LastIntimidateDayFaction, slac_CurrentGameTimeModulo.GetValue() as Int)
				DialogueFavorGeneric.Intimidate(Follower)
				slacConfig.debugSLAC && slacUtility.Log("Follower Dialogue Scene: " + slacUtility.GetActorNameRef(Follower) + " intimidated")
			ElseIf signal == 3
				; Bribe
				Follower.SetFactionRank(slac_LastBribeDayFaction, slac_CurrentGameTimeModulo.GetValue() as Int)
				Int bribeValue = Follower.GetBribeAmount()
				DialogueFavorGeneric.Bribe(Follower)
				
				; Remove bribe gold from followers so the player cannot retrieve it from their inventory.
				If Follower.IsPlayerTeammate()
					Follower.RemoveItem(gold,bribeValue)
				EndIf
				slacConfig.debugSLAC && slacUtility.Log("Follower Dialogue Scene: " + slacUtility.GetActorNameRef(Follower) + " bribed (" + bribeValue + " gold)")
			EndIf
			
			; Notify successful result
			slacNotify.Show("SexStart", Follower, Creature, Consensual = True, Group = False)

		Else
			; Could not start animation
			slacUtility.UnstripActor(Follower)
			slacUtility.StopInviteAnimation(Follower,Creature)
			slacConfig.debugSLAC && slacUtility.Log("Follower Dialogue Scene animation failed: " + slacUtility.GetActorNameRef(Follower) + ", " + slacUtility.GetActorNameRef(Creature))
		
			; Notify failed result
			If oral
				If slacUtility.TreatAsSex(Follower,Creature) == 1
					slacUtility.slacData.SetSignalBool(Follower,"GettingCunnilingus",True)
				Else
					slacUtility.slacData.SetSignalBool(Follower,"GettingBlowJob",True)
					slacUtility.slacData.SetSignalBool(Creature,"CreatureVictim",True)
				EndIf
			EndIf
			slacNotify.Show("SexStartFail", Follower, Creature, Consensual = True, Group = False)
			slacUtility.slacData.ClearSignal(Follower,"GettingBlowJob")
			slacUtility.slacData.ClearSignal(Creature,"CreatureVictim")
		
		EndIf
		
	Else
		; Creature or victim failed tests
		slacNotify.Show("PursuitFail", Follower, Creature, Consensual = True, Group = False)
		slacConfig.debugSLAC && slacUtility.Log("Follower Dialogue Scene tests failed: " + slacUtility.GetActorNameRef(Follower) + ", " + slacUtility.GetActorNameRef(Creature))
	
	EndIf

	; Reset
	slacConfig.debugSLAC && slacUtility.Log("Follower Dialogue Scene resetting: " + slacUtility.GetActorNameRef(Follower) + ", " + slacUtility.GetActorNameRef(Creature))
	CreatureRef2.Clear()
	CreatureRef3.Clear()
	CreatureRef4.Clear()
	slac_FollowerDialogueSignal.SetValue(0)
	GetOwningQuest().Reset()
	GetOwningQuest().SetStage(0)
	GetOwningQuest().Start()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_3
Function Fragment_3()
;BEGIN CODE
	; Follower failure to reach creature
	Actor Follower = FollowerRef.GetActorRef()
	Actor Creature = CreatureRef.GetActorRef()

	slacNotify.Show("PursuitEscape", Follower, Creature, Consensual = True, Group = False)
	slacConfig.debugSLAC && slacUtility.Log("Follower Dialogue Scene failure to reach creature: " + slacUtility.GetActorNameRef(Follower) + ", " + slacUtility.GetActorNameRef(Creature))

	; Reset
	slac_FollowerDialogueSignal.SetValue(0)
	GetOwningQuest().Reset()
	GetOwningQuest().SetStage(0)
	GetOwningQuest().Start()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

ReferenceAlias Property FollowerRef Auto
ReferenceAlias Property CreatureRef Auto
ReferenceAlias Property CreatureRef2 Auto
ReferenceAlias Property CreatureRef3 Auto
ReferenceAlias Property CreatureRef4 Auto

FavorDialogueScript Property DialogueFavorGeneric Auto
GlobalVariable Property slac_CurrentGameTimeModulo Auto
GlobalVariable Property slac_FollowerDialogueSignal Auto
Faction Property slac_LastBribeDayFaction Auto
Faction Property slac_LastPersuadeDayFaction Auto
Faction Property slac_LastIntimidateDayFaction Auto
MiscObject Property gold Auto

slac_Utility Property slacUtility  Auto  
slac_Config Property slacConfig  Auto  
slac_Notify Property slacNotify  Auto  


Scriptname slac_PlayerScript extends ReferenceAlias
{Player Script for SexLab Aroused Creatures where most of the scheduling takes place}

slac_Config Property slacConfig Auto
slac_Utility Property slacUtility Auto
slac_Notify Property slacNotify Auto
slac_StaminaWidget Property StaminaMeter Auto
Faction Property slac_engagedActor Auto
GlobalVariable Property slac_LastEngageTime Auto
Spell Property slac_CloakAbility Auto
Spell Property slac_TargetSpell Auto
Actor Property crosshairRef Auto
Float Property LastUpdateTime = 0.0 Auto
Actor Property PlayerRef Auto
Actor lastBlockedActor
Actor Property LastSelectedNPC = None Auto
Actor Property LastSelectedCreature = None Auto
Int lastTargetKey = -1
Int lastInviteTargetKey = -1
Float lastStruggleInputTime = 0.0
Int lastStruggleKeyOne = -1
Int ActivateKey
Bool InviteInProgress = False
Bool struggleInProgress = False
Bool DoInitMaintenance = True
Float UNITFOOTRATIO = 21.3333 ; Approximate CK Unit to Foot ratio
Float FOOTUNITRATIO = 0.0468 ; Approximate Foot to CK Unit ratio


Int Function GetVersion()
    Return 40037
EndFunction


Event OnInit()
	;Debug.Trace("[slac] Aroused Creatures Initialising")
	RegisterForSingleUpdate(10.0)
EndEvent


Event OnPlayerLoadGame()
	DoInitMaintenance = False
	LastSelectedNPC = None
	LastSelectedCreature = None

	; Force debug state from file (this technique must only be used to enable debugging)
	If MiscUtil.FileExists("Data/SKSE/Plugins/ArousedCreatures/debugslac.txt")
		Log("Aroused Creatures Debug Override Activated", forceTrace = True)
		slacConfig.debugSLAC = True
	EndIf

	; Check script versions
	slacConfig.VersionCheck()
	
	; Load Default Profile on initial load
	If slacConfig.InInitMaintenance
		Log("Aroused Creatures Loading Default Settings", forceTrace = True)
		If slacConfig.LoadSettings(0)
			Log("Aroused Creatures Default Settings loaded successfully", forceTrace = True)
		Else
			Log("WARNING: Aroused Creatures Default Settings failed to load", forceTrace = True)
		EndIf
	EndIf
	slacConfig.InInitMaintenance = False

	; Register for updates if active
	If slacConfig.modActive
		Log("Aroused Creatures starting maintenance", forceTrace = True)
		
		UnregisterForUpdate()
		
		; Listen for animations
		Log("Aroused Creatures registering for animation events", forceTrace = True)
		UnregisterForAnimationEvent(PlayerRef, "tailHorseMount")
		UnregisterForAnimationEvent(PlayerRef, "tailHorseDismount")
		UnregisterForAnimationEvent(PlayerRef, "weaponDraw")
		RegisterForAnimationEvent(PlayerRef, "tailHorseMount")
		RegisterForAnimationEvent(PlayerRef, "tailHorseDismount")
		RegisterForAnimationEvent(PlayerRef, "weaponDraw")
		
		; Check registered keys
		Log("Aroused Creatures updating hotkeys", forceTrace = True)
		UpdateKeyRegistery(False)
		
		; Register for crosshair targeting
		Log("Aroused Creatures registering crosshair events", forceTrace = True)
		crosshairref = None
		UnregisterforCrosshairRef()
		RegisterForCrosshairRef()
		
		; Register mods, animations, reset timers, etc.
		Log("Aroused Creatures performing primary maintenance cycle", forceTrace = True)
		slacUtility.Maintenance()
		
		; Reset flags
		struggleInProgress = False
		
		; Reset timing
		LastUpdateTime = Utility.GetCurrentRealTime()

		; If not disabled on start up
		RegisterForSingleUpdate(10) ; Wait in case there are instances from save game still running
		Log("Aroused Creatures starting enabled", forceTrace = True)
		
	Else
		Log("Aroused Creatures loading disabled. Cleaning up...", forceTrace = True)
		
		; Unregister for events
		UnregisterForUpdate()
		UnregisterForAnimationEvent(PlayerRef, "tailHorseMount")
		UnregisterForAnimationEvent(PlayerRef, "tailHorseDismount")
		UnregisterForAnimationEvent(PlayerRef, "weaponDraw")
		crosshairref = None
		UnregisterforCrosshairRef()
		UnregisterForAllKeys()
		
		; Clear aliases and data, and unregister for mod events
		slacUtility.Maintenance()
		
		Log("Aroused Creatures is disabled")
		
	EndIf
EndEvent


Event OnUpdate()
	; Perform first-time maintenance operations outside OnInit.
	; This is to prevent accidentally and permanently locking up the MCM during this event.
	If DoInitMaintenance
		DoInitMaintenance = False
		OnPlayerLoadGame()
		Return
	EndIf

	Float currentTime = Utility.GetCurrentRealTime()
	LastUpdateTime = currentTime

	; Recheck loaded mods instead of running scan
	If slacConfig.softDependanciesTest
		slacConfig.softDependanciesTest = false
		slacUtility.ModCheck(true)
		
		; Register next tick for cloak check
		RegisterForSingleUpdate(slacConfig.checkFrequency + 5.0)
		
		Return
	EndIf
	
	; Sync settings and quests after MCM interaction
	If slacConfig.modActive && slacConfig.configUpdate
		slacConfig.configUpdate = False
		UpdateKeyRegistery()
		slacConfig.SyncQuests()
	EndIf
	
	; Record any change to vanilla Activate control
	ActivateKey = Input.GetMappedKey("Activate")
	
	; Update current game day modulo for dialogue tests
	slacConfig.UpdateGameTimeModulo()
	
	; Clear stuck force greet alias if appropriate
	Actor testCHRef = Game.GetCurrentCrosshairRef() as Actor
	Actor CDRFTemp = slacUtility.CreatureDialogueForcedRef.GetActorRef()
	If CDRFTemp && UI.IsMenuOpen("Dialogue Menu") && CDRFTemp != testCHRef
		; Not in dialogue and not looking at the forced greet creature
		slacConfig.debugSLAC && Log("PlayerScript CH Ref Change: Clearing force greet creature ref " + slacUtility.GetActorNameRef(CDRFTemp))
		slacUtility.CreatureDialogueForcedRef.Clear()
		CDRFTemp.Evaluatepackage()
	EndIf
	
	; Check for change in combat state
	If slacConfig.modActive && slacConfig.lastCombatState != PlayerRef.GetCombatState()
		slacConfig.debugSLAC && Log("Updating combat cooldown (update): last state " + slacConfig.lastCombatState + ", new state " + PlayerRef.GetCombatState() + ", time " + currentTime)
		slacConfig.lastCombatState = PlayerRef.GetCombatState()
		slacConfig.lastCombatStateChange = currentTime
	EndIf
	
	; Check suitor validity
	If slacConfig.lastCombatState > 0 || slacConfig.suitorsMaxPC < 1
		slacUtility.ClearSuitors()
	ElseIf !PlayerRef.IsInFaction(slacUtility.slac_engagedActor)
		; If the player is involved in StartCreatureSex() then we want to let the suitors become queuers
		slacUtility.UpdateSuitors()
	EndIf
	
	; Check claimed actor validity
	slacUtility.UpdateClaimedActors()

	;slacConfig.debugSLAC && Log("Combat state: " + slacConfig.lastCombatState + ", PC Pursuit: " + slacConfig.slac_Pursuit_00.IsRunning() + ", NPC Pursuit: " + slacConfig.slac_Pursuit_01.IsRunning())

	; Check for overrunning quests
	String victimName = ""
	String attackerName = ""

	; Stop overrunning PC pursuit
	If slacConfig.slac_Pursuit_00.IsRunning() && ((slacConfig.lastCombatState > 0 && !slacConfig.allowCombatEngagements) || (currentTime - slacConfig.pursuit00LastStartTime > slacConfig.pursuitMaxTimePC) || (slacConfig.weaponsPreventAutoEngagement && PlayerRef.IsWeaponDrawn()))
		; Cancel player pursuit quest
		Bool PursuitConsensual = slacConfig.slac_Pursuit00Type.GetValue() as Int == 20
		Bool PursuitGroup = slacUtility.PlayerAttacker2.GetActorReference() != None || slacUtility.PlayerAttacker3.GetActorReference() != None || slacUtility.PlayerAttacker4.GetActorReference() != None
		Actor Creature = slacUtility.PlayerAttacker.GetActorReference()
		If (currentTime - slacConfig.pursuit00LastStartTime) > slacConfig.pursuitMaxTimePC
			slacNotify.Show("PursuitEscape", PlayerRef, Creature, Consensual = PursuitConsensual, Group = PursuitGroup)
			slacConfig.debugSLAC && Log("PC Auto pursuer " + slacUtility.GetActorNameRef(Creature) + " could not reach the player at distance " + slacConfig.PrecisionFloatString(Creature.GetDistance(PlayerRef)) + " units / " + slacConfig.PrecisionFloatString(Creature.GetDistance(PlayerRef) * FOOTUNITRATIO) + " ft after " + slacConfig.PrecisionFloatString(currentTime - slacConfig.pursuit00LastStartTime) + " seconds")
		Else
			slacNotify.Show("PursuitScare", PlayerRef, Creature, Consensual = PursuitConsensual, Group = PursuitGroup)
		EndIf
		slacUtility.EndPursuitQuest(slacConfig.slac_Pursuit_00,True)
		slacUtility.UpdateFailedPursuitTime(Creature)
		slacUtility.UpdateLastEngageTime()
	EndIf
	
	; Stop overrunning NPC Pursuit
	If slacConfig.slac_Pursuit_01.IsRunning() && ((slacConfig.lastCombatState > 0 && !slacConfig.allowCombatEngagements) || (currentTime - slacConfig.pursuit01LastStartTime > slacConfig.pursuitMaxTimeNPC) || (slacConfig.weaponsPreventAutoEngagement && PlayerRef.IsWeaponDrawn()))
		Bool PursuitConsensual = slacConfig.slac_Pursuit01Type.GetValue() as Int == 20
		Bool PursuitGroup = slacUtility.NPCAttacker2.GetActorReference() != None || slacUtility.NPCAttacker3.GetActorReference() != None || slacUtility.NPCAttacker4.GetActorReference() != None
		Actor Victim = slacUtility.NPCVictim.GetActorReference()
		Actor Creature = slacUtility.NPCAttacker.GetActorReference()
		If (currentTime - slacConfig.pursuit01LastStartTime > slacConfig.pursuitMaxTimeNPC)
			slacNotify.Show("PursuitEscape", Victim, Creature, Consensual = PursuitConsensual, Group = PursuitGroup)
			slacConfig.debugSLAC && Log("NPC Auto pursuer " + slacUtility.GetActorNameRef(Creature) + " could not reach victim " + slacUtility.GetActorNameRef(Victim) + " at distance " + slacConfig.PrecisionFloatString(Creature.GetDistance(Victim)) + " units / " + slacConfig.PrecisionFloatString(Creature.GetDistance(Victim) * FOOTUNITRATIO) + " ft after " + slacConfig.PrecisionFloatString(currentTime - slacConfig.pursuit01LastStartTime) + " seconds")
		Else
			slacNotify.Show("PursuitScare", Victim, Creature, Consensual = PursuitConsensual, Group = PursuitGroup)
		EndIf
		slacUtility.EndPursuitQuest(slacConfig.slac_Pursuit_01,True)
		slacUtility.UpdateFailedPursuitTime(Creature)
		slacUtility.UpdateLastEngageTime()
	EndIf
	
	; End overrunning follower dialogue pursuit - also end on combat or drawn weapons
	If slacConfig.slac_FollowerDialogueScene.IsPlaying() && ((slacConfig.lastCombatState > 0 && !slacConfig.allowCombatEngagements) || (currentTime - slacConfig.FollowerDialogueLastStartTime) > slacConfig.pursuitMaxTimeNPC || (slacConfig.weaponsPreventAutoEngagement && PlayerRef.IsWeaponDrawn()))
		If slacUtility.FollowerDialogueFollowerRef.GetActorReference() != None && slacUtility.FollowerDialogueCreatureRef.GetActorReference() != None
			; Pursuer did not reach target in time
			Actor Victim = slacUtility.FollowerDialogueFollowerRef.GetActorReference()
			Actor Creature = slacUtility.FollowerDialogueCreatureRef.GetActorReference()
			If (currentTime - slacConfig.FollowerDialogueLastStartTime) > slacConfig.pursuitMaxTimeNPC
				slacNotify.Show("PursuitEscape", Victim, Creature, Consensual = True, Group = slacUtility.slac_FollowerDialogue.GetStage() == 50)
				slacConfig.debugSLAC && Log("Follower Dialogue pursuer " + slacUtility.GetActorNameRef(Creature) + " could not reach victim " + slacUtility.GetActorNameRef(Victim) + " at distance " + slacConfig.PrecisionFloatString(Creature.GetDistance(Victim)) + " units / " + slacConfig.PrecisionFloatString(Creature.GetDistance(Victim) * FOOTUNITRATIO) + " ft after " + slacConfig.PrecisionFloatString(currentTime - slacConfig.FollowerDialogueLastStartTime) + " seconds")
			Else
				slacNotify.Show("PursuitScare", Victim, Creature, Consensual = True, Group = slacUtility.slac_FollowerDialogue.GetStage() == 50)
			EndIf
			
		Else
			; Problem with dialogue quest
			Log("Follower Dialogue quest aliases unfilled")
		
		EndIf
		
		slacUtility.EndPursuitQuest(slacConfig.slac_FollowerDialogue,True)
		slacUtility.UpdateLastEngageTime()
	
	EndIf

	; End overrunning creature dialogue pursuit - also end on combat or drawn weapons
	If slacConfig.slac_CreatureDialogueScene.IsPlaying() && ((slacConfig.lastCombatState > 0 && !slacConfig.allowCombatEngagements) || (currentTime - slacConfig.CreatureDialogueLastStartTime) > slacConfig.pursuitMaxTimeNPC || (slacConfig.weaponsPreventAutoEngagement && PlayerRef.IsWeaponDrawn()))
		Actor Victim = slacUtility.CreatureDialogueVictimRef.GetActorReference()
		Actor Creature = slacUtility.CreatureDialogueCreatureRef.GetActorReference()
		Bool DialogueConsent = slacConfig.slac_CreatureDialogueSignal.GetValue() == 20
		If (currentTime - slacConfig.CreatureDialogueLastStartTime) > slacConfig.pursuitMaxTimeNPC
			slacNotify.Show("PursuitEscape", Victim, Creature, Consensual = DialogueConsent, Group = False)
			slacConfig.debugSLAC && Log("Creature Dialogue pursuer " + slacUtility.GetActorNameRef(Creature) + " could not reach victim " + slacUtility.GetActorNameRef(Victim) + " at distance " + slacConfig.PrecisionFloatString(Creature.GetDistance(Victim)) + " units / " + slacConfig.PrecisionFloatString(Creature.GetDistance(Victim) * FOOTUNITRATIO) + " ft after " + slacConfig.PrecisionFloatString(currentTime - slacConfig.CreatureDialogueLastStartTime) + " seconds")
		Else
			slacNotify.Show("PursuitScare", Victim, Creature, Consensual = DialogueConsent, Group = False)
		EndIf
		slacUtility.EndPursuitQuest(slacConfig.slac_CreatureDialogue,True)
		slacUtility.UpdateLastEngageTime()
	
	ElseIf !PlayerRef.IsInFaction(slacConfig.slac_InvitingFaction) && slacConfig.slac_CreatureDialogueSignal.GetValue() == 10 && ((slacConfig.lastCombatState > 0 && !slacConfig.allowCombatEngagements) || (currentTime - slacConfig.CreatureDialogueLastStartTime) > slacConfig.pursuitMaxTimePC || (slacConfig.weaponsPreventAutoEngagement && PlayerRef.IsWeaponDrawn()))
		; Cancel commanded creature follow package unless the player is in the act of inviting.
		; A little awkward. Might need a rethink.
		slacConfig.slac_CreatureDialogueSignal.SetValue(0)
		Actor Creature = slacUtility.CreatureDialogueCreatureRef.GetActorReference()
		slacNotify.Show("PursuitFail", PlayerRef, Creature, Consensual = True, Group = False)
	
	EndIf

	If slacConfig.modActive
		Quest slacScan = slacUtility.slac_Scan
		Float lasttime = slac_LastEngageTime.GetValue()
		Actor playerHorse = Game.GetPlayersLastRiddenHorse()
		struggleInProgress = False
		
		; Update random value for quest comment selection
		slacUtility.SetRandomValue()
		
		; Update player horse dialogue alias
		If playerHorse
			slacUtility.FollowerPlayerHorseRef.ForceRefTo(playerHorse as ObjectReference)

		EndIf
		
		; Check for player horse bucking
		If (slacConfig.lastCombatState < 1 || slacConfig.allowCombatEngagements) && slacConfig.horseRefusalPCRiding && playerHorse
			If PlayerRef.IsOnMount() && slacUtility.GetActorArousal(playerHorse) >= slacConfig.horseRefusalPCThreshold
				If slacConfig.horseRefusalPCSex == 2 || slacUtility.GetSex(playerHorse) == slacConfig.horseRefusalPCSex
					; Throw player
					slacUtility.BuckPlayer()
				EndIf
			EndIf
		EndIf

		; Run scan
		Int foundCreatures = 0
		If slacConfig.lastCombatState < 1 || slacConfig.allowCombatEngagements
			foundCreatures = slacUtility.ScanCreatures()
	
		Else
			Log("Player in combat. Skipping scan application")
			
		EndIf
		
		; Ignore low delay in checks to prevent churning where auto-engagement is blocked.
		; This is reset if a check is run, regardless of result.
		Float SafeDelay = slacConfig.checkFrequency
		If SafeDelay < 20.0
			SafeDelay = 20.0
		EndIf
		
		; Check for auto-engagement
		If slacConfig.inMaintenance
			Log("Maintenance still running. Skipping auto engagement scan")
	
		ElseIf !slacUtility.SexLab || !slacUtility.SexLab.Enabled
			Log("SexLab not running. Skipping auto engagement scan")
		
		ElseIf !slacConfig.allowCombatEngagements && slacConfig.lastCombatState > 0
			Log("player in combat state. Skipping auto engagement scan")
			
		;ElseIf slacConfig.nextEngageTime > 0 && currentTime - lasttime < slacConfig.nextEngageTime
		;	Log("General Cooldown. Skipping auto engagement scan")
		
		ElseIf slacConfig.cooldownNPCType == 0 && (currentTime - slacConfig.slacData.GetSessionFloat(none,"LastEngageTime",0.0 - slacConfig.cooldownNPC) < slacConfig.cooldownNPC)
			Log("Global Cooldown. Skipping auto engagement scan")

		ElseIf !slacConfig.allowCombatEngagements && slacConfig.combatStateChangeCooldown > 0 && currentTime - slacConfig.lastCombatStateChange < slacConfig.combatStateChangeCooldown
			Log("Combat Cooldown. Skipping auto engagement scan")
			
		ElseIf slacUtility.MenuOpen("Dialogue Menu")
			Log("Player in dialogue menu. Skipping auto engagement scan")
		
		ElseIf slacConfig.weaponsPreventAutoEngagement && PlayerRef.IsWeaponDrawn()
			Log("Player's weapons drawn. Skipping auto engagement scan")
		
		ElseIf !slacUtility.LocationTest()
			slacConfig.debugSLAC && Log("Current location (" + slacConfig.LocationString() + ") not permitted. Skipping auto engagement scan")
		
		ElseIf slacUtility.SexLab.ActiveAnimations > slacConfig.SLAnimationMax
			Log("Too many SexLab animations playing (" + slacUtility.SexLab.ActiveAnimations + "/15, limit " + slacConfig.SLAnimationMax + "). Skipping auto engagement scan")
		
		ElseIf slacConfig.DHLPBlockAuto && slacConfig.DHLPIsSuspended
			Log("DHLP Suspension. Skipping auto engagement scan.")

		ElseIf foundCreatures > 0
			; Automated engagement check can go ahead
			Log("Auto engagement check is starting")
			slacUtility.ProcessCreatureQuestAliases()
			SafeDelay = slacConfig.checkFrequency
			
		Else
			Log("Auto engagement check skipped. Scan found no creatures.")
			
		EndIf
		
		; Register next tick
		Log("Next update in " + SafeDelay + " seconds")
		RegisterForSingleUpdate(SafeDelay)
	
	Else
		Log("Inactive Update")
		slacUtility.playerEngaged = false
		slacUtility.slac_Scan.Stop()
		slac_LastEngageTime.SetValue(0.0)
		PlayerRef.RemoveFromfaction(slac_engagedActor)
		UnregisterForUpdate()
	
	EndIf
EndEvent


; Refresh the registered key presses to listen for
Function UpdateKeyRegistery(bool notify = true)
	UnregisterForAllKeys()
	
	RegisterForKey(slacConfig.targetKey)
	RegisterForKey(slacConfig.inviteTargetKey)
	RegisterForKey(slacConfig.AutoToggleKey)
	
	ActivateKey = Input.GetMappedKey("Activate")
	RegisterForKey(ActivateKey)
	
	If slacConfig.targetKey != lastTargetKey
		Log("Target key set to " + slacConfig.targetKey,notify)
	EndIf
	lastTargetKey = slacConfig.targetKey
	
	If slacConfig.inviteTargetKey != lastInviteTargetKey
		Log("Invite key set to " + slacConfig.inviteTargetKey,notify)
	EndIf
	lastInviteTargetKey = slacConfig.inviteTargetKey
EndFunction
Function RegisterStruggleKeys(Bool Regsiter = True)
	If Regsiter
		RegisterForKey(slacConfig.struggleKeyOne)
		RegisterForKey(slacConfig.struggleKeyTwo)
		Return
	Endif
	UnregisterForKey(slacConfig.struggleKeyOne)
	UnregisterForKey(slacConfig.struggleKeyTwo)
EndFunction

; Respond to key press
Event OnKeyDown(Int keyCode)
	; crosshairref is asynchronous so we need to capture its current state to prevent it changing after conditions
	Actor tempCHRef = crosshairref
	
	If slacConfig.modActive && !slacUtility.MenuOpen("ForceAll") ;!Utility.IsInMenuMode() && !UI.IsTextInputEnabled()
		;Log("keyCode " + keyCode)
		
		; Workaround for SKSE bug that prevents OnCrosshairRefChange() receiving None on looking away from a target (fixed in 2.0.17)
		; This should also work for VR - not tested
		Actor currentCHRef = Game.GetCurrentCrosshairRef() as Actor
		If currentCHRef != tempCHRef
			crosshairref = currentCHRef
			tempCHRef = crosshairref
		EndIf
		
		; DXScanCodes
		Bool LCtrlHeld = Input.IsKeyPressed(29) ; 29 LCtrl
		Bool LShiftHeld = Input.IsKeyPressed(42) ; 42 LShift
		Bool LAltHeld = Input.IsKeyPressed(56) ; 56 LAlt
		
		If keyCode == slacConfig.targetKey
			If slacConfig.debugSLAC && LCtrlHeld && LShiftHeld && LAltHeld ; LCtrl+LAlt+LShift
				; Debug only

			ElseIf LCtrlHeld && !LShiftHeld ; LCtrl !LShift
				; Test Player
				slacUtility.UpdateTargetActor(PlayerRef)
				
			ElseIf !tempCHRef && LShiftHeld && LCtrlHeld
				; Quick Clean PC with LShift+LCtrl while not looking at other actor
				Log("SLAC cleaning PC", forceNote = True)
				slacUtility.CleanActor(PlayerRef, fullClean = True)
				Log("SLAC PC cleaning complete", forceNote = True)
				
			ElseIf tempCHRef && tempCHRef as Actor
				; Quick Clean with LShift+LCtrl
				If LShiftHeld && LCtrlHeld
					Log("SLAC cleaning actor " + slacUtility.GetActorNameRef(tempCHRef), forceNote = True)
					slacUtility.CleanActor(tempCHRef, fullClean = True)
					Log("SLAC cleaning complete for actor " + slacUtility.GetActorNameRef(tempCHRef), forceNote = True)
				EndIf
				; Collect actor from crosshair
				slacUtility.UpdateTargetActor(tempCHRef)

				;UpdateLastSelectedActor(tempCHRef)
			Else
				; No actor under crosshair

				; Clear target
				slacUtility.UpdateTargetActor()
				If LShiftHeld && LCtrlHeld
					; Quick Clean Player with LSHift+LCtrl
					slacUtility.CleanActor(PlayerRef, fullClean = True)
					
				Else
					; Collect actor using spell projectile
					slac_TargetSpell.Cast(PlayerRef)
					Log("Using target spell...")
					
				EndIf
			EndIf

		ElseIf keyCode == slacConfig.AutoToggleKey
			slacConfig.AutoToggleSwitch()

		ElseIf slacConfig.struggleEnabled && keyCode == slacConfig.struggleKeyOne || keyCode == slacConfig.struggleKeyTwo
			If slacUtility.PlayerEngaged && slacUtility.playerCanStruggle
				; Player struggling
				If struggleInProgress
					; Skip input as last input is still being processed
					lastStruggleKeyOne = keyCode
					lastStruggleInputTime = Utility.GetCurrentRealTime()
				Else
					; New input
					StruggleProcess(keyCode)
				EndIf
			EndIf
			
		ElseIf keyCode == ActivateKey && LShiftHeld && tempCHRef as Actor && tempCHRef.HasKeyword(slacUtility.ActorTypeHorse) && slacConfig.creatureDialogueAllowHorses
			; Bypass horse dialogue and activate normally
			tempCHRef.Activate(PlayerRef, True)
			slacConfig.debugSLAC && Log("Activation: Bypassing horse dialogue for " + slacUtility.GetActorNameRef(tempCHRef) + " and activating normally")

		ElseIf keyCode == ActivateKey
			; PC used object Activation key (E by default)
			slacConfig.debugSLAC && tempCHRef && Log("Activtion: Activating " + slacUtility.GetActorNameRef(tempCHRef) + ", horse:" + slacConfig.creatureDialogueAllowHorses + ", silent:" + slacConfig.creatureDialogueAllowSilent)
			If tempCHRef as Actor && (slacConfig.creatureDialogueAllowHorses || slacConfig.creatureDialogueAllowSilent)
				Race tempCHRefRace = tempCHRef.GetRace()
				If !PlayerRef.IsOnMount() && \
					!tempCHRef.IsBeingRidden() && \
					!slacUtility.playerEngaged && \
					!tempCHRef.IsInFaction(slacConfig.slac_PursuitFaction) && \
					((slacConfig.creatureDialogueAllowHorses && \
					tempCHRef.HasKeyword(slacUtility.ActorTypeHorse)) || \
					((slacConfig.creatureDialogueAllowSilent && \
					!tempCHRef.HasKeyword(slacUtility.ActorTypeNPC)) && \
					!tempCHRefRace.AllowPCDialogue())) && \
					(tempCHRef.IsPlayerTeammate() || slacConfig.allCreatureDialogueEnabled)
				
					; PC is activating a silent creature
					If tempCHRef.HasKeyword(slacUtility.ActorTypeHorse) || slacUtility.SexLab.AllowedCreature(tempCHRefRace)
						
						If slacConfig.creatureDialogueSex == 1 && slacUtility.GetSex(tempCHRef) == 0
							slacConfig.debugSLAC && Log("Activation: Forced greet cancelled for " + slacUtility.GetActorNameRef(tempCHRef) + " by female creature dialogue sex restriction")
							
						ElseIf slacConfig.creatureDialogueSex == 0 && slacUtility.GetSex(tempCHRef) == 1
							slacConfig.debugSLAC && Log("Activation: Forced greet cancelled for " + slacUtility.GetActorNameRef(tempCHRef) + " by male creature dialogue sex restriction")
						
						ElseIf slacConfig.ConvenientHorsesLoaded && slacConfig.convenientHorses && Game.GetPlayersLastRiddenHorse() == tempCHRef
							slacConfig.debugSLAC && Log("Activation: Forced greet cancelled for " + slacUtility.GetActorNameRef(tempCHRef) + " handled by Convenient Horses")
						
						ElseIf slacConfig.ImmersiveHorsesLoaded && slacConfig.convenientHorses && (Game.GetPlayersLastRiddenHorse() == tempCHRef || tempCHRef.IsInFaction(slacConfig.PlayerHorseFaction))
							slacConfig.debugSLAC && Log("Activation: Forced greet cancelled for " + slacUtility.GetActorNameRef(tempCHRef) + " handled by Immersive Horses")
						
						ElseIf tempCHRef.HasKeyword(slacUtility.ActorTypeFamiliar)
							slacConfig.debugSLAC && Log("Activation: Forced greet cancelled for " + slacUtility.GetActorNameRef(tempCHRef) + " familiar unable to use package")
						
						ElseIf tempCHRef.IsDead()
							slacConfig.debugSLAC && Log("Activation: Forced greet cancelled for " + slacUtility.GetActorNameRef(tempCHRef) + " creature is dead")
							; Allow searching corpses of previously blocked creatures
							slacUtility.EnableActorActivation(tempCHRef)

						ElseIf !tempCHRef.HasKeyword(slacUtility.ActorTypeHorse) || slacConfig.creatureDialogueAllowHorses
							slacConfig.debugSLAC && Log("Activation: Using forced greet alias for " + slacUtility.GetActorNameRef(tempCHRef))
							slacUtility.CreatureDialogueForcedRef.ForceRefTo(tempCHRef as ObjectReference)
							tempCHRef.Evaluatepackage()
						
						Else
							slacConfig.debugSLAC && Log("Activation: Creature not allowed to speak " + slacUtility.GetActorNameRef(tempCHRef))
						
						EndIf
					
					ElseIf slacConfig.debugSLAC
						Log("Activation: " + slacUtility.GetActorNameRef(tempCHRef) + " creature (race:" + tempCHRefRace + ") not allowed by SexLab")
					
					EndIf
				
				ElseIf PlayerRef.IsOnMount()
					Actor playerHorse = Game.GetPlayersLastRiddenHorse()
					If playerHorse && playerHorse.HasKeyword(slacUtility.ActorTypeHorse) ; Ensure PC is not riding a dragon
						Log("Dismounting dialogue enabled horse")
						PlayerRef.Dismount()
					
					EndIf
					
				ElseIf False && slacConfig.debugSLAC
					; Keeping this for debugging horse activation issues
					Log("Activation: dumping activation failure for " + slacUtility.GetActorNameRef(tempCHRef))
					Log("Activation: !PlayerRef.IsOnMount() " + !PlayerRef.IsOnMount())
					Log("Activation: !tempCHRef.IsBeingRidden() " + !tempCHRef.IsBeingRidden())
					Log("Activation: !slacUtility.playerEngaged " + !slacUtility.playerEngaged)
					Log("Activation: !tempCHRef.IsInFaction(slacConfig.slac_PursuitFaction) " + !tempCHRef.IsInFaction(slacConfig.slac_PursuitFaction))
					Log("Activation: slacConfig.creatureDialogueAllowHorses " + slacConfig.creatureDialogueAllowHorses)
					Log("Activation: tempCHRef.HasKeyword(slacUtility.ActorTypeHorse) " + tempCHRef.HasKeyword(slacUtility.ActorTypeHorse))
					Log("Activation: slacConfig.creatureDialogueAllowSilent " + slacConfig.creatureDialogueAllowSilent)
					Log("Activation: !tempCHRef.HasKeyword(slacUtility.ActorTypeNPC)) " + !tempCHRef.HasKeyword(slacUtility.ActorTypeNPC))
					Log("Activation: !tempCHRefRace.AllowPCDialogue() " + !tempCHRefRace.AllowPCDialogue())
					Log("Activation: tempCHRef.IsPlayerTeammate() " + tempCHRef.IsPlayerTeammate())
					Log("Activation: slacConfig.allCreatureDialogueEnabled " + slacConfig.allCreatureDialogueEnabled)
				EndIf
			Else
				slacConfig.debugSLAC && tempCHRef && Log("Activation: rejected for " + slacUtility.GetActorNameRef(tempCHRef))
			EndIf
		EndIf
	EndIf
EndEvent


; Respond to key release
Event OnKeyUp(Int keyCode, Float holdTime)
	Actor tempCHRef = crosshairref
	
	; VR compatibility where using the wands prevents OnCrosshairRef events
	If slacConfig.useVRCompatibility && (!tempCHRef || tempCHRef == None)
		tempCHRef = Game.GetCurrentCrosshairRef() as Actor
	EndIf
	
	If slacConfig.modActive && tempCHRef && tempCHRef as Actor && !slacUtility.MenuOpen("ForceAll")
		If keyCode == slacConfig.inviteTargetKey
			String targetName = tempCHRef.GetLeveledActorBase().GetName()
			String targetRaceKey = slacUtility.GetCreatureRaceKeyString(tempCHRef)
			
			If Input.IsKeyPressed(42) && Input.IsKeyPressed(29) ; Shift+Ctrl held
				; Debug only
				
			ElseIf slacUtility.SexLab.IsActorActive(PlayerRef)
				Log("Player engaged, skipping new invite")
				slacConfig.UpdateFailedNPCs(PlayerRef,"_engaged")
				
			ElseIf InviteInProgress
				Log("Invite in progress, skipping new invite")
				slacConfig.UpdateFailedNPCs(PlayerRef,"_engaged")
				
			ElseIf !InviteInProgress && !tempCHRef.HasKeyword(slacUtility.ActorTypeNPC) && !PlayerRef.IsOnMount() && !tempCHRef.IsBeingRidden() && !slacUtility.SexLab.IsActorActive(PlayerRef)
				InviteInProgress = True
				
				; Indicate inviting status to block other engagements via TestCreature/TestVictim
				PlayerRef.AddToFaction(slacConfig.slac_InvitingFaction)
				tempCHRef.AddToFaction(slacConfig.slac_InvitedFaction)
				
				If slacConfig.inviteCreatureSex != 2 && slacUtility.GetSex(tempCHRef) != slacConfig.inviteCreatureSex
					; Wrong creature sex: male
					slacNotify.Show("SexReject", PlayerRef, tempCHRef, Consensual = True, Group = False)
					slacConfig.UpdateFailedCreatures(tempCHRef,"_invitesex")
				
				ElseIf (slacConfig.inviteOpensHorseDialogue && tempCHRef.HasKeyword(slacUtility.ActorTypeHorse)) || slacConfig.inviteOpensCreatureDialogue
					; Invite opens dialogue
					slacConfig.debugSLAC && Log("Using invite forced greet alias for " + slacUtility.GetActorNameRef(tempCHRef))
					slacUtility.CreatureDialogueForcedRef.ForceRefTo(tempCHRef as ObjectReference)
					tempCHRef.EvaluatePackage()
						
				Else
					; Direct Invitation
					Log("Inviting " + targetName + " (hold time " + holdTime + ")")
					Bool success = False
					Int PCTreatAsSex = slacUtility.TreatAsSex(playerRef,tempCHRef)
					Int CreatureSex = slacUtility.GetSex(tempCHRef)
					Bool isHeteroPair = (PCTreatAsSex == 0 && CreatureSex == 1) || (PCTreatAsSex == 1 && CreatureSex == 0)
					
					If slacUtility.GetActorArousal(tempCHRef) >= slacConfig.inviteArousalMin
						
						; Invite animation
						slacUtility.StopPlayer()
						slacUtility.StripActor(PlayerRef, False)
						If slacConfig.inviteAnimationPC > 0
							slacUtility.PlayInviteAnimation(PlayerRef,tempCHRef)
							Utility.Wait(2.0)
						EndIf
						
						; Note that the AND condition here means that TestVictim does not need to be executed if TestCreature fails.
						Bool TestPassed = slacUtility.TestCreature(tempCHRef, invited = True) && slacUtility.TestVictim(PlayerRef,tempCHRef, inviting = True)
						
						If holdTime > 1.5
							; Use group if available
						
							; Find additional creatures
							Actor[] otherCreatures = PapyrusUtil.ActorArray(3)
							otherCreatures = slacUtility.FindExtraCreatures(tempCHRef, PlayerRef, MaxExtras = 3, ArousalMin = slacConfig.inviteArousalMin, Invitation = True)
							Int oci = 0
							Int otherCreaturesCount = 0
							While testPassed && oci < otherCreatures.length
								If otherCreatures[oci]
									; Add creatures to aliases with follow packages so they move toward the player while SL spins up
									If otherCreaturesCount == 0
										slacUtility.CreatureDialogueCreatureRef2.ForceRefTo(otherCreatures[oci] as ObjectReference)
									
									ElseIf otherCreaturesCount == 1
										slacUtility.CreatureDialogueCreatureRef3.ForceRefTo(otherCreatures[oci] as ObjectReference)
									
									ElseIf otherCreaturesCount == 2
										slacUtility.CreatureDialogueCreatureRef4.ForceRefTo(otherCreatures[oci] as ObjectReference)
									
									EndIf
									otherCreaturesCount += 1
								EndIf
								oci += 1
							EndWhile
							slacConfig.slac_CreatureDialogueSignal.SetValue(10)
							
							If testPassed && slacUtility.StartCreatureSex(PlayerRef, tempCHRef, nonConsensual = False, otherAttacker2 = otherCreatures[0], otherAttacker3 = otherCreatures[1], otherAttacker4 = otherCreatures[2])
								slacNotify.Show("SexStart", PlayerRef, tempCHRef, Consensual = True, Group = otherCreaturesCount > 0)
								success = True
							Else
								slacNotify.Show("SexStartFail", PlayerRef, tempCHRef, Consensual = True, Group = otherCreaturesCount > 0)
							EndIf
							
							slacUtility.CreatureDialogueCreatureRef2.Clear()
							slacUtility.CreatureDialogueCreatureRef3.Clear()
							slacUtility.CreatureDialogueCreatureRef4.Clear()
							slacConfig.slac_CreatureDialogueSignal.SetValue(0)

						ElseIf holdTime > 0.5
							; Use oral if available
							
							String RejTags = "";
							If PCTreatAsSex == 1 && CreatureSex == 0
								RejTags = "Cunnilingus" ; Female PC performs on male creature
							
							ElseIf CreatureSex == 1
								RejTags = "BlowJob" ; Male or female PC performs on female creature
							
							EndIf
							
							If testPassed \
							&& (slacUtility.StartCreatureSex(PlayerRef, tempCHRef, False, requireTags = "Oral", rejectTags = RejTags) \
							|| (RejTags != "" && slacUtility.StartCreatureSex(PlayerRef, tempCHRef, False, requireTags = "Oral")))
								; Success: Start sex with reject tags
								slacNotify.Show("SexStart", PlayerRef, tempCHRef, Consensual = True, Group = False)
								success = True

							Else
								; Failure
								slacNotify.Show("SexStartFail", PlayerRef, tempCHRef, Consensual = True, Group = False)
							
							EndIf
							
						Else ; Tap 
							; Use non-oral
							
							If testPassed && slacUtility.StartCreatureSex(PlayerRef, tempCHRef, False, rejectTags = "Oral")
								; Success
								success = True
								slacNotify.Show("SexStart", PlayerRef, tempCHRef, Consensual = True, Group = False)
							
							Else
								; Failure
								slacNotify.Show("SexStartFail", PlayerRef, tempCHRef, Consensual = True, Group = False)

							EndIf
						EndIf
						
						If !success
							Utility.Wait(1.0)
							slacUtility.StopInviteAnimation(PlayerRef,tempCHRef)
							slacUtility.UnstripActor(PlayerRef, False)
							slacUtility.StartPlayer()
						EndIf
					Else
						; Creature not aroused
						slacConfig.UpdateFailedCreatures(tempCHRef,"_arousal")
						slacNotify.Show("ArousalFail", PlayerRef, tempCHRef, Consensual = True, Group = False)

					EndIf
				EndIf
				
				; Reset inviting status
				PlayerRef.RemoveFromFaction(slacConfig.slac_InvitingFaction)
				tempCHRef.RemoveFromFaction(slacConfig.slac_InvitedFaction)
				
				InviteInProgress = False
			EndIf

		EndIf
	EndIf
EndEvent


; Monitor targeted objects
; This event is currently unregistered in slac_Utility before any SL animations (StartCreatureSex)
; and re-registered afterwards (EndCreatureSex).
Event OnCrosshairRefChange(ObjectReference ref)
	; Update reference
	Actor tempCHRef = None
	;Log("CHR: " + slacUtility.GetActorNameRef(ref as Actor),forceNote = True)
	If ref as Actor
		tempCHRef = ref as Actor
		crosshairref = tempCHRef
	EndIf

	; We're unblocking the previously blocked actor immediately in order to not need to maintain a form list for clean up
	lastBlockedActor && slacUtility.EnableActorActivation(lastBlockedActor)
	lastBlockedActor = None
	
	; If the last actor was in a force greet package then looking away from them means they must be cleared from the behaviour.
	; Would rather not do this much work on a passive action, but this is a really persistent issue.
	Actor CDRFTemp = slacUtility.CreatureDialogueForcedRef.GetActorRef()
	If CDRFTemp && !UI.IsMenuOpen("Dialogue Menu") && CDRFTemp != tempCHRef
		; Not in dialogue and not looking at the forced greet creature
		slacConfig.debugSLAC && Log("PlayerScript CH Ref Change: Clearing force greet creature ref " + slacUtility.GetActorNameRef(CDRFTemp))
		slacUtility.CreatureDialogueForcedRef.Clear()
		CDRFTemp.Evaluatepackage()
	EndIf
	
	If !tempCHRef || tempCHRef == None
		crosshairref = None
		Return
	EndIf

	; Make sure direct invite is not locked
	InviteInProgress = False
	
	If slacConfig.modActive && !slacUtility.playerEngaged && tempCHRef && tempCHRef != None && tempCHRef.HasKeyword(slacUtility.ActorTypeCreature)
		; Player is not in an SL animation and target is a creature
		If tempCHRef.HasKeyword(slacUtility.ActorTypeHorse)
			; Creature is a horse
			If PlayerRef.IsOnMount() || !slacConfig.creatureDialogueAllowHorses || tempCHRef.IsDead()
				; Player is riding or horse dialogue is not allowed or the horse is dead
				If slacConfig.convenientHorsesLoaded && slacConfig.convenientHorses && (Game.GetPlayersLastRiddenHorse() != tempCHRef && !tempCHRef.IsInFaction(slacConfig.PlayerHorseFaction))
					; Prevent player mounting when they should be talking to Convenient Horses dialogue stand-in
					; This is to preserve blocking behaviour from CH / IH
					If !tempCHRef.IsDead()
						; Block living horses
						slacUtility.DisableActorActivation(tempCHRef)
						lastBlockedActor = tempCHRef
						slacConfig.debugSLAC && Log("Blocking horse ref " + slacUtility.GetActorNameRef(tempCHRef))
					Else
						; Unblock dead horses
						slacUtility.EnableActorActivation(tempCHRef)
						slacConfig.debugSLAC && Log("Unblocking horse ref " + slacUtility.GetActorNameRef(tempCHRef))
					EndIf
				
				Else
					; Allow PC to dismount (probably does nothing - see OnKeyDown event for dismount override)
					; Also allow accessing dead horse inventory
					;slacUtility.EnableActorActivation(tempCHRef)
				
				EndIf
				
			ElseIf slacConfig.creatureDialogueAllowHorses
				; Prevent PC from mounting horse on normal activation to allow forced greet dialogue instead
				If !tempCHRef.IsDead()
					; Block living horses
					slacUtility.DisableActorActivation(tempCHRef)
					lastBlockedActor = tempCHRef
					slacConfig.debugSLAC && Log("Blocking horse ref " + slacUtility.GetActorNameRef(tempCHRef))
				Else
					; Unblock dead horses
					slacUtility.EnableActorActivation(tempCHRef)
					slacConfig.debugSLAC && Log("Unblocking horse ref " + slacUtility.GetActorNameRef(tempCHRef))
				EndIf
				
			EndIf
		EndIf
	EndIf
	
	; Unblock dead actors
	tempCHRef.HasKeyword(slacUtility.ActorTypeCreature) && tempCHRef.IsDead() && slacUtility.EnableActorActivation(tempCHRef)

	; Check for change in combat state - OnCombatStateChange() does not fire on the player so periodic checks are required for monitoring
	If slacConfig.lastCombatState != PlayerRef.GetCombatState()
		slacConfig.lastCombatState = PlayerRef.GetCombatState()
		slacConfig.LastCombatStateChange = Utility.GetCurrentRealTime()
	EndIf
EndEvent


; Process struggle input
Function StruggleProcess(Int keyCode)
	Bool skipPartners = False
	struggleInProgress = True
	Int safeLastStruggleKey = lastStruggleKeyOne
	Float safeLastStruggleInputTime = lastStruggleInputTime
	
	; Struggle key check
	Float damage = slacConfig.struggleStaminaDamage
	If safeLastStruggleKey == keyCode && slacConfig.struggleKeyOne && slacConfig.struggleKeyTwo
		; double damage for non-alternating keys
		damage += slacConfig.struggleStaminaDamage
		skipPartners = True
	EndIf
	lastStruggleKeyOne = keyCode
	
	; Struggle timing check
	Float currentTime = Utility.GetCurrentRealTime()
	Float currentDelay = currentTime - safeLastStruggleInputTime
	If currentDelay < slacConfig.struggleTimingOne || currentDelay > slacConfig.struggleTimingTwo
		; increase damage wrong speed
		damage += slacConfig.struggleStaminaDamage
		skipPartners = True
	EndIf
	lastStruggleInputTime = currentTime
	
	; apply damage and assess result
	PlayerRef.DamageActorValue("Stamina", damage)
	skipPartners || slacUtility.playerPrimaryPartner.DamageActorValue("Stamina", (slacConfig.struggleStaminaDamage * slacConfig.struggleStaminaDamageMultiplier) / slacUtility.playerPartnersCount)

	If PlayerRef.GetActorValue("Stamina") < 1
		; Player has no stamina
		If slacConfig.struggleFailureEnabled
			; Player can no longer struggle
			slacUtility.playerCanStruggle = False
			slacUtility.playerStruggleFinished = True
			slacNotify.Show("StruggleFail", PlayerRef, slacUtility.playerPrimaryPartner, Consensual = False, Group = slacUtility.playerPartnersCount > 1)
			slacUtility.WidgetManager.StopMeter()
			Log("StruggleProcess: player struggled failed (playerCanStruggle:" + slacUtility.playerCanStruggle + ",playerStruggleFinished:" + slacUtility.playerStruggleFinished + ")")
		EndIf
		If slacConfig.struggleExhaustionMode > 0
			; Player stamina recovery blocked
			PlayerRef.DamageActorValue("Stamina", 1000.0)
			slacUtility.slac_StaminaDrainLongSpell.Cast(PlayerRef)
		EndIf
	
	ElseIf slacUtility.playerEngaged && slacUtility.playerPrimaryPartner.GetActorValue("Stamina") < 1
		; Creatures lose with zero total stamina, animation ends
		slacUtility.EndCreatureSexPrematurely(PlayerRef)
		slacConfig.struggleQueueEscape && slacUtility.ClearQueue(PlayerRef)
		slacNotify.Show("StruggleSucceed", PlayerRef, slacUtility.playerPrimaryPartner, Consensual = False, Group = slacUtility.playerPartnersCount > 1)
	
	EndIf
	
	struggleInProgress = False
EndFunction


Event OnAnimationEvent (ObjectReference akSource, String asEventName)
	If !slacConfig.modActive
		; Should not be acting on animation events if the mod is disabled 
		Return
	EndIf
	
	Log("OnAnimationEvent: source " + akSource + ", event " + asEventName)
	
	If asEventName == "tailHorseMount" && akSource == playerRef
		; Cancel PC pursuit
		slacUtility.EndPursuitQuest(slacConfig.slac_Pursuit_00)

		; Clear PC creature queue
		slacUtility.ClearQueue(PlayerRef)

		; Clear suitors
		slacUtility.ClearSuitors()

		; Cancel following dialogue creature
		If slacConfig.slac_CreatureDialogueSignal.GetValue() == 10
			slacConfig.slac_CreatureDialogueSignal.SetValue(0)
		EndIf

		; Check for player horse bucking
		Actor PlayerHorse = Game.GetPlayersLastRiddenHorse()
		If slacConfig.horseRefusalPCMounting && playerHorse
			If PlayerRef.IsOnMount() && slacUtility.GetActorArousal(playerHorse) >= slacConfig.horseRefusalPCThreshold
				If slacConfig.horseRefusalPCSex == 2 || slacUtility.GetSex(playerHorse) == slacConfig.horseRefusalPCSex
					; Throw player
					Log("Bucking player while mounting")
					slacUtility.BuckPlayer()
				EndIf
			EndIf
		EndIf
		
	ElseIf asEventName == "tailHorseDismount" && akSource == playerRef && slacConfig.horseRefusalPCEngage
		; Start sex after refusal - this is treated as an auto engagement
		If slacUtility.slacData.GetSignalBool(PlayerRef, "HorseRefusalDismount")
			Actor PlayerHorse = Game.GetPlayersLastRiddenHorse()
			Utility.Wait(2.0) ; Wait for dismount animation to complete
			If slacUtility.GetActorArousal(PlayerHorse) >= slacConfig.pcCreatureArousalMin && slacUtility.TestCreature(playerHorse) && slacUtility.TestVictim(PlayerRef, playerHorse)
				; Use auto consent setting
				Bool NonConsensual = True
				If slacConfig.pcConsensualIndex == 0
					NonConsensual = False
				ElseIf slacConfig.pcConsensualIndex == 2 && slacUtility.GetActorArousal(PlayerRef) >= slacConfig.pcArousalMin
					NonConsensual = False
				EndIf
				
				; Start sex
				If slacUtility.StartCreatureSex(PlayerRef, PlayerHorse, nonConsensual)
					; Success
					slacNotify.Show("SexStart", PlayerRef, PlayerHorse, Consensual = !nonConsensual, Group = False)
				EndIf
			ElseIf slacConfig.debugSLAC
				Log("OnAnimationEvent: bucked player sex failure - Horse:" + slacUtility.GetActorNameRef(PlayerHorse) + " Horse Arousal:" + slacUtility.GetActorArousal(PlayerHorse) + " (required:" + slacConfig.pcCreatureArousalMin + ") CheckCreature:" + slacUtility.CheckCreature(playerHorse) + " CheckVictim:" + slacUtility.CheckVictim(PlayerRef, playerHorse))
			EndIf
		EndIf
		slacUtility.slacData.ClearSignal(PlayerRef, "HorseRefusalDismount")
		
	ElseIf asEventName == "weaponDraw" && akSource == playerRef
		; Check for change in combat state
		Float currentTime = Utility.GetCurrentRealTime()
		Bool combatStateChanged = False
		If slacConfig.lastCombatState != PlayerRef.GetCombatState()
			slacConfig.debugSLAC && Log("Updating combat cooldown (anim): last state " + slacConfig.lastCombatState + ", new state " + PlayerRef.GetCombatState() + ", time " + currentTime)
			slacConfig.lastCombatState = PlayerRef.GetCombatState()
			slacConfig.lastCombatStateChange = currentTime
			combatStateChanged = True
		EndIf
				
		; Scare off PC pursuers
		If ((slacConfig.lastCombatState > 0 && !slacConfig.allowCombatEngagements) || ((slacConfig.weaponsPreventAutoEngagement || !slacConfig.pcAllowWeapons) && PlayerRef.IsWeaponDrawn())) && slacConfig.slac_Pursuit_00.IsRunning()
			Bool PursuitConsensual = slacConfig.slac_Pursuit00Type.GetValue() as Int == 20
			Bool PursuitGroup = slacUtility.PlayerAttacker2.GetActorReference() != None || slacUtility.PlayerAttacker3.GetActorReference() != None || slacUtility.PlayerAttacker4.GetActorReference() != None
			Actor Creature = slacUtility.PlayerAttacker.GetActorReference()
			slacNotify.Show("PursuitScare", PlayerRef, Creature, Consensual = PursuitConsensual, Group = PursuitGroup)
			slacUtility.EndPursuitQuest(slacConfig.slac_Pursuit_00)
			slacUtility.UpdateLastEngageTime()
		EndIf
		
		; Scare off NPC pursuers
		If ((slacConfig.lastCombatState > 0 && !slacConfig.allowCombatEngagements) || (slacConfig.weaponsPreventAutoEngagement && PlayerRef.IsWeaponDrawn())) && slacConfig.slac_Pursuit_01.IsRunning() 
			Bool PursuitConsensual = slacConfig.slac_Pursuit01Type.GetValue() as Int == 20
			Bool PursuitGroup = slacUtility.NPCAttacker2.GetActorReference() != None || slacUtility.NPCAttacker3.GetActorReference() != None || slacUtility.NPCAttacker4.GetActorReference() != None
			Actor Victim = slacUtility.NPCVictim.GetActorReference()
			Actor Creature = slacUtility.NPCAttacker.GetActorReference()
			slacNotify.Show("PursuitScare", Victim, Creature, Consensual = PursuitConsensual, Group = PursuitGroup)
			slacUtility.EndPursuitQuest(slacConfig.slac_Pursuit_01)
			slacUtility.UpdateLastEngageTime()

		EndIf
		
		; Scare off suitors
		If !slacConfig.suitorsPCAllowWeapons && slacConfig.suitorsMaxPC > 0 && (PlayerRef.IsWeaponDrawn() || slacConfig.lastCombatState > 0) && slacUtility.ClearSuitors()
			Bool SuitorGroup = slacUtility.CountSuitors() > 1
			slacNotify.Show("SuitorReject", PlayerRef, Creature = None, Consensual = True, Group = SuitorGroup)

		EndIf
		
		; Scare off queueing creatures
		; Behaviour not implemented yet
		
		Log("Anim Event WeaponDraw completed: source " + akSource)
	
	EndIf
EndEvent


; Collected actors for slac_Notify testing
Function UpdateLastSelectedActor(Actor target = None)
	If Input.IsKeyPressed(56) ; LAlt
		LastSelectedNPC = PlayerRef
	ElseIf target && target.HasKeyword(slacUtility.ActorTypeNPC)
		LastSelectedNPC = target
	ElseIf target
		LastSelectedCreature = target
	EndIf
EndFunction


; Logging
Function Log(String logMessage, bool forceTrace = False, bool forceNote = False, bool forceConsole = False)
	slacUtility.Log(logMessage, forceTrace, forceNote, forceConsole)
EndFunction
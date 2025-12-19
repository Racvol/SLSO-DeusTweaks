Scriptname slac_Utility extends Quest  
{Utility Script for SexLab Aroused Creatures containing most of the logic}

; SLAC
	slac_Config Property slacConfig Auto
	slac_Data Property slacData Auto
	slac_Animation Property slacAnimation Auto
	slac_WidgetManager Property WidgetManager Auto
	slac_Notify Property slacNotify Auto
	Quest Property slac_Monitor Auto
	Keyword Property slac_ActorMonitored Auto
	Quest Property slac_Claimed Auto
	Keyword Property slac_ClaimedActor Auto
	Scene Property slac_ClaimedScene Auto
	GlobalVariable Property slac_LastEngageTime Auto
	GlobalVariable Property slac_RandomValue Auto
	Spell Property slac_ScanCloakCreatureSpell Auto
	Spell Property slac_ScanCloakNPCSpell Auto
	Spell Property slac_ScanProcessCreatureDebugSpell Auto
	Faction Property slac_engagedActor Auto
	Faction Property slac_victimActor Auto
	Bool Property playerEngaged Auto
	Bool playerConsent = False
	Actor[] playerPartners
	Actor Property playerPrimaryPartner Auto
	Int Property playerPartnersCount = 0 Auto
	Bool Property playerCanStruggle = True Auto
	Bool Property playerStruggleStarted = False Auto
	Bool Property playerStruggleFinished = False Auto
	Int Property currentLoad Auto
	Actor[] questCreatures
	Idle Property IdleInvitationF01 Auto
	Bool BuckingInProgressPC = False
	Float BuckingDelayTimePC = 0.0

; Player Pursuit Quest
	Quest Property slac_Scan auto
	Quest Property slac_Pursuit_00 auto
	Quest Property slac_Pursuit_01 auto
	ReferenceAlias Property PlayerAttacker auto
	ReferenceAlias Property PlayerAttacker2 auto
	ReferenceAlias Property PlayerAttacker3 auto
	ReferenceAlias Property PlayerAttacker4 auto
	ReferenceAlias Property NPCVictim auto
	ReferenceAlias Property NPCAttacker auto
	ReferenceAlias Property NPCAttacker2 auto
	ReferenceAlias Property NPCAttacker3 auto
	ReferenceAlias Property NPCAttacker4 auto
	Bool Property Pursuit00Active = false auto
	Bool Property Pursuit01Active = false auto

; NPC Scan
	Quest Property slac_ScanNPC auto
	GlobalVariable Property slac_ScanNPCFindGender Auto
	Float Property LastScanProcessTime = 0.0 Auto

; Dialogue and Quests
; Follower
	Quest Property slac_FollowerDialogue auto
	ReferenceAlias Property FollowerDialogueFollowerRef auto
	ReferenceAlias Property FollowerDialogueCreatureRef auto
	ReferenceAlias Property FollowerDialogueTargetRef auto
	ReferenceAlias Property FollowerPlayerHorseRef auto

; Creature
	ReferenceAlias Property CreatureDialogueCreatureRef auto
	ReferenceAlias Property CreatureDialogueVictimRef auto
	ReferenceAlias Property CreatureDialogueTargetRef auto
	ReferenceAlias Property CreatureDialogueForcedRef auto
	ReferenceAlias Property CreatureDialogueCreatureRef1 auto
	ReferenceAlias Property CreatureDialogueCreatureRef2 auto
	ReferenceAlias Property CreatureDialogueCreatureRef3 auto
	ReferenceAlias Property CreatureDialogueCreatureRef4 auto

; Struggle
	Spell property slac_StaminaDrainSpell Auto
	MagicEffect property slac_StaminaDrainEffect Auto
	Spell property slac_StaminaDrainLongSpell Auto


; SexLab/Aroused
	Faction Property slaArousal Auto
	Faction Property slaNaked Auto
	Faction Property SexLabAnimatingFaction Auto
	SexLabFramework Property SexLab auto
	sslCreatureAnimationSlots Property SexLabCreatures Auto

; Vanilla
	Actor Property PlayerRef Auto
	Keyword Property KeywordClothingBody Auto
	Keyword Property KeywordArmorCuirass Auto
	Keyword Property ActorTypeCreature Auto
	Keyword Property ActorTypeFamiliar Auto
	Keyword Property ActorTypeHorse Auto
	Keyword Property ActorTypeNPC Auto
	Faction Property CreatureFaction Auto
	Race Property ElderRace Auto
	Idle Property StaggerStart Auto
	Idle Property HorseIdleRearUp Auto

; Internal
	Float UNITFOOTRATIO = 21.3333 ; Approximate CK Unit to Foot ratio
	Float FOOTUNITRATIO = 0.0468 ; Approximate Foot to CK Unit ratio

; Not Used
	Faction Property slac_arousedActor Auto
	ReferenceAlias Property slac_ScanNPCFoundActor Auto
	ReferenceAlias Property slac_ScanNPCFoundActor01 Auto
	ReferenceAlias Property slac_ScanNPCFoundActor02 Auto
	ReferenceAlias Property slac_ScanNPCFoundActor03 Auto
	ReferenceAlias Property slac_ScanNPCFoundActor04 Auto
	ReferenceAlias Property slac_ScanNPCCenterRef Auto
	ReferenceAlias Property slac_ScanNPCIgnoredActor01 Auto
	ReferenceAlias Property slac_ScanNPCIgnoredActor02 Auto
	ReferenceAlias Property slac_ScanNPCIgnoredActor03 Auto
	ReferenceAlias Property slac_ScanNPCIgnoredActor04 Auto
	Spell property slac_ActiveCreatureSpell Auto
	Spell property slac_ActiveActorSpell Auto
	MagicEffect property slac_ActiveCreatureEffect Auto
	MagicEffect property slac_ActiveActorEffect Auto
	Spell Property slac_IgnoreSpell Auto


Int Function GetVersion()
	Return 40037
EndFunction


Function Log(String logMessage, bool forceTrace = False, bool forceNote = False, bool forceConsole = False)
	(slacConfig.debugSLAC || forceTrace) && Debug.Trace("[slac] " + logMessage)
	forceNote && Debug.Notification(logMessage)
	(slacConfig.debugSLAC || forceConsole) && MiscUtil.PrintConsole("[slac] " + logMessage)
EndFunction


Event OnInit()
	slac_LastEngageTime.SetValue(0.0)
	slac_ScanCloakCreatureSpell.SetNthEffectMagnitude(0, slacConfig.cloakRadius as Float)
	slac_ScanCloakCreatureSpell.SetNthEffectMagnitude(1, slacConfig.cloakRadius as Float)
	currentLoad = 0;
	Log("Utility Initialised")
EndEvent


Event StartDefaultTags()
	Log("Setting creature animation tags...", forceTrace = True, forceConsole = True)
	slacConfig.SetDefaultTags()
	Log("Setting creature animation tags done!", forceTrace = True, forceConsole = True)
	Log("Checking for new creature races...", forceTrace = True, forceConsole = True)
	slacConfig.UpdateRaceKeys()
	Log("Checking for new creature races done!", forceTrace = True, forceConsole = True)
EndEvent


Function Maintenance()
	Log("Maintenance: Starting...", forceTrace = True, forceConsole = True)
	slacConfig.inMaintenance = True
	Float currentTime = Utility.GetCurrentRealTime()

	; Turn off debugging from last session to prevent unintended log spam
	;slacConfig.debugSLAC = False
	
	; Reset for previous game time
	slac_LastEngageTime.SetValue(-60.0)
	slacConfig.lastCombatState = 0
	slacConfig.lastCombatStateChange = -60.0
	
	; Clear target actor
	UpdateTargetActor(None, quiet = True)
	
	; Make absolutely sure there is nothing left in the pursuit quests
	Log("Maintenance: Resetting quests and aliases", forceTrace = True, forceConsole = True)
	slac_Pursuit_00.Reset()
	slac_Pursuit_01.Reset()
	PlayerAttacker.Clear()
	PlayerAttacker2.Clear()
	PlayerAttacker3.Clear()
	PlayerAttacker4.Clear()
	NPCVictim.Clear()
	NPCAttacker.Clear()
	NPCAttacker2.Clear()
	NPCAttacker2.Clear()
	NPCAttacker2.Clear()
	
	; Reset dialogue quest aliases
	FollowerDialogueTargetRef.Clear()
	FollowerPlayerHorseRef.Clear()
	FollowerDialogueFollowerRef.Clear()
	FollowerDialogueCreatureRef.Clear()
	FollowerDialogueTargetRef.Clear()
	
	CreatureDialogueCreatureRef.Clear()
	CreatureDialogueCreatureRef1.Clear()
	CreatureDialogueCreatureRef2.Clear()
	CreatureDialogueCreatureRef3.Clear()
	CreatureDialogueCreatureRef4.Clear()
	CreatureDialogueVictimRef.Clear()
	CreatureDialogueTargetRef.Clear()
	; Make sure last creature force greet is fully cleared
	Actor FGCreature = CreatureDialogueForcedRef.GetActorRef()
	CreatureDialogueForcedRef.Clear()
	FGCreature && FGCreature.EvaluatePackage()
	
	; Reset NPC Scan quest
	slac_ScanNPCCenterRef.Clear()
	slac_ScanNPCIgnoredActor01.Clear()
	slac_ScanNPCIgnoredActor02.Clear()
	slac_ScanNPCIgnoredActor03.Clear()
	slac_ScanNPCIgnoredActor04.Clear()
	slac_ScanNPC.Reset()
	slac_ScanNPC.Stop()
	
	; Load Notification
	If slacConfig.modActive 
		Log("Maintenance: loading notifications", forceTrace = True, forceConsole = True)
		slacNotify.UpdateNotes()
	EndIf

	; Monitor
	Log("Maintenance: Clearing monitored actors", forceTrace = True, forceConsole = True)
	slac_Monitor.IsRunning() || slac_Monitor.Start()
	ClearAllMonitoredActors()
	
	; Claimed Actors
	Log("Maintenance: Clearing claimed actors", forceTrace = True, forceConsole = True)
	slac_Claimed.IsRunning() || slac_Claimed.Start()
	ReleaseAllClaimedActors()

	; Queues
	Log("Maintenance: Clearing queues", forceTrace = True, forceConsole = True)
	ClearAllQueues()
	
	; Reset quest times
	slacConfig.pursuit00LastStartTime = currentTime
	slacConfig.pursuit01LastStartTime = currentTime
	slacConfig.FollowerDialogueLastStartTime = currentTime
	slacConfig.CreatureDialogueLastStartTime = currentTime
	
	; Update Globals
	Log("Maintenance: Updating global variables", forceTrace = True, forceConsole = True)
	slacConfig.UpdateGlobals()
	
	; Update cloak radius
	slac_ScanCloakCreatureSpell.SetNthEffectMagnitude(0, slacConfig.cloakRadius as Float)
	slac_ScanCloakCreatureSpell.SetNthEffectMagnitude(1, slacConfig.cloakRadius as Float)
	Log("Creature Scan Cloak radius set to " + slacConfig.cloakRadius + " feet",True)
	
	; Player horse
	Actor playerHorse = Game.GetPlayersLastRiddenHorse()
	If slacConfig.modActive && playerHorse
		FollowerPlayerHorseRef.ForceRefTo(playerHorse as ObjectReference)
	EndIf
	
	; Player struggle
	playerCanStruggle = True
	playerStruggleFinished = False
	PlayerRef.DispelSpell(slac_StaminaDrainSpell)
	PlayerRef.DispelSpell(slac_StaminaDrainLongSpell)

	; Mod Events
	Log("Maintenance: Registering/Unregistering for mod events", forceTrace = True, forceConsole = True)
	UnregisterForAllModEvents()
	slacConfig.modActive && ModEventReg()

	; Update default animation tags
	; This is kept registered while the mod is disabled in case the user needs to 
	; re-enable after updating SL animations.
	RegisterForModEvent("SexLabSlotCreatureAnimations","StartDefaultTags")
	
	; Clear test failure data
	Log("Maintenance: Clearing failure data", forceTrace = True, forceConsole = True)
	slacConfig.ClearFailData()
	
	; Clear signal and session data from all actors and objects
	Log("Maintenance: Clearing signal and session data", forceTrace = True, forceConsole = True)
	slacData.ClearSignalAll()
	slacData.ClearSessionAll()

	; Reset horse bucking safeties
	BuckingInProgressPC = False
	BuckingDelayTimePC = 0.0
	
	If slacConfig.modActive
		; Update compiled armor slot data
		Log("Maintenance: Compiling armor slot data", forceTrace = True, forceConsole = True)
		UpdateArmorSlotNames()
		
		; Update Allowed Creatures checks
		Log("Maintenance: Updating creature race keys", forceTrace = True, forceConsole = True)
		slacConfig.UpdateRaceKeys()
	
		; Check loaded mods
		Log("Maintenance: Pausing before mod check (2 secs)...", forceTrace = True, forceConsole = True)
		Utility.Wait(1.0)
		Log("Maintenance: Checking loaded mods", forceTrace = True, forceConsole = True)
		ModCheck()
		slacConfig.softDependanciesTest = False;
	EndIf
	
	; Reset struggle meter
	Log("Maintenance: Refreshing meter", forceTrace = True, forceConsole = True)
	WidgetManager.StopMeter()
	WidgetManager.SetHAnchor("left")
	WidgetManager.SetXPosition(slacConfig.widgetXPositionNPC)
	WidgetManager.SetYPosition(slacConfig.widgetYPositionNPC)
	
	; Stop / Start pursuit and dialogue quests (we do this last as stopping a quest can take some time)
	Log("Maintenance: Syncing quests", forceTrace = True, forceConsole = True)
	slac_Pursuit_00.Stop()
	slac_Pursuit_01.Stop()
	slacConfig.SyncQuests()
	
	; Maintenance Complete
	slacConfig.modActive && slacConfig.debugSLAC && Log("Aroused Creatures Ready", forceNote = True)
	!slacConfig.modActive && slacConfig.debugSLAC && Log("Aroused Creatures Unready", forceNote = True)
	Log("Maintenance: Aroused Creatures maintenance complete in " + (Utility.GetCurrentRealTime() - currentTime), forceTrace = True, forceConsole = True)
	
	; Output Current config info for support diagnosis
	If slacConfig.modActive
		Log("Aroused Creatures script versions: " + slacConfig.GetVersion() + "/" + GetVersion() + "/" + slacConfig.slacPlayerScript.GetVersion(), forceTrace = True, forceConsole = True)
		Log("Aroused Creatures Config Info:", forceTrace = True, forceConsole = True)
		slacConfig.debugSLAC && slacConfig.dumpSettings()
		Log("Scan radius: " + Math.Floor(slacConfig.slac_ScanRadius.Getvalue()) + "units (" + Math.Floor(slacConfig.slac_ScanRadius.Getvalue() / UNITFOOTRATIO) + "ft from " + slacConfig.cloakRadius + "ft in config)", forceTrace = True, forceConsole = True)
		Log("Engage radius: " + Math.Floor(slacConfig.slac_EngageRadius.Getvalue()) + "units (" + Math.Floor(slacConfig.slac_EngageRadius.Getvalue() / UNITFOOTRATIO) + "ft from " + slacConfig.engageRadius + "ft in config)", forceTrace = True, forceConsole = True)
		Log("Version: " + slacConfig.GetVersionString() + " (" + slacConfig.GetVersion() + ")", forceTrace = True, forceConsole = True)
	EndIf

	slacConfig.inMaintenance = False
EndFunction

Function ModEventReg()
	; Animation changes
	RegisterForModEvent("HookAnimationChange_slacEngagement", "animationUpdate")

	; Animation progress
	RegisterForModEvent("HookAnimationStart_slacEngagement", "OnStartingCreatureSex")
	RegisterForModEvent("HookAnimationEnding_slacEngagement", "EndingCreatureSex")
	RegisterForModEvent("HookAnimationEnd_slacEngagement", "endCreatureSex")
	
	; DHLP Compatibility Events
	OnDHLPResume() ; Unset flag
	RegisterForModEvent("dhlp-Suspend", "OnDHLPSuspend")
	RegisterForModEvent("dhlp-Resume", "OnDHLPResume")
EndFunction


; Check loaded mods for compatibility options
Function ModCheck(Bool notify = False)

	slacConfig.submitLoaded = False
	slacConfig.defeatLoaded = False
	slacConfig.DeviousDevicesLoaded = False
	slacConfig.NakedDefeatLoaded = False
	slacConfig.ToysLoaded = False
	slacConfig.deviouslyHelplessLoaded = False
	slacConfig.ConvenientHorsesLoaded = False
	slacConfig.ImmersiveHorsesLoaded = False
	
	Int mods = Game.GetModCount()
	While mods > 0
		mods -= 1
		String Modname = Game.GetModName(mods)
		
		If Modname == "SexLab Submit.esp"
			; Get Submit calm effect
			Log("Checking Submit", forceTrace = True, forceNote = notify)
			slacConfig.SubmitCalm = Game.GetFormFromFile(0x043ead, "SexLab Submit.esp") as MagicEffect
			If slacConfig.SubmitCalm != None
				slacConfig.submitLoaded = True
				Log("Submit Registered", forceTrace = True, forceNote = notify)
			Else
				Log("Submit version not compatible", forceTrace = True, forceNote = notify)
			EndIf
		
		ElseIf Modname == "SexLabDefeat.esp"
			; Get Defeat calm effects and factions
			Log("Checking Defeat", forceTrace = True, forceNote = notify)
			slacConfig.DefeatCalm = Game.GetFormFromFile(0x04274f, "SexLabDefeat.esp") as MagicEffect
			slacConfig.DefeatAltCalm = Game.GetFormFromFile(0x0ca2f6, "SexLabDefeat.esp") as MagicEffect
			slacConfig.DefeatFaction = Game.GetFormFromFile(0x1d92, "SexLabDefeat.esp") as Faction
			slacConfig.DefeatRapistFaction = Game.GetFormFromFile(0xf558, "SexLabDefeat.esp") as Faction
			slacConfig.DefeatActiveKeyword = Game.GetFormFromFile(0x5C666, "SexLabDefeat.esp") as Keyword
			If slacConfig.DefeatCalm != None && slacConfig.DefeatAltCalm != None && slacConfig.DefeatFaction != None
				slacConfig.defeatLoaded = True
				If slacConfig.DefeatRapistFaction != none
					Log("Defeat v4.x Registered", forceTrace = True, forceNote = notify)
				Else
					Log("Defeat v5.x+ Registered", forceTrace = True, forceNote = notify)
				EndIf
			Else
				Log("Defeat version not compatible", forceTrace = True, forceNote = notify)
			EndIf
			
		ElseIf Modname == "DeviouslyHelpless.esp"
			; Get Deviously Helpless creature calm effect
			Log("Checking Deviously Helpless", forceTrace = True, forceNote = notify)
			slacConfig.DeviouslyHelplessCalm = Game.GetFormFromFile(0x016B92, "DeviouslyHelpless.esp") as MagicEffect
			if slacConfig.DeviouslyHelplessCalm != None
				slacConfig.deviouslyHelplessLoaded = True
				Log("Deviously Helpless Registered", forceTrace = True, forceNote = notify)
			Else
				Log("Deviously Helpless version not compatible", forceTrace = True, forceNote = notify)
			EndIf
			
		ElseIf Modname == "Convenient Horses.esp"
			; Convenient Horses horse talking activator
			; HorseTalker 0x18B953
			; HorseTalkerAlias 0x20329
			Log("Checking Convenient Horses", forceTrace = True, forceNote = notify)
			slacConfig.ConvenientHorsesLoaded = True
			;slacConfig.ConvenientHorsesTalkerAlias = Game.GetFormFromFile(0x20329, "Convenient Horses.esp") as Alias
			slacConfig.ConvenientHorsesTalker = Game.GetFormFromFile(0x18B953, "Convenient Horses.esp") as ObjectReference
			
			If slacConfig.ConvenientHorsesTalker != None
				Log("Convenient Horses Registered", forceTrace = True, forceNote = notify)
			Else
				Log("Convenient Horses version not compatible", forceTrace = True, forceNote = notify)
			EndIf
		
		ElseIf Modname == "Immersive Horses.esp"
			Log("Checking Immersive Horses", forceTrace = True, forceNote = notify)
			slacConfig.ImmersiveHorsesLoaded = True
			Log("Immersive Horses Registered as Convenient Horses", forceTrace = True, forceNote = notify)
		
		ElseIf ModName == "Devious Devices - Assets.esm"
			Log("Checking Devious Devices", forceTrace = True, forceNote = notify)
			slacConfig.zad_DeviousBelt = Game.GetFormFromFile(0x3330, "Devious Devices - Assets.esm") as Keyword
			slacConfig.zad_DeviousGag = Game.GetFormFromFile(0x7EB8, "Devious Devices - Assets.esm") as Keyword
			slacConfig.zad_DeviousHood = Game.GetFormFromFile(0x2AFA2, "Devious Devices - Assets.esm") as Keyword
			slacConfig.zad_PermitOral = Game.GetFormFromFile(0xFAC9, "Devious Devices - Assets.esm") as Keyword
			slacConfig.zad_PermitAnal = Game.GetFormFromFile(0xFACA, "Devious Devices - Assets.esm") as Keyword
			slacConfig.zad_PermitVaginal = Game.GetFormFromFile(0xFACB, "Devious Devices - Assets.esm") as Keyword
			
			If slacConfig.debugSLAC
				Log("Devious Devices zad_DeviousBelt: " + slacConfig.zad_DeviousBelt)
				Log("Devious Devices zad_DeviousGag: " + slacConfig.zad_DeviousGag)
				Log("Devious Devices zad_DeviousHood: " + slacConfig.zad_DeviousHood)
				Log("Devious Devices zad_PermitOral: " + slacConfig.zad_PermitOral)
				Log("Devious Devices zad_PermitAnal: " + slacConfig.zad_PermitAnal)
				Log("Devious Devices zad_PermitVaginal: " + slacConfig.zad_PermitVaginal)
			EndIf
			
			If slacConfig.zad_DeviousBelt && slacConfig.zad_DeviousGag && slacConfig.zad_DeviousHood && \
			   slacConfig.zad_PermitOral && slacConfig.zad_PermitAnal && slacConfig.zad_PermitVaginal
				slacConfig.DeviousDevicesLoaded = True
			EndIf

		ElseIf ModName == "dse-display-model.esp"
			Log("Checking Display Model", forceTrace = True, forceNote = notify)
			slacConfig.dse_dm_FactionActorUsingDevice = Game.GetFormFromFile(0x2858, "dse-display-model.esp") as Faction
			
			If slacConfig.dse_dm_FactionActorUsingDevice
				slacConfig.DisplayModelLoaded = True
				slacConfig.debugSLAC && Log("Display Model dse_dm_FactionActorUsingDevice: " + slacConfig.dse_dm_FactionActorUsingDevice)
			Else
				slacConfig.debugSLAC && Log("Display Model not compatible")
			EndIf

		ElseIf ModName == "Naked Defeat.esp"
			Log("Checking Naked Defeat", forceTrace = True, forceNote = notify)
			slacConfig.NakedDefeatActorFaction = Game.GetFormFromFile(0x5B01, "Naked Defeat.esp") as Faction
			If slacConfig.NakedDefeatActorFaction
				slacConfig.NakedDefeatLoaded = True
				slacConfig.debugSLAC && Log("Naked Defeat actor faction: " + slacConfig.NakedDefeatActorFaction)
			Else
				slacConfig.debugSLAC && Log("Naked Defeat not compatible")
			EndIf
		EndIf
	EndWhile

	Int lightMods = Game.GetLightModCount()
	While lightMods > 0
		lightMods -= 1
		String ModName = Game.GetLightModName(lightMods)

		If ModName == "Toys.esm"
			Log("Checking Toys", forceTrace = True, forceNote = notify)
			slacConfig.toys_BlockOral = Game.GetFormFromFile(0x82A, "Toys.esm") as Keyword
			slacConfig.toys_BlockAnal = Game.GetFormFromFile(0x82B, "Toys.esm") as Keyword
			slacConfig.toys_BlockVaginal = Game.GetFormFromFile(0x82C, "Toys.esm") as Keyword

			If slacConfig.toys_BlockOral && slacConfig.toys_BlockAnal && slacConfig.toys_BlockVaginal
				slacConfig.ToysLoaded = True
			EndIf

			If slacConfig.debugSLAC
				Log("toys_BlockOral:" + slacConfig.toys_BlockOral)
				Log("toys_BlockAnal:" + slacConfig.toys_BlockAnal)
				Log("toys_BlockVaginal:" + slacConfig.toys_BlockVaginal)
			EndIf
	
		EndIf

	EndWhile
	
	; Report manual check completion
	If notify
		If slacConfig.submitLoaded || slacConfig.defeatLoaded || slacConfig.deviouslyHelplessLoaded || slacConfig.ConvenientHorsesLoaded
			Log("Mods registered", forceTrace = True, forceNote = notify)
		Else
			Log("No compatible mods found", forceTrace = True, forceNote = notify)
		EndIf
	EndIf
EndFunction


; Check Creature for contraindications before starting a pursuit quest or SexLab animation
; akAttacker:		Creature to check
; failOnPursuit:	Reject the creature if it is currently pursuing a victim.
; invited: 			Use tests for invitation - currently this only overrides follower / summoned creature test.
; Returns a string value representing test failure or and empty string ("") for success.
; The failure string is pretended with an underscore "_" to avoid issues with papyrus string caching.
; Use TestCreature() with the same arguments for a boolean result
String Function CheckCreature(Actor akAttacker, Bool failOnPursuit = True, Bool invited = False)

	; Check creature is accessible
	If !akAttacker || akAttacker.IsDisabled()
		Return "_missing"
	EndIf

	; Check DHLP status
	; Technically this is a global test, but it could happen during a pursuit. So we need to test 
	; for it at the end. Testing here simply saves repeating the code in half-dozen separate scripts.
	If !invited && slacConfig.DHLPBlockAuto && slacConfig.DHLPIsSuspended
		Return "_dhlp"
	EndIf

	; Running Cursed Loot scene
	If !invited && slacConfig.DCURBlockAuto && StorageUtil.GetIntValue(PlayerRef, "DCUR_SceneRunning", 0) > 0
		Return "_dcurscene"
	EndIf

	; Not present in cell
	If !akAttacker.Is3DLoaded()
		Return "_no3d"
	EndIf
	If !akAttacker.GetParentCell().IsAttached() || akAttacker.GetDistance(PlayerRef) > 10000.0
		Return "_unloaded"
	EndIf

	; Creature - this version disabled to allow SexLab.AllowedCreature to do the work and permit creature actors missing the creature keyword
	;If !(akAttacker.HasKeyword(ActorTypeCreature) || akAttacker.IsInfaction(CreatureFaction))
	;	Return "_notcreature"
	;EndIf
	
	; Ignored
	If !invited && slacData.GetAllBool(akAttacker, "Ignored", False)
		Return "_ignored"
	EndIf
	
	; Not a creature 
	If akAttacker.HasKeyword(ActorTypeNPC)
		Return "_notcreature"
	EndIf
	
	; No suitable animations
	If !SexLab.AllowedCreature(akAttacker.GetRace())
		Return "_noanims"
	EndIf
	
	; Forbidden by SexLab
	If SexLab.IsForbidden(akAttacker)
		Return "_forbidden"
	EndIf
	
	; Blocked by SLAC
	If !invited && akAttacker.IsInFaction(slacConfig.slac_AutoEngageBlockedFaction)
		Return "_blocked"
	EndIf

	; Already invited
	If !invited && akAttacker.IsInFaction(slacConfig.slac_InvitedFaction)
		Return "_invite"
	EndIf
	
	; In combat
	If !slacConfig.allowCombatEngagements && (akAttacker.IsInCombat() || PlayerRef.GetCombatState() > 0) && GetActorArousal(akAttacker) >= slacConfig.hostileArousalMin
		Return "_combat"
	EndIf
	
	; Enemy Creature
	If !slacConfig.allowHostileEngagements && !slacConfig.allowEnemies && akAttacker.IsHostileToActor(PlayerRef) && GetActorArousal(akAttacker) >= slacConfig.hostileArousalMin
		Return "_hostile"
	EndIf
	
	; Sleeping creature - this should only affect ambushing creatures
	If !invited && !slacConfig.allowHostileEngagements && akAttacker.GetSleepState() > 0
		Return "_asleep"
	EndIf
	
	; Already animating
	If SexLab.IsActorActive(akAttacker) || akAttacker.GetFactionRank(SexLabAnimatingFaction) > -1
		Return "_engaged"
	EndIf
	
	; Ridden
	If akAttacker.IsBeingRidden()
		Return "_ridden"
	EndIf
	
	; Bleeding out
	If akAttacker.IsBleedingOut() && !slacConfig.allowCombatEngagements
		Return "_bleeding"
	EndIf
	
	; Dead
	If akAttacker.IsDead()
		Return "_dead"
	EndIf
	
	; Follower (including player's horse)
	If !invited && (akAttacker.IsPlayerTeammate() || akAttacker.IsPlayersLastRiddenHorse())
		If slacConfig.allowedPCCreatureFollowers == 2 && slacConfig.allowedNPCCreatureFollowers == 2
			Return "_follower"
		EndIf
	EndIf
	
	; Non-Follower
	If !invited && (!akAttacker.IsPlayerTeammate() && !akAttacker.IsPlayersLastRiddenHorse())
		If slacConfig.allowedPCCreatureFollowers == 1 && slacConfig.allowedNPCCreatureFollowers == 1
			Return "_notfollower"
		EndIF
	EndIf
	
	; Familiar
	If !invited && !slacConfig.allowFamiliarsPC && !slacConfig.allowFamiliarsNPC && (akAttacker.HasKeyword(ActorTypeFamiliar) || akAttacker.IsCommandedActor())
		Return "_familiar"
	EndIf
	
	; In scene
	Quest currentQuest
	Scene currentScene = akAttacker.GetCurrentScene()
	If currentScene && !IsClaimed(akAttacker)
		currentQuest = currentScene.GetOwningQuest()
		If currentQuest
			If currentQuest == slacConfig.slac_Pursuit_00 || currentQuest == slacConfig.slac_Pursuit_01
				If failOnPursuit
					Return "_pursuit"
				EndIf
			ElseIf currentQuest == slacConfig.slac_FollowerDialogue || currentQuest == slacConfig.slac_CreatureDialogue
				If failOnPursuit
					Return "_sought"
				EndIf
			ElseIf !slacConfig.allowInScene && currentQuest.GetId() != "DialogueGenericSceneDog01"
				Return "_quest"
			EndIf
		EndIf
	EndIf
	
	; Creature gender
	Int attackerGender = GetSex(akAttacker) % 2
	If !invited
		If attackerGender == 1 && slacConfig.pcCreatureSexValue == 0 && slacConfig.npcCreatureSexValue == 0
			; Female creatures not allowed
			Return "_female"
		ElseIf attackerGender == 0 && slacConfig.pcCreatureSexValue == 1 && slacConfig.npcCreatureSexValue == 1
			; Male creatures not allowed
			Return "_male"
		EndIf
	EndIf
	
	; Same sex animations
	; Individual PC/NPC conditions applied in TestVictim.
	If !invited && attackerGender == 0 && !slacConfig.allowPCMM && !slacConfig.allowNPCMM && slacConfig.npcVictimSexValue == 0 && slacConfig.pcVictimSexValue == 0
		; Male creatures not allowed
		Return "_MM"
	ElseIf !invited && attackerGender == 1 && !slacConfig.allowPCFF && !slacConfig.allowNPCFF && slacConfig.npcVictimSexValue == 1 && slacConfig.pcVictimSexValue == 1
		; Female creatures not allowed
		Return "_FF"
	EndIf
	
	; Calmed actors not permitted
	If !invited && slacConfig.disallowMagicInfluenceCharm && akAttacker.HasMagicEffectWithKeyword(slacConfig.MagicInfluenceCharm)
		Return "_calmed"
	EndIf
	If !invited && slacConfig.disallowMagicAllegianceFaction && akAttacker.IsInFaction(slacConfig.MagicAllegianceFaction)
		Return "_calmed"
	EndIf
	If !invited && slacConfig.disallowMagicCharmFaction && akAttacker.IsInFaction(slacConfig.MagicCharmFaction)
		Return "_calmed"
	EndIf
	
	; Creature calmed by another SL mod
	If slacConfig.submit && slacConfig.submitLoaded && akAttacker.HasMagicEffect(slacConfig.SubmitCalm)
		Return "_submit"
	ElseIf slacConfig.deviouslyHelpless && slacConfig.deviouslyHelplessLoaded && akAttacker.HasMagicEffect(slacConfig.DeviouslyHelplessCalm)
		Return "_deviouslyhelpless"
	ElseIf slacConfig.NakedDefeatLoaded && slacConfig.NakedDefeatFilter && akAttacker.IsInFaction(slacConfig.NakedDefeatActorFaction)
		Return "_nakeddefeat"
	ElseIf slacConfig.defeat && slacConfig.defeatLoaded && akAttacker.HasKeyword(slacConfig.DefeatActiveKeyword) || \
	(slacConfig.DefeatCalm != none && akAttacker.HasMagicEffect(slacConfig.DefeatCalm)) || \
	(slacConfig.DefeatAltCalm != none && akAttacker.HasMagicEffect(slacConfig.DefeatAltCalm)) || \
	(slacConfig.DefeatFaction != none && akAttacker.IsInFaction(slacConfig.DefeatFaction)) || \
	(slacConfig.DefeatRapistFaction != none && akAttacker.IsInFaction(slacConfig.DefeatRapistFaction))
		Return "_defeat"
	EndIf
	
	Return ""
EndFunction

; Boolean result for CheckCreature()
Bool Function TestCreature(Actor akAttacker, Bool failOnPursuit = True, Bool invited = False)
	String testResult = CheckCreature(akAttacker,failOnPursuit,invited)
	If testResult == ""
		Return True
	EndIf
	If akAttacker
		slacConfig.debugSLAC && Log(GetActorNameRef(akAttacker) + " failed creature test: " + StringUtil.SubString(testResult,1))
		; Every loading screen would flood the failure list with "unloaded" so we'll skip those
		testResult != "_unloaded" && slacConfig.UpdateFailedCreatures(akAttacker,testResult)
	EndIf
	Return False
EndFunction


; Check NPC for contraindications before starting a pursuit quest or SexLab animation
; akVictim:			Actor (Required) The non-creature actor to check
; akAttacker: 		Actor (Optional) A creature actor that is going to engage them, if known. This is used to test gender, hostility, distance, LoS, etc.
; failOnPursuit:	Bool (Default True) Indicate if the test should fail when the victim is in a SLAC pursuit scene.
; inviting:			Bool (Default False) Indicate if the victim is inviting the creature. Some conditions can be ignored for invitation, especially for the PC.
; This function returns a string for batch debugging purposes as logging every NPC test would generate too much spam
; Returns an empty string on success - use TestVictim() with the same arguments for a bool result
String Function CheckVictim(Actor akVictim, Actor akAttacker = None, Bool failOnPursuit = True, Bool inviting = False)
	Int victimGender = SexLab.GetGender(akVictim)
	Int vanillaSex = akVictim.GetLeveledActorBase().GetSex()
	Bool isTrans = victimGender != vanillaSex
	Int attackerGender = 0
	Bool IsPlayer = akVictim == PlayerRef
	Float startTime = Utility.GetCurrentRealTime()
	If akAttacker
		attackerGender = GetSex(akAttacker)
	EndIf
	
	; Victim not accessible
	If !akVictim || akVictim.IsDisabled()
		Return "_missing"
	EndIf
	
	; Not present in cell
	If !akVictim.Is3DLoaded()
		Return "_no3d"
	EndIf
	If !akVictim.GetParentCell().IsAttached()
		Return "_unloaded"
	EndIf
		
	; Is a Creature
	If !akVictim.HasKeyword(ActorTypeNPC) && (akVictim.HasKeyword(ActorTypeCreature) || akVictim.IsInfaction(CreatureFaction) || SexLab.AllowedCreature(akVictim.GetRace()))
		Return "_creature"
	EndIf
	
	; Bleeding out
	If akVictim.IsBleedingOut() && !slacConfig.allowCombatEngagements
		Return "_bleeding"
	EndIf
	
	; Dead
	If akVictim.IsDead()
		Return "_dead"
	EndIf
	
	; Trespassing
	If akVictim.IsTrespassing()
		Return "_trespassing"
	EndIf
	
	; Forbidden by SexLab
	If SexLab.IsForbidden(akVictim)
		Return "_forbidden"
	EndIf
	
	; Blocked by SLAC
	If !inviting && akVictim.IsInFaction(slacConfig.slac_AutoEngageBlockedFaction)
		Return "_blocked"
	EndIf
	
	; Already invited
	If !inviting && akVictim.IsInFaction(slacConfig.slac_InvitingFaction)
		Return "_invite"
	EndIf
	
	; In combat
	If !slacConfig.allowCombatEngagements && (akVictim.IsInCombat() || PlayerRef.GetCombatState() > 0 || (!IsPlayer && akVictim.IsWeaponDrawn()))
		Return "_combat"
	EndIf
	
	; Already animating
	If SexLab.IsActorActive(akVictim) || akVictim.GetFactionRank(SexLabAnimatingFaction) > -1
		; If the actor is animating we need to know if the creature can or should queue for them
		If IsQueued(akVictim)
			Int queueCount = GetQueueCount(akVictim)
			Actor AttackerQueueVictim = GetCreatureQueueVictim(akAttacker)
			If IsQueued(akAttacker) && AttackerQueueVictim == akVictim
				; Creature and victim in same queue - skips checks
			ElseIf IsQueued(akAttacker) && AttackerQueueVictim != akVictim
				; Both victim and creature in separate queues
				; Creatures should not leave one queue just to join another
				Return "_queued"
			ElseIf (IsPlayer && queueCount >= slacConfig.queueLengthMaxPC) || (!IsPlayer && queueCount >= slacConfig.queueLengthMaxNPC)
				; Queue full for victim
				Return "_fullqueue"
			EndIf
		Else
			; Victim already engaged and does not have a queue
			Return "_engaged"
		EndIf
	EndIf
	
	; PC / NPC specific checks
	If IsPlayer
		; Check PC state
		
		; Player controls disabled
		If !SexLab.IsActorActive(akVictim) && !Game.IsMovementControlsEnabled()
			Return "_control"
		EndIf
		
		; Player in dialogue (unless invitation which is either impossible in dialogue or is triggered by dialogue)
		If !inviting && MenuOpen()
			Return "_menu"
		EndIf
		
		; Familiar
		If !inviting && !slacConfig.allowFamiliarsPC && akAttacker && (akAttacker.HasKeyword(ActorTypeFamiliar) || akAttacker.IsCommandedActor())
			Return "_familiar"
		EndIf
		
		; Weapons drawn
		If !inviting && !slacConfig.pcAllowWeapons && (PlayerRef.IsWeaponDrawn() || PlayerRef.GetEquippedItemType(0) == 11 || PlayerRef.GetEquippedItemType(1) == 11)
			Return "_weapons"
		EndIf
		
		; Gender
		If isTrans
			; PC is trans (vanilla/SexLab)
			If vanillaSex == 0 && slacConfig.TransMFTreatAsPC == 3
				; Male -> Female ignored
				Return "_transMF"
			ElseIf vanillaSex == 1 && slacConfig.TransFMTreatAsPC == 3
				; Female -> Male ignored
				Return "_transFM"
			Else
				victimGender = TreatAsSex(PlayerRef, akAttacker)
			EndIf
			
		EndIf
		
		; Basic Sex Test
		If !inviting && victimGender != slacConfig.pcVictimSexValue && slacConfig.pcVictimSexValue != 2
			; PC sex
			Return "_gender"
		EndIf
		
		; Same sex options
		If slacConfig.TransFMTreatAsPC == 2
			; Use sex based on attacker so we don't care about MM / FF
		ElseIf !inviting && victimGender == 0 && attackerGender == 0 && !slacConfig.allowPCMM
			Return "_MM"
		ElseIf !inviting && victimGender == 1 && attackerGender == 1 && !slacConfig.allowPCFF
			Return "_FF"
		EndIf
	Else
		; Check NPC State
		
		; Familiar
		If !inviting && !slacConfig.allowFamiliarsNPC && akAttacker && (akAttacker.HasKeyword(ActorTypeFamiliar) || akAttacker.IsCommandedActor())
			Return "_familiar"
		EndIf
		
		; Age
		If !inviting && !slacConfig.allowElders && akVictim.GetRace() == ElderRace
			Return "_elder"
		EndIf
		
		; NPC in dialogue with player
		If !inviting && MenuOpen("Dialogue Menu") && akVictim.GetDialogueTarget() == PlayerRef
			Return "_talking"
		EndIf
		
		; Gender
		If isTrans
			; NPC is trans
			If !inviting && vanillaSex == 0 && slacConfig.TransMFTreatAsNPC == 3
				; Male -> Female ignored
				Return "_transMF"
			ElseIf !inviting && vanillaSex == 1 && slacConfig.TransFMTreatAsNPC == 3
				; Female -> Male ignored
				Return "_transFM"
			Else
				victimGender = TreatAsSex(akVictim, akAttacker)
			EndIf
		EndIf
		
		; Basic Sex Test
		If !inviting && victimGender != slacConfig.npcVictimSexValue && slacConfig.npcVictimSexValue != 2
			; NPC sex
			Return "_gender"
		EndIf
		
		; Same sex options
		If slacConfig.TransFMTreatAsNPC == 2
			; Use sex based on attacker so we don't care about MM / FF
		ElseIf !inviting && victimGender == 0 && attackerGender == 0 && !slacConfig.allowNPCMM
			Return "_MM"
		ElseIf !inviting && victimGender == 1 && attackerGender == 1 && !slacConfig.allowNPCFF
			Return "_FF"
		EndIf
	EndIf
	
	; Allowed Creature Race
	If !inviting && (IsPlayer && slacConfig.checkPCCreatureRace) || (!IsPlayer && slacConfig.checkNPCCreatureRace)
		If akAttacker != None && !slacConfig.AllowedCreatureActor(akAttacker,akVictim)
			Return "_notallowed"
		EndIf
	EndIf
	
	; Armor & Clothing
	If !inviting
		Armor BodySlotArmor = GetEquippedArmor(akVictim, "Body")
		If BodySlotArmor
			Int ArmorClass = slacData.GetPersistInt(BodySlotArmor,"ArmorClassOverride",BodySlotArmor.GetWeightClass())
			If ArmorClass == 1 && ((IsPlayer && !slacConfig.AllowHeavyArmorPC) || (!IsPlayer && !slacConfig.AllowHeavyArmorNPC))
				Return "_heavyarmor"
			ElseIf ArmorClass == 0 && ((IsPlayer && !slacConfig.AllowLightArmorPC) || (!IsPlayer && !slacConfig.AllowLightArmorNPC))
				Return "_lightarmor"
			ElseIf ArmorClass == 2 && ((IsPlayer && !slacConfig.AllowClothingPC) || (!IsPlayer && !slacConfig.AllowClothingNPC))
				Return "_clothing"
			EndIf
			; ArmorClass == 3 is treat as naked / ignored
		EndIf
	EndIf
	
	; Victim is sleeping
	If !inviting && slacConfig.noSleepingActors && akVictim.GetSleepState() > 0
		Return "_asleep"
	EndIf
	
	; Victim is sitting / swimming
	If !inviting && slacConfig.noSittingActors
		If akVictim.GetSitState() > 0
			Return "_sitting"
		ElseIf akVictim.IsSwimming()
			Return "_swimming"
		EndIf
	EndIf

	; General victim checks
	; SexLab.ValidateActor(akVictim) generates too much log spam
	If akVictim.IsChild() || akVictim.IsFlying() || akVictim.IsDisabled() || !akVictim.Is3DLoaded()
		Return "_invalid"
	EndIf

	; On horse
	If akVictim.IsOnMount()
		Return "_mounted"
	EndIf
	
	; In scene
	Quest currentQuest
	Scene currentScene = akVictim.GetCurrentScene()
	If currentScene && !IsClaimed(akVictim)
		currentQuest = currentScene.GetOwningQuest()
		If currentQuest
			If currentQuest == slacConfig.slac_Pursuit_00 || currentQuest == slacConfig.slac_Pursuit_01
				If failOnPursuit
					Return "_pursuit"
				EndIf
			ElseIf currentQuest == slacConfig.slac_FollowerDialogue || currentQuest == slacConfig.slac_CreatureDialogue
				If failOnPursuit
					Return "_commanded"
				EndIf
			ElseIf !slacConfig.allowInScene && currentQuest != slac_Claimed && currentQuest.GetId() != "DialogueGenericSceneDog01"
				Return "_quest"
			EndIf
		EndIf
	EndIf
	
	; Victim involved in Defeat event
	If slacConfig.defeat && slacConfig.defeatLoaded && akVictim.HasKeyword(slacConfig.DefeatActiveKeyword)
		Return "_defeat"
	EndIf
	
	; Victim involved Naked Defeat activity
	If slacConfig.NakedDefeatLoaded && slacConfig.NakedDefeatFilter && akVictim.IsInFaction(slacConfig.NakedDefeatActorFaction)
		Return "_nakeddefeat"
	EndIf
	
	; Victim is Display Model
	If !inviting && slacConfig.DisplayModelLoaded && akVictim.IsInFaction(slacConfig.dse_dm_FactionActorUsingDevice)
		Return "_displaymodel"
	EndIf
	
	; Followers not permitted
	If !inviting && !IsPlayer && slacConfig.allowedNPCFollowers == 2 && akVictim.IsPlayerTeammate()
		Return "_follower"
	EndIf
	
	; Non-Followers not permitted
	If !inviting && !IsPlayer && slacConfig.allowedNPCFollowers == 1 && !akVictim.IsPlayerTeammate()
		Return "_notfollower"
	EndIf
	
	; Calmed actors not permitted
	If !inviting && slacConfig.disallowMagicInfluenceCharm && akVictim.HasMagicEffectWithKeyword(slacConfig.MagicInfluenceCharm)
		Return "_calmed"
	EndIf
	If !inviting && slacConfig.disallowMagicAllegianceFaction && akVictim.IsInFaction(slacConfig.MagicAllegianceFaction)
		Return "_calmed"
	EndIf
	If !inviting && slacConfig.disallowMagicCharmFaction && akVictim.IsInFaction(slacConfig.MagicCharmFaction)
		Return "_calmed"
	EndIf
	
	; Devious Devices Blocking
	If slacConfig.DeviousDevicesLoaded && slacConfig.DeviousDevicesFilter
		Bool PermitVaginal = True
		Bool PermitAnal = True
		If akVictim.WornHasKeyword(slacConfig.zad_DeviousBelt)
			 PermitVaginal = akVictim.WornHasKeyword(slacConfig.zad_PermitVaginal)
			 PermitAnal = akVictim.WornHasKeyword(slacConfig.zad_PermitAnal)
		EndIf
		Bool PermitOral = akVictim.WornHasKeyword(slacConfig.zad_PermitOral) || (!akVictim.WornHasKeyword(slacConfig.zad_DeviousHood) && !akVictim.WornHasKeyword(slacConfig.zad_DeviousGag))
		
		;slacConfig.debugSLAC && Log("DD Test " + GetActorNameRef(akVictim) + " - Belt:" + akVictim.WornHasKeyword(slacConfig.zad_DeviousBelt) + " Gag:" + akVictim.WornHasKeyword(slacConfig.zad_DeviousGag) + " Vaginal:" + PermitVaginal + " Anal:" + PermitAnal + " Oral:" + PermitAnal)
		
		If !PermitVaginal && !PermitAnal && !PermitOral
			Return "_devious"
		EndIf
	EndIf

	; Toys Blocking
	If slacConfig.ToysLoaded && slacConfig.ToysFilter
		If akVictim.WornHasKeyword(slacConfig.toys_BlockOral) \
		&& akVictim.WornHasKeyword(slacConfig.toys_BlockAnal) \
		&& akVictim.WornHasKeyword(slacConfig.toys_BlockVaginal)
			Return "_toys"
		EndIf
	EndIf
	
	; Victim-Attacker tests
	If akAttacker
		; Hostile to Victim (but not summoned creature - probably buggy)
		; This makes the assumption that only the PC will use calming magic on creatures, which might be wrong.
		If !inviting && !slacConfig.allowHostileEngagements
			If akAttacker.IsHostileToActor(akVictim) && !akAttacker.IsCommandedActor() && !akAttacker.HasMagicEffectWithKeyword(slacConfig.MagicInfluenceCharm) && !akAttacker.IsInFaction(slacConfig.MagicCharmFaction) 
				Return "_hostile"
			EndIf
			if akVictim.GetFactionReaction(akAttacker) == 1; || GetEnemyFactionReaction(akVictim,akAttacker)
				Return "_enemy"
			EndIf
		EndIf
	EndIf
	
	Return ""
EndFunction


; Produce boolean result for victim validity using CheckVictim()
Bool Function TestVictim(Actor akVictim, Actor akAttacker = None, Bool failOnPursuit = True, Bool inviting = False)
	String testResult = CheckVictim(akVictim,akAttacker,failOnPursuit,inviting)
	If testResult == ""
		Return True
	EndIf
	slacConfig.debugSLAC && Log(GetActorNameRef(akVictim) + " failed actor test: " + StringUtil.SubString(testResult,1))
	slacConfig.UpdateFailedNPCs(akVictim,testResult)
	Return False
EndFunction


; Test all factions for two actors and return true if any reactions between them are "enemy"
; Unfortunately this does nothing - faction reaction is neutral between all ally and enemy creature factions.
Bool Function GetEnemyFactionReaction(Actor akVictim, Actor akAttacker)
	Faction[] victimFactions = akvictim.GetFactions(-128,127)
	Faction[] attackerFactions = akAttacker.GetFactions(-128,127)
	String victimNameRef = GetActorNameRef(akVictim)
	String attackerNameRef = GetActorNameRef(akAttacker)
	Int i = 0
	While i < victimFactions.Length
		Int c = 0
		If victimfactions[i]
			While c < attackerFactions.Length
				If attackerFactions[c] && attackerFactions[c] != victimfactions[i]
					;Log("Faction Reaction for " + victimNameRef + " and " + attackerNameRef + ": " + victimfactions[i] + " + " + attackerFactions[c] + " = " + victimfactions[i].GetReaction(attackerFactions[c]))
					If (victimfactions[i].GetReaction(attackerFactions[c]) == 1 || attackerFactions[c].GetReaction(victimfactions[i]) == 1)
						Return True
					EndIf
				EndIf
				c += 1
			EndWhile
		EndIf
		i += 1
	EndWhile
	Return False
EndFunction


; Search for partners for the given creature during automatic engagement
; Only called from ProcessCreatureQuestAliases() 
; Actor     @akAttacker        The creature that will be searching for victims or partners
Bool function CheckForAutoEngagement(Actor akAttacker)
	;Int playerGender = SexLab.GetGender(PlayerRef)
	Int playerGender = TreatAsSex(PlayerRef,akAttacker)
	Int playerVanillaGender = PlayerRef.GetActorBase().GetSex()
	Bool playerIsTrans = playerGender != playerVanillaGender
	String attackerName = akAttacker.GetLeveledActorBase().GetName()
	String attackerNameRef = GetActorNameRef(akAttacker)
	Float startTime = Utility.GetCurrentRealTime()
	Bool NPCCooldown = slacConfig.cooldownNPC > 0 && slacConfig.cooldownNPCType == 0 && CheckCooldown(None,slacConfig.cooldownNPC)
	Bool PCCooldown = slacConfig.cooldownPC > 0 && CheckCooldown(PlayerRef,slacConfig.cooldownPC)
	Float finalTime = 0.0
	Int attackerGender = 0
	attackerGender = GetSex(akAttacker)
	Race attackerRace = akAttacker.GetRace()
	String akAttackerRaceKey = GetCreatureRaceKeyString(akAttacker)
	String attackerGenderWord = "male"
	If attackerGender != 0
		attackerGenderWord = "female"
	EndIf
	
	; Active actors
	If !slacConfig.pcActive && !slacConfig.npcActive
		; No actors permitted
		Log("No automated engagements permitted (PC/NPC Settings)")
		Return False
	EndIf
	
	; Check for cooldown as script execution will often be lagging.
	If slacConfig.cooldownNPCType == 0 && CheckCooldown(None,slacConfig.cooldownNPC)
		Log("Global Cooldown, skipping creature " + attackerNameRef)
		slacConfig.UpdateFailedCreatures(akAttacker,"_cooldown1")
		Return False
	EndIf

	; Check for DHLP Suspension
	If slacConfig.DHLPBlockAuto && slacConfig.DHLPIsSuspended
		;Log("DHLP Suspension Event, skipping creature " + attackerNameRef)
		slacConfig.UpdateFailedCreatures(akAttacker,"_dhlp")
		Return False
	EndIf

	; Check for running Cursed Loot scene
	If slacConfig.DCURBlockAuto && StorageUtil.GetIntValue(PlayerRef, "DCUR_SceneRunning", 0) > 0
		slacConfig.UpdateFailedCreatures(akAttacker,"_dcurscene")
		Return False
	EndIf

	; Check for personal PC and global NPC cooldown
	If PCCooldown && NPCCooldown
		Log("PC & NPC Cooldowns, skipping creature " + attackerNameRef)
		slacConfig.UpdateFailedCreatures(akAttacker,"_cooldown3")
		Return False
	EndIf
	
	; Check for creature personal cooldown (this NPC Auto Settings apply to both PC and NPCs for now)
	If slacConfig.cooldownNPCType > 1 && slacConfig.cooldownNPC > 0 && CheckCooldown(akAttacker,slacConfig.cooldownNPC)
		Log("Creature Cooldown, skipping creature " + attackerNameRef)
		slacConfig.UpdateFailedCreatures(akAttacker,"_cooldown4")
		Return False
	EndIf

	; Check for Failed Pursuit Cooldown
	If (slacConfig.pursuitQuestPC || slacConfig.pursuitQuestNPC) && slacConfig.FailedPursuitCooldown >= 60
		If CheckCooldown(akAttacker, slacConfig.FailedPursuitCooldown, startTime, "LastFailedPursuitTime") 
			slacConfig.debugSLAC && Log("AutoEngage: Failed Pursuit Cooldown, skipping creature " + attackerNameRef)
			slacConfig.UpdateFailedCreatures(akAttacker,"_pursuitcd")
			Return False
		EndIf
	Else
		slacData.ClearSession(akAttacker,"LastFailedPursuitTime")
	EndIf

	; Creature not permitted for PC or NPCs
	If slacConfig.OnlyPermittedCreaturesPC && slacConfig.OnlyPermittedCreaturesNPC && !akAttacker.IsInFaction(slacConfig.slac_AutoEngagePermittedFaction)
		slacConfig.UpdateFailedCreatures(akAttacker,"_nopermit")
		Return False
	EndIf

	; Check for location restrictions
	Bool PCLocationAllowed = LocationTestPC()
	Bool NPCLocationAllowed = LocationTestNPC()
	If !PCLocationAllowed && !NPCLocationAllowed
		Log("Location restricted " + attackerNameRef)
		slacConfig.UpdateFailedCreatures(akAttacker,"_location")
		Return False
	EndIf
	
	; Check for recent change in combat state
	If slacConfig.lastCombatState != PlayerRef.GetCombatState()
		slacConfig.debugSLAC && Log("Updating combat cooldown (check): last state " + slacConfig.lastCombatState + ", new state " + PlayerRef.GetCombatState() + ", time " + startTime)
		slacConfig.lastCombatState = PlayerRef.GetCombatState()
		slacConfig.LastCombatStateChange = startTime
	EndIf
	If !slacConfig.allowCombatEngagements && slacConfig.lastCombatState > 0
		Log("Player in combat, skipping creature " + attackerNameRef)
		slacConfig.UpdateFailedCreatures(akAttacker,"_combatpc")
		Return False
	EndIf
	If !slacConfig.allowCombatEngagements && slacConfig.combatStateChangeCooldown > 0 && startTime - slacConfig.lastCombatStateChange < slacConfig.combatStateChangeCooldown
		Log("Combat Cooldown, skipping creature " + attackerNameRef)
		slacConfig.UpdateFailedCreatures(akAttacker,"_combatcd")
		Return False
	EndIf
	
	; Weapons drawn preventing all auto engagements
	If slacConfig.weaponsPreventAutoEngagement && (PlayerRef.IsWeaponDrawn() || PlayerRef.GetEquippedItemType(0) == 11 || PlayerRef.GetEquippedItemType(1) == 11)
		Log("Player's weapons drawn, skipping creature " + attackerNameRef)
		slacConfig.UpdateFailedCreatures(akAttacker,"_weaponsall")
		Return False
	EndIf

	; Player in dialogue - this prevents all engagements since identifying the actor that the PC is in dialogue with has proven unreliable
	If MenuOpen("Dialogue Menu")
		Log("Player in dialogue, skipping creature " + attackerNameRef)
		slacConfig.UpdateFailedCreatures(akAttacker,"_talking")
		Return False
	EndIf
	
	; Check if creature is allowed to leave a current queue
	Bool creatureInQueue = IsQueued(akAttacker)
	Actor queueVictim = None
	If creatureInQueue
		queueVictim = GetCreatureQueueVictim(akAttacker)
		String queueVictimName = GetActorNameRef(queueVictim)
		If !queueVictim || queueVictim == None
			; Invalid queue
			Log("Queued: " + attackerNameRef + " occupying empty queue, cleaning...")
			RemoveQueueCreature(akAttacker)
			ReleaseActor(akAttacker)
			creatureInQueue = False
		ElseIf akAttacker.IsInCombat() || akAttacker.IsDead() || akAttacker.IsBleedingOut()
			; Creature no longer suitable for queueing - wait for TestCreature() to report cause
			Log("Queued: " + attackerNameRef + " in peril or otherwise invalid, cleaning...")
			RemoveQueueCreature(akAttacker)
			ReleaseActor(akAttacker)
			creatureInQueue = False
		ElseIf (queueVictim == PlayerRef && slacConfig.allowQueueLeaversPC) || (queueVictim != PlayerRef && slacConfig.allowQueueLeaversNPC)
			; Creature permitted to leave queue
			Log("Queued " + attackerNameRef + " permitted to leave queue for " + queueVictimName)
		Else
			; Skip creatures in queues (if they are not permitted to leave)
			slacConfig.debugSLAC && Log(attackerNameRef + " (" + attackerGenderWord + ") waiting in queue " + (Utility.GetCurrentRealTime() - startTime) + " secs")
			slacConfig.UpdateFailedCreatures(akAttacker,"_inqueue")
			Return False
		EndIf
	EndIf
	
	; Creature allowed for any actor
	If !slacConfig.AllowedCreatureActorAny(akAttacker)
		slacConfig.debugSLAC && Log(attackerNameRef + " is not allowed for any actors")
		slacConfig.UpdateFailedCreatures(akAttacker,"_notallowed")
		Return False
	EndIf
	
	int AttackerArousal = akAttacker.GetFactionRank(slaArousal)
	; Occasionally arousal will return a negative value (not in faction) which we will treat as zero
	If AttackerArousal < 0
		AttackerArousal = 0
	EndIf
	
	; Check creature arousal requirement.
	; If the PC/NPC thresholds must be tested then the process must continue regardless of the creature arousal.
	; These conditions mean that "Creature Only" or "Both" arousal requirements for both PC and NPCs will provide better performance.
	String ArousalResult = "Failed"
	If slacConfig.pcRequiredArousalIndex == 1 || slacConfig.pcRequiredArousalIndex == 3
		ArousalResult = "PCs arousal needs to be checked"
	ElseIf slacConfig.npcRequiredArousalIndex == 1 || slacConfig.npcRequiredArousalIndex == 3
		ArousalResult = "NPCs arousal needs to be checked"
	ElseIf slacConfig.npcVictimSexValue != 1 && (slacConfig.NPCMaleRequiredArousalIndex == 0 || slacConfig.NPCMaleRequiredArousalIndex == 2) && AttackerArousal >= slacConfig.NPCMaleCreatureArousalMin
		ArousalResult = "Creature arousal threshold for male NPCs"
	ElseIf slacConfig.npcVictimSexValue != 1 && (slacConfig.NPCMaleRequiredArousalIndex == 1 || slacConfig.NPCMaleRequiredArousalIndex == 3)
		ArousalResult = "Male NPCs arousal needs to be checked"
	ElseIf slacConfig.npcVictimSexValue != 1 && slacConfig.NPCMaleRequiredArousalIndex == 4 && AttackerArousal >= slacConfig.inviteArousalMin
		ArousalResult = "Male NPCs arousal needs to be checked for willing creature"
	ElseIf (slacConfig.pcRequiredArousalIndex == 0 || slacConfig.pcRequiredArousalIndex == 2) && AttackerArousal >= slacConfig.pcCreatureArousalMin
		ArousalResult = "Creature arousal threshold for the PC"
	ElseIf (slacConfig.npcRequiredArousalIndex == 0 || slacConfig.npcRequiredArousalIndex == 2) && AttackerArousal >= slacConfig.npcCreatureArousalMin
		ArousalResult = "Creature arousal threshold for NPCs"
	ElseIf (slacConfig.pcRequiredArousalIndex == 0 || slacConfig.pcRequiredArousalIndex == 2) && AttackerArousal >= slacConfig.GetIntPercent(slacConfig.CreatureNakedArousalModPC, slacConfig.pcCreatureArousalMin)
		ArousalResult = "Creature naked arousal threshold for the PC " + slacConfig.CreatureNakedArousalModPC + "pc of " + slacConfig.pcCreatureArousalMin + " = " + slacConfig.GetIntPercent(slacConfig.CreatureNakedArousalModPC, slacConfig.pcCreatureArousalMin)
	ElseIf (slacConfig.npcRequiredArousalIndex == 0 || slacConfig.npcRequiredArousalIndex == 2) && AttackerArousal >= slacConfig.GetIntPercent(slacConfig.CreatureNakedArousalModNPC, slacConfig.npcCreatureArousalMin)
		ArousalResult = "Creature naked arousal threshold for NPCs " + slacConfig.CreatureNakedArousalModNPC + "pc of " + slacConfig.npcCreatureArousalMin + " = " + slacConfig.GetIntPercent(slacConfig.CreatureNakedArousalModNPC, slacConfig.npcCreatureArousalMin)
	ElseIf (slacConfig.npcRequiredArousalIndex == 4 || slacConfig.pcRequiredArousalIndex == 4) && AttackerArousal >= slacConfig.inviteArousalMin
		ArousalResult = "Creature arousal threshold for Either With Invite"
	ElseIf slacConfig.collarAttraction && AttackerArousal >= slacConfig.collaredArousalMin
		ArousalResult = "Creature arousal threshold for collard victims (PC & NPCs)"
	ElseIf SexLab.IsRunning && slacConfig.orgyModePC && (slacConfig.orgyRequiredArousalPCIndex == 0 || slacConfig.orgyRequiredArousalPCIndex == 2) && AttackerArousal >= slacConfig.orgyArousalMinPCCreature
		ArousalResult = "Creature arousal threshold during orgy mode"
	ElseIf SexLab.IsRunning && slacConfig.orgyModePC && (slacConfig.orgyRequiredArousalPCIndex == 1 || slacConfig.orgyRequiredArousalPCIndex == 3)
		ArousalResult = "PC arousal threshold must be checked during orgy mode for (PC settings currently used for NPCs as well)"
	ElseIf SexLab.IsRunning && slacConfig.orgyModeNPC && (slacConfig.orgyRequiredArousalNPCIndex == 0 || slacConfig.orgyRequiredArousalNPCIndex == 2) && AttackerArousal >= slacConfig.orgyArousalMinNPCCreature
		ArousalResult = "Creature arousal threshold during orgy mode"
	ElseIf SexLab.IsRunning && slacConfig.orgyModeNPC && (slacConfig.orgyRequiredArousalNPCIndex == 1 || slacConfig.orgyRequiredArousalNPCIndex == 3)
		ArousalResult = "NPC arousal threshold must be checked during orgy mode"
	ElseIf slacConfig.pcCrouchIndex == 3 && AttackerArousal >= slacConfig.inviteArousalMin
		ArousalResult = "Creature arousal threshold for crouching PC"
	Else
		slacConfig.debugSLAC && Log(attackerNameRef + " (" + attackerGenderWord + ") not aroused (" + AttackerArousal + ") " + (Utility.GetCurrentRealTime() - startTime) + " secs")
		slacConfig.UpdateFailedCreatures(akAttacker,"_arousal")
		Return False
	EndIf
	slacConfig.debugSLAC && Log(attackerNameRef + " (" + attackerGenderWord + ") passes basic arousal test: " + ArousalResult + " (" + AttackerArousal + ") " + (Utility.GetCurrentRealTime() - startTime) + " secs")
	
	; Validate creature state
	; We do this last so that the more numerous conditions in CheckCreature()
	; can be skipped for actors that do not meet the arousal thresholds
	If !TestCreature(akAttacker, failOnPursuit = True)
		slacConfig.debugSLAC && Log(attackerNameRef + " (" + attackerGenderWord + ") failed automated engagement test " + (Utility.GetCurrentRealTime() - startTime) + " secs")
		Return False
	EndIf
	
	
	; ===== FIND VICTIM =====
	
	; Note that we need to loop through all available actors here so failures have to be carried through.
	; The "valid" bool is used to skip processing once an actor has failed
	
	Int foundCount = 0
	Int ignoreCount = 0
	Actor[] ignoredActors = new Actor[4]
	Actor[] foundVictims = PapyrusUtil.ActorArray(0)

	If !slacConfig.pcActive
		ignoredActors[ignoreCount] = PlayerRef
		ignoreCount += 1
	EndIf
	
	; If the creature is in a queue and not permitted to leave then we stop here
	; If they are permitted to leave then we need them to ignore their current victim
	If creatureInQueue
		If queueVictim && queueVictim != None
			If (queueVictim == PlayerRef && !slacConfig.allowQueueLeaversPC) || (queueVictim != PlayerRef && !slacConfig.allowQueueLeaversNPC)
				; Creature not permitted to leave queue	
				slacConfig.debugSLAC && Log(attackerNameRef + " (" + attackerGenderWord + ") queueing for " + GetActorNameRef(queueVictim) + " " + (Utility.GetCurrentRealTime() - startTime) + " secs")
				slacConfig.UpdateFailedCreatures(akAttacker,"_inqueue")
				Return False
			Else
				; Queued creature is looking for alternative victims
				; Ignore queue victim (if they are not already ignored)
				If queueVictim != PlayerRef || (queueVictim == PlayerRef && ignoreCount == 0)
					ignoredActors[ignoreCount] = queueVictim
					ignoreCount += 1
				EndIf
			EndIf
		Else
			; Invalid queue - remove any persistent data
			RemoveQueueCreature(akAttacker)
			ReleaseActor(akAttacker)
		EndIf
	EndIf
	
	; Gender Filter for NPCs
	; If there are same-sex restrictions then search only for the opposite sex unless transgender options are enabled
	; We are only looking at NPCs here as the player will be added outside of FindNPCs
	; As v4.10 pcVictimSexValue and npcVictimSexValue now uses 2 = both, but the scan quest still uses -1 = both
	Int searchNPCGender = slacConfig.npcVictimSexValue
	If slacConfig.npcVictimSexValue == 2
		; both sexes allowed
		If attackerGender == 0
			; Male creatures search for female NPCs
			searchNPCGender = 1
			If slacConfig.TransMFTreatAsNPC == 1 || slacConfig.AllowNPCMM
				; Unless MF trans are treated as female or MM auto engagements are permitted
				searchNPCGender = -1
			EndIf
		ElseIf attackerGender == 1
			; Female creatures search for male NPCs
			searchNPCGender = 0
			If slacConfig.TransFMTreatAsNPC == 0 || slacConfig.AllowNPCFF
				; Unless FM trans are treated as male of FF auto engagements are permitted
				searchNPCGender = -1
			EndIf
		EndIf
	ElseIf slacConfig.npcVictimSexValue == 1 && slacConfig.TransFMTreatAsNPC == 0
		; Vanilla females may be treated as males
		searchNPCGender = -1
	ElseIf slacConfig.npcVictimSexValue == 0 && slacConfig.TransMFTreatAsNPC == 1
		; Vanilla males may be treated as females
		searchNPCGender = -1
	EndIf
	; Else - We just use the default npcVictimSexValue
	; MM and FF filtering performed in TestVictim for latter options
	
	; Search for nearby NPCs
	; We already know where the PC is so we only care about collecting NPCs if they are allowed
	If IsSuitor(akAttacker) && !slacConfig.suitorsPCAllowLeave
		; The creature is a suitor so they should only engage the queue target
		; At the moment this can only be the player.
		If slacConfig.pcActive && !PCCooldown && PCLocationAllowed
			; Player can be auto-engaged
			foundVictims = PapyrusUtil.PushActor(foundVictims,PlayerRef)
		Else
			; Player cannot be auto-engaged but is still the only option
			slacConfig.debugSLAC && Log(attackerNameRef + " (" + attackerGenderWord + ") is a suitor waiting for invitation from the player - " + (Utility.GetCurrentRealTime() - startTime) + " secs")
			slacConfig.UpdateFailedCreatures(akAttacker,"_suitor")
			Return False
		EndIf
		
	ElseIf slacConfig.npcActive && !NPCCooldown && NPCLocationAllowed
		; Search for NPC victims
		foundVictims = FindNPCs(akAttacker, slacConfig.engageRadius * UNITFOOTRATIO, searchNPCGender)
		foundVictims = RemoveActorsFromArray(foundVictims,ignoredActors)
		If foundVictims.Length > slacConfig.countMax
			foundVictims = PapyrusUtil.SliceActorArray(foundVictims,0,slacConfig.countMax - 1)
		EndIf

	ElseIf slacConfig.pcActive && !PCCooldown && PCLocationAllowed
		; Player is only possible victim
		foundVictims = PapyrusUtil.PushActor(foundVictims,PlayerRef)

	EndIf
	
	slacConfig.debugSLAC && Log(attackerNameRef + " is selecting from " + foundVictims.Length + " potential partners")
	
	; Sort and Preference
	If slacConfig.npcActive && !NPCCooldown && NPCLocationAllowed
		Bool playerClose = PlayerRef.GetDistance(akAttacker) <= (slacConfig.engageRadius * UNITFOOTRATIO)
		
		Int workingPreference = slacConfig.actorPreferenceIndex
		
		If slacConfig.actorPreferenceIndex == 3
			; Randomise the PC/NPC preference - 50/50 first or last
			workingPreference = Utility.RandomInt(1,2)
		EndIf

		If workingPreference == 0 && slacConfig.pcActive && queueVictim != PlayerRef && playerClose
			; No Preference - use distance from creature
			foundVictims = PapyrusUtil.PushActor(foundVictims,PlayerRef)
			slacConfig.debugSLAC && Log(attackerNameRef + " is adding the Player as a potential partner")
		EndIf
		
		slacConfig.debugSLAC && Log(attackerNameRef + " is sorting " + foundVictims.Length + " potential partners")
		
		; Sort victim list by distance from Creature
		If foundVictims.Length > 1
			; Array is worth sorting
			Float[] distCache = PapyrusUtil.FloatArray(foundVictims.Length)
			Int foundVictimsIndex = 0
			
			; Collect distance measurements in a single pass so we do not need to keep calling
			; GetDistance() for comparisons
			While foundVictimsIndex < foundVictims.Length
				distCache[foundVictimsIndex] == 999999.0 ; This just needs to be larger than the max scan cloak radius
				If foundVictims[foundVictimsIndex] && foundVictims[foundVictimsIndex] != None
					distCache[foundVictimsIndex] = foundVictims[foundVictimsIndex].GetDistance(akAttacker)
				EndIf
				foundVictimsIndex += 1
			EndWhile
			
			; Sort actors into temp array in order of ascending distance
			Actor[] tempVictims = PapyrusUtil.ActorArray(foundVictims.Length)
			Int tempVictimsIndex = 0
			While tempVictimsIndex < foundVictims.Length
				foundVictimsIndex = 0
				Float lastDist = 999999.0 ; This just needs to be larger than the max scan cloak radius
				Int smallestIndex = 0
				While foundVictimsIndex < foundVictims.Length
					If foundVictims[foundVictimsIndex] != None && distCache[foundVictimsIndex] <= lastDist
						tempVictims[tempVictimsIndex] = foundVictims[foundVictimsIndex]
						lastDist = distCache[foundVictimsIndex]
						smallestIndex = foundVictimsIndex
					EndIf
					foundVictimsIndex += 1
				EndWhile
				; Clear last found actor so we can find the next closest
				foundVictims[smallestIndex] = None
				tempVictimsIndex += 1
			EndWhile
			foundVictims = tempVictims
		EndIf
			
		; Make the PC the first or last choice
		If slacConfig.pcActive && queueVictim != PlayerRef && playerClose && !slacData.GetSignalBool(PlayerRef, "HorseRefusalDismount", False)
			If workingPreference == 1 && !slacConfig.slac_Pursuit_00.IsRunning()
				; Preferred PC in first round - add player to front of list and truncate if necessary
				foundVictims = PapyrusUtil.MergeActorArray(PapyrusUtil.ActorArray(1,PlayerRef), foundVictims, RemoveDupes = True)
			ElseIf workingPreference == 2 ; && count < slacConfig.countMax ; left as an interesting note since the compiler missed the fact that "count" was not a declared variable it this point
				; Preferred NPC, deferred PC until last round - add player to end of list after truncating if necessary
				foundVictims = PapyrusUtil.RemoveActor(foundVictims,PlayerRef)
				If foundVictims.Length >= slacConfig.countMax
					; Replace end of long list
					foundVictims[foundVictims.Length - 1] = PlayerRef
				Else
					; Add to end of short list
					foundVictims = PapyrusUtil.PushActor(foundVictims,PlayerRef)
				EndIf
			EndIf
		EndIf
		
		slacConfig.debugSLAC && Log(attackerNameRef + " has finished sorting " + foundVictims.Length + " potential partners")
	
	ElseIf slacConfig.debugSLAC
		Log(attackerNameRef + " does not require sorting for less than 2 potential partners")

	EndIf

	String report = attackerNameRef + " (" + attackerGenderWord + ")"
	If !slacConfig.modActive
		Log("Aroused Creatures deactivated: " + report + " victim search not started")
		; No failure report for this one
		Return False
	ElseIf foundVictims.Length < 1
		Log(report + " could not find anyone (" + (Utility.GetCurrentRealTime() - startTime) + " secs)" + slacConfig.CondString(NPCCooldown,", NPCs on cooldown"))
		slacConfig.UpdateFailedCreatures(akAttacker,"_novictims")
		Return False
	ElseIf slacConfig.debugSLAC
		Int tempi = 0
		String tempreport = ""
		While tempi < foundVictims.Length
			If foundVictims[tempi]
				tempreport = tempreport + " " + GetActorNameRef(foundVictims[tempi]) + "(" + Math.Floor(foundVictims[tempi].GetDistance(akAttacker) / UNITFOOTRATIO) + "ft)"
			EndIf
			tempi += 1
		EndWhile
		Log("Found victims for " + GetActorNameRef(akAttacker) + " total " + foundVictims.Length + " in " + slacConfig.PrecisionFloatString(Utility.GetCurrentRealTime() - startTime, 2) + " secs, pref:" + slacConfig.actorPreferenceIndex + " -" + tempreport)
	EndIf
	
	
	; ===== Loop through collected victims =====
	
	
	String lastFailure = ""
	Int count = 0
	While count < foundVictims.Length
		Int victimArousalMin
		Int attackerArousalMin
		Actor akVictim = foundVictims[count]
		Bool valid = True
		lastFailure = ""
		
		; This process is long and slow so it is entirely possible that the creature has been unloaded in the meantime
		; This test is not reliable but it's all there is right now
		If !akAttacker.Is3DLoaded() || !akAttacker.GetParentCell().IsAttached() || akAttacker.GetDistance(PlayerRef) > 10000.0
			slacConfig.debugSLAC && Log(attackerNameRef + " was unloaded during processing (dist:" + akAttacker.GetDistance(PlayerRef) + ")" + (Utility.GetCurrentRealTime() - startTime) + " secs")
			slacConfig.UpdateFailedCreatures(akAttacker,"_unloaded")
			Return False
		EndIf
		; The mod may also have been deactivated during the process
		If !slacConfig.modActive
			Log("Aroused Creatures deactivated: " + report + " in-progress victim search cancelled (" + count + ")")
			Return False
		EndIf

		; No actor - this shouldn't happen, but just in case we want to avoid a lot of "None" errors
		; This necessarily dumps the rest of the victims if any
		If !akVictim || akVictim == None
			slacConfig.debugSLAC && Log(attackerNameRef + " was disabled or unloaded during processing")
			slacConfig.UpdateFailedCreatures(akAttacker,"_missing")
			Return False
		EndIf
		
		If slacConfig.DHLPBlockAuto && slacConfig.DHLPIsSuspended
			Log("DHLP Suspension Event, skipping creature " + attackerNameRef)
			slacConfig.UpdateFailedCreatures(akAttacker,"_dhlp")
			Return False
		EndIf

		; VALIDATE VICTIM
		String victimName = "[missing actor]"
		String victimNameRef = "[missing actor]"
		Bool isPlayer = akVictim == PlayerRef
		Int VictimArousal = 0
		Int victimGender = TreatAsSex(akVictim,akAttacker)
		Int victimVanillaSex = akVictim.GetLeveledActorBase().GetSex()
		Bool isTrans = victimVanillaSex != SexLab.GetGender(akVictim)
	
		victimName = akVictim.GetLeveledActorBase().GetName()
		victimNameRef = GetActorNameRef(akVictim)
		VictimArousal = akVictim.GetFactionRank(slaArousal)
		
		; Occasionally arousal will return a negative value which we will treat as zero
		If VictimArousal < 0
			VictimArousal = 0
		EndIf
		
		; Creature Followers for PC / NPCs (NPC followers are filtered in CheckVictim())
		If valid && !akAttacker.IsPlayerTeammate() && !akAttacker.IsPlayersLastRiddenHorse()
			If (IsPlayer && slacConfig.allowedPCCreatureFollowers == 1) || (!IsPlayer && slacConfig.allowedNPCCreatureFollowers == 1)
				; Follower creatures only
				lastFailure = "creaturetypes"
				valid = False
				slacConfig.UpdateFailedCreatures(akAttacker,"_notfollower")
			EndIf
		ElseIf valid && (akAttacker.IsPlayerTeammate() || akAttacker.IsPlayersLastRiddenHorse())
			If (IsPlayer && slacConfig.allowedPCCreatureFollowers == 2) || (!IsPlayer && slacConfig.allowedNPCCreatureFollowers == 2)
				; Non-follower creatures only
				lastFailure = "creaturetypes"
				valid = False
				slacConfig.UpdateFailedCreatures(akAttacker,"_follower")
			EndIf
		EndIf

		; Creature Sex
		If valid && IsPlayer && slacConfig.pcCreatureSexValue < 2 && attackerGender != slacConfig.pcCreatureSexValue
			; Wrong creature sex for PC
			lastFailure = "creaturesex"
			valid = False
			slacConfig.UpdateFailedNPCs(akVictim,"_creaturesex")
		ElseIf valid && !IsPlayer && slacConfig.npcCreatureSexValue < 2 && attackerGender != slacConfig.npcCreatureSexValue
			; Wrong creature sex for NPC
			lastFailure = "creaturesex"
			valid = False
			slacConfig.UpdateFailedNPCs(akVictim,"_creaturesex")
		EndIf
		
		; PC Cooldown
		If valid && IsPlayer && CheckCooldown(akVictim,slacConfig.cooldownPC)
			lastFailure = "cooldown2"
			valid = False
			slacConfig.UpdateFailedNPCs(akVictim,"_cooldown2")
		EndIf
		
		; NPC Cooldown
		If valid && !IsPlayer && (slacConfig.cooldownNPCType == 1 || slacConfig.cooldownNPCType == 3) && CheckCooldown(akVictim,slacConfig.cooldownNPC)
			lastFailure = "cooldown2"
			valid = False
			slacConfig.UpdateFailedNPCs(akVictim,"_cooldown2")
		EndIf
		
		; NPC Not Permitted by SLAC
		If valid && !IsPlayer && slacConfig.OnlyPermittedNPCs && !akVictim.IsInFaction(slacConfig.slac_AutoEngagePermittedFaction)
			lastFailure = "nopermit"
			valid = False
			slacConfig.UpdateFailedCreatures(akVictim,"_nopermit")
		EndIf
	
		; Creature Not Permitted by SLAC
		If valid && ((IsPlayer && slacConfig.OnlyPermittedCreaturesPC) || (!IsPlayer && slacConfig.OnlyPermittedCreaturesNPC)) && !akAttacker.IsInFaction(slacConfig.slac_AutoEngagePermittedFaction)
			lastFailure = "nopermit"
			valid = False
			slacConfig.UpdateFailedCreatures(akAttacker,"_nopermit")
		EndIf
	
		; Check for player dismounting
		If valid && IsPlayer && slacData.GetSignalBool(PlayerRef, "HorseRefusalDismount", False)
			lastFailure = "mounted"
			valid = False
			slacConfig.UpdateFailedNPCs(akVictim,"_mounted")
		EndIf

		; General Victim Validation
		If valid
			lastFailure = CheckVictim(akVictim,akAttacker)
			If lastFailure != ""
				valid = False
				slacConfig.UpdateFailedNPCs(akVictim,lastFailure)
				lastFailure = StringUtil.SubString(lastFailure,1)
			EndIf
		EndIf
			
		; Location
		If valid && (isPlayer && !PCLocationAllowed) || (!isPlayer && !NPCLocationAllowed)
			lastFailure = "location"
			valid = False
			slacConfig.UpdateFailedNPCs(akVictim,"_location")
		EndIf
		
		; Line of Sight - this function is unreliable so we check both directions to try and improve the result.
		; This is not intended to check for visibility just that the actors are in the general same area
		If valid && slacConfig.requireLos && !akAttacker.HasLOS(akVictim) && !akVictim.HasLOS(akAttacker)
			lastFailure = "_los"
			valid = False
			slacConfig.UpdateFailedNPCs(akVictim,"_los")
		EndIf
		
		; Distance for attacker/victim
		If valid && akVictim.GetDistance(akAttacker) > (slacConfig.engageRadius * UNITFOOTRATIO)
			;slacConfig.debugSLAC && Log("Victim " + akVictim + " test failure on distance to " + akAttacker + " (" + akVictim.GetDistance(akAttacker) + "units > " + (slacConfig.engageRadius * UNITFOOTRATIO) + "/" + slacConfig.slac_EngageRadius.GetValue() + "units)")
			lastFailure = "distance"
			valid = False
			slacConfig.UpdateFailedNPCs(akVictim,"_distance")
		EndIf
	
		; PC Crouching
		If valid && IsPlayer
			If slacConfig.pcCrouchIndex == 1 && !PlayerRef.IsSneaking()
				; Allow
				lastFailure = "nocrouch"
				valid = False
				slacConfig.UpdateFailedNPCs(akVictim,"_nocrouch")
			ElseIf slacConfig.pcCrouchIndex == 2 && PlayerRef.IsSneaking()
				; Prevent
				lastFailure = "crouch"
				valid = False
				slacConfig.UpdateFailedNPCs(akVictim,"_crouch")
			EndIf
		EndIf


		; Collect basic arousal thresholds
		Bool IsNaked = GetActorArmorClass(akVictim) == 3
		Bool AllowMaleVictim = False
		If isPlayer
			; Arousal threshold values for PC
			victimArousalMin = slacConfig.pcArousalMin
			attackerArousalMin = slacConfig.pcCreatureArousalMin
			If IsNaked && !SexLab.IsActorActive(akVictim)
				attackerArousalMin = slacConfig.GetIntPercent(slacConfig.CreatureNakedArousalModPC, attackerArousalMin)
			EndIf
		Else
			; Arousal threshold values for NPC
			If victimGender == 0
				; Male
				victimArousalMin = slacConfig.NPCMaleArousalMin
				attackerArousalMin = slacConfig.NPCMaleCreatureArousalMin
				If slacConfig.NPCMaleAllowVictim == 2 || (attackerGender == 0 && slacConfig.NPCMaleAllowVictim != 1) || (attackerGender == 1 && slacConfig.NPCMaleAllowVictim != 0)
					; Male NPC can be pursued by this creature
					; The actual decision is made in the Consent & Arousal check below
					AllowMaleVictim = True
				EndIf
				If IsNaked && !SexLab.IsActorActive(akVictim)
					attackerArousalMin = slacConfig.GetIntPercent(slacConfig.CreatureNakedArousalModNPC, attackerArousalMin)
					
				EndIf
			Else
				; Female
				victimArousalMin = slacConfig.npcArousalMin
				attackerArousalMin = slacConfig.npcCreatureArousalMin
				If IsNaked && !SexLab.IsActorActive(akVictim)
					attackerArousalMin = slacConfig.GetIntPercent(slacConfig.CreatureNakedArousalModNPC, attackerArousalMin)
				EndIf
			EndIf
		EndIf
		
		
		; Check Victim Collar
		; We do this here instead of CheckVictim() as we may need to use alternate arousal thresholds based on the result
		If valid && (slacConfig.onlyCollared || slacConfig.collarAttraction)
			Bool isCollared = akVictim.IsEquipped(slacConfig.slac_CollarsFormList)
			
			If slacConfig.onlyCollared && !isCollared
				; No collar-type items
				lastFailure = "nocollar"
				valid = False
				slacConfig.UpdateFailedNPCs(akVictim,"_nocollar")
				
			ElseIf slacConfig.collarAttraction && isCollared && slacConfig.collaredArousalMin < attackerArousalMin
				; Use collared arousal threshold for creatures
				attackerArousalMin = slacConfig.collaredArousalMin
				
			EndIf
		EndIf

		;  Consolidate required arousal / consent
		Int workingArousalIndex = 0
		Int workingConsentIndex = 2
		
		; Normal Mode required arousal
		If isPlayer
			; Player
			workingArousalIndex = slacConfig.pcRequiredArousalIndex
			workingConsentIndex = slacConfig.pcConsensualIndex
			
		Else
			; NPC
			If victimGender == 0
				; Male
				workingArousalIndex = slacConfig.NPCMaleRequiredArousalIndex
				workingConsentIndex = slacConfig.NPCMaleConsensualIndex
				
			Else
				; Female
				workingArousalIndex = slacConfig.npcRequiredArousalIndex
				workingConsentIndex = slacConfig.npcConsensualIndex
				
			EndIf
		EndIf
		
		; Orgy Mode required arousal
		If valid && SexLab.IsRunning
			If slacConfig.orgyModePC && isPlayer
				; Use PC orgy values if they are lower
				If slacConfig.orgyArousalMinPC < attackerArousalMin
					victimArousalMin = slacConfig.orgyArousalMinPC
				EndIf
				If slacConfig.orgyArousalMinPCCreature < attackerArousalMin
					attackerArousalMin = slacConfig.orgyArousalMinPCCreature
				EndIf
				workingArousalIndex = slacConfig.orgyRequiredArousalPCIndex
				workingConsentIndex = slacConfig.orgyConsentPCIndex
				
			ElseIf slacConfig.orgyModeNPC && !isPlayer
				; Use NPC orgy values if they are lower
				If slacConfig.orgyArousalMinNPC < attackerArousalMin
					victimArousalMin = slacConfig.orgyArousalMinNPC
				EndIf
				If slacConfig.orgyArousalMinNPCCreature < attackerArousalMin
					attackerArousalMin = slacConfig.orgyArousalMinNPCCreature
				EndIf
				workingArousalIndex = slacConfig.orgyRequiredArousalNPCIndex
				workingConsentIndex = slacConfig.orgyConsentNPCIndex
				
			EndIf
		EndIf
		
		; Check Consent & Arousal
		Bool nonConsensualCheck = False
		Bool arousalCheck = False
		Bool RequireMaleVictim = False
		String arousalType = "[invalid]"
		If valid
			If isPlayer && playerGender == 1 && AttackerArousal >= slacConfig.inviteArousalMin && (slacConfig.pcCrouchIndex == 3 && PlayerRef.IsSneaking())
				; Female Sneak Invitation
				arousalCheck = True
				nonConsensualCheck = False
				arousalType = "player sneak"
				
			ElseIf workingArousalIndex == 0
				; Both aroused
				If AttackerArousal >= attackerArousalMin && VictimArousal >= victimArousalMin
					arousalCheck = True
				EndIf
				nonConsensualCheck = False
				arousalType = "both aroused"
				
			ElseIf workingArousalIndex == 1
				; Either aroused
				If AttackerArousal >= attackerArousalMin || VictimArousal >= victimArousalMin
					arousalCheck = True
					If workingConsentIndex == 2 && VictimArousal < victimArousalMin
						; Adaptive non-consensual (PC/NPC victim)
						nonConsensualCheck = True
						RequireMaleVictim = AllowMaleVictim
					EndIf
				EndIf
				arousalType = "either aroused"
				
			ElseIf workingArousalIndex == 2
				; Creature aroused
				If AttackerArousal >= attackerArousalMin
					arousalCheck = True
					If (workingConsentIndex == 2 && VictimArousal < victimArousalMin) || (victimGender == 0 && workingConsentIndex == 1)
						; Adaptive non-consensual (PC/NPC victim)
						nonConsensualCheck = True
						RequireMaleVictim = AllowMaleVictim
					EndIf
				EndIf
				arousalType = "creature aroused"
				
			ElseIf workingArousalIndex == 3
				; "Victim" aroused
				If VictimArousal >= victimArousalMin
					arousalCheck = True
					If workingConsentIndex == 2 && AttackerArousal < attackerArousalMin
						; Adaptive non-consensual (creature victim)
						nonConsensualCheck = True
					EndIf
				EndIf
				arousalType = "victim aroused"
				
			ElseIf workingArousalIndex == 4
				; Either With Invite: Creature aroused or Victim aroused AND Creature at Invite arousal
				If AttackerArousal >= attackerArousalMin || (VictimArousal >= victimArousalMin && AttackerArousal >= slacConfig.inviteArousalMin)
					arousalCheck = True
					If (workingConsentIndex == 2 && VictimArousal < victimArousalMin) || (victimGender == 0 && workingConsentIndex == 1)
						; Adaptive non-consensual (PC/NPC victim)
						nonConsensualCheck = True
						RequireMaleVictim = AllowMaleVictim
					EndIf
				EndIf
				arousalType = "either aroused with invite"
				
			EndIf
			
			If !arousalCheck
				lastFailure = "arousal " + AttackerArousal + "-" + VictimArousal
				valid = False
				slacConfig.UpdateFailedNPCs(akVictim,"_actorarousal")
				
			EndIf
			
			; Force consensual result
			If workingConsentIndex == 0
				nonConsensualCheck = False
			ElseIf workingConsentIndex == 1
				nonConsensualCheck = True
			EndIf
			
			slacConfig.debugSLAC && Log("Auto Engagement arousal check " + slacConfig.CondString(arousalCheck,"Passed","Failed") + " - arousal type " + arousalType + " - " + attackerNameRef + " " + attackerArousal +  "/" + attackerArousalMin + " and " + victimNameRef + " " + victimArousal +  "/" + victimArousalMin + ", non-consensual " + nonConsensualCheck)
			
		EndIf
		
		; We need to skip some things if the victim is in a queue not occupied by the creature
		Bool victimInQueue = IsQueued(akVictim) 
		
		; Creatures should only queue for engaged male NPCs if they are aroused and required arousal includes them.
		If valid && !IsPlayer && victimInQueue && victimGender == 0
			If !slacConfig.NPCMaleQueuing
				lastFailure = "no male queue"
				valid = False
				slacConfig.UpdateFailedNPCs(akVictim,"_nomalequeue")
			ElseIf AttackerArousal < AttackerArousalMin || slacConfig.NPCMaleRequiredArousalIndex != 3
				lastFailure = "male queue arousal " + AttackerArousal
				valid = False
				slacConfig.UpdateFailedCreatures(akVictim,"_arousal")
			EndIf
		EndIf
		
		; Prevent player's horse queuing for NPCs
		If valid && !IsPlayer && victimInQueue && akAttacker == Game.GetPlayersLastRiddenHorse()
			lastFailure = "horsequeue"
			valid = False
			slacConfig.UpdateFailedCreatures(akAttacker,"horsequeue")
		EndIF

		; Find additional creatures for group animation
		Actor[] otherAttackers = PapyrusUtil.ActorArray(3)
		Int groupChanceRequired = Utility.RandomInt(1,100)
		If valid && ((isPlayer && slacConfig.groupChancePC >= groupChanceRequired) || (!isPlayer && slacConfig.groupChanceNPC >= groupChanceRequired))
			; Start with a random number of extra creatures
			Int maxExtras = 3
			If isPlayer
				maxExtras = Utility.RandomInt(1,slacConfig.groupMaxExtrasPC)
				If slacConfig.groupArousalPC < attackerArousalMin
					attackerArousalMin = slacConfig.groupArousalPC
				EndIf
			Else
				maxExtras = Utility.RandomInt(1,slacConfig.groupMaxExtrasNPC)
				If slacConfig.groupArousalNPC < attackerArousalMin
					attackerArousalMin = slacConfig.groupArousalNPC
				EndIf
			EndIf
			otherAttackers = FindExtraCreatures(akAttacker, akVictim, maxExtras, attackerArousalMin)
		EndIf
		
		; Count extra creatures and their sexes
		Int otherAttackersCount = 0
		Int maleCreatureCount = 0
		Int femaleCreatureCount = 0
		
		If attackerGender == 0
			maleCreatureCount += 1
		Else
			femaleCreatureCount += 1
		EndIf
		
		Int oai = 0
		While oai < otherAttackers.length
			If otherAttackers[oai]
				otherAttackersCount += 1
				If GetSex(otherAttackers[oai]) == 0
					maleCreatureCount += 1
				Else
					femaleCreatureCount += 1
				EndIf
			EndIf
			oai += 1
		EndWhile
		
		; Male PC/NPC Animation
		; If the victim is male and MUST use the male role then we need to be sure their are animations for female creatures.
		; We do this here instead of before the group test as there may be 3-5p animations but no 2p. This still works on the
		; assumption that there will always be 2p animations available for females so we don't test for that currently.
		; Group animations with male PC/NPC are only partially supported - results may be unexpected
		If valid && !victimInQueue && otherAttackersCount < 1 && victimGender == 0
			If (IsPlayer && (femaleCreatureCount > 0 && slacConfig.MalePCRoleWithFemaleCreature == 0) || (maleCreatureCount > 0 && slacConfig.MalePCRoleWithMaleCreature == 0)) || \
				(!IsPlayer && (femaleCreatureCount > 0 && slacConfig.MaleNPCRoleWithFemaleCreature == 0) || (maleCreatureCount > 0 && slacConfig.MaleNPCRoleWithMaleCreature == 0))
				; PC/NPC is male and males must have male position
				; Keep in mind we are just looking for valid 2p anims so we know there is SOMETHING valid to use.
				Int animCount = 0
				String[] SLPPTestScenes
				sslBaseAnimation[] maleAnims
				If slacConfig.UsingSLPP()
					; SexLab P+
					Actor[] Positions = PapyrusUtil.ActorArray(2)
					Positions[0] = akVictim
					Positions[1] = akAttacker
					SLPPTestScenes = GetAllScenes(Positions)
					animCount = SLPPTestScenes.Length
				Else
					; SexLab
					maleAnims = SexLab.GetCreatureAnimationsByRaceGenders(2, attackerRace, MaleCreatures = maleCreatureCount, FemaleCreatures = femaleCreatureCount, ForceUse = false)
					maleAnims = FilterAnimationList(maleAnims, tags = "MC", requireAll = True)
					animCount = maleAnims.Length
				EndIf

				If animCount < 1
					; No male animations available
					lastFailure = "no male anim"
					valid = False
					slacConfig.UpdateFailedNPCs(akVictim,"_nomaleanim")
				ElseIf slacConfig.debugSLAC
					Log("Found " + animCount + " MC animations for " + victimNameRef + " and " + attackerNameRef)
					slacConfig.UsingSLPP() && ListScenes(SLPPTestScenes)
					!slacConfig.UsingSLPP() && ListAnims(maleAnims)
				EndIf
			EndIf
		EndIf
		
		; After all of that it is entirely possible that the player has passed through a loading screen
		If !PlayerRef || PlayerRef == None
			Log("Player missing while processing " + victimNameref + " for engagement by " + attackerNameRef + ". Ending process.")
			;slacConfig.UpdateFailedCreatures(akAttacker,"_unloaded")
			Return False
		EndIf
		
		; Check that SexLab is still available
		If !SexLab.Enabled
			Log("SexLab disabled or updating while processing " + victimNameref + " for engagement by " + attackerNameRef + ". Ending process.")
			Return False
		EndIf
		
		; Final Check
		finalTime = Utility.GetCurrentRealTime() - startTime
		If valid
			Bool Success = False
			If victimInQueue
				; QUEUING
				
				If (isPlayer && slacConfig.queueLengthMaxPC < 1) || (!isPlayer && slacConfig.queueLengthMaxNPC < 1)
					; Queue disabled failure (in case the options have changed during processing).
					lastFailure = "noqueue"
					slacConfig.UpdateFailedCreatures(akAttacker,"_noqueue")
					
				ElseIf victimGender == 0 && nonConsensualCheck && GetAnimationRoll(victimGender, attackerGender , isPlayer) == 0
					; Unwilling creatures should not queue
					lastFailure = "ncqueue"
					slacConfig.UpdateFailedCreatures(akAttacker,"ncqueue")
		
				Else
					; Queue Creature
					If AddQueueCreature(akVictim, akAttacker)
						; Queue Success
						
						; Add creature to claim scene
						slacConfig.claimQueuedActors && ClaimActor(akAttacker)
	
						slacNotify.Show("QueueJoin", akVictim, akAttacker, Consensual = !nonConsensualCheck, Group = False)
						Log(report + " " + victimNameRef + "(queued) - " + finalTime + " secs")
						Return True
						
					Else
						; Queue failure
						lastFailure = "fullqueue"
						slacConfig.UpdateFailedCreatures(akAttacker,"_fullqueue")

					EndIf

				EndIf
				
			ElseIf (isPlayer && slacConfig.pursuitQuestPC) || (!isPlayer && slacConfig.pursuitQuestNPC)
				; PURSUIT
				
				If isPlayer
					; PC
					If !slacConfig.slac_Pursuit_00.IsRunning()
					
						; Update player pursuit quest
						ReleaseActor(akVictim)
						ReleaseActor(akAttacker)
						RemoveQueueCreature(akAttacker)
						RemoveSuitor(akAttacker)
						PlayerAttacker.ForceRefTo(akAttacker as ObjectReference)
						
						Monitor(akVictim)
						Monitor(akAttacker)
						
						; Add other attackers
						PlayerAttacker2.clear()
						PlayerAttacker3.clear()
						PlayerAttacker4.clear()
						If otherAttackersCount > 0
							If otherAttackers[0] != none
								ReleaseActor(otherAttackers[0])
								RemoveQueueCreature(otherAttackers[0])
								RemoveSuitor(otherAttackers[0])
								PlayerAttacker2.ForceRefTo(otherAttackers[0] as ObjectReference)
								Monitor(otherAttackers[0])
							EndIf
							If otherAttackers[1] != none
								ReleaseActor(otherAttackers[1])
								RemoveQueueCreature(otherAttackers[1])
								RemoveSuitor(otherAttackers[1])
								PlayerAttacker3.ForceRefTo(otherAttackers[1] as ObjectReference)
								Monitor(otherAttackers[1])
							EndIf
							If otherAttackers[2] != none
								ReleaseActor(otherAttackers[2])
								RemoveQueueCreature(otherAttackers[2])
								RemoveSuitor(otherAttackers[2])
								PlayerAttacker4.ForceRefTo(otherAttackers[2] as ObjectReference)
								Monitor(otherAttackers[2])
							EndIf
						EndIf
						
						If nonConsensualCheck
							slacConfig.slac_Pursuit00Type.SetValue(10)
							akVictim.AddToFaction(slac_victimActor)
						Else
							slacConfig.slac_Pursuit00Type.SetValue(20)
						EndIf
						
						slacConfig.pursuit00LastStartTime = Utility.GetCurrentRealTime()
						slacConfig.slac_Pursuit_00.Start()
						Pursuit00Active = true
						
						Success = True

					Else
						lastFailure = "pursuit"
						slacConfig.UpdateFailedCreatures(akAttacker,"_nopursuit")
					EndIf
				Else
				
					; NPC
					If !slacConfig.slac_Pursuit_01.IsRunning()
					
						; Update NPC pursuit quest
						NPCVictim.ForceRefTo(akVictim as ObjectReference)
						NPCAttacker.ForceRefTo(akAttacker as ObjectReference)
						
						ReleaseActor(akVictim)
						ReleaseActor(akAttacker)
						Monitor(akVictim)
						RemoveQueueCreature(akAttacker)
						RemoveSuitor(akAttacker)
						Monitor(akAttacker)
						
						; Add other attackers
						NPCAttacker2.clear()
						NPCAttacker3.clear()
						NPCAttacker4.clear()
						If otherAttackersCount > 0
							If otherAttackers[0] != none
								ReleaseActor(otherAttackers[0])
								RemoveQueueCreature(otherAttackers[0])
								RemoveSuitor(otherAttackers[0])
								NPCAttacker2.ForceRefTo(otherAttackers[0] as ObjectReference)
								Monitor(otherAttackers[0])
							EndIf
							If otherAttackers[1] != none
								ReleaseActor(otherAttackers[1])
								RemoveQueueCreature(otherAttackers[1])
								RemoveSuitor(otherAttackers[1])
								NPCAttacker3.ForceRefTo(otherAttackers[1] as ObjectReference)
								Monitor(otherAttackers[1])
							EndIf
							If otherAttackers[2] != none
								ReleaseActor(otherAttackers[2])
								RemoveQueueCreature(otherAttackers[2])
								RemoveSuitor(otherAttackers[2])
								NPCAttacker4.ForceRefTo(otherAttackers[2] as ObjectReference)
								Monitor(otherAttackers[2])
							EndIf
						EndIf
						
						; Consent
						slacData.ClearSignal(akVictim, "NPCIsAggressor")
						If nonConsensualCheck
							If victimGender == 0
								; Male NPC
								If !RequireMaleVictim
									; Male NPC pursues creature
									slacConfig.slac_Pursuit01Type.SetValue(30)
									akAttacker.AddToFaction(slac_victimActor)
									slacData.SetSignalBool(akVictim, "NPCIsAggressor", True)
									
								Else 
									; Creature pursues Male NPC
									slacConfig.slac_Pursuit01Type.SetValue(10)
									akVictim.AddToFaction(slac_victimActor)

								Endif

							Else
								; Creature pursues female NPC
								slacConfig.slac_Pursuit01Type.SetValue(10)
								akVictim.AddToFaction(slac_victimActor)
								
							EndIf
							
						Else
							slacConfig.slac_Pursuit01Type.SetValue(20)

						EndIf

						slacConfig.pursuit01LastStartTime = Utility.GetCurrentRealTime()
						slacConfig.slac_Pursuit_01.Start()
						Pursuit01Active = True
						
						Success = True

					Else
						lastFailure = "pursuit"
						slacConfig.UpdateFailedCreatures(akAttacker,"_nopursuit")
					EndIf
				EndIf
				
				; Notify pursuit start result
				Success && slacNotify.Show("PursuitStart", akVictim, akAttacker, !nonConsensualCheck, otherAttackersCount > 0)

			Else
				; NO PURSUIT
				
				If startCreatureSex(akVictim, akAttacker, nonConsensualCheck, "", "", otherAttackers[0], otherAttackers[1], otherAttackers[2])
					
					Monitor(akVictim)
					Monitor(akAttacker)
					RemoveQueueCreature(akAttacker)
					RemoveSuitor(akAttacker)
						
					If otherAttackersCount > 0
						If otherAttackers[0] != none
							Monitor(otherAttackers[0])
							RemoveQueueCreature(otherAttackers[0])
							RemoveSuitor(otherAttackers[0])
						EndIf
						If otherAttackers[1] != none
							Monitor(otherAttackers[1])
							RemoveQueueCreature(otherAttackers[1])
							RemoveSuitor(otherAttackers[1])
						EndIf
						If otherAttackers[2] != none
							Monitor(otherAttackers[2])
							RemoveQueueCreature(otherAttackers[2])
							RemoveSuitor(otherAttackers[2])
						EndIf
					EndIf
					
					; Consent
					slacData.ClearSignal(akVictim, "NPCIsAggressor")
					If nonConsensualCheck
						If victimGender == 0
							; Male NPC
							If !RequireMaleVictim
								; Male NPC assaults creature
								slacData.SetSignalBool(akVictim, "NPCIsAggressor", True)
								akAttacker.AddToFaction(slac_victimActor)
							Else
								; Creature assault Male NPC
								akVictim.AddToFaction(slac_victimActor)
							EndIf
						Else
							; Female NPC is assaulted by creature
							akVictim.AddToFaction(slac_victimActor)
						EndIf
					EndIf
					
					Success = True

					; Notify sex start result
					slacNotify.Show("SexStart", akVictim, akAttacker, !nonConsensualCheck, otherAttackersCount > 0)

				Else
					lastFailure = "quickfail"
					slacConfig.UpdateFailedCreatures(akAttacker,"_quickfail")
				EndIf
			EndIf

			; SUCCESS
			If Success
				Log(report + " " + victimNameRef + "(selected" + AttackerArousal + "-" + VictimArousal + ") with " + GetActorNameRef(otherAttackers[0]) + ", " + GetActorNameRef(otherAttackers[1]) + " and " + GetActorNameRef(otherAttackers[2]) + " - " + finalTime + " secs")
				Return True
			EndIf

		EndIf
		
		; Append debug report
		report += " " + victimNameRef + "(" + lastFailure + ")"
		
		count += 1
	EndWhile
	
	; Debug report
	Log(report + " - " + finalTime + " secs")
	
	; Better Luck Next Time
	Return False
EndFunction
; Legacy function for updates mid-game
Bool function CheckForEngagement(Actor akAttacker, Actor akSelectedVictim = None, Bool invited = False, String requireTags = "", String rejectTags = "", Bool forceGroup = False)
	CheckForAutoEngagement(akAttacker)
EndFunction


; Collect other creatures with a compatible race for 3p to 5p SL animations using existing Quest Aliases
; Trying to match the available creatures with suitable multiple-race animations is too much work for a very limited result
; v4.10: @MatchCreatureSex is defaulting to true for now as otherwise games with both creature sexes will see far fewer successful groups.
; This is less efficient than embedding the process in CheckForAutoEngagement (the previous method) but it will provide more flexibility in future.
; Actor  @akAttacker          The creature whose race we are looking for more of
; Actor  @akVictim            The PC/NPC actor we need to test for compatibility with
; Int    @maxExtras           The maximum number of additional creatures to find (default and hard max: 3)
; Int    @attackerArousalMin  The minimum arousal level for valid creatures (default: 0)
; Bool   @MatchCreatureSex    Should this return creatures of the same sex as initial the attacker.
Actor[] Function FindExtraCreatures(Actor akAttacker, Actor akVictim, Int MaxExtras = 3, Int ArousalMin = 0, Bool Invitation = False, Bool MatchCreatureSex = True)
	Actor[] otherAttackers = PapyrusUtil.ActorArray(3)
	
	If !akAttacker
		Log("FindExtraCreatures missing creature")
		Return otherAttackers
	ElseIf !akVictim
		Log("FindExtraCreatures missing NPC")
		Return otherAttackers
	EndIf
	
	Race attackerRace = akAttacker.GetRace()
	String akAttackerRaceKey = GetCreatureRaceKeyString(akAttacker)
	Int attackerGender = GetSex(akAttacker)
	Int otherAttackersCount = 0
	Int maleCreatureCount = 0
	Int femaleCreatureCount = 0
	String attackerName = akAttacker.GetLeveledActorBase().GetName()
	String attackerNameRef = GetActorNameRef(akAttacker)
	String victimName = akVictim.GetLeveledActorBase().GetName()
	String victimNameRef = GetActorNameRef(akVictim)
	Int victimGender = TreatAsSex(akVictim)
	String victimGenderLetter = slacConfig.CondString(victimGender == 0,"M","F")
	Actor queueVictim = GetCreatureQueueVictim(akAttacker)
	Bool IsPlayer = akVictim == PlayerRef
	Bool AlwaysMF = GetAlwaysMF(IsPlayer)
	Int AnimRoll = GetAnimationRoll(VictimGender, AttackerGender, IsPlayer)
	
	Actor[] tempQuestCreatures = PapyrusUtil.RemoveActor(questCreatures, None)
	
	If attackerGender == 0
		maleCreatureCount += 1
	Else
		femaleCreatureCount += 1
	EndIf

	If maxExtras > 3
		maxExtras = 3
	EndIf
	
	Log("FindExtraCreatures starting for " + victimNameRef + " and " + attackerNameRef + " with " + tempQuestCreatures.Length + " candidates ...")
	Float searchStartTime = Utility.GetCurrentRealTime()
	
	; Add valid creatures to potential group from last scan result
	Int i = 0 
	While i < tempQuestCreatures.Length && otherAttackersCount < maxExtras
		Bool valid = True
		String reportHead = "FindExtraCreatures Group candidate " + (i+1) + " "
		
		; No creature in slot
		If tempQuestCreatures[i] == None
			valid = False
			slacConfig.debugSLAC && Log(reportHead + "failed for " + victimNameRef + " is missing")
		EndIf
		
		; Candidate not initial attacker
		If valid && tempQuestCreatures[i] == akAttacker
			valid = False
			slacConfig.debugSLAC && Log(reportHead + "failed for " + victimNameRef + " is initial attacker " + attackerNameRef)
		EndIf
		
		Int candidateSex = GetSex(tempQuestCreatures[i])
		
		; Candidate creature sex must matche initial creature sex
		If valid && MatchCreatureSex && attackerGender != candidateSex
			valid = False
			slacConfig.debugSLAC && Log(reportHead + "failed: sex mismatch " + GetActorNameRef(tempQuestCreatures[i]) + " (" + slacConfig.CondString(candidateSex == 0,"M","F") + ") and " + attackerNameRef + " (" + slacConfig.CondString(attackerGender == 0,"M","F") + ") for " + victimNameRef)
		EndIf
		
		; Candidate must be compatible race for initial attacker
		If valid && !slacConfig.UsingSLPP() && !SexLab.AllowedCreatureCombination(attackerRace, tempQuestCreatures[i].GetRace())
			valid = False
			slacConfig.debugSLAC && Log(reportHead + "failed: incompatible (SL) " + GetActorNameRef(tempQuestCreatures[i]) + " (" + slacConfig.CondString(candidateSex == 0,"M","F") + ") for " + victimNameRef + " race " + tempQuestCreatures[i].GetRace())
		EndIf

		; Same as compatible race test above. Right now, without exhaustively going through every 
		; combination of the races we can't support multi-race creature animations
		If valid && slacConfig.UsingSLPP() && GetCreatureRaceKeyString(tempQuestCreatures[i]) != akAttackerRaceKey
			valid = False
			slacConfig.debugSLAC && Log(reportHead + "failed: incompatible (SLP+) " + GetActorNameRef(tempQuestCreatures[i]) + " (" + slacConfig.CondString(candidateSex == 0,"M","F") + ") for " + victimNameRef + " race " + tempQuestCreatures[i].GetRace())
		EndIf
		
		Int extraArousal = tempQuestCreatures[i].GetFactionRank(slaArousal)
					
		; Creature must meet arousal minimum
		If valid && ArousalMin > 0 && extraArousal < ArousalMin
			valid = False
			slacConfig.debugSLAC && Log(reportHead + "failed: arousal " + GetActorNameRef(tempQuestCreatures[i]) + " (" + slacConfig.CondString(candidateSex == 0,"M","F") + ") for " + victimNameRef + " arousal " + extraArousal + "/" + ArousalMin)
		EndIf
		
		; Candidate must pass standard testing
		If valid
			String creatureResult = CheckCreature(tempQuestCreatures[i], invited = Invitation)
			If creatureResult != ""
				valid = False
				slacConfig.debugSLAC && Log(reportHead + "failed: TestCreature " + GetActorNameRef(tempQuestCreatures[i]) + "(" + slacConfig.CondString(candidateSex == 0,"M","F") + ") (" + creatureResult + ") for " + victimNameRef)
			EndIf
		EndIf
		
		; Victim with candidate must pass standard testing
		If valid
			String victimResult = CheckVictim(akVictim, tempQuestCreatures[i], inviting = Invitation)
			If victimResult != ""
				valid = False
				slacConfig.debugSLAC && Log(reportHead + "failed: TestVictim " + victimNameRef + " (" + victimResult + ") with " + GetActorNameRef(tempQuestCreatures[i]) + " (" + slacConfig.CondString(candidateSex == 0,"M","F") + ")")
			EndIf
		EndIf
		
		; Candidate in a queue must be allowed to leave their queue OR must be in the victim's queue
		If valid && IsQueued(tempQuestCreatures[i]) && queueVictim && akVictim != queueVictim
			If (IsPlayer && !slacConfig.allowQueueLeaversPC) || (!IsPlayer && !slacConfig.allowQueueLeaversNPC)
				valid = False
				slacConfig.debugSLAC && Log(reportHead + "failed: queued " + GetActorNameRef(tempQuestCreatures[i]) + " (" + slacConfig.CondString(candidateSex == 0,"M","F") + ") for " + victimNameRef)
			EndIf
		EndIf
		
		; Add candidate to group
		If valid
			otherAttackers[otherAttackersCount] = tempQuestCreatures[i]
			otherAttackersCount += 1
			If candidateSex == 0
				maleCreatureCount += 1
			Else
				femaleCreatureCount += 1
			EndIf
			
			; Report
			If slacConfig.debugSLAC
				String questCreatureRaceKey = GetCreatureRaceKeyString(tempQuestCreatures[i])
				If questCreatureRaceKey == ""
					questCreatureRaceKey = attackerName
				EndIf
				Log(reportHead + "passed: added " + GetActorNameRef(tempQuestCreatures[i]) + " " + slacConfig.CondString(candidateSex == 0,"M","F") + ") " + otherAttackersCount + "/" + maxExtras + " for " + victimNameRef + " and " + attackerNameRef)
			EndIf
		EndIf
								
		i += 1
	EndWhile
	
	; Debug extra creature list
	If slacConfig.debugSLAC
		Log("Found " + otherAttackersCount + " additional " + akAttackerRaceKey + " for " + victimNameRef + " and " + attackerNameRef + ". max:" + maxExtras + "/3")
		Int debugi = 0
		While otherAttackersCount > 0 && debugi < otherAttackers.length
			If otherAttackers[debugi]
				Log("FindExtraCreatures Additional creature " + (debugi+1) + " " + GetActorNameRef(otherAttackers[debugi]) + " (" + slacConfig.CondString(GetSex(otherAttackers[debugi]) == 0,"Male","Female") + ") for " + victimNameRef)
			EndIf
			debugi += 1
		EndWhile
	EndIf
	
	; Debug roll calculation
	If slacConfig.debugSLAC
		String templogstring = "FindExtraCreatures GetCreatureAnimationsByRaceGenders (group) for " + victimNameRef + "(" + victimGenderLetter + ") rolls "
		If victimGender == 0
			IsPlayer && Log(templogstring + "MPCM:" + slacConfig.MalePCRoleWithMaleCreature + " MPCF:" + slacConfig.MalePCRoleWithFemaleCreature)
			!IsPlayer && Log(templogstring + "MNPCM:" + slacConfig.MaleNPCRoleWithMaleCreature + " MNPCF:" + slacConfig.MaleNPCRoleWithFemaleCreature)
		Else
			IsPlayer && Log(templogstring + "FPCM:" + slacConfig.FemalePCRoleWithMaleCreature + " FPCF:" + slacConfig.FemalePCRoleWithFemaleCreature)
			!IsPlayer && Log(templogstring + "FNPCM:" + slacConfig.FemaleNPCRoleWithMaleCreature + " FNPCF:" + slacConfig.FemaleNPCRoleWithFemaleCreature)
		EndIf
	EndIf
	
	; Check for multi position animations starting with the maximum available creatures and
	; culling the extras until something is found
	If otherAttackersCount > 0
		sslBaseAnimation[] testAnims
		String[] SLPPTestScenes
		Int testAnimCount = 0
		Int testOtherAttackerIndex = otherAttackersCount - 1
		Int genderTagCount = 0
		String chosenTag = ""
		Actor[] TestActorList = PapyrusUtil.ActorArray(2)
		TestActorList[0] = akVictim
		TestActorList[1] = akAttacker
		While testOtherAttackerIndex >= 0 && testAnimCount <= 0
			If slacConfig.UsingSLPP()
				; SexLab P+
				slacConfig.debugSLAC && Log("FindExtraCreatures: testing group " + GetActorNameRefArray(PapyrusUtil.MergeActorArray(TestActorList, otherAttackers)))
				SLPPTestScenes = GetAllScenes(PapyrusUtil.MergeActorArray(TestActorList, otherAttackers))
				testAnimCount = SLPPTestScenes.Length

			Else
				; SexLab

				; Gender Tag
				String femaleVictimGenderTag = SexLab.GetGenderTag(1,0,otherAttackersCount+1) ; Female NPC
				String maleVictimGenderTag = SexLab.GetGenderTag(0,1,otherAttackersCount+1) ; Male NPC
				;testAnims = SexLab.GetCreatureAnimationsByRaceTags(2 + otherAttackersCount, attackerRace, genderTag, "", True)
				
				; We already know the victim is allowed to use the creature sexes from TestVictim()
				testAnims = SexLab.GetCreatureAnimationsByRaceGenders(2 + otherAttackersCount, attackerRace, maleCreatures = maleCreatureCount, femaleCreatures = femaleCreatureCount, ForceUse = False)
				testAnimCount = testAnims.Length
				
				; Check anims for appropriate gender tags
				; This is very ugly as the logic for potentially mixed creature sexes is limited. In the end this will 
				; tend to greatly reduce successful groups for configurations that allow both creature sexes. Keep in 
				; mind, we do not care at this stage how many appropriate animations there are so long as it's more than one.
				genderTagCount = 0
				chosenTag = ""
				If testAnimCount > 0
					If AnimRoll != 1
						; Animations for males
						If (IsPlayer && ((maleCreatureCount > 0 && slacConfig.MalePCRoleWithMaleCreature != 1) || (femaleCreatureCount > 0 && slacConfig.MalePCRoleWithFemaleCreature != 1))) || \
							(!IsPlayer && ((maleCreatureCount > 0 && slacConfig.MaleNPCRoleWithMaleCreature != 1) || (femaleCreatureCount > 0 && slacConfig.MaleNPCRoleWithFemaleCreature != 1)))
							; Male roll PC/NPCs in male position
							genderTagCount += SexLab.CountTag(testAnims, femaleVictimGenderTag)
							chosenTag = TagListStringAdd(chosenTag, femaleVictimGenderTag)
						EndIf
						If (IsPlayer && ((maleCreatureCount > 0 && slacConfig.MalePCRoleWithMaleCreature > 0) || (femaleCreatureCount > 0 && slacConfig.MalePCRoleWithFemaleCreature > 0))) || \
							(!IsPlayer && ((maleCreatureCount > 0 && slacConfig.MaleNPCRoleWithMaleCreature > 0) || (femaleCreatureCount > 0 && slacConfig.MaleNPCRoleWithFemaleCreature > 0)))
							; Male roll PC/NPCs in female position
							genderTagCount += SexLab.CountTag(testAnims, maleVictimGenderTag)
							chosenTag = TagListStringAdd(chosenTag, maleVictimGenderTag)
						EndIf
					EndIf
					If AnimRoll != 0
						; Animations for females
						If (IsPlayer && ((maleCreatureCount > 0 && slacConfig.FemalePCRoleWithMaleCreature > 0) || (femaleCreatureCount > 0 && slacConfig.FemalePCRoleWithFemaleCreature > 0))) || \
							(!IsPlayer && ((maleCreatureCount > 0 && slacConfig.FemaleNPCRoleWithMaleCreature > 0) || (femaleCreatureCount > 0 && slacConfig.FemaleNPCRoleWithFemaleCreature > 0)))
							; Female roll PC/NPCs in female position
							genderTagCount += SexLab.CountTag(testAnims, femaleVictimGenderTag)
							chosenTag = TagListStringAdd(chosenTag, femaleVictimGenderTag)
						EndIf
						If (IsPlayer && ((maleCreatureCount > 0 && slacConfig.FemalePCRoleWithMaleCreature != 1) || (femaleCreatureCount > 0 && slacConfig.FemalePCRoleWithFemaleCreature != 1))) || \
							(!IsPlayer && ((maleCreatureCount > 0 && slacConfig.FemaleNPCRoleWithMaleCreature != 1) || (femaleCreatureCount > 0 && slacConfig.FemaleNPCRoleWithFemaleCreature != 1)))
							; Female roll PC/NPCs in male position
							genderTagCount += SexLab.CountTag(testAnims, maleVictimGenderTag)
							chosenTag = TagListStringAdd(chosenTag, maleVictimGenderTag)
						EndIf
					EndIf
				EndIf
				If genderTagCount < 1
					; No gender-appropriate animations in list
					testAnimCount = 0
				EndIf
			EndIf
				
			If slacConfig.debugSLAC
				If slacConfig.UsingSLPP()
					; SexLab P+
					Log("FindExtraCreatures GetAllScenes (group) found " + testAnimCount + " anims for " + victimNameRef + ", " + attackerNameRef + " and " + otherAttackersCount + " extra creatures (males:" + maleCreatureCount + " females:" + femaleCreatureCount + ")")
					ListScenes(SLPPTestScenes)
				Else
					; SexLab
					Log("FindExtraCreatures GetCreatureAnimationsByRaceGenders (group) found " + testAnimCount + " anims for " + victimNameRef + ", " + attackerNameRef + " and " + otherAttackersCount + " extra creatures (tag " + chosenTag + " count " + genderTagCount + " males:" + maleCreatureCount + " females:" + femaleCreatureCount + ")")
					ListAnims(testAnims)
				EndIf
			EndIf
			
			If testAnimCount < 1
				; Nothing found - reduce extra attackers by 1 and try again
				slacConfig.debugSLAC && Log("FindExtraCreatures Removing creature candidate " + testOtherAttackerIndex + " " + GetActorNameRef(otherAttackers[testOtherAttackerIndex]) + " (" + slacConfig.CondString(GetSex(otherAttackers[testOtherAttackerIndex]) == 0,"M","F") + ") for " + victimNameRef + " no suitable animations for " + otherAttackersCount + " extras (M" + maleCreatureCount + "/F" + femaleCreatureCount + ")")
				otherAttackersCount -= 1
				If GetSex(otherAttackers[testOtherAttackerIndex]) == 0
					maleCreatureCount -= 1
				Else
					femaleCreatureCount -= 1
				EndIf
				otherAttackers[testOtherAttackerIndex] = none
			EndIf
			testOtherAttackerIndex -= 1
		EndWhile
	EndIf
	
	Log("FindExtraCreatures took " + (Utility.GetCurrentRealTime() - searchStartTime) + " secs")

	Return otherAttackers
EndFunction


; Start sex between an PC/NPC actor and creatures
; Actor  @akVictim        The PC/NPC actor
; Actor  @akAttacker      The primary/lead creature they are to animate with
; Bool   @nonConsensual   If True (default) aggressive tagged animations will be selected if possible with a fallback to any available
; String @requiredTags    Comma delimited list of tags to prioritise in animation selection with a fallback to any available
; String @rejectTags      Comma delimited list of tags used to exclude animations. If all animations are rejected it will fallback to any available
; Bool   #Return          returns True if the animation is successfully started.
Bool Function StartCreatureSex(Actor akVictim, Actor akAttacker, Bool nonConsensual = True, String requireTags = "", String rejectTags = "", Actor otherAttacker2 = None, Actor otherAttacker3 = None, Actor otherAttacker4 = None)
	If !akVictim || !akAttacker
		Log("StartCreatureSex missing actors - Victim:" + GetActorNameRef(akVictim) + ", Attacker:" + GetActorNameRef(akAttacker))
	EndIf
	
	String attackerName = GetActorNameRef(akAttacker)
	Race attackerRace = akAttacker.GetRace()
	Int attackerGender = GetSex(akAttacker)
	Bool attackerVictim = akAttacker.IsInFaction(slac_victimActor) || slacData.GetSignalBool(akVictim, "NPCIsAggressor")
	String victimName = GetActorNameRef(akVictim)
	Int victimGender = TreatAsSex(akVictim,akAttacker)
	Int victimVanillaSex = akVictim.GetLeveledActorBase().GetSex()
	Bool isTrans = SexLab.GetGender(akVictim) != victimVanillaSex
	Bool isPlayer = akVictim == PlayerRef
	Bool IncludeAggressive = (IsPlayer && !slacConfig.restrictAggressivePC) || (!IsPlayer && !slacConfig.restrictAggressiveNPC)
	Bool IncludeConsensual = (IsPlayer && !slacConfig.restrictConsensualPC) || (!IsPlayer && !slacConfig.restrictConsensualNPC)
	Int maleVictimCount = 0
	Int femaleVictimCount = 0
	Int maleCreatureCount = 0
	Int femaleCreatureCount = 0

	; Resolve sex role for "victim" 
	; 0 = male, 1 = female, 2 = either
	Int VictimRoll = 1
	Bool AlwaysMF = False
	If nonConsensual && GetAlwaysMF(IsPlayer)
		; Aggressor is always male roll
		VictimRoll = slacConfig.CondInt(attackerVictim,0,1)
		AlwaysMF = True

	Else
		VictimRoll = GetAnimationRoll(victimGender,attackerGender,IsPlayer)

	EndIf

	slacConfig.debugSLAC && Log("StartCreatureSex: " + attackerName + " (a:" + slacConfig.CondString(attackerGender == 0,"M","F") + ") & " + victimName + " (v:" + slacConfig.CondString(victimVanillaSex == 0,"M","F") + "/sl:" + slacConfig.CondString(SexLab.GetGender(akVictim) == 0,"M","F") + "/tr:" + slacConfig.CondString(victimGender == 0,"M","F") + ") - Victim Roll:" + slacConfig.CondString(VictimRoll == 2,"E",slacConfig.CondString(VictimRoll == 0,"M","F")) + " NonCon:" + nonConsensual + ", AlwaysMF:" + AlwaysMF + " requireTags:[ " + requireTags + "], rejectTags:[" + rejectTags + "]")

	If !SexLab.Enabled
		; Check that SexLab has not changed state
		Log("StartCreatureSex SexLab disabled or updating, StartCreatureSex for " + victimName + " and " + attackerName + " interrupted before animation selection.")
		Return False

	ElseIf SexLab.IsActorActive(akVictim)
		; Victim already engaged
		Log("StartCreatureSex " + victimName + " animating before " + attackerName + " could engage them at double check")
		Return False

	ElseIf SexLab.IsActorActive(akAttacker)
		; Attacker already engaged
		Log("StartCreatureSex " + attackerName + " animating before they could engage " + victimName + " at double check")
		Return False
	
	ElseIf slacConfig.DHLPBlockAuto && slacConfig.DHLPIsSuspended
		Log("DHLP Suspension Event, cancelling engagement for " + attackerName)
		slacConfig.UpdateFailedCreatures(akAttacker,"_dhlp")
		Return False

	EndIf
	
	; Claim and tag actors as engaged early to reduce chance of simultaneous engagements trying to start on 
	; them. Make sure this is cleaned up on failure.
	ClaimActor(akVictim)
	ClaimActor(akAttacker)
	ClaimActor(otherAttacker2)
	ClaimActor(otherAttacker3)
	ClaimActor(otherAttacker4)
	akVictim.AddToFaction(slac_engagedActor)
	akAttacker.AddToFaction(slac_engagedActor)
	otherAttacker2 && otherAttacker2.AddToFaction(slac_engagedActor)
	otherAttacker3 && otherAttacker3.AddToFaction(slac_engagedActor)
	otherAttacker4 && otherAttacker4.AddToFaction(slac_engagedActor)
	
	; Stop player moving if the creature is queuing for them
	If isPlayer && slacConfig.queueLengthMaxPC > 0 && IsQueued(akAttacker)
		StopPlayer()
	EndIf
	
	; Strip victim
	If !IsStripped(akVictim)
		StripActor(akVictim,nonConsensual)
	EndIf
	
	If attackerGender == 0
		maleCreatureCount += 1
	Else
		femaleCreatureCount += 1
	EndIf
	
	; Collect actors in array for SLP+ functions
	Actor[] ActorPositions = PapyrusUtil.ActorArray(5)
	ActorPositions[0] = akVictim
	ActorPositions[1] = akAttacker

	; Add extra attackers
	Int otherAttackersCount = 0
	String otherAttacker2Name = GetActorNameRef(otherAttacker2)
	String otherAttacker3Name = GetActorNameRef(otherAttacker3)
	String otherAttacker4Name = GetActorNameRef(otherAttacker4)
	If otherAttacker2 != None
		ActorPositions[otherAttackersCount + 2] = otherAttacker2
		otherAttackersCount += 1
		If GetSex(otherAttacker2) == 0
			maleCreatureCount += 1
		Else
			femaleCreatureCount += 1
		EndIf

	EndIf
	If otherAttacker3 != None
		ActorPositions[otherAttackersCount + 2] = otherAttacker3
		otherAttackersCount += 1
		If GetSex(otherAttacker3) == 0
			maleCreatureCount += 1
		Else
			femaleCreatureCount += 1
		EndIf

	EndIf
	If otherAttacker4 != None
		ActorPositions[otherAttackersCount + 2] = otherAttacker4
		otherAttackersCount += 1
		If GetSex(otherAttacker4) == 0
			maleCreatureCount += 1
		Else
			femaleCreatureCount += 1
		EndIf

	EndIf
	
	; Trim actor array
	ActorPositions = PapyrusUtil.ResizeActorArray(ActorPositions, 2 + otherAttackersCount)

	; Build Gender Tag
	; We should have established that animations are available using TestCreatures()
	; before calling this so we will skip further checks to save time
	String genderTag = "FC"
	If VictimRoll == 0
		maleVictimCount = 1
		genderTag = SexLab.GetGenderTag(0,1,otherAttackersCount+1)
	
	ElseIf VictimRoll == 1
		femaleVictimCount = 1
		genderTag = SexLab.GetGenderTag(1,0,otherAttackersCount+1)
	
	Else
		maleVictimCount = -1
		femaleVictimCount = -1
		genderTag = SexLab.GetGenderTag(1,0,otherAttackersCount+1)
	
	EndIf
	
	If slacConfig.debugSLAC
		String akAttackerRaceKey = GetCreatureRaceKeyString(akAttacker)
		Log("StartCreatureSex found " + otherAttackersCount + " extra " + akAttackerRaceKey + " for " + victimName + " (" + attackerName + ", " + otherAttacker2Name + ", " + otherAttacker3Name + ", " + otherAttacker4Name + ") Tag:" + genderTag +  " [M" + maleVictimCount + ",F:" + femaleVictimCount + ",MC:" +  maleCreatureCount + ",FC" + femaleCreatureCount + "]")
	
	EndIf
	
	; Scene location
	ObjectReference SceneCenter = None
	If akVictim.GetSleepState() > 0
		; Use victim's bed (hopefully)
		SceneCenter = SexLab.FindBed(akVictim, Radius = 100, IgnoreUsed = false)

	ElseIf akVictim.GetSitState() > 0 || akVictim.IsSwimming()
		; Use creature's location
		SceneCenter = akAttacker as ObjectReference

	EndIf

	; Format/convert SLP+ tags
	String SLPPTags = requireTags
	Bool RoughConsensual = False
	; The aggressive tag is only used in a consensual context so it does not need to be fed to SLP+
	If TagListStringHas(SLPPTags, "Aggressive")
		If !nonConsensual
			RoughConsensual = True
		EndIf
		SLPPTags = TagListStringRemove(SLPPTags, "Aggressive")
	EndIf
	If rejectTags != ""
		String[] TempTags = PapyrusUtil.StringSplit(rejectTags,",")
		Int ti = 0
		While ti < TempTags.Length
			If TempTags[ti] != ""
				SLPPTags = TagListStringAdd(SLPPTags, "-" + TempTags[ti])
			EndIf
			ti += 1
		EndWhile
	EndIf
	; Tagging is all over the place in SLP+, so we'll try to trim some consensual animations.
	; this may not be necessary in future, and could even be counterproductive.
	If nonConsensual || RoughConsensual
		SLPPTags = TagListStringAdd(SLPPTags, "-Handjob,-FootJob,-Cunnilingus")
	EndIf

	; Filter animations
	
	; Get all animations for the given creature genders
	; Since the gender tag does not indicate creature gender we will need to get all suitable tagged 
	; anims and then filter them for other appropriate genders. This does not check the NPC gender so 
	; we do that with the gender tag later.
	slacData.ClearSignal(akVictim, "GivingAnal,GettingAnal,GivingBlowjob,GettingBlowjob,GettingCunnilingus,GivingCunnilingus")
	Float filterStartTime = Utility.GetCurrentRealTime()
	sslBaseAnimation[] raceAnims
	String[] SLPPSceneIDs
	Bool TagsSkipped = False
	Actor SubmissiveActor = None
	Int SLPPFallbackState = 0
	If NonConsensual && VictimRoll == 0
		SubmissiveActor = akAttacker
	ElseIf NonConsensual || RoughConsensual
		SubmissiveActor = akVictim
	EndIf
	If !slacConfig.skipFilteringStartSex
		If slacConfig.UsingSLPP()
			; SexLab P+

			; Note that SLP+ does not define non-con animations in the same way as SL, so further
			; refinement may be needed here in future.
			If nonConsensual || RoughConsensual || IncludeAggressive
				SLPPSceneIDs = SexLabRegistry.LookupScenes(ActorPositions, asTags = SLPPTags, akSubmissive = SubmissiveActor, aiFurniturePreference = 1, akCenter = SceneCenter)
			EndIf
			If !nonConsensual || IncludeConsensual
				SLPPSceneIDs = PapyrusUtil.MergeStringArray(SLPPSceneIDs, SexLabRegistry.LookupScenes(ActorPositions, asTags = SLPPTags, akSubmissive = None, aiFurniturePreference = 1, akCenter = SceneCenter), RemoveDupes = True)
			EndIf
			;slacConfig.debugSLAC && Log("StartCreatureSex SLP+ LookupScenes found " + SLPPSceneIDs.Length + " " + slacConfig.CondString(nonConsensual || RoughConsensual,"submissive","consensual") + " scenes for " + attackerName + ", " + victimName + " and " + otherAttackersCount + " others (tags:" + SLPPTags + ")")

			; fallback with/without submissive actor
			If SLPPSceneIDs.Length < 1
				; Get consensual scenes with tags
				SLPPSceneIDs = SexLabRegistry.LookupScenes(ActorPositions, asTags = SLPPTags, akSubmissive = None, aiFurniturePreference = 1, akCenter = SceneCenter)
				
				; Get non-consensual scenes with tags
				String[] TempSLPPSceneIDs = SexLabRegistry.LookupScenes(ActorPositions, asTags = SLPPTags, akSubmissive = akVictim, aiFurniturePreference = 1, akCenter = SceneCenter)
				
				; Flag change alternate scene context
				If nonConsensual && SLPPSceneIDs.Length > 0
					; Non-con -> Con
					SLPPFallbackState = 1
				ElseIf !nonConsensual && TempSLPPSceneIDs.Length > 0
					; Con -> Non-con
					SLPPFallbackState = 2
				EndIf

				; Report
				slacConfig.debugSLAC && Log("StartCreatureSex SLP+ LookupScenes fallback 1 (opposite consent) found " + SLPPSceneIDs.Length + " consensual and " + TempSLPPSceneIDs.Length + " consensual scenes for " + attackerName + ", " + victimName + " and " + otherAttackersCount + " others (tags:" + SLPPTags + ") FallbackState:" + SLPPFallbackState)

				; Merge scene lists
				SLPPSceneIDs = PapyrusUtil.MergeStringArray(SLPPSceneIDs, TempSLPPSceneIDs, RemoveDupes = True)
			EndIf

			; fallback without tags
			If SLPPSceneIDs.Length < 1 && SLPPTags != ""
				String[] TempSLPPSceneIDs
				
				; Get consensual scenes without tags
				If !nonConsensual || IncludeConsensual
					SLPPSceneIDs = SexLabRegistry.LookupScenes(ActorPositions, asTags = "", akSubmissive = None, aiFurniturePreference = 1, akCenter = SceneCenter)
				EndIf

				; Get non-consensual scenes without tags
				If nonConsensual || RoughConsensual || IncludeAggressive
					TempSLPPSceneIDs = SexLabRegistry.LookupScenes(ActorPositions, asTags = "", akSubmissive = SubmissiveActor, aiFurniturePreference = 1, akCenter = SceneCenter)
				EndIf

				; Flag change alternate scene context
				If nonConsensual && SLPPSceneIDs.Length > 0
					; Non-con -> Con
					SLPPFallbackState = 1
				ElseIf !nonConsensual && TempSLPPSceneIDs.Length > 0
					; Con -> Non-con
					SLPPFallbackState = 2
				EndIf

				; Report
				slacConfig.debugSLAC && Log("StartCreatureSex SLP+ LookupScenes fallback 2 (no tags) found " + SLPPSceneIDs.Length + " consensual and " + TempSLPPSceneIDs.Length + " consensual scenes for " + attackerName + ", " + victimName + " and " + otherAttackersCount + " others (tags:" + SLPPTags + ") FallbackState:" + SLPPFallbackState)

				; Merge scene lists
				SLPPSceneIDs = PapyrusUtil.MergeStringArray(SLPPSceneIDs, TempSLPPSceneIDs, RemoveDupes = True)
				TagsSkipped = True
			EndIf

			; fallback with/without submissive actor and without tags
			If SLPPSceneIDs.Length < 1 && SLPPTags != ""
				String[] TempSLPPSceneIDs

				SLPPSceneIDs = SexLabRegistry.LookupScenes(ActorPositions, asTags = "", akSubmissive = None, aiFurniturePreference = 1, akCenter = SceneCenter)
				TempSLPPSceneIDs = SexLabRegistry.LookupScenes(ActorPositions, asTags = "", akSubmissive = akVictim, aiFurniturePreference = 1, akCenter = SceneCenter)
				
				; Flag change alternate scene context
				If nonConsensual && SLPPSceneIDs.Length > 0
					; Non-con -> Con
					SLPPFallbackState = 1
				ElseIf !nonConsensual && TempSLPPSceneIDs.Length > 0
					; Con -> Non-con
					SLPPFallbackState = 2
				EndIf

				; Report
				slacConfig.debugSLAC && Log("StartCreatureSex SLP+ LookupScenes fallback 3 (opposite consent, no tags) found " + SLPPSceneIDs.Length + " consensual and " + TempSLPPSceneIDs.Length + " consensual scenes for " + attackerName + ", " + victimName + " and " + otherAttackersCount + " others (tags:" + SLPPTags + ") FallbackState:" + SLPPFallbackState)

				SLPPSceneIDs = PapyrusUtil.MergeStringArray(SLPPSceneIDs, TempSLPPSceneIDs, RemoveDupes = True)
				TagsSkipped = True
			EndIf
		
			If slacConfig.debugSLAC
				Log("StartCreatureSex SLP+ LookupScenes returned " + SLPPSceneIDs.Length + " scenes for " + attackerName + ", " + victimName + " and " + otherAttackersCount + " others (tags:" + SLPPTags + ") Tags Skipped: " + TagsSkipped)
			Endif

			; End SLP+
		Else
			; SexLab
			; Use Filtering Tags > Genders

			; Build tag lists
			If nonConsensual && !IncludeConsensual
				; Aggressive animations
				requireTags = TagListStringAdd(requireTags,"Aggressive")
			ElseIf !nonConsensual
				; Consensual animations unless the aggressive tag is required in a consensual engagement
				If !TagListStringHas(requireTags,"Aggressive") && !IncludeAggressive
					rejectTags = TagListStringAdd(rejectTags,"Aggressive")
				EndIf
				If IncludeAggressive
					rejectTags = TagListStringRemove(rejectTags,"Aggressive")
				EndIf
				If IncludeConsensual
					requireTags = TagListStringRemove(requireTags,"Aggressive")
				EndIf
			EndIf
		
			; Get all tagged but non-gendered animations
			raceAnims = SexLab.GetCreatureAnimationsByRaceTags(2 + otherAttackersCount, attackerRace, requireTags, rejectTags)
			slacConfig.debugSLAC && Log("StartCreatureSex SL GetCreatureAnimationsByRaceTags (start) returned " + raceAnims.Length + " animations for " + attackerName + ", " + victimName + " and " + otherAttackersCount + " others (require:" + requireTags + " - reject:" + rejectTags + ")")

			; Filter animations for genders if required otherwise keep unfiltered list
			If VictimRoll < 2 && raceAnims.Length > 0
				; Male or Female roll victim
				raceAnims = FilterAnimationListGender(raceAnims, maleVictimCount, femaleVictimCount, maleCreatureCount, femaleCreatureCount)
				slacConfig.debugSLAC && Log("StartCreatureSex SL FilterAnimationListGender (start) returned " + raceAnims.Length + " animations for " + attackerName + ", " + victimName + " and " + otherAttackersCount + " others (require:" + requireTags + " - reject:" + rejectTags + ")")
			Else
				slacConfig.debugSLAC && Log("StartCreatureSex SL FilterAnimationListGender (start) Not used for " + attackerName + ", " + victimName + " and " + otherAttackersCount + " others (require:" + requireTags + " - reject:" + rejectTags + ")")
			EndIf
			
			; Fallback animation selection without tags 
			If raceAnims.Length < 1
				TagsSkipped = True
				slacConfig.debugSLAC && Log("StartCreatureSex SL Normal animation selection found no suitable animations for " + attackerName + ", " + victimName + " and " + otherAttackersCount + " others. Using fallback selection.")
				String report = ""
				If VictimRoll == 1
					; Fallback for female roll uses gender tag
					raceAnims = SexLab.GetCreatureAnimationsByRaceTags(2 + otherAttackersCount, attackerRace, genderTag)
					report = "GetCreatureAnimationsByRaceTags (fallback female roll)"
				ElseIf VictimRoll == 0
					; Fallback for male roll uses gender tag
					raceAnims = SexLab.GetCreatureAnimationsByRaceTags(2 + otherAttackersCount, attackerRace, genderTag)
					report = "GetCreatureAnimationsByRaceTags (fallback male roll)"
					If raceAnims.Length < 1 && VictimGender == 1
						; Fallback to female roll if actor is actually female - as usual, expecting there to always be animations for female NPCs
						genderTag = SexLab.GetGenderTag(0,1,otherAttackersCount+1)
						raceAnims = SexLab.GetCreatureAnimationsByRaceTags(2 + otherAttackersCount, attackerRace, genderTag)
						report = "GetCreatureAnimationsByRaceTags (fallback female base sex)"
					EndIf
				Else
					; Fallback for any sex - does not use gender tag
					raceAnims = SexLab.GetCreatureAnimationsByRace(2 + otherAttackersCount, attackerRace)
					report = "GetCreatureAnimationsByRaceTags (fallback any roll receiver)"
				EndIf
				slacConfig.debugSLAC && Log("StartCreatureSex SL " + report + " returned " + raceAnims.Length + " non-specific animations for " + attackerName + ", " + victimName + " and " + otherAttackersCount + " others (" + genderTag + ")")
			EndIf
			; End SL
		EndIf
	Else
		; Skip filtering
		Log("StartCreatureSex is skipping animation filtering (Other Settings > Compatibility & Fixes) for " + victimName + " and " + attackerName)
		TagsSkipped = True
		If slacConfig.UsingSLPP()
			SLPPSceneIDs = SexLabRegistry.LookupScenes(ActorPositions, asTags = "", akSubmissive = None, aiFurniturePreference = 1, akCenter = akVictim)
			String[] TempSceneIDs = SexLabRegistry.LookupScenes(ActorPositions, asTags = "", akSubmissive = akVictim, aiFurniturePreference = 1, akCenter = akVictim)
			SLPPSceneIDs = PapyrusUtil.MergeStringArray(SLPPSceneIDs, TempSceneIDs, RemoveDupes = True)
			slacConfig.debugSLAC && Log("StartCreatureSex SLP+ LookupScenes (unfiltered) returned " + SLPPSceneIDs.Length + " unfiltered animations for " + attackerName + ", " + victimName + " and " + otherAttackersCount + " others")
		Else
			raceAnims = SexLab.GetCreatureAnimationsByRace(2 + otherAttackersCount, attackerRace)
			slacConfig.debugSLAC && Log("StartCreatureSex SL GetCreatureAnimationsByRace (unfiltered) returned " + raceAnims.Length + " unfiltered animations for " + attackerName + ", " + victimName + " and " + otherAttackersCount + " others")
		EndIf
	EndIf
	
	If slacConfig.debugSLAC
		If slacConfig.UsingSLPP()
			Log("StartCreatureSex SLP+ filtering took " + (Utility.GetCurrentRealTime() - filterStartTime) + " seconds")
			SLPPSceneIDs.Length < 1 && Log("StartCreatureSex SLP+ did not find any animations for " + attackerName + ", " + victimName + " and " + otherAttackersCount + " others with tags: " + SLPPTags)
			slacConfig.debugSLAC && ListScenes(SLPPSceneIDs)
		Else
			Log("StartCreatureSex SL filtering took " + (Utility.GetCurrentRealTime() - filterStartTime) + " seconds")
			raceAnims.Length < 1 && Log("StartCreatureSex SL did not find any animations for " + attackerName + ", " + victimName + " and " + otherAttackersCount + " others with tags req: " + requireTags + ", rej: " + rejectTags + "")
			slacConfig.debugSLAC && ListAnims(raceAnims)
		EndIf
	EndIf
		
	; Signal animation type based on successful tags
	; Note that non-specific animations can include both oral and conventional anims selected randomly
	; so we won't signal unless we know for sure that only specific animations are included.
	; For now, there is no method to indicate direction in same-sex animations as this is difficult to 
	; determine from the info available in the animation tags.
	If SLPPSceneIDs.Length > 0 || raceAnims.Length > 0
		String TempTags = slacConfig.CondString(slacConfig.UsingSLPP(), SLPPTags, requireTags)
		; The consent of the engagement should still be signalled even when using fallback animations. 
		RoughConsensual && slacData.SetSignalBool(akVictim, "RoughConsensual", True)
		; However, we should not be applying details like oral and anal context if we don't know what 
		; sort of animations are involved.
		If !TagsSkipped && !slacConfig.skipFilteringStartSex
			If VictimRoll == 1
				; Female PC/NPC
				If attackerGender == 0 && TagListStringHas(TempTags, "BlowJob")
					slacData.SetSignalBool(akVictim, "GivingBlowjob", True)
				ElseIf attackerGender == 1 && attackerVictim && TagListStringHas(TempTags, "Cunnilingus")
					slacData.SetSignalBool(akVictim, "GivingCunnilingus", True)
				ElseIf attackerGender == 0 && TagListStringHas(TempTags, "Anal")
					slacData.SetSignalBool(akVictim, "GettingAnal", True)
				ElseIf !attackerVictim && TagListStringHas(TempTags, "Cunnilingus")
					slacData.SetSignalBool(akVictim, "GettingCunnilingus", True)
				EndIf
			Else
				; Male PC/NPC
				If attackerGender == 1 && TagListStringHas(TempTags, "Cunnilingus")
					slacData.SetSignalBool(akVictim, "GivingCunnilingus", True)
				ElseIf attackerGender == 0 && !attackerVictim && TagListStringHas(TempTags, "BlowJob")
					slacData.SetSignalBool(akVictim, "GivingBlowjob", True)
				ElseIf attackerVictim && TagListStringHas(TempTags, "Anal")
					slacData.SetSignalBool(akVictim, "GivingAnal", True)
				ElseIf attackerVictim && TagListStringHas(TempTags, "BlowJob")
					slacData.SetSignalBool(akVictim, "GettingBlowjob", True)
				EndIf
			EndIf
		EndIf
	EndIf

	; If there are still no animations at this stage then we'll be relying on SexLab to make a selection

	; Animation selection can take time so we need to make sure nothing has changed in the meantime
	Bool Cancel = False
	
	; Avoid male NPCs in the female position which will happen if the thread is started with no anims supplied
	If !slacConfig.UsingSLPP() && VictimRoll == 0 && raceAnims.Length < 1
		slacConfig.UpdateFailedNPCs(akVictim,"_nomaleanim")
		Log("StartCreatureSex SL No female creature animations could be found for " + victimName + " and " + attackerName + ", male receiver not permitted")
		Cancel = True
	EndIf
	
	; Check one more time that SexLab has not changed state since beginning this process
	If !SexLab.Enabled
		Log("StartCreatureSex SexLab disabled or updating, StartCreatureSex for " + victimName + " and " + attackerName + " interrupted after animation selection.")
		Cancel = True
	EndIf
	
	; or that the Victim/Attacker are already engaged
	If SexLab.IsActorActive(akVictim)
		Log("StartCreatureSex " + victimName + " engaged before " + attackerName + " could begin at triple check")
		Cancel = True
	ElseIf SexLab.IsActorActive(akAttacker)
		Log("StartCreatureSex " + attackerName + " engaged before they could engage " + victimName + " could begin at triple check")
		Cancel = True
	EndIf

	; Possibly protect against suspended script event failure from OnCrossHairRefChange()
	; This seems to affect other mods using this event. The root cause is unknown.
	If isPlayer && !Cancel
		Log("StartCreatureSex unregistering OnCrosshairRefChange event during player animation")
		slacConfig.slacPlayerScript.UnregisterforCrosshairRef()
	EndIf

	; Start Animation
	Bool Started = False
	If !Cancel && slacConfig.UsingSLPP()
		SexLabThread SLPPthread
		If SLPPSceneIDs.Length
			; Animations found
			If SLPPFallbackState == 0
				slacConfig.debugSLAC && Log("StartCreatureSex SLP+ starting thread for " + GetActorNameRefArray(ActorPositions))
				SLPPthread = SexLab.StartSceneEx(ActorPositions, asScenes = SLPPSceneIDs, akSubmissive = SubmissiveActor, asContext = "", akCenter = SceneCenter, aiFurniture = 1, asHook = "slacEngagement")
			Else
				slacConfig.debugSLAC && Log("StartCreatureSex SLP+ Starting thread in fallback state for " + GetActorNameRefArray(ActorPositions) + ". Trying consent switch fallback (was SubmissiveActor:" + SubmissiveActor + ")")
				If SLPPFallbackState == 1
					; Non-con -> Con fallback
					SLPPthread = SexLab.StartSceneEx(ActorPositions, asScenes = SLPPSceneIDs, akSubmissive = None, asContext = "", akCenter = SceneCenter, aiFurniture = 1, asHook = "slacEngagement")
				Else
					; Con -> Non-con fallback
					SLPPthread = SexLab.StartSceneEx(ActorPositions, asScenes = SLPPSceneIDs, akSubmissive = akVictim, asContext = "", akCenter = SceneCenter, aiFurniture = 1, asHook = "slacEngagement")
				EndIf
			EndIf
			;ActorPositions = PapyrusUtil.SliceActorArray(ActorPositions,0,2)
			;SLPPthread = SexLab.StartScene(akPositions = ActorPositions, asTags = "", akSubmissive = SubmissiveActor, akCenter = SceneCenter, aiFurniture = 1, asHook = "slacEngagement")

		Else
			; No animations found

			; final fallback 1
			slacConfig.debugSLAC && Log("StartCreatureSex SLP+ found no animations or has skipped filtering: using fallback StartScene for " + victimName + " and " + attackerName)
			SLPPthread = SexLab.StartScene(ActorPositions, asTags = "", akSubmissive = SubmissiveActor, akCenter = SceneCenter, aiFurniture = 1, asHook = "slacEngagement")

			; final fallback 2
			If !SLPPthread || SLPPthread == None
				slacConfig.debugSLAC && Log("StartCreatureSex SLP+ found no alternative animations using StartScene for " + victimName + " and " + attackerName + " " + slacConfig.CondString(SubmissiveActor == None,"without","with") + " submissive actor")
				If SubmissiveActor
					SubmissiveActor = None
				Else 
					SubmissiveActor = akVictim
				EndIf
				SLPPthread = SexLab.StartScene(ActorPositions, asTags = "", akSubmissive = None, akCenter = SceneCenter, aiFurniture = 1, asHook = "slacEngagement")
			EndIf
		EndIf

		; SexLab P+ start functions currently return None, so we check the victim status instead.
		If SLPPthread
			Started = True
			slacConfig.debugSLAC && Log("StartCreatureSex SLP+ Succeeded: stared SexLab thread for " + victimName + " and " + attackerName + " thread " + SLPPthread)
		Else
			Cancel = True
			slacConfig.debugSLAC && Log("StartCreatureSex SLP+ Failed: could not start SexLab thread for " + victimName + " and " + attackerName + " thread " + SLPPthread)
		EndIf
	ElseIf !Cancel
		; Create SL Thread
		sslThreadModel thread = SexLab.NewThread()
		If !thread
			Log("StartCreatureSex SL could not claim a SexLab thread for " + victimName + " and " + attackerName)
			Cancel = True
		Else
			; Adjust location for sleeping / sitting victims
			thread.CenterOnObject(SceneCenter)
		
			; Add actors
			If VictimRoll == 0
				; Male roll
				thread.AddActor(akVictim, IsVictim = False)
				thread.AddActor(akAttacker, IsVictim = NonConsensual && attackerVictim)
			Else
				; Female roll
				thread.AddActor(akVictim, IsVictim = NonConsensual && !attackerVictim)
				thread.AddActor(akAttacker, IsVictim = False)
			EndIf
			otherAttacker2 != None && thread.AddActor(otherAttacker2)
			otherAttacker3 != None && thread.AddActor(otherAttacker3)
			otherAttacker4 != None && thread.AddActor(otherAttacker4)

			; Add animations
			thread.SetAnimations(raceAnims)
			
			; Set Hook
			thread.SetHook("slacEngagement")
			
			If thread.StartThread()
				Started = True
				slacConfig.debugSLAC && Log("StartCreatureSex SL Succeeded: stared SexLab thread for " + victimName + " and " + attackerName)
			Else
				Cancel = True
				slacConfig.debugSLAC && Log("StartCreatureSex SL Failed: could not start SexLab thread for " + victimName + " and " + attackerName)
			EndIf
		EndIf
	EndIf

	If Cancel
		; Cancel engagement

		; Restore OnCrossHairRefChange event removed before launching SL thread
		If IsPlayer
			Log("StartCreatureSex re-registering OnCrosshairRefChange event after SL scene start failure for player.")
			slacConfig.slacPlayerScript.RegisterForCrosshairRef()
		EndIf

		CleanActor(akAttacker)
		CleanActor(otherAttacker2)
		CleanActor(otherAttacker3)
		CleanActor(otherAttacker4)
		If GetQueueCount(akVictim) < 1
			CleanActor(akVictim)
			UnStripActor(akVictim,nonConsensual)
		EndIf
		Return False
	Else 
		; Success

		; Monitor participants
		If slacConfig.onHitInterrupt
			Monitor(akVictim)
			Monitor(akAttacker)
			Monitor(otherAttacker2)
			Monitor(otherAttacker3)
			Monitor(otherAttacker4)
		EndIf
		
		slacConfig.debugSLAC && Log("StartCreatureSex engagement started: " + victimName + " engaged with " + attackerName + " and " + otherAttackersCount + " others using " + raceAnims.Length + " initial anims")

		; Signal nature of engagement
		slacData.SetSignalBool(akAttacker, "PrincipalCreature", True)
		slacData.SetSignalBool(akVictim, "PrincipalVictim", True)
		slacData.SetSignalBool(akVictim, "NonConsensualVictim", nonConsensual && !attackerVictim)
		slacData.SetSignalBool(akVictim, "NonConsensualAggressor", nonConsensual && attackerVictim)
		slacData.SetSignalBool(akAttacker, "NonConsensualVictim", nonConsensual && attackerVictim)
		slacData.SetSignalBool(akAttacker, "NonConsensualAggressor", nonConsensual && !attackerVictim)
		
		; Update player partner data for struggle option
		If isPlayer
			playerEngaged = True
			playerConsent = !nonConsensual
			playerPartners = new Actor[4]
			playerPartners[0] = akAttacker
			playerPrimaryPartner =  akAttacker
			
			; Creature orgasm tracking not working.
			;If slacConfig.UsingSLPP()
			;	SexLab.TrackActor(akAttacker, "SLACCreatureTrack")
			;	RegisterForModEvent("SLACCreatureTrack_Orgasm", "OnCreatureOrgasm")
			;	SexLab.IsActorTracked(akAttacker) && Log("StartCreatureSex: " + attackerName + " is being tracked for orgasm")
			;Else
				RegisterForModEvent("PlayerTrack_Orgasm", "OnCreatureOrgasm")
				Log("StartCreatureSex: Player is being tracked for orgasm")
			;EndIf
			
			playerPartnersCount = 1
			If otherAttacker2 != None
				playerPartners[1] = otherAttacker2
				playerPartnersCount += 1
			EndIf
			If otherAttacker3 != None
				playerPartners[2] = otherAttacker3
				playerPartnersCount += 1
			EndIf
			If otherAttacker4 != None
				playerPartners[3] = otherAttacker4
				playerPartnersCount += 1
			EndIf
			
			; Struggle if the player has more than 10% Stamina
			playerStruggleStarted = False
			playerCanStruggle = False
			If !playerStruggleFinished && nonConsensual && slacConfig.struggleEnabled && PlayerRef.GetActorValue("Stamina") > (GetMaximumStamina(PlayerRef) / 10)
				playerCanStruggle = True
				playerStruggleStarted = True
				Log("StartCreatureSex player struggle enabled: engaged " + playerEngaged + ", consent " + playerConsent + ", partners " + playerPartnersCount + ", can struggle " + playerCanStruggle)
			EndIf
		EndIf
		
		; Add female (or male receiver) victim as queue target
		If VictimRoll == 1 || (slacConfig.allowNPCMM && VictimRoll == 0)
			If femaleCreatureCount < 1 && !IsQueued(akVictim) && ((isPlayer && slacConfig.queueLengthMaxPC > 0) || (!isPlayer && slacConfig.queueLengthMaxNPC > 0))
				If AddQueueVictim(akVictim)
					Log("StartCreatureSex " + victimName + " queued for more creatures")
				Else
					Log("StartCreatureSex could not queue " + victimName)
				EndIf
			EndIf
		EndIf
		
		; Remove creatures from queues
		RemoveAnyQueuedCreatures(akAttacker,otherAttacker2,otherAttacker3,otherAttacker4)
		
		; Convert remaining PC suitors to queuers
		If IsPlayer && slacConfig.queueLengthMaxPC > 0
			; Remove suitors involved in current animation
			RemoveSuitor(akAttacker)
			RemoveSuitor(otherAttacker2)
			RemoveSuitor(otherAttacker3)
			RemoveSuitor(otherAttacker4)
			
			; Get remaining suitors
			Actor[] CurrentSuitors = GetAllSuitors()
			
			; Add remaining suitors to queue while possible
			Int i = 0
			While i < CurrentSuitors.Length && AddQueueCreature(PlayerRef, CurrentSuitors[i])
				slacData.SetSignalBool(CurrentSuitors[i],"QueuedSuitor",True)
				i += 1
			EndWhile
						
			; Notify
			i > 0 && slacNotify.Show("SuitorQueue", PlayerRef, Group = i > 1)

			Log("StartCreatureSex suitors: " + i + " of " + CurrentSuitors.Length + " suitors added to PC queue")

			; Clear any remaining suitors
			ClearSuitors()
		EndIf

		; Update Last Engage times
		; We potentially want to treat chained engagements as a single act
		; So for now we will only trigger the cooldown when an actor is freed from the process during EndCreatureSex()
		;Float StartSexTime = Utility.GetCurrentRealTime()
		;slacData.SetSessionFloat(akVictim,"LastEngageTime",StartSexTime)
		;slacData.SetSessionFloat(None,"LastEngageTime",StartSexTime)
			
		Return True
	EndIf
EndFunction


; This animation start SL mod event is specifically to enable the struggle meter as beating it before this will break SL
Event OnStartingCreatureSex(int tid, bool HasPlayer)
	; Collect thread information
	Actor[] positions = PapyrusUtil.ActorArray(2)
	String AnimID = ""
	If slacConfig.UsingSLPP()
		; SexLab P+
		SexLabThread SLPPThread = SexLab.GetThread(tid)
		positions = SLPPThread.GetPositions()
		AnimID = SLPPThread.GetActiveScene()

	Else
		; SexLab
		sslThreadController SLThread = SexLab.GetController(tid)
		positions = SLThread.positions
		AnimID = SLThread.Animation.Registry

	EndIf

	; Start player struggle meter
	If HasPlayer && playerStruggleStarted
		;slac_StaminaDrainLongSpell.Cast(PlayerRef)
		Actor[] principals = GetPrincipalActors(positions)
		Actor akAttacker = principals[1]
		If akAttacker && akAttacker != None
			playerCanStruggle = True
			!slacConfig.struggleMeterHidden && WidgetManager.StartMeter(akAttacker)
			slacConfig.slacPlayerScript.RegisterStruggleKeys()
			Log("Player struggle initialised with " + GetActorNameRef(akAttacker))
		EndIf
	EndIF

	; Record latest animation
	If AnimID != ""
		If hasPlayer
			slacConfig.UpdateRecentPCAnims(AnimID)
		Else
			slacConfig.UpdateRecentNPCAnims(AnimID)
		EndIf
	EndIf
EndEvent


; Filter an animation array by given tags
; sslBaseAnimation[] @anims       An array of animations to select from
; String             @tags        A comma delimited list of tags to look for in the list
; String             @rejectTags  A comma delimited list of tags used to exclude animations from the list
; Bool               @requireAll  If True (default) then the returned animations must have all the listed tags, If False then they must have at least one of the tags.
; sslBaseAnimation[] #return      An array of filtered animations.
sslBaseAnimation[] Function FilterAnimationList(sslBaseAnimation[] anims, String tags = "", String rejectTags = "", Bool requireAll = True)
	String[] tagList = PapyrusUtil.StringSplit(tags)
	tagList = PapyrusUtil.ClearEmpty(tagList)
	String[] rejectTagList = PapyrusUtil.StringSplit(rejectTags)
	rejectTagList = PapyrusUtil.ClearEmpty(rejectTagList)
	
	slacConfig.debugSLAC && Log("filtering anims - require: " + PapyrusUtil.StringJoin(tagList,",") + " reject:" + PapyrusUtil.StringJoin(rejectTagList,",") + ")")
	
	; Check tags on input list
	Int i = 0
	Bool[] tagged = Utility.CreateBoolArray(anims.Length)
	While i < anims.Length
		tagged[i] = ((requireAll && anims[i].HasAllTag(tagList)) || (!requireAll && anims[i].HasOneTag(tagList))) && (rejectTagList.Length < 1 || !anims[i].HasOneTag(rejectTagList))
		slacConfig.debugSLAC && Log("anim " + anims[i].Name + " " + PapyrusUtil.StringJoin(anims[i].GetTags(), ",") + " require:" + anims[i].HasAllTag(tagList) + " reject:" + anims[i].HasOneTag(rejectTagList))
		i += 1
	EndWhile
	
	; Build output list
	Int count = PapyrusUtil.CountBool(tagged, True)
	If count > 0
		sslBaseAnimation[] outputAnims = sslUtility.AnimationArray(count)
		i = 0
		Int oi = 0
		While i < tagged.Length
			If tagged[i]
				outputAnims[oi] = anims[i]
				oi += 1
			EndIf
			i += 1
		EndWhile
		
		; Return filtered list
		Return outputAnims
	EndIf
	
	; No animations left, return empty array
	Return sslUtility.AnimationArray(0)
EndFunction
String[] Function FilterScenesByTags(String[] SLPPScenes, String SLPPTags)
	String[] tagList = PapyrusUtil.StringSplit(SLPPTags)
	tagList = PapyrusUtil.ClearEmpty(tagList)

	; Select animations using SexLab P+ tagging system.
	; "TagName" must have, "-TagName" must NOT have, "~TagName" must have at least ONE of.
	Int si = 0
	Bool[] tagged = Utility.CreateBoolArray(SLPPScenes.Length)
	While si < SLPPScenes.Length
		Int ti = 0
		Bool requireOR = False
		Bool tOR = False
		String TagResult = ""
		If SexLabRegistry.IsSceneEnabled(SLPPScenes[si])
			Bool last = False
			While !last && ti < tagList.Length
				requireOR = requireOR || StringUtil.GetNthChar(tagList[ti],0) == "~"
				If StringUtil.GetNthChar(tagList[ti],0) == "-" && SexLabRegistry.IsSceneTag(SLPPScenes[si],StringUtil.Substring(tagList[ti], 1))
					; If a negative tag is found we can skip the rest of the tags
					tagged[si] = False
					last = true
				ElseIf requireOR && !tOR && StringUtil.GetNthChar(tagList[ti],0) == "~" && SexLabRegistry.IsSceneTag(SLPPScenes[si],StringUtil.Substring(tagList[ti], 1))
					; If one OR tag is found we can skip other OR tags but still need to check for positive and negative tags
					tagged[si] = True
					tOR = True
				ElseIf SexLabRegistry.IsSceneTag(SLPPScenes[si],tagList[ti])
					; Even if a positive tag is found we must still look for negative and OR tags
					tagged[si] = True
				EndIf
				If requireOR && !tOR
					; If there are any OR tags must treat the scene as invalid until one is found
					tagged[si] = False
				EndIf
				TagResult = TagResult + tagList[ti] + "(" + StringUtil.Substring(tagList[ti], 1) + "):" + tagged[si] + " "
				ti += 1
			EndWhile
			slacConfig.debugSLAC && Log("FilterScenesByTags: " + SexLabRegistry.GetSceneName(SLPPScenes[si]) + " - FilterTags:" + TagResult + " - AllTags:" + PapyrusUtil.StringJoin(SexLabRegistry.GetSceneTags(SLPPScenes[si]),","))
		Else
			; No need to check
			tagged[si] = False
			slacConfig.debugSLAC && Log("FilterScenesByTags: " + SexLabRegistry.GetSceneName(SLPPScenes[si]) + " - SCENE DISABLED - AllTags:" + PapyrusUtil.StringJoin(SexLabRegistry.GetSceneTags(SLPPScenes[si]),","))
		EndIf
		si += 1
	EndWhile
	
	; Build output array
	Int count = PapyrusUtil.CountBool(tagged, True)
	String[] tempScenes = Utility.CreateStringArray(count)
	If count > 0
		si = 0
		Int oi = 0
		While si < tagged.Length
			If tagged[si]
				tempScenes[oi] = SLPPScenes[si]
				oi += 1
			EndIf
			si += 1
		EndWhile
	EndIf

	Return tempScenes
EndFunction
String[] Function GetAllScenes(Actor[] ActorPositions, String Tags = "", Int FurniturePref = 1, ObjectReference Center = None)
	Actor[] Positions = PapyrusUtil.RemoveActor(ActorPositions, None)
	slacConfig.debugSLAC && Log("GetAllScenes: looking up animation for " + GetActorNameRefArray(Positions))
	String[] SceneIDs = SexLabRegistry.LookupScenes(Positions, asTags = Tags, akSubmissive = None, aiFurniturePreference = FurniturePref, akCenter = Center)
	SceneIDs = PapyrusUtil.MergeStringArray(SceneIDs, SexLabRegistry.LookupScenes(Positions, asTags = Tags, akSubmissive = ActorPositions[0], aiFurniturePreference = FurniturePref, akCenter = Center), RemoveDupes = True)
	Return SceneIDs
EndFunction


; Filter animation list based on gender
; sslBaseAnimation[] @anims             An array of animations to select from
; Int                @Males             Number of male non-creature actors needed
; Int                @Females           Number of female non-creature actors needed
; Int                @MaleCreatures     Number of male creature actors needed
; Int                @FemaleCreatures   Number of female creature actors needed
; sslBaseAnimation[] #return            An array of filtered animations.
; A negative gender count will ignore that gender for filtering.
sslBaseAnimation[] Function FilterAnimationListGender(sslBaseAnimation[] anims, Int Males, Int Females, Int MaleCreatures, Int FemaleCreatures)
	If anims.Length < 1
		; Nothing to filter
		Return anims
	EndIf
		
	sslBaseAnimation[] OutputAnims = sslUtility.AnimationArray(0)
	Int ai = 0
	Int TotalAnims = anims.Length
	While ai < TotalAnims
		;Int TotalPositions = anims[ai].ActorCount()
		Int[] GT = anims[ai].Genders
		String result = "Rejected"
		If (Males == GT[0] || Males < 0) && (Females == GT[1] || Females < 0) && (MaleCreatures == GT[2] || MaleCreatures < 0) && (FemaleCreatures == GT[3] || FemaleCreatures < 0)
			OutputAnims = sslUtility.PushAnimation(anims[ai], OutputAnims)
			result = "Pass"
		EndIf
		slacConfig.debugSLAC && Log("Gender Filter " + anims[ai].Name + " [M:" + GT[0] + ",F:" + GT[1] + ",MC:" + GT[2] + ",FC:" + GT[3] + "] " + result)
		ai += 1
	EndWhile
	
	Return OutputAnims
EndFunction

; Manually strip actor and store stripped forms
; @akActor  Actor: The actor to be stripped of clothing
; @victim   Bool: True if the actor is a victim (depending on SexLab settings this will limit stripping to certain items)
Function StripActor(Actor akActor, Bool victim = True)
	; Stripping/unstripping will not work as expected on unloaded actors
	If !akActor.Is3DLoaded() || !akActor.GetParentCell().IsAttached()
		Return
	EndIf
	
	; Strip victim (if not already stripped)
	If slacConfig.disableSLACStripping
		slacConfig.debugSLAC && Log("All SLAC stripping disabled - " + GetActorNameRef(akActor) + " not stripped")

	ElseIf !akActor.WornHasKeyword(KeywordArmorCuirass) && !akActor.WornHasKeyword(KeywordClothingBody)
		slacConfig.debugSLAC && Log(GetActorNameRef(akActor) + " already naked")
		
	ElseIf slacData.GetPersistFormListCount(akActor,"StripForms") < 1
		Form[] stripSet
		If victim
			; Non-consensual 
			stripSet = SexLab.StripActor(akActor, VictimRef = akActor, DoAnimate = False)
		Else 
			; Consensual - Strip animation
			stripSet = SexLab.StripActor(akActor, DoAnimate = (slacConfig.inviteStripDelayPC > 0))
		EndIf
		
		Int i = 0
		While i < stripSet.Length
			slacData.SetPersistFormList(akActor,"StripForms", stripSet[i])
			i += 1
		EndWhile
		
		slacConfig.debugSLAC && Log("Stripped " + i + " items from " + GetActorNameRef(akActor))
		
		; Wait for the undress animation to finish to prevent breaking invite animation
		!victim && slacConfig.inviteStripDelayPC > 0 && Utility.Wait(slacConfig.inviteStripDelayPC as Float)
	Else
		slacConfig.debugSLAC && Log(GetActorNameRef(akActor) + " already stripped") 
	EndIf
EndFunction


; Manually strip actor and store stripped forms
; @akActor  Actor: The actor to have removed clothing returned
; @victim   Bool: True if the actor is a victim (depending on SexLab settings this may prevent the return of clothing)
Function UnstripActor(Actor akActor, Bool victim = True)
	; Stripping/unstripping will not work as expected on unloaded actors
	If !akActor.Is3DLoaded()
		Return
	EndIf
	
	; Convert
	If StorageUtil.FormListCount(akActor, "SLArousedCreatures.StripForms") > 0
		Int prevCount = StorageUtil.FormListCount(akActor, "SLArousedCreatures.StripForms")
		While prevCount >= 0
			prevCount -= 1
			slacData.SetPersistFormList(akActor,"StripForms",StorageUtil.FormListGet(akActor, "SLArousedCreatures.StripForms", prevCount))
		EndWhile
		StorageUtil.ClearObjFormListPrefix(akActor,"SLArousedCreatures.StripForms")
	EndIf
	
	; Strip victim
	If slacData.GetPersistFormListCount(akActor,"StripForms") > 0
		; Actor was stripped by SLAC
		SexLab.UnStripActor(akActor, slacData.GetPersistFormListArray(akActor,"StripForms"), victim)
		slacConfig.debugSLAC && Log("Unstripped " + slacData.GetPersistFormListCount(akActor,"StripForms") + " items for " + GetActorNameRef(akActor))
		slacData.ClearPersist(akActor,"StripForms")
	Else
		slacConfig.debugSLAC && Log("Nothing to unstrip for " + GetActorNameRef(akActor))
	EndIf
EndFunction


; Check is an actor has been stripped by SLAC
; @akActor  Actor: The actor to be checked
; #return   Bool: True if the actor is currently stripped by SLAC (not is the actor is stripped by any other mod including SexLab)
Bool Function IsStripped(Actor akActor)
	Return slacData.GetPersistFormListCount(akActor,"StripForms") > 0
EndFunction


; Legacy - Remove for v5
; Check is actor is currently in a SLAC-initiated engagement
; @akActor  Actor: The actor to check
; #return   Bool: True if the actor is currently engaged in a SLAC triggered animation
Bool Function IsSLACActive(Actor akActor)
	
	If (SexLab.IsActorActive(akActor) || akActor.GetFactionRank(SexLabAnimatingFaction) > -1) && akActor.IsInFaction(slac_engagedActor)
		; Actor is currently in SLAC-triggered SL animation
		Return True
	EndIf
	
	;clean up
	akActor.RemoveFromfaction(slac_engagedActor)
	Return False
EndFunction


; Check if an actor is currently involved in a SLAC pursuit scene
; @akActor  Actor: The actor to check
; #return   Bool: True if the actor is currently in a SLAC pursuit.
Bool Function IsSLACPursuitActive(Actor akActor)
	Scene actorScene = akActor.GetCurrentScene()
	
	If actorScene && (actorScene == slacConfig.slac_Pursuit_00_scene || actorScene == slacConfig.slac_Pursuit_01_scene)
		; Actor is currently involved in a pursuit scene
		Return True
	ElseIf actorScene && (actorScene == slacConfig.slac_FollowerDialogueScene || actorScene == slacConfig.slac_CreatureDialogueScene)
		; Actor is currently involved in a dialogue pursuit scene
		Return True
	EndIf
	
	Return False
EndFunction


; Adjust struggle on creature orgasm
Event OnCreatureOrgasm(Form ActorRef, Int tid)
	Actor akActor = ActorRef as Actor
	String ActorName = GetActorNameRef(akActor)
	
	; Orgasm tracking not working for either SL or SLP+ right now.
	If slacConfig.UsingSLPP()
		; SexLab P+
	;	Log("OnCreatureOrgasm: SLACCreatureTrack_Orgasm fired on " + ActorName)
	;	SexLab.UnTrackActor(akActor, "OnCreatureOrgasm")
	;	UnRegisterForModEvent("SLACCreatureTrack_Orgasm")
	;	Log("OnCreatureOrgasm: " + ActorName + " orgasm tracking: " + SexLab.IsActorTracked(akActor))
	Else
		; SexLab
		Log("OnCreatureOrgasm: PlayerTrack_Orgasm fired on " + ActorName)
		UnregisterForModEvent("PlayerTrack_Orgasm")
		Log("OnCreatureOrgasm: SL PlayerTrack orgasm tracking stopped")
	EndIf

	; Hide struggle meter
	!slacConfig.struggleMeterHidden && WidgetManager.ObscureNPCMeter()
	slacConfig.slacPlayerScript.RegisterStruggleKeys(False)
EndEvent


; Handle a concluding animation
Event EndingCreatureSex(int tid, bool HasPlayer)
	If HasPlayer
		slacConfig.queueLengthMaxPC > 0 && GetQueueCount(PlayerRef) > 0 && StopPlayer()
		!slacConfig.struggleMeterHidden && WidgetManager.StopMeter()
		slacConfig.slacPlayerScript.RegisterStruggleKeys(False)
		Log("Animation ending for player")
	EndIf
EndEvent


; Handle the conclusion of a SLAC-triggered animation
Event EndCreatureSex(int tid, bool HasPlayer)
	slacConfig.debugSLAC && Log("EndCreatureSex operation (HasPlayer:" + HasPlayer + ")")
	
	; Reset cooldown
	UpdateLastEngageTime()
	Float endTime = Utility.GetCurrentRealTime()
	
	; Restore OnCrossHairRefChange event removed before launching SL thread in StartCreatureSex
	If HasPlayer
		Log("EndCreatureSex reregistering OnCrosshairRefChange event after SL scene with player")
		slacConfig.slacPlayerScript.RegisterForCrosshairRef()
	EndIf

	; The cleanup process can be laggy so we need to know early if the player is exiting an animation
	If HasPlayer
		slacConfig.debugSLAC && Log("EndCreatureSex prep for player handling")
		playerEngaged = False

		; Struggles keys will be reregistered at the start of the next animation, if any
		slacConfig.slacPlayerScript.RegisterStruggleKeys(False)

		If IsQueued(PlayerRef)
			; Prevent player moving between queued scenes
			StopPlayer()
			(slacConfig.queueLengthMaxPC < 1 || GetQueueCount(PlayerRef) < 1) && StartPlayer()
			slacConfig.debugSLAC && Log("EndCreatureSex player queued: queueLengthMaxPC:" + slacConfig.queueLengthMaxPC + ", GetQueueCount(PlayerRef):" + GetQueueCount(PlayerRef))
			; Pause stamina regen
			If !playerConsent && slacConfig.struggleEnabled
				slac_StaminaDrainLongSpell.Cast(PlayerRef)
			EndIf
		EndIf
	EndIf

	Actor[] positions
	Actor akVictim
	Actor lastAttacker
	Int victimGender = 1
	Bool IsAggressive = True

	If slacConfig.UsingSLPP()
		; Get SexLab P+ thread
		SexLabThread SLPPThread = SexLab.GetThread(tid)
		positions = SLPPThread.GetPositions()
		IsAggressive = !SLPPThread.IsConsent()

	Else
		; Get SexLab thread
		sslThreadController thread = SexLab.GetController(tid)
		positions = thread.Positions
		IsAggressive = thread.IsAggressive

	EndIf
	slacConfig.debugSLAC && Log("EndCreatureSex positions: " + GetActorNameRefArray(positions))

	; SLP+ comments suggest the actor list is not in any particular order so we use 
	; signal data applied when starting the thread to ID the principal actors.
	; We'll use the first instance of NPC and/or creature if no signal data is found.
	Actor[] Principals = GetPrincipalActors(positions)
	akVictim = Principals[0]
	lastAttacker = Principals[1]

	; The thread may be tagged as aggressive even if participation was consensual so we use the SLAC signal instead.
	Bool lastNonConsensual = slacData.GetSignalBool(akVictim,"NonConsensualVictim",False)
	
	slacConfig.debugSLAC && Log("EndCreatureSex ending engagement " + GetActorNameRef(akVictim) + " and " + GetActorNameRef(lastAttacker) + " (non-con: " + lastNonConsensual + ", aggressive:" + IsAggressive + ")")
	slacConfig.debugSLAC && IsQueued(akVictim) && Log("EndCreatureSex victim " + GetActorNameRef(akVictim) + " is queued for " + GetQueueCount(akVictim) + " partners")

	; Notify ending
	If positions.Length > 1
		slacNotify.Show("SexEnd", akVictim, lastAttacker, Consensual = !lastNonConsensual, Group = positions.Length > 2)
	EndIf

	; Remove SLAC factions and spells and update session data for creature participants
	Int i = 0
	While i < positions.Length
		If GetIsCreature(positions[i])
			CleanActor(positions[i])
			slacData.SetSessionFloat(positions[i],"LastEngageTime",endTime)
		EndIf
		i += 1
	EndWhile
	
	; Check for queued creatures
	If IsQueued(akVictim) && GetQueueCount(akVictim) > 0
		; Determine consent for next engagement in queue
		Bool nextNonConsensual = lastNonConsensual
		String qConReport = ""
		If (HasPlayer && slacConfig.consensualQueuePC == 0) || (!HasPlayer && slacConfig.consensualQueueNPC == 0)
			; Consensual
			nextNonConsensual = False
			qConReport = "Non-Consensual"
		ElseIf (HasPlayer && slacConfig.consensualQueuePC == 1) || (!HasPlayer && slacConfig.consensualQueueNPC == 1)
			; non-consensual
			nextNonConsensual = True
			qConReport = "Consensual"
		ElseIf (HasPlayer && slacConfig.consensualQueuePC == 2) || (!HasPlayer && slacConfig.consensualQueueNPC == 2)
			; Adaptive
			Int victimArousal = GetActorArousal(akVictim)
			nextNonConsensual = True
			If (HasPlayer && victimArousal > slacConfig.pcArousalMin) || (!HasPlayer && victimArousal > slacConfig.npcArousalMin)
				; Regular threshold
				nextNonConsensual = False
				qConReport = "Adaptive Consensual"
			ElseIf (HasPlayer && slacConfig.orgyModePC && victimArousal > slacConfig.orgyArousalMinPC) || (!HasPlayer && slacConfig.orgyModeNPC && victimArousal > slacConfig.orgyArousalMinNPC)
				; Orgy threshold
				nextNonConsensual = False
				qConReport = "Adaptive Consensual (orgy)"
			Else
				qConReport = "Adaptive Non-Consensual"
			EndIf
		EndIf
			
		; Systematically try to engage each creature in queue, removing failures, until the next 
		; successful engagement or the queue is exhausted.
		; Currently CheckForAutoEngagement() just isn't fast enough so no multi-position animations via queues for now
		; In future we may look at building in an alternate creature pool for FindExtraCreatures()
		Int qi = 0
		While qi < 5
			Actor nextAttacker = GetNextQueueCreature(akVictim)
			Bool AggressiveTag = False
			If HasPlayer && !lastNonConsensual && nextAttacker && slacData.GetSignalBool(nextAttacker,"QueuedSuitor")
				; Consensual override for queued suitors
				nextNonConsensual = False
				qConReport = "Suitor Consensual"
				; Allow for rough consensual animations
				AggressiveTag = slacData.GetSignalBool(akVictim, "RoughConsensual")
				slacConfig.debugSLAC && Log("EndCreatureSex: next queued creature is consensual suitor " + GetActorNameRef(nextAttacker) + " AggressiveTag:" + AggressiveTag)
			EndIf

			If !nextAttacker
				; No more queued creatures - so victim needs to be cleaned, unstripped, etc.
				qi = 5
			ElseIf akVictim.GetDistance(nextAttacker) > (slacConfig.engageRadius * UNITFOOTRATIO)
				; Creature too far from victim. May indicate penning-in or caged creature.
				slacNotify.Show("QueueFail", akVictim, nextAttacker, Consensual = !nextNonConsensual, Group = False)
				slacConfig.UpdateFailedCreatures(nextAttacker,"_distance")
				UpdateFailedPursuitTime(nextAttacker)
				slacConfig.debugSLAC && Log("EndCreatureSex victim " + GetActorNameRef(akVictim) + " test failure on distance to " + GetActorNameRef(nextAttacker) + " (" + akVictim.GetDistance(nextAttacker) + "units > " + (slacConfig.engageRadius * UNITFOOTRATIO) + "/" + slacConfig.slac_EngageRadius.GetValue() + "units)")
			
			ElseIf TestVictim(akVictim,nextAttacker) && StartCreatureSex(akVictim, nextAttacker, nextNonConsensual, requireTags = slacConfig.CondString(AggressiveTag,"Aggressive"))
				; Moving on to next queued creature without cleaning, unstripping, etc.
				; Successfully engaged creatures are removed form the queue by StartCreatureSex()
				
				; Remove pause from stamina regen
				HasPlayer && PlayerRef.DispelSpell(slac_StaminaDrainSpell)
				
				slacConfig.debugSLAC && Log("EndCreatureSex engaging next queued partner " + GetActorNameRef(nextAttacker) + " for " + GetActorNameRef(akVictim) + " Consent: " + qConReport + "(" + nextNonConsensual + ")")
				
				; Notify partner change
				slacNotify.Show("QueueNext", akVictim, nextAttacker, Consensual = !nextNonConsensual, Group = False)
				Return

			Else
				; Failed standard tests
				slacNotify.Show("QueueFail", akVictim, nextAttacker, Consensual = !nextNonConsensual, Group = False)
				
				; Clean invalid creature partner which will remove them from the queue 
				CleanActor(nextAttacker)
				slacConfig.debugSLAC && Log("EndCreatureSex queue creature " + GetActorNameRef(nextAttacker) + " failed to engage while queuing for " + GetActorNameRef(akVictim))

			EndIf
			qi += 1
		EndWhile
		
		; Failed to find valid queuing creature
		slacConfig.debugSLAC && Log("EndCreatureSex victim " + GetActorNameRef(akVictim) + " is queued but no valid partners found in queue")

	Else
		slacConfig.debugSLAC && Log("EndCreatureSex victim " + GetActorNameRef(akVictim) + " not in queue or queue empty")

	EndIf
	
	; Apply exhaustion effect to player
	If HasPlayer
		If (slacConfig.struggleExhaustionMode == 1 && slacConfig.struggleEnabled && !playerConsent && !playerCanStruggle) || \
			(slacConfig.struggleExhaustionMode == 2 && !playerConsent) || \
			slacConfig.struggleExhaustionMode == 3
			; Player Exhausted
			slac_StaminaDrainSpell.Cast(PlayerRef)
			PlayerRef.DamageActorValue("Stamina", 10000.0)
			slacConfig.debugSLAC && Log("EndCreatureSex player exhaustion applied (playerConsent:" + playerConsent + ",playerCanStruggle:" + playerCanStruggle + ",struggleEnabled:" + slacConfig.struggleEnabled + ",struggleExhaustionMode:" + slacConfig.struggleExhaustionMode + ")")
		Else
			; Player Not Exhausted
			slacConfig.debugSLAC && Log("EndCreatureSex player exhaustion disabled (playerConsent:" + playerConsent + ",playerCanStruggle:" + playerCanStruggle + ",struggleEnabled:" + slacConfig.struggleEnabled + ",struggleExhaustionMode:" + slacConfig.struggleExhaustionMode + ")")
		EndIf
		PlayerRef.DispelSpell(slac_StaminaDrainLongSpell)
	EndIf

	; Unstrip victim
	If IsStripped(akVictim)
		UnStripActor(akVictim,IsAggressive)
	EndIf
	
	; Update victim session data
	slacData.SetSessionFloat(akVictim,"LastEngageTime",endTime)
	slacData.SetSessionFloat(None,"LastEngageTime",endTime)
	
	; Reset PC data
	If HasPlayer		
		Log("EndCreatureSex Resetting PC data")
		playerEngaged = False
		playerPartners = new Actor[4]
		playerPrimaryPartner = None
		playerPartnersCount = 0
		playerConsent = True
		playerCanStruggle = True
		playerStruggleStarted = False
		playerStruggleFinished = False
		
		; Hide Partner Stamina Meter
		;!slacConfig.struggleMeterHidden && WidgetManager.StopMeter()
		WidgetManager.StopMeter()
	EndIf

	; Final cleanup
	CleanActor(akVictim)
EndEvent


; Interrupt a SLAC Animation
Function EndCreatureSexPrematurely(Actor akSubject)
	If slacConfig.UsingSLPP()
		SexLabThread SLPPThread = SexLab.GetThreadByActor(akSubject)
		If SLPPthread
			SLPPThread.StopAnimation()
			slacConfig.debugSLAC && Log("EndCreatureSexPrematurely: Ending SLP+ engagement for : " + GetActorNameRef(akSubject))
			Return
		EndIf
	Else
		sslThreadController control = SexLab.GetActorController(akSubject)
		If control != none
			control.EndAnimation(True)
			slacConfig.debugSLAC && Log("EndCreatureSexPrematurely: Ending SL engagement for : " + GetActorNameRef(akSubject))
			Return
		EndIf
	EndIf

	; No running animation - remove any lingering effects or factions
	CleanActor(akSubject)
	slacConfig.debugSLAC && Log("EndCreatureSexPrematurely: " + GetActorNameRef(akSubject) + " not engaged. Effects removed.")
EndFunction


; Pick principal actors from position list returned by SexLab
Actor[] Function GetPrincipalActors(Actor[] positions)
	Int i = positions.Length - 1
	Bool creaturefound = False
	Bool victimfound = False
	Actor[] principals = PapyrusUtil.ActorArray(2)
	While i >= 0
		If !creaturefound && slacData.getSignalBool(positions[i], "PrincipalCreature")
			principals[1] = positions[i]
			creaturefound = True
		ElseIf !victimfound && slacData.getSignalBool(positions[i], "PrincipalVictim")
			principals[0] = positions[i]
			victimfound = True
		ElseIf !creaturefound && GetIsCreature(positions[i])
			principals[1] = positions[i]
		ElseIf !victimfound && GetIsNPC(positions[i])
			principals[0] = positions[i]
		EndIf
		i -= 1
	EndWhile
	Return principals
EndFunction


; End a pursuit quest before engagement - this stops the quest scene and removes the SLAC factions and spells
; Should not be called if an engagement has already started. Use EndPursuitQuestForActor() if the quest is not known.
; @pursuitQuest   The pursuit quest to stop, this will be either slac_Pursuit_00 for the PC or slac_Pursuit_01 for NPCs
; @clean          If False then the actors will not be cleaned - this is not currently useful.
; #return         Currently this will only return False if there is no recognised pursuit quest provided. 
Bool Function EndPursuitQuest(Quest pursuitQuest, Bool clean = True)
	Actor akAttacker
	Actor akAttacker2
	Actor akAttacker3
	Actor akAttacker4
	Actor akVictim
	
	If pursuitQuest
		If pursuitQuest == slacConfig.slac_Pursuit_00 || pursuitQuest == slacConfig.slac_Pursuit_01
			
			If pursuitQuest == slacConfig.slac_Pursuit_00
				akVictim = PlayerRef
				akAttacker = PlayerAttacker.GetActorRef()
				akAttacker2 = PlayerAttacker2.GetActorRef()
				akAttacker3 = PlayerAttacker3.GetActorRef()
				akAttacker4 = PlayerAttacker4.GetActorRef()
			ElseIf pursuitQuest == slacConfig.slac_Pursuit_01
				akVictim = NPCVictim.GetActorRef()
				akAttacker = NPCAttacker.GetActorRef()
				akAttacker2 = NPCAttacker2.GetActorRef()
				akAttacker3 = NPCAttacker3.GetActorRef()
				akAttacker4 = NPCAttacker4.GetActorRef()
			EndIf
			
			pursuitQuest.Stop()
			
		ElseIf pursuitQuest == slacConfig.slac_FollowerDialogue
			akVictim = FollowerDialogueFollowerRef.GetActorRef()
			akAttacker = FollowerDialogueCreatureRef.GetActorRef()
			slacConfig.slac_FollowerDialogueScene.Stop()
			
		ElseIf pursuitQuest == slacConfig.slac_CreatureDialogue
			akVictim = CreatureDialogueVictimRef.GetActorRef()
			akAttacker = CreatureDialogueCreatureRef.GetActorRef()
			Actor FGCreature = CreatureDialogueForcedRef.GetActorRef()
			CreatureDialogueForcedRef.Clear()
			FGCreature && FGCreature.EvaluatePackage()
			slacConfig.slac_CreatureDialogueScene.Stop()
			slacConfig.slac_CreatureDialogueSignal.SetValue(0)
			
		Else
			Return False
		EndIf
		
		; Remove any lingering effects or factions
		If clean
			CleanActor(akVictim)
			CleanActor(akAttacker)
			CleanActor(akAttacker2)
			CleanActor(akAttacker3)
			CleanActor(akAttacker4)
		EndIf
		
		; Report
		If slacConfig.debugSLAC
			If akVictim && akAttacker
				Log("Stopping pursuit for " + GetActorNameRef(akVictim) + " and " + GetActorNameRef(akAttacker))
			ElseIf akVictim
				Log("Stopping pursuit for " + GetActorNameRef(akVictim) + " and unknown assailant")
			ElseIf akAttacker
				Log("Stopping pursuit for " + GetActorNameRef(akAttacker) + " and unknown victim")
			EndIf
		EndIf
		
		Return True
	EndIf
	
	Return False
EndFunction


; End a pursuit quest that the actor MIGHT be involved in.
; @akSubject	The actor who might be in a pursuit quest
; @clean
Bool Function EndPursuitQuestForActor(Actor akSubject, Bool clean = True)
	Scene actorScene = akSubject.GetCurrentScene()
	Quest actorQuest
	
	If actorScene
		actorQuest = actorScene.GetOwningQuest()
		If actorQuest
			Return EndPursuitQuest(actorQuest,clean)
		EndIf
	EndIf
	
	Return False
EndFunction


; Remove SLAC related magic effects and factions from an actor
; @akActor     The actor to clean
; @fullClean	If True will also remove any factions or effects that would not normally be removed
Function CleanActor(Actor akActor, Bool fullClean = False)
	If !akActor
		; Missing actor
		Return
	EndIf
	
	If akActor == PlayerRef
		playerEngaged = False
		UnregisterForModEvent("PlayerTrack_Orgasm")
	EndIf
	
	; Remove factions
	akActor.RemoveFromfaction(slac_engagedActor)
	akActor.RemoveFromfaction(slac_victimActor)
	akActor.RemoveFromFaction(slacConfig.slac_InvitingFaction)
	akActor.RemoveFromFaction(slacConfig.slac_InvitedFaction)
	
	; Fix lingering idles so long as the actor is not doing something that depends on 
	; pending animation events - i.e. this will completely break the game for a mounted PC
	If !MenuOpen() && !akActor.IsOnMount() && !akActor.IsWeaponDrawn() && akActor.GetSitState() < 1 && akActor.GetSleepState() < 1 && !akActor.IsSwimming()
		akActor.ClearLookAt()
		Debug.SendAnimationEvent(akActor as ObjectReference,"IdleForceDefaultState")
	EndIf
	
	; Remove from queue
	If IsQueued(akActor)
		If akActor.HasKeyword(slacConfig.slac_QueueingCreature)
			; Creature
			RemoveQueueCreature(akActor)
			slacConfig.debugSLAC && Log("CleanActor: removing queued creature: " + GetActorNameRef(akActor))
		Else
			; NPC
			ClearQueue(akActor)
			slacConfig.debugSLAC && Log("CleanActor: removing queued NPC: " + GetActorNameRef(akActor))
		EndIf
	EndIf
	
	; Remove from suitor list
	IsSuitor(akActor) && RemoveSuitor(akActor)
	
	; Remove from claimed actors
	ReleaseActor(akActor)

	; Remove from monitored actors
	UnMonitor(akActor)
	
	; Remove custom SexLab actor tracking
	SexLab.IsActorTracked(akActor) && SexLab.UntrackActor(akActor,"SLACCreatureTrack")
	
	; Remove debug spells
	akActor.DispelSpell(slac_ScanProcessCreatureDebugSpell)
	akActor.RemoveSpell(slac_ScanProcessCreatureDebugSpell)
	
	; Remove Stamina Pause Spell
	akActor.DispelSpell(slac_StaminaDrainLongSpell)
	
	; Legacy - Should be removed before next beta
	akActor.DispelSpell(slac_ActiveActorSpell)
	akActor.RemoveSpell(slac_ActiveActorSpell)
	akActor.DispelSpell(slac_ActiveCreatureSpell)
	akActor.RemoveSpell(slac_ActiveCreatureSpell)
	akActor.DispelSpell(slac_IgnoreSpell)
	akActor.RemoveSpell(slac_IgnoreSpell)
	
	; Remove signal data - this data is only supposed to persist from pursuit to the end of animation with last queued partner.
	slacData.ClearSignal(akActor)
	
	If fullClean
		; Remove persistent SLAC-related factions and data
		akActor.RemoveFromfaction(slacConfig.slac_LastBribeDayFaction)
		akActor.RemoveFromfaction(slacConfig.slac_LastIntimidateDayFaction)
		akActor.RemoveFromfaction(slacConfig.slac_LastPersuadeDayFaction)
		akActor.RemoveFromfaction(slacConfig.slac_AutoEngageBlockedFaction)
		akActor.RemoveFromfaction(slacConfig.slac_AutoEngagePermittedFaction)
		
		; Remove magic effects
		akActor.DispelSpell(slac_StaminaDrainSpell)

		; Remove session data - normally kept until next game load
		slacData.ClearSession(akActor)
		
		; Reverse SLAC-disabled activation for horses
		EnableActorActivation(akActor)
	
		If IsStripped(akActor)
			UnStripActor(akActor)
		EndIf
	EndIf
	
	If akActor == PlayerRef
		Log("Cleaning player data")
		playerEngaged = False
		playerStruggleStarted = False
		
		; Allow PC to move
		StartPlayer()
		;Game.EnablePlayerControls(abMovement = True, abActivate = True)
		;Game.EnablePlayerControls(1,0,0,0,0,0,1)
		
		; Clean up struggle data
		playerCanStruggle = True
		playerPartners = new Actor[4]
		playerPrimaryPartner = None
		playerPartnersCount = 0
	EndIf
	
	slacConfig.debugSLAC && Log(GetActorNameRef(akActor) + " " + slacConfig.CondString(fullClean,"fully cleaned","cleaned"))

	Return
EndFunction

; Reset cooldown
Float Function UpdateLastEngageTime(Float newTime = -1.0)
	If newTime < 0.0
		newTime = Utility.GetCurrentRealTime()
	EndIf
	slac_LastEngageTime.SetValue(newTime)
	Return newTime
EndFunction

; Update Failed Pursuit time
Function UpdateFailedPursuitTime(Actor Subject)
	If slacConfig.FailedPursuitCooldown >= 60
		slacData.SetSessionFloat(Subject, "LastFailedPursuitTime", Utility.GetCurrentRealTime())
		Return
	EndIf
	slacData.ClearSession(Subject, "LastFailedPursuitTime")
EndFunction

; Check last engage time cooldown for actor or globally.
; Everything is calculated in seconds.
; Return:
; True = On Cooldown
; False = Off Cooldown
Bool Function CheckCooldown(Actor subject = None, Int cooldown, Float time = 0.0, String datakey = "LastEngageTime")
	If time == 0.0
		time = Utility.GetCurrentRealTime()
	EndIf
	If time - slacData.GetSessionFloat(subject, datakey, 0.0 - cooldown) < cooldown
		Return True
	EndIf
	slacData.ClearSession(subject, datakey)
	slacData.ClearPersist(subject, datakey)
	Return False
EndFunction


; ===================================
; =                                 =
; =           Monitoring            =
; =                                 =
; ===================================

; Add actor to monitor quest alias
; This replaces the old method of catching actor events that used ActiveMagicEffects
; Return true on success or if the actor is already monitored
Bool Function Monitor(Actor monitorActor = none)
	If !monitorActor || !slacConfig.onHitInterrupt
		Return False
	ElseIf monitorActor.HasKeyword(slac_ActorMonitored)
		slacConfig.debugSLAC && Log("Monitor: actor " + GetActorNameRef(monitorActor) + " already monitored")
		Return True
	EndIf
	Int aliasesTotal = slac_Monitor.GetNumAliases()
	Int i = 0
	While i < aliasesTotal
		ReferenceAlias thisRefAlias = slac_Monitor.GetNthAlias(i) as ReferenceAlias
		Actor actorRef = thisRefAlias.GetActorRef() as Actor
		If actorRef == None
			thisRefAlias.ForceRefTo(monitorActor)
			(thisRefAlias as slac_MonitorScript).PrepMonitor()
			Return True
		EndIf
		i += 1
	EndWhile
	slacConfig.debugSLAC && Log("Monitor: failed to monitor " + GetActorNameRef(monitorActor) + " monitor quest full")
	Return False
EndFunction
; Remove actor from monitor quest alias
Function UnMonitor(Actor monitorActor)
	If !monitorActor || !monitorActor.HasKeyword(slac_ActorMonitored)
		Return
	EndIf
	Int aliasesTotal = slac_Monitor.GetNumAliases()
	Bool done = False
	Int i = 0
	While i < aliasesTotal && !done
		ReferenceAlias thisRefAlias = slac_Monitor.GetNthAlias(i) as ReferenceAlias
		Actor actorRef = thisRefAlias.GetActorRef() as Actor
		If actorRef == monitorActor
			thisRefAlias.Clear()
			slacConfig.debugSLAC && Log("Monitor: un-monitoring " + GetActorNameRef(monitorActor))
			Return
		EndIf
		i += 1
	EndWhile
EndFunction
; Clear all monitor aliases
Function ClearAllMonitoredActors()
	Int aliasesTotal = slac_Monitor.GetNumAliases()
	Int count = 0;
	Int i = 0
	While i < aliasesTotal
		ReferenceAlias thisRefAlias = slac_Monitor.GetNthAlias(i) as ReferenceAlias
		Actor actorRef = thisRefAlias.GetActorRef() as Actor
		If actorRef
			thisRefAlias.Clear()
			count += 1
			slacConfig.debugSLAC && Log("Monitor: actor cleared: " + GetActorNameRef(actorRef))
		EndIf
		i += 1
	EndWhile
	slacConfig.debugSLAC && Log("Monitor: actors cleared, total: " + count + " of " + aliasesTotal)
EndFunction
; DEBUG: Dump info on all monitor aliases to log
Function DumpAllMonitoredActors()
	Int aliasesTotal = slac_Monitor.GetNumAliases()
	Int count = 0;
	Int i = 0
	While i < aliasesTotal
		ReferenceAlias thisRefAlias = slac_Monitor.GetNthAlias(i) as ReferenceAlias
		thisRefAlias && slacConfig.debugSLAC && Log("Monitor: monitored actor: (" + i + ") " + GetActorNameRef(thisRefAlias.GetActorRef() as Actor))
		i += 1
	EndWhile
	slacConfig.debugSLAC && Log("Monitor: actors dumped, total: " + count + " of " + aliasesTotal)
EndFunction


; ===================================
; =                                 =
; =         Claimed Actors          =
; =                                 =
; ===================================

; Add actor to claiming scene quest alias
; This does nothing directly for SLAC. It is intended as a forward-compatible method to indicate that other
; mods should not try to use this actor. This can be done by simply checking if the actor is involved in a 
; running scene before acting.
; Note the similarity to the Monitor functions above. It was decided not to combine monitoring and claiming
; as monitoring includes script attachment, which we would prefer to avoid where possible.
; Return true on success or if the actor is already claimed
Bool Function ClaimActor(Actor ClaimedActor = none)
	If !slacConfig.claimActiveActors || !ClaimedActor
		Return False
	ElseIf IsClaimed(ClaimedActor)
		slacConfig.debugSLAC && Log("Claimed Actors: actor " + GetActorNameRef(ClaimedActor) + " already claimed")
		Return True
	EndIf
	Int aliasesTotal = slac_Claimed.GetNumAliases()
	Int i = 0
	While i < aliasesTotal
		ReferenceAlias thisRefAlias = slac_Claimed.GetNthAlias(i) as ReferenceAlias
		Actor actorRef = thisRefAlias.GetActorRef() as Actor
		If actorRef == None
			thisRefAlias.ForceRefTo(ClaimedActor)
			slac_Claimed.IsRunning() || slac_Claimed.Start()
			slac_ClaimedScene.IsPlaying() || slac_ClaimedScene.Start()
			slacConfig.debugSLAC && Log("Claimed Actors: actor " + GetActorNameRef(ClaimedActor) + " claimed (" + IsClaimed(ClaimedActor) + "," + slac_ClaimedScene.IsPlaying() + ")")
			Return True
		EndIf
		i += 1
	EndWhile
	slacConfig.debugSLAC && Log("Claimed Actor: failed to claim actor " + GetActorNameRef(ClaimedActor) + " claimed quest full")
	Return False
EndFunction

; Check if actor is claimed
Bool Function IsClaimed(Actor akActor)
	If akActor.HasKeyword(slac_ClaimedActor)
		slac_Claimed.IsRunning() || slac_Claimed.Start()
		slac_ClaimedScene.IsPlaying() || slac_ClaimedScene.Start()
		Return True
	EndIf
	Return False
EndFunction

; Remove actor from claimed actor quest alias
Function ReleaseActor(Actor ClaimedActor)
	If !ClaimedActor || !IsClaimed(ClaimedActor)
		Return
	EndIf
	Int aliasesTotal = slac_Claimed.GetNumAliases()
	Bool done = False
	Int i = 0
	While i < aliasesTotal && !done
		ReferenceAlias thisRefAlias = slac_Claimed.GetNthAlias(i) as ReferenceAlias
		Actor actorRef = thisRefAlias.GetActorRef() as Actor
		If actorRef == ClaimedActor
			thisRefAlias.Clear()
			slac_Claimed.IsRunning() || slac_Claimed.Start()
			slac_ClaimedScene.IsPlaying() || slac_ClaimedScene.Start()
			slacConfig.debugSLAC && Log("Claimed Actor: released " + GetActorNameRef(ClaimedActor))
			Return
		EndIf
		i += 1
	EndWhile
EndFunction

; Clear all claimed aliases
Int Function ReleaseAllClaimedActors()
	Int aliasesTotal = slac_Claimed.GetNumAliases()
	Int count = 0;
	Int i = 0
	While i < aliasesTotal
		ReferenceAlias thisRefAlias = slac_Claimed.GetNthAlias(i) as ReferenceAlias
		Actor actorRef = thisRefAlias.GetActorRef() as Actor
		If actorRef
			thisRefAlias.Clear()
			count += 1
			slacConfig.debugSLAC && Log("Claimed Actors: clearing all - actor " + GetActorNameRef(actorRef) + " released")
		EndIf
		i += 1
	EndWhile
	slacConfig.debugSLAC && Log("Claimed Actors: actors released, total: " + count + " of " + aliasesTotal)
	Return count
EndFunction

; Test all claimed actors and release any that release any improper claims.
; Return number of remaining claimed actors
Int Function UpdateClaimedActors()
	Int aliasesTotal = slac_Claimed.GetNumAliases()
	Int count = 0;
	Int usedTotal = 0;
	Int i = 0
	While i < aliasesTotal
		ReferenceAlias thisRefAlias = slac_Claimed.GetNthAlias(i) as ReferenceAlias
		Actor actorRef = thisRefAlias.GetActorRef() as Actor
		If actorRef
			usedTotal += 1
			If actorRef.IsInFaction(slac_engagedActor)
				; Engaged
			ElseIf slacConfig.claimQueuedActors && (actorRef.HasKeyword(slacConfig.slac_QueueingVictim) || actorRef.HasKeyword(slacConfig.slac_QueueingCreature))
				; Queued with claim
			ElseIf slacConfig.claimQueuedActors && actorRef.HasKeyword(slacConfig.slac_SuitorCreature)
				; Suitor with claim
			ElseIf actorRef.IsInFaction(slacConfig.slac_InvitingFaction) || actorRef.IsInFaction(slacConfig.slac_InvitedFaction)
				; Inviting or invited
			Else
				thisRefAlias.Clear()
				count += 1
				slacConfig.debugSLAC && Log("Claimed Actors Validation: " + GetActorNameRef(actorRef) + " cleared")
			EndIf
		EndIf
		i += 1
	EndWhile
	slac_Claimed.IsRunning() || slac_Claimed.Start()
	slac_ClaimedScene.IsPlaying() || slac_ClaimedScene.Start()
	slacConfig.debugSLAC && Log("Claimed Actors Validation: " + count + " of " + usedTotal + " were released")
	Return usedTotal - count
EndFunction

; DEBUG: Dump info on all claimed aliases to log
Function DumpAllClaimedActors()
	Int aliasesTotal = slac_Claimed.GetNumAliases()
	Int count = 0;
	Int i = 0
	While i < aliasesTotal
		ReferenceAlias thisRefAlias = slac_Claimed.GetNthAlias(i) as ReferenceAlias
		thisRefAlias && slacConfig.debugSLAC && Log("Claimed Actors: claimed actor: (" + i + ") " + GetActorNameRef(thisRefAlias.GetActorRef() as Actor))
		i += 1
	EndWhile
	slacConfig.debugSLAC && Log("Claimed Actors: actors dumped, total: " + count + " of " + aliasesTotal + " - Scene Playing: " + slac_ClaimedScene.IsPlaying())
EndFunction


; ===================================
; =                                 =
; =            Scanning             =
; =                                 =
; ===================================

; Run Scan
; Fill global questCreatures array with nearby creatures
Int Function ScanCreatures()
	LastScanProcessTime = Utility.GetCurrentRealTime()
	
	If slac_Scan.IsRunning()
		Log("Scan already running, halting and returning 0")
		slac_Scan.Reset()
		slac_Scan.Stop()
		Return 0
	EndIf
	
	; Start Scan quest - function must not return until slac_Scan.Stop() is called
	Float scanStartTime = Utility.GetCurrentRealTime()
	slac_ScanCloakCreatureSpell.Cast(PlayerRef,PlayerRef)
	slac_Scan.Start()
	Utility.Wait(0.2)
	
	; Collect creatures
	Int i = 0
	questCreatures = PapyrusUtil.ActorArray(slacConfig.creatureCountMax)
	Int found = 0
	While i < questCreatures.length && slacConfig.modActive
		; Convert alias to actor ref
		; We won't bother skipping invalid aliases as the work required is the same either way.
		ReferenceAlias refAlias = slac_Scan.GetNthAlias(i) as ReferenceAlias
		Actor akAttacker = refAlias.GetActorRef() as Actor
		If akAttacker
			questCreatures[i] = akAttacker
			found += 1
		EndIf
		LastScanProcessTime = Utility.GetCurrentRealTime()
		i += 1
	EndWhile
	
	; Reset Scan quest
	PlayerRef.DispelSpell(slac_ScanCloakCreatureSpell)
	slac_Scan.Reset()
	slac_Scan.Stop()
	slacConfig.debugSLAC && Log("Quest alias scan found " + found + " out of " + slac_Scan.GetNumAliases() + " creatures in " + ((Utility.GetCurrentRealTime() - scanStartTime) as Int) + "secs")
	Return found
EndFunction

; Process creatures captured by the slac_Scan quest aliases - returns True if engagements are checked
Bool Function ProcessCreatureQuestAliases()
	Actor[] tempCreatures = questCreatures
	LastScanProcessTime = Utility.GetCurrentRealTime()
	Float checkStartTime = LastScanProcessTime
	Armor BodySlotArmor = GetEquippedArmor(PlayerRef, "Body")
	Bool Dressed = BodySlotArmor && slacData.GetPersistInt(BodySlotArmor,"ArmorClassOverride",BodySlotArmor.GetWeightClass()) != 3

	; Iterate through creatures array and have them look for victims.
	Int i = 0
	Int creaturesFound = 0
	While i < tempCreatures.length && creaturesFound < slacConfig.creatureCountMax && slacConfig.modActive
		Actor akAttacker = tempCreatures[i]
		If akAttacker
			
			; Debug shader
			slacConfig.debugScanShaders && slac_ScanProcessCreatureDebugSpell.Cast(akAttacker,akAttacker)
			
			; Check for engagement
			Bool Engagement = False
			If slacConfig.pcActive || slacConfig.npcActive
				Engagement = CheckForAutoEngagement(akAttacker)
			EndIf
			
			; Check for possible suitor instead
			If !Engagement && slacConfig.suitorsMaxPC > 0
				If (PlayerRef.IsSneaking() && slacConfig.suitorsPCCrouchEffect != 2) || (!PlayerRef.IsSneaking() && slacConfig.suitorsPCCrouchEffect != 1)
					If !slacConfig.suitorsPCOnlyNaked || !Dressed
						!SexLab.IsActorActive(PlayerRef) && !IsQueued(PlayerRef) && !slacConfig.AutoToggleState && CheckForNewSuitor(akAttacker) && slacConfig.ClaimQueuedActors && ClaimActor(akAttacker)
					EndIf
				EndIf
			EndIf

			creaturesFound += 1
		EndIf
		LastScanProcessTime = Utility.GetCurrentRealTime()
		i += 1
	EndWhile
	
	Float checkDuration = Utility.GetCurrentRealTime() - checkStartTime
	slacConfig.UpdateExecutionTimes(checkDuration)
	!slacConfig.modActive && Log("Aroused Creature deactivated: ending current scan")
	Log("Creature process duration: " + (checkDuration as Int) + "secs")
	
	Return True
EndFunction


; This replicated the behaviour of SexLab's actor collection system.
; By Contrast this one works more like the creature scanning system by simply collected a large group of actors near a reference actor.
; For now this only works on Actors due to limited spell/effect control on other objects.
; This should be called via FindNPCs() which takes an actor as an argument to avoid casting.
; THIS IS NOT THREAD SAFE, it should only be called from within this script and never from anything in events other than the OnUpdate() process in the player script.
Actor[] Function ProcessNPCQuestAliases(ObjectReference centerRef, Float radius = 1000.0, Int gender = 1)
	Actor[] foundActors = PapyrusUtil.ActorArray(0)
	If !centerRef || centerRef == None
		Log("ProcessNPCQuestAliases: No center ref for NPC Scan")
		Return foundActors
	EndIf

	Actor centerRefActor = centerRef as Actor
	If !centerRefActor.Is3DLoaded() || !centerRefActor.GetParentCell().IsAttached() || centerRefActor.GetDistance(PlayerRef) > 10000.0
		Log("ProcessNPCQuestAliases: Center ref not appropriate actor for NPC Scan (before reset)")
		Return foundActors
	EndIf
	
	; Prep scan
	slac_ScanNPCFindGender.SetValue(gender)
	; For cloak spell Magnitude is interpreted as radius in feet
	slac_ScanCloakNPCSpell.SetNthEffectMagnitude(0, radius / UNITFOOTRATIO) ; Debug shader
	slac_ScanCloakNPCSpell.SetNthEffectMagnitude(1, radius / UNITFOOTRATIO) ; Keyword effect
	slac_ScanNPC.Stop()

	If !centerRefActor.Is3DLoaded() || !centerRefActor.GetParentCell().IsAttached() || centerRefActor.GetDistance(PlayerRef) > 10000.0
		Log("ProcessNPCQuestAliases: Center ref not appropriate actor for NPC Scan (after reset)")
		Return foundActors
	EndIf

	; Start Scan
	slac_ScanCloakNPCSpell.Cast(centerRefActor,centerRefActor)
	slac_ScanNPC.Start()
	Utility.Wait(0.1)
	
	; Collect found actors
	Int availableAliases = slac_ScanNPC.GetNumAliases()
	Int i = 0
	While i < availableAliases && slacConfig.modActive
		ReferenceAlias refAlias = slac_ScanNPC.GetNthAlias(i) as ReferenceAlias
		Actor npcActor = refAlias.GetActorRef() as Actor
		If npcActor
			foundActors = PapyrusUtil.PushActor(foundActors, npcActor)
			slacConfig.debugSLAC && Log("ProcessNPCQuestAliases: Checking " + (i + 1) + "/" + availableAliases + " " + GetActorNameRef(npcActor))
		EndIf
		i += 1
	EndWhile

	; Stop Scan
	slac_ScanNPC.Stop()
	centerRefActor.DispelSpell(slac_ScanCloakNPCSpell)
	
	slacConfig.debugSLAC && Log("ProcessNPCQuestAliases located " + foundActors.Length + " actors within " + (radius / UNITFOOTRATIO) + "ft of " + GetActorNameRef(centerRefActor))
	
	Return foundActors
EndFunction

; Use this short-cut for searching with an actor as the center
; For now this is the only way to search as the ObjectReference must have spell control functions
Actor[] Function FindNPCs(Actor actorRef, Float radius = 1000.0, Int gender = 1)
	Return ProcessNPCQuestAliases(actorRef as ObjectReference, radius, gender)
EndFunction

; Helper function to replace Ignored actors functionality in previous version - must be called separately on returned actor array.
Actor[] Function RemoveActorsFromArray(Actor[] actorsArray, Actor[] discardActors)
	actorsArray = PapyrusUtil.RemoveActor(actorsArray, None)
	discardActors = PapyrusUtil.RemoveActor(discardActors, None)
	
	If actorsArray.Length < 1 || discardActors.Length < 1
		Return actorsArray
	EndIf
	
	Int i = 0;
	While i < discardActors.Length && actorsArray.Length > 0
		If discardActors[i]
			actorsArray = PapyrusUtil.RemoveActor(actorsArray, discardActors[i])
		EndIf
		i += 1
	EndWhile
	Return actorsArray
EndFunction


; ===================================
; =                                 =
; =     Animation & Interaction     =
; =                                 =
; ===================================

; Track current animations for Aggressive toggles config
Event AnimationUpdate(int tid, bool hasPlayer)
	String AnimID = ""
	If slacConfig.UsingSLPP()
		; SexLab P+
		SexLabThread SLPPThread = SexLab.GetThread(tid)
		AnimID = SLPPThread.GetActiveScene()
	Else
		; SexLab
		sslThreadController SLThread = SexLab.GetController(tid)
		AnimID = SLThread.Animation.Registry
	EndIf

	If AnimID != ""
		If hasPlayer
			slacConfig.UpdateRecentPCAnims(AnimID)
		Else
			slacConfig.UpdateRecentNPCAnims(AnimID)
		EndIf
	EndIf
EndEvent


; Shortcut functions to refine disabling of PC in future
Function StopPlayer()
	Game.SetPlayerAiDriven()
EndFunction
Function StartPlayer()
	Game.SetPlayerAiDriven(False)
EndFunction


; Play Invite Animation - the animation may be distorted by reapplication of head tracking by the game
; Actor @inviter	 The NPC actor that will be playing the invite animation
; Actor @invited   (Optional) the invited actor that the animation will be rotated to address.
; This has been pushed out into another script to allow for customisation without having to replace slac_Utility
Function PlayInviteAnimation(Actor inviter, Actor invited = none)
	slacAnimation.PlayInviteAnimation(inviter,invited)
EndFunction

; Stop Invite Animation
Function StopInviteAnimation(Actor inviter, Actor invited = None)
	slacAnimation.StopInviteAnimation(inviter,invited)
EndFunction


; Immersively force dismount player from horse
; This is only for the player at the moment as doing this for NPCs causes issues which AI behaviour
; and can conflict with functions in some horse mods like Simple Horse that despawn follower mounts.
Function BuckPlayer()
	If PlayerRef.IsInCombat() || PlayerRef.GetCombatState() > 0
		Log("Bucking: in combat - cancelling refusal")
		Return
	EndIf
	
	If Utility.GetCurrentRealTime() < BuckingDelayTimePC
		; Wait for failed dismount safety delay to expire
		Log("Bucking: dismount delayed")
		Return
	EndIf

	BuckingDelayTimePC = 0.0

	If BuckingInProgressPC
		; Clear safety even if bucking is already processing. More than two consecutive bucking triggers
		; within the bucking window is unlikely and we prefer to avoid accidentally blocking all bucking.
		BuckingInProgressPC = False
		Log("Bucking: in progress")	
		Return
	EndIf

	Actor playerHorse = Game.GetPlayersLastRiddenHorse()

	If playerHorse
		slacConfig.debugSLAC && Log("Bucking: player horse " + GetActorNameRef(playerHorse))

		; Prevent consecutive bucking animations
		BuckingInProgressPC = True
		
		; Wait for triggering mount animation to finish
		; The riding trigger is not time-dependant so this delay will not matter
		Utility.Wait(2.0)
		
		; Make sure this is actually a horse to avoid trying to play an incompatible animation
		If !playerHorse.HasKeyword(ActorTypeHorse)
			slacConfig.debugSLAC && Log("Bucking: Bucking animations cancelled, " + GetActorNameRef(playerHorse) + " is not a horse")	
		Else
			; Horse rearing animation
			playerHorse.PlayIdle(HorseIdleRearUp)
		EndIf
		
		; Timing for sensible dismount
		Utility.Wait(1.0)
		
		; Dismount and signal for automated sex triggered by animation event
		; Sex on dismount is asynchronous, so we need to signal before attempting dismount in case the 
		; function does not return before the animation event triggers.
		slacData.SetSignalBool(PlayerRef, "HorseRefusalDismount", True)

		; Attempt dismount
		If PlayerRef.Dismount()
			Log("Bucking: dismount success")
		Else
			; Reset and wait for thirty seconds before trying again.
			Log("Bucking: dismount failure. Delaying further attempts for 30s.")
			BuckingDelayTimePC = Utility.GetCurrentRealTime() + 30
			slacData.ClearSignal(PlayerRef, "HorseRefusalDismount")
		EndIf
		
		; Show message even if dismount failed. This should explain the animation to the player.
		slacNotify.Show("HorseBuck", PlayerRef, playerHorse)

		BuckingInProgressPC = False
	Else
		Log("Bucking: could not resolve player's horse")
	EndIf
EndFunction


; Disable / Enable actor activation
; This is currently only used to prevent the PC from mounting a horse when trying to enter dialogue with it.
; These functions record changes using StorageUtil but the record is not currently used
; The proper response to situations where blocking/unblocking interferes with other blocking activity is not clear
Bool Function EnableActorActivation(Actor akActor)
	If akActor && akActor.IsActivationBlocked()
		; Enable activation
		StorageUtil.UnsetIntValue(akActor,"SLArousedCreatures.ActivationBlocked")
		slacData.ClearPersist(akActor,"ActivationBlocked")
		akActor.BlockActivation(False)
		slacConfig.debugSLAC && Log("PC activation allowed for " + GetActorNameRef(akActor))
		Return True
	Endif
	Return False
EndFunction
Function DisableActorActivation(Actor akActor)
	If akActor
		If !akActor.IsActivationBlocked()
			; Disable activation
			slacData.SetPersistBool(akActor,"ActivationBlocked",True)
			akActor.BlockActivation(True)
			slacConfig.debugSLAC && Log("PC activation blocked for " + GetActorNameRef(akActor))
		Endif
	EndIf
EndFunction



; ===================================
; =                                 =
; =             Suitors             =
; =                                 =
; ===================================

; Test potential suitor and add them to the list if eligible
Bool Function CheckForNewSuitor(Actor akSuitor)
	String attackerName = akSuitor.GetLeveledActorBase().GetName()
	String attackerNameRef = GetActorNameRef(akSuitor)
	
	If IsSuitor(akSuitor)
		Log("Suitor: " + attackerNameRef + " already a suitor")
		Return False
		
	ElseIf SexLab.IsActorActive(PlayerRef)
		Log("Suitor: " + attackerNameRef + " cannot attend engaged player")
		Return False
		
	ElseIf !TestSuitor(akSuitor, noisy = True)
		Log("Suitor: " + attackerNameRef + " failed creature test")
		Return False
		
	ElseIf !TestVictim(PlayerRef, akSuitor)
		Log("Suitor: " + attackerNameRef + " failed player test")
		Return False
		
	Else
		If AddSuitor(akSuitor) > -1
			slacNotify.Show("SuitorJoin", PlayerRef, akSuitor, Consensual = True, Group = False)
			Return True
		Else
			Log("No slots available for " + attackerNameRef + " to become a suitor")
		EndIf
	EndIf
	
	Return False
EndFunction

; Add a creature to the list of PC suitors
Int Function AddSuitor(Actor akSuitor, Actor akTarget = None)
	If !akTarget
		akTarget = PlayerRef
	EndIf
	If akSuitor.HasKeyword(slacConfig.slac_SuitorCreature)
		; Already a suitor
		;slacCOnfig.debugSLAC && Log(GetActorNameRef(akSuitor) + " is already a suitor")
		Return -1
	ElseIf CountSuitors() >= slacConfig.suitorsMaxPC
		;slacCOnfig.debugSLAC && Log(GetActorNameRef(akSuitor) + " cannot become a suitor, too many (Max:" + slacConfig.suitorsMaxPC + ")")
		Return -1
	EndIf
	
	Int i = 0
	Int aliasCount = slacConfig.slac_Suitors.GetNumAliases()
	While i < aliasCount
		ReferenceAlias refAlias = slacConfig.slac_Suitors.GetNthAlias(i) as ReferenceAlias
		Actor refAliasActor = refAlias.GetActorRef() as Actor
		If !refAliasActor
			refAlias.ForceRefTo(akSuitor as ObjectReference)
			slacCOnfig.debugSLAC && Log(GetActorNameRef(akSuitor) + " added as suitor " + i)
			Return i
		EndIf
		i += 1
	EndWhile
	Return -1
EndFunction

; Return all current suitors
Actor[] Function GetAllSuitors(Actor akTarget = None)
	If !akTarget
		akTarget = PlayerRef
	EndIf
	
	Actor[] Suitors = PapyrusUtil.ActorArray(0)
	Int i = 0
	Int aliasCount = slacConfig.slac_Suitors.GetNumAliases()
	While i < aliasCount
		ReferenceAlias refAlias = slacConfig.slac_Suitors.GetNthAlias(i) as ReferenceAlias
		Actor refAliasActor = refAlias.GetActorRef() as Actor
		If refAliasActor
			Suitors = PapyrusUtil.PushActor(Suitors, refAliasActor)
		EndIf
		i += 1
	EndWhile
	
	Return Suitors
EndFunction

; Remove a creature from the list of PC suitors
Int Function RemoveSuitor(Actor akSuitor, Actor akTarget = None)
	If !akTarget
		akTarget = PlayerRef
	EndIf
	If !akSuitor || !akSuitor.HasKeyword(slacConfig.slac_SuitorCreature)
		Return -1
	EndIf
	
	Int i = 0
	Int aliasCount = slacConfig.slac_Suitors.GetNumAliases()
	While i < aliasCount
		ReferenceAlias refAlias = slacConfig.slac_Suitors.GetNthAlias(i) as ReferenceAlias
		Actor refAliasActor = refAlias.GetActorRef() as Actor
		If refAliasActor == akSuitor
			refAlias.Clear()
			slacConfig.debugSLAC && Log(GetActorNameRef(akSuitor) + " removed as suitor ")
			Return i
		EndIf
		i += 1
	EndWhile
	Return -1
EndFunction

; Check of creature is suitor
Bool Function IsSuitor(Actor akSuitor, Actor akTarget = None)
	If !akTarget
		akTarget = PlayerRef
	EndIf
	Return akSuitor.HasKeyword(slacConfig.slac_SuitorCreature)
EndFunction

; Return the current number of suitors
Int Function CountSuitors(Actor akTarget = None)
	If !akTarget
		akTarget = PlayerRef
	EndIf
	Int i = 0
	Int aliasCount = slacConfig.slac_Suitors.GetNumAliases()
	Int suitorCount = 0
	While i < aliasCount
		ReferenceAlias refAlias = slacConfig.slac_Suitors.GetNthAlias(i) as ReferenceAlias
		Actor refAliasActor = refAlias.GetActorRef() as Actor
		If refAliasActor
			suitorCount += 1
		EndIf
		i += 1
	EndWhile
	Return suitorCount
EndFunction

; Check if creature is a valid suitor - does NOT test if they are already a suitor
Bool Function TestSuitor(Actor akSuitor, Actor akTarget = None, Bool noisy = False)
	If !akTarget
		akTarget = PlayerRef
	EndIf

	Int SuitorArousal = GetActorArousal(akSuitor)

	If SuitorArousal < slacConfig.creatureCommandThreshold
		noisy && slacConfig.debugSLAC && Log("Suitor test: " + GetActorNameRef(akSuitor) + " is not aroused (" + SuitorArousal + "/" + slacConfig.creatureCommandThreshold + ")")
		Return False

	ElseIf !IsSuitor(akSuitor) && GetActorArousal(akTarget) < slacConfig.suitorsPCArousalMin
		noisy && slacConfig.debugSLAC && Log("Suitor test: the Player is not aroused")
		Return False

	ElseIf !slacConfig.AllowedCreatureActor(akSuitor, akTarget)
		noisy && slacConfig.debugSLAC && Log("Suitor test: " + GetActorNameRef(akSuitor) + " race not allowed")
		Return False

	ElseIf IsQueued(akSuitor)
		noisy && slacConfig.debugSLAC && Log("Suitor test: " + GetActorNameRef(akSuitor) + " in queue")
		Return False

	ElseIf akSuitor.GetDistance(akTarget) > (slacConfig.engageRadius * 1.1) * UNITFOOTRATIO
		noisy && slacConfig.debugSLAC && Log("Suitor test: " + GetActorNameRef(akSuitor) + " is too far from player (" + akSuitor.GetDistance(akTarget) + " > " + (slacConfig.engageRadius * UNITFOOTRATIO) + ")")
		Return False

	ElseIf !slacConfig.suitorsPCAllowFollowers && (akSuitor.IsPlayerTeammate() || akSuitor.IsPlayersLastRiddenHorse())
		noisy && slacConfig.debugSLAC && Log("Suitor test: " + GetActorNameRef(akSuitor) + " is a teammate")
		Return False

	ElseIf !slacConfig.suitorsPCAllowWeapons && akTarget.IsWeaponDrawn()
		noisy && slacConfig.debugSLAC && Log("Suitor test: " + GetActorNameRef(akSuitor) + " rejected due to drawn weapons")
		Return False

	ElseIf SexLab.IsActorActive(akSuitor) 
		noisy && slacConfig.debugSLAC && Log("Suitor test: " + GetActorNameRef(akSuitor) + " already engaged")
		Return False

	ElseIf !TestCreature(akSuitor, invited = True) || !TestVictim(akTarget, akSuitor, inviting = True)
		noisy && slacConfig.debugSLAC && Log("Suitor test: " + GetActorNameRef(akSuitor) + " and/or player failed standard tests")
		Return False

	EndIf

	Return True
EndFunction

; Check all suitors and remove invalid creatures
Function UpdateSuitors(Actor akSuitor = None, Actor akTarget = None)
	If !akTarget
		akTarget = PlayerRef
	EndIf
	
	slacCOnfig.debugSLAC && Log("Updating suitors...")
	
	; Test given suitor
	If akSuitor
		If !TestSuitor(akSuitor)
			RemoveSuitor(akSuitor)
			ReleaseActor(akSuitor)
			slacNotify.Show("SuitorLeave", PlayerRef, akSuitor)
		EndIf
		Return
	EndIf
	
	; Test all current suitors
	Int i = 0
	Int aliasCount = slacConfig.slac_Suitors.GetNumAliases()
	Int activeSuitors = 0
	Bool removedSuitors = False
	While i < aliasCount
		ReferenceAlias refAlias = slacConfig.slac_Suitors.GetNthAlias(i) as ReferenceAlias
		Actor refAliasActor = refAlias.GetActorRef() as Actor
		If refAliasActor
			If activeSuitors > slacConfig.suitorsMaxPC || !TestSuitor(refAliasActor,noisy = True)
				RemoveSuitor(refAliasActor)
				ReleaseActor(refAliasActor)
				removedSuitors = True
			Else
				activeSuitors += 1
			EndIf
		EndIf
		i += 1
	EndWhile
	removedSuitors && slacNotify.Show("SuitorLeave", PlayerRef, Group = True)
	slacCOnfig.debugSLAC && Log("Updating suitors complete (" + activeSuitors + "/" + slacConfig.suitorsMaxPC + ")")
EndFunction

; Clear all suitors
Bool Function ClearSuitors(Actor akTarget = None)
	If !akTarget
		akTarget = PlayerRef
	EndIf
	Int i = 0
	Int aliasCount = slacConfig.slac_Suitors.GetNumAliases()
	Int suitorCount = 0
	While i < aliasCount
		ReferenceAlias refAlias = slacConfig.slac_Suitors.GetNthAlias(i) as ReferenceAlias
		Actor refAliasActor = refAlias.GetActorRef() as Actor
		If refAliasActor
			ReleaseActor(refAliasActor)
			suitorCount += 1
		EndIf
		refAlias.Clear()
		i += 1
	EndWhile
	Log("Cleared " + suitorCount + " suitors")
	Return suitorCount > 0
EndFunction




; ===================================
; =                                 =
; =            Queueing             =
; =                                 =
; ===================================

; Add an NPC as a victim for queueing creatures
; Return True for success.
Bool Function AddQueueVictim(Actor akVictim)
	If akVictim.HasKeyword(slacConfig.slac_QueueingVictim)
		; Already in queue
		slacConfig.debugSLAC && Log("Victim " + GetActorNameRef(akVictim) + " already in queue " + slacData.GetSessionInt(akVictim,"QueueVictimIndex",-1))
		Return False
	EndIf
	
	; Find available victim slot
	Float startTime = Utility.GetCurrentRealTime()
	Int i = 0
	Int usedIndex = -1
	While i <= 24
		ReferenceAlias refAlias = slacConfig.slac_Queue.GetNthAlias(i) as ReferenceAlias
		Actor queuedVictim = refAlias.GetActorRef() as Actor
		If queuedVictim == none
			; Vacant queue
			
			; Clear queue aliases just in case
			ClearQueue(victimIndex = i)
			
			; Add victim
			refAlias.ForceRefTo(akVictim as ObjectReference)
			slacData.SetSessionBool(akVictim,"IsQueueVictim",True)
			slacData.SetSessionInt(akVictim,"QueueVictimIndex",i)
			slacData.SetSessionInt(akVictim,"QueuedCreatures",0)
			
			slacConfig.debugSLAC && Log("Victim " + GetActorNameRef(akVictim) + " added to queue " + i)
			Return True
		EndIf
		i += 6
	EndWhile
	
	; No queue positions available
	slacConfig.debugSLAC && Log("No queues available for " + GetActorNameRef(akVictim) + " (" + (Utility.GetCurrentRealTime() - startTime) + "secs)")
	Return False
EndFunction


; Simple boolean check for queued victim or creature
Bool Function IsQueued(Actor akActor)
	If akActor
		Return akActor.HasKeyword(slacConfig.slac_QueueingVictim) || akActor.HasKeyword(slacConfig.slac_QueueingCreature)
	EndIf
	Return False
EndFunction


; remove victim from queue and clear any remaining creatures
Function ClearQueue(Actor akVictim = None, Int victimIndex = -1)
	If akVictim != None
		victimIndex = slacData.GetSessionInt(akVictim,"QueueVictimIndex",-1)
	EndIf
	
	If victimIndex > -1
		If akVictim == None
			akVictim = GetAliasActor(slacConfig.slac_Queue, victimIndex)
		EndIf
		
		; Clear victim
		If akVictim
			StorageUtil.UnsetIntValue(akVictim, "SLArousedCreatures.IsQueueVictim")
			StorageUtil.UnsetIntValue(akVictim, "SLArousedCreatures.QueueVictimIndex")
			StorageUtil.UnsetIntValue(akVictim, "SLArousedCreatures.QueuedCreatures")
			slacData.ClearSession(akVictim,"IsQueueVictim")
			slacData.ClearSession(akVictim,"QueueVictimIndex")
			slacData.ClearSession(akVictim,"QueuedCreatures")
			ReferenceAlias victimSlot = slacConfig.slac_Queue.GetNthAlias(victimIndex) as ReferenceAlias
			victimSlot.Clear()
			slacConfig.debugSLAC && Log("Queue victim " + GetActorNameRef(akVictim) + " in queue " + victimIndex + " cleared")
		EndIf
		
		; Clear creatures
		; No need to call RemoveQueueCreature() as we are just erasing everything
		Int i = 1
		While i <= 5
			ReferenceAlias queuedCreatureRef = slacConfig.slac_Queue.GetNthAlias(victimIndex + i) as ReferenceAlias
			Actor queuedCreature = queuedCreatureRef.GetActorRef() as Actor
			StorageUtil.UnsetIntValue(queuedCreature, "SLArousedCreatures.IsQueueCreature")
			StorageUtil.UnsetIntValue(queuedCreature, "SLArousedCreatures.QueueCreatureVictimIndex")
			StorageUtil.UnsetIntValue(queuedCreature, "SLArousedCreatures.QueueCreatureIndex")
			slacData.ClearSession(queuedCreature,"IsQueueCreature")
			slacData.ClearSession(queuedCreature,"QueueCreatureVictimIndex")
			slacData.ClearSession(queuedCreature,"QueueCreatureIndex")
			queuedCreatureRef.Clear()
			i += 1
		EndWhile
		
		slacConfig.debugSLAC && Log("Queue " + victimIndex + " cleared. Victim was " + GetActorNameRef(akVictim))
	EndIf
EndFunction
Function ClearAllQueues()
	Int i = 0
	While i < 25
		ClearQueue(victimIndex = i)
		i += 6
	EndWhile
EndFunction

; Add creature to the end of the queue for an actor
; This also tidies the queue to move empty slots to the end
; The indexes of the added creatures will be 1-5,7-11,13-17,25-29
Bool Function AddQueueCreature(Actor akVictim, Actor akCreature)
	Int victimIndex = slacData.GetSessionInt(akVictim,"QueueVictimIndex",-1)
	String victimNameRef = GetActorNameRef(akVictim)
	String creatureNameRef = GetActorNameRef(akCreature)
	
	If victimIndex == -1
		slacConfig.debugSLAC && Log("Could not queue " + creatureNameRef + ", victim " + victimNameRef + " has no queue")
		Return False
	EndIf
	
	; Normalise queue and get current count
	Int count = NormaliseQueue(victimIndex)
	
	If count > 4
		; Queue full
		slacConfig.debugSLAC && Log("Could not queue " + creatureNameRef + " for " + victimNameRef + ", queue " + victimIndex + " is full")
		Return False
	EndIf
	
	; Add new creatures
	ReferenceAlias queueSlot = slacConfig.slac_Queue.GetNthAlias(victimIndex + count + 1) as ReferenceAlias
	queueSlot.ForceRefTo(akCreature as ObjectReference)
	slacData.SetSessionBool(akCreature,"IsQueueCreature", 1)
	slacData.SetSessionInt(akCreature,"QueueCreatureVictimIndex",victimIndex)
	slacData.SetSessionInt(akCreature,"QueueCreatureIndex",victimIndex + count + 1)

	; Update victim data
	slacData.SetSessionInt(akVictim,"QueuedCreatures", count + 1)
	
	If slacConfig.debugSLAC
		Log("Creature " + creatureNameRef + " added to queue " + victimIndex + " for " + victimNameRef + " at " + (victimIndex + count + 1)) 
		DebugQueue(victimIndex)
	EndIf
	
	Return True
EndFunction

; Remove creature from queue which is then normalised and return number of creatures left in queue
Int Function RemoveQueueCreature(Actor akCreature)
	If !akCreature || akCreature == None
		Return 0
	ElseIf !IsQueued(akCreature)
		slacData.ClearSession(akCreature,"IsQueueCreature")
		slacData.ClearSession(akCreature,"QueueCreatureVictimIndex")
		slacData.ClearSession(akCreature,"QueueCreatureIndex")
		Return 0
	EndIf
	
	slacConfig.debugSLAC && Log("Removing " + GetActorNameRef(akCreature) + " from queue")
	Int creatureIndex = slacData.GetSessionInt(akCreature,"QueueCreatureIndex",-1)
	Int victimIndex = slacData.GetSessionInt(akCreature,"QueueCreatureVictimIndex",-1)
	ReferenceAlias queuedCreatureRef

	If victimIndex > -1 && creatureIndex > -1
		queuedCreatureRef = slacConfig.slac_Queue.GetNthAlias(creatureIndex) as ReferenceAlias
	EndIf
	Actor testActor = queuedCreatureRef.GetActorRef()
	
	If victimIndex < 0 || creatureIndex < 0 || testActor != akCreature
		; Incorrect or missing queue info - Something went wrong
		Log(GetActorNameRef(akCreature) + " is in queue but missing queue data: resolving...")
		
		; Find creature's actual queue
		victimIndex = -1
		Int i = 1
		Int total = slacConfig.slac_Queue.GetNumAliases()
		While i < total
			ReferenceAlias tempref = slacConfig.slac_Queue.GetNthAlias(i) as ReferenceAlias
			If tempref && tempref.GetActorRef() == akCreature
				; Creature found
				queuedCreatureRef = tempRef
				creatureIndex = i
				victimIndex = QueueIndexVictimFromCreature(creatureIndex)
				; End Search
				i = total
			EndIf
			i += 1
		EndWhile
		
		slacConfig.debugSLAC && victimIndex > -1 && Log(GetActorNameRef(akCreature) + " found in queue " + victimIndex)
	EndIf
	
	If victimIndex < 0
		slacConfig.debugSLAC && Log("Queue not found for " + GetActorNameRef(akCreature))
		Return 0
	EndIf
	
	; Remove creature from queue
	slacData.ClearSession(akCreature,"IsQueueCreature")
	slacData.ClearSession(akCreature,"QueueCreatureVictimIndex")
	slacData.ClearSession(akCreature,"QueueCreatureIndex")
	queuedCreatureRef.Clear()

	; Normalise queue and get current count
	Int count = NormaliseQueue(victimIndex)
	
	; Update victim data
	Actor queueVictim = GetAliasActor(slacConfig.slac_Queue, victimIndex)
	slacData.SetSessionInt(queueVictim,"QueuedCreatures",count)
	If slacConfig.debugSLAC
		Log(GetActorNameRef(akCreature) + " removed from queue for " + GetActorNameRef(queueVictim) + " (queue " + victimIndex + ")")
		DebugQueue(victimIndex)
	EndIf
	
	Return count
EndFunction

Function RemoveAnyQueuedCreatures(Actor Creature0 = None, Actor Creature1 = None, Actor Creature2 = None, Actor Creature3 = None, Actor Creature4 = None)
	Creature0 && RemoveQueueCreature(Creature0)
	Creature1 && RemoveQueueCreature(Creature1)
	Creature2 && RemoveQueueCreature(Creature2)
	Creature3 && RemoveQueueCreature(Creature3)
	Creature4 && RemoveQueueCreature(Creature4)
EndFunction

Int Function QueueIndexVictimFromCreature(Int creatureIndex)
	Return creatureIndex - (creatureIndex % 6)
EndFunction

; Normalise Queue - remove gaps in queue and return number of queued creatures
; This is not going to be thread-safe any time soon. EndCreatureSex() fires RemoveQueueCreature() which then fires 
; NormaliseQueue(). Any overlap could result in a creature's position in a queue being overridden giving them queue 
; data without a queue. So we need to look for that on subsequent scans.
Int Function NormaliseQueue(Int victimIndex)
	If (victimIndex % 6) != 0
		; Not a victim index
		slacConfig.debugSLAC && Log("Queue Normalisation: " + victimIndex + " is not a valid queue victim index")
		Return -1
	EndIf
	String victimNameRef = GetActorNameRef(GetAliasActor(slacConfig.slac_Queue,victimIndex))
	slacConfig.debugSLAC && Log("Queue Normalisation at victim index " + victimIndex + " for " + victimNameRef)
	slacConfig.debugSLAC && DebugQueue(victimIndex)
	
	; Iterate through aliases
	Int i = victimIndex + 1
	Int lastEmpty = 0
	ReferenceAlias lastEmptyRef
	Int creatureCount = 0
	String report = ""
	While i <= victimIndex + 5
		ReferenceAlias tempref = slacConfig.slac_Queue.GetNthAlias(i) as ReferenceAlias
		Actor queueingCreature = tempref.GetActorRef()
		If !queueingCreature || queueingCreature == None
			; Set new empty position - consecutive empty position should be ignored, we only want the first available slot
			If lastEmpty == 0
				lastEmpty = i
				lastEmptyRef = slacConfig.slac_Queue.GetNthAlias(i) as ReferenceAlias
			Endif
		ElseIf lastEmpty > 0
			; Move creature up to empty position
			lastEmptyRef.ForceRefTo(queueingCreature as ObjectReference)
			slacData.SetSessionInt(queueingCreature,"QueueCreatureIndex",lastEmpty)
			tempref.Clear()
			If slacConfig.debugSLAC
				report = report + GetActorNameRef(queueingCreature) + " [" + lastEmpty + " <- " + i + "], "
			EndIf
			; Mark next sequential position as empty
			lastEmpty += 1
			lastEmptyRef = slacConfig.slac_Queue.GetNthAlias(lastEmpty) as ReferenceAlias
			creatureCount += 1
		Else
			; No empty positions ahead of creature
			creatureCount += 1
			slacData.SetSessionInt(queueingCreature,"QueueCreatureIndex",i)
			If slacConfig.debugSLAC
				report = report + GetActorNameRef(queueingCreature) + " [" + i + "], "
			EndIf
		EndIf
		i += 1
	EndWhile
	
	If report == ""
		report = "[queue empty]"
	EndIf
	
	Log("Queue Normalisation: queue index " + victimIndex + " for " + victimNameRef + " normalised: " + report)
	slacConfig.debugSLAC && DebugQueue(victimIndex)
	
	Return creatureCount
EndFunction

; Get the victim that a creature is queueing for or None if there is no queue victim
Actor Function GetCreatureQueueVictim(Actor akCreature)
	If akCreature && IsQueued(akCreature)
		Int victimIndex = slacData.GetSessionInt(akCreature,"QueueCreatureVictimIndex",-1)
		If victimIndex > -1
			Return GetAliasActor(slacConfig.slac_Queue,victimIndex)
		EndIf
	EndIf
	Return None
EndFunction

; Get number of creature is queue for actor
Int Function GetQueueCount(Actor akActor)
	If akActor
		Return slacData.GetSessionInt(akActor,"QueuedCreatures",0)
	EndIf
	Return 0
EndFunction

; Get the creature at the head of the queue
; This does not remove the creature from the queue
Actor Function GetNextQueueCreature(Actor akVictim)
	If akVictim && IsQueued(akVictim)
		Int victimIndex = slacData.GetSessionInt(akVictim,"QueueVictimIndex",-1)
		If victimIndex > -1 && (victimIndex % 6) == 0
			; Valid victim index
			Actor queueVictim = GetAliasActor(slacConfig.slac_Queue,victimIndex)
			If queueVictim == akVictim
				; Valid queue - send any actor at the head of the queue
				Return GetAliasActor(slacConfig.slac_Queue, victimIndex + 1)
			EndIf
		EndIf
	EndIf
	Return None
EndFunction

; Return relative queue position (-1 = not queued, 0 = victim, 1-5 = queueing creatures)
Int Function GetQueuePosition(Actor akActor)
	If slacData.GetSessionInt(akActor,"IsQueueCreature",-1) > -1
		; Creature 
		Int victimIndex = slacData.GetSessionInt(akActor,"QueueCreatureVictimIndex",-1)
		Int creatureIndex = slacData.GetSessionInt(akActor,"QueueCreatureIndex",-1)
		Log("Queue position " + (creatureIndex - victimIndex) + " for " + GetActorNameRef(akActor))
		Return creatureIndex - victimIndex
	ElseIf slacData.GetSessionBool(akActor,"IsQueuevictim")
		; Victim
		Log("Queue position 0 for " + GetActorNameRef(akActor))
		Return 0
	EndIf
	
	; Not in queue
	Log("Queue position NA for " + GetActorNameRef(akActor))
	Return -1
EndFunction

; Output list of queued actors 
Function DebugQueue(Int victimIndex = -1)
	If (victimIndex % 6) != 0
		Log("Debug Queue: " + victimIndex + " is not a valid queue victim index")
	ElseIf victimIndex > -1
		; Output specific queue data
		Int i = 0
		String report = "Debug Queue " + victimIndex + ": "
		While i <= 5
			If i > 0
				report = report + ", "
			EndIf
			report = report + (victimIndex + i) + "->" + GetActorNameRef(GetAliasActor(slacConfig.slac_Queue, victimIndex + i))
			i += 1
		EndWhile
		Log(report)
	Else
		; Output data for all queues
		victimIndex = 0
		While victimIndex <= 24
			Int i = 0
			String report = "Debug Queue " + victimIndex + ": "
			While i <= 5
				If i > 0
					report = report + ", "
				EndIf
				report = report + (victimIndex + i) + "->" + GetActorNameRef(GetAliasActor(slacConfig.slac_Queue, victimIndex + i))
				i += 1
			EndWhile
			Log(report)
			victimIndex += 6
		EndWhile
	EndIf
EndFunction



; ===================================
; =                                 =
; =        Armor Functions          =
; =                                 =
; ===================================


; Get Equipped Armor from slot name or slot index
Armor Function GetEquippedArmor(Actor akActor, String SlotName = "", Int SlotIndex = -1)
	If !akActor || akActor == None
		Return None
	EndIf
	
	; Convert Slot Index to Slot Mask
	If SlotIndex > 29 && SlotIndex < 62
		Return akActor.GetWornForm(ArmorSlotIndexToMask(SlotIndex)) as Armor
	EndIf
	
	; Convert Slot Name to Slot Mask
	If StringUtil.GetLength(SlotName) > 0
		Int SlotMask = ArmorSlotNameToMask(SlotName)
		If SlotMask > -2
			Return akActor.GetWornForm(SlotMask) as Armor
		EndIf
	EndIf
	
	Return None
EndFunction

; Record Armor Slot Name->Mask and Index->Name
Function SetArmorSlotName(Int SlotIndex, String SlotName1, String SlotName2 = "", String SlotName3 = "", String SlotName4 = "", String SlotName5 = "", String SlotName6 = "")
	; Get Slot Mask from Slot Index
	Int SlotMask = ArmorSlotIndexToMask(SlotIndex)
	
	; Record name->slot mask
	StorageUtil.SetIntValue(none,"SLArousedCreatures.ArmorSlots." + SlotName1, SlotMask)
	StringUtil.GetLength(SlotName2) > 0 && StorageUtil.SetIntValue(none,"SLArousedCreatures.ArmorSlots." + SlotName2, SlotMask)
	StringUtil.GetLength(SlotName3) > 0 && StorageUtil.SetIntValue(none,"SLArousedCreatures.ArmorSlots." + SlotName3, SlotMask)
	StringUtil.GetLength(SlotName4) > 0 && StorageUtil.SetIntValue(none,"SLArousedCreatures.ArmorSlots." + SlotName4, SlotMask)
	StringUtil.GetLength(SlotName5) > 0 && StorageUtil.SetIntValue(none,"SLArousedCreatures.ArmorSlots." + SlotName5, SlotMask)
	StringUtil.GetLength(SlotName6) > 0 && StorageUtil.SetIntValue(none,"SLArousedCreatures.ArmorSlots." + SlotName6, SlotMask)
	
	; Record slot->name
	If StorageUtil.GetStringValue(none,"SLArousedCreatures.ArmorSlots.Slot" + SlotIndex, "") == ""
		StorageUtil.SetStringValue(none,"SLArousedCreatures.ArmorSlots.Slot" + SlotIndex, SlotName1)
	EndIf
EndFunction

; Return slot indexes from slot mask
Int[] Function ArmorSlotMaskToIndexs(Int SlotMask)
	Int[] SlotIndexes = Utility.CreateIntArray(0)
	Int i = 30
	While i < 62
		If Math.LogicalAnd(1,SlotMask)
			SlotIndexes = PapyrusUtil.PushInt(SlotIndexes,i)
		EndIf
		SlotMask = Math.RightShift(SlotMask,1)
		i += 1
	EndWhile
	Return SlotIndexes
EndFunction
; Return first (lowest) slot index from slot mask
Int Function ArmorSlotMaskToFirstIndex(Int SlotMask)
	Int i = 30
	While i < 62
		If Math.LogicalAnd(1,SlotMask)
			Return i
		EndIf
		SlotMask = Math.RightShift(SlotMask,1)
		i += 1
	EndWhile
	Return i
EndFunction

; Resolve slot name from slot index
String Function ArmorSlotIndexToName(Int SlotIndex)
	Return StorageUtil.GetStringValue(none,"SLArousedCreatures.ArmorSlots.Slot" + SlotIndex, "Unnamed Slot")
EndFunction

; Get slot mask from index
Int Function ArmorSlotIndexToMask(Int SlotIndex)
	Return Armor.GetMaskForSlot(SlotIndex)
	; Alt
	Int SlotMask = 1
	Int i = 0
	While i+30 < SlotIndex
		SlotMask = SlotMask * 2
		i += 1
	EndWhile
	Return SlotMask
EndFunction

; Get slot mask from name
Int Function ArmorSlotNameToMask(String SlotName)
	Return StorageUtil.GetIntValue(none,"SLArousedCreatures.ArmorSlots." + SlotName, -2)
EndFunction

; Compile Slot Index->Name->Mask data
Function UpdateArmorSlotNames()
	; Slot naming:
	; https://www.creationkit.com/index.php?title=Slot_Masks_-_Armor
	; https://www.creationkit.com/index.php?title=Biped_Object
	
	; Reset
	StorageUtil.ClearAllPrefix("SLArousedCreatures.ArmorSlots.")
	
	; Regular
	SetArmorSlotName(30,"Head") ; 0x00000001
	SetArmorSlotName(31,"Hair") ; 0x00000002
	SetArmorSlotName(32,"Body") ; 0x00000004
	SetArmorSlotName(33,"Hands") ; 0x00000008
	SetArmorSlotName(34,"Forearms") ; 0x00000010
	SetArmorSlotName(35,"Amulet") ; 0x00000020
	SetArmorSlotName(36,"Ring") ; 0x00000040
	SetArmorSlotName(37,"Feet") ; 0x00000080
	SetArmorSlotName(38,"Calves") ; 0x00000100
	SetArmorSlotName(39,"Shield") ; 0x00000200
	SetArmorSlotName(40,"Tail") ; 0x00000400
	SetArmorSlotName(41,"LongHair") ; 0x00000800
	SetArmorSlotName(42,"Circlet") ; 0x00001000
	SetArmorSlotName(43,"Ears") ; 0x00002000
	
	; Custom
	SetArmorSlotName(44,"Face","Mask","Veil","Glasses","Spectacles","Goggles") ; 0x00004000
	SetArmorSlotName(45,"Neck","Throat"); 0x00008000
	SetArmorSlotName(46,"Chest","ChestOuter","ChestOver","Breastplate"); 0x00010000
	SetArmorSlotName(47,"Back","Backpack"); 0x00020000
	SetArmorSlotName(48,"MiscA","MiscFX01","MiscFXA","FXA"); 0x00040000
	SetArmorSlotName(49,"PelvisOuter","PelvisOver"); 0x00080000
	SetArmorSlotName(50,"DecapitateHead"); 0x00100000
	SetArmorSlotName(51,"Decapitate"); 0x00200000
	SetArmorSlotName(52,"PelvisInner","PelvisUnder","Briefs","Panties"); 0x00400000
	SetArmorSlotName(53,"RightLeg","LegRight","LegOuter","LegOver"); 0x00800000
	SetArmorSlotName(54,"LeftLeg","LegLeft","LegInner","LegUnder","Tights","Stockings"); 0x01000000
	SetArmorSlotName(55,"FaceAlt","FaceJewelry","FaceJewellery","Jewellery"); 0x02000000
	SetArmorSlotName(56,"ChestInner","ChestUnder","Bra","Brassiere"); 0x04000000
	SetArmorSlotName(57,"Shoulder","Shoulders","Pauldron","Pauldrons"); 0x08000000
	SetArmorSlotName(58,"LeftArm","ArmLeft","ArmInner","ArmUnder","ArmSecondary"); 0x10000000
	SetArmorSlotName(59,"RightArm","ArmRight","ArmOuter","ArmOver","ArmPrimary"); 0x20000000
	SetArmorSlotName(60,"MiscB","MiscFX02","MiscFXB","FXB"); 0x40000000
	SetArmorSlotName(61,"FX01"); 0x80000000
	
EndFunction

; Armor class shortcuts
Int Function GetArmorClass(Armor BodySlotArmor = None)
	If BodySlotArmor
		Return slacData.GetPersistInt(BodySlotArmor,"ArmorClassOverride",BodySlotArmor.GetWeightClass())
	EndIf
	Return 3
EndFunction
; Armor class shortcuts
Int Function GetActorArmorClass(Actor akActor)
	Armor BodySlotArmor = GetEquippedArmor(akActor, "Body")
	Return GetArmorClass(BodySlotArmor)
EndFunction


; ===================================
; =                                 =
; =              DHLP               =
; =                                 =
; ===================================

;Set/unset DHLP suspension flag
Function OnDHLPSuspend(string eventName = "", string strArg = "", float numArg = 0.0, Form sender = None)
	slacConfig.DHLPIsSuspended = True
	; Stop running quests and clear queues and suitors
	EndPursuitQuest(slacConfig.slac_Pursuit_00)
	EndPursuitQuest(slacConfig.slac_Pursuit_01)	
	EndPursuitQuest(slacConfig.slac_FollowerDialogue)
	EndPursuitQuest(slacConfig.slac_CreatureDialogue)
	ClearSuitors()
	ClearAllQueues()
	ReleaseAllClaimedActors()
EndFunction
Function OnDHLPResume(string eventName = "", string strArg = "", float numArg = 0.0, Form sender = None)
	slacConfig.DHLPIsSuspended = False
EndFunction



; ===================================
; =                                 =
; =        Helper Functions         =
; =                                 =
; ===================================


; Tag string management
String Function TagListStringAdd(String targetTags, String newTags)
	String[] targetTagList = PapyrusUtil.StringSplit(targetTags)
	targetTagList = PapyrusUtil.ClearEmpty(targetTagList)
	String[] newTagList = PapyrusUtil.StringSplit(newTags)
	newTagList = PapyrusUtil.ClearEmpty(newTagList)

	; Redundancy check
	If targetTagList.Length < 1
		Return PapyrusUtil.StringJoin(newTagList)
	ElseIf newTagList.Length < 1
		Return PapyrusUtil.StringJoin(targetTagList)
	EndIf
	
	; Replace added SexLap P+ conditional tags. i.e. remove "Aggressive" when adding "-Aggressive"
	If slacConfig.UsingSLPP() && targetTagList.Length > 0
		Int i = 0
		While i < newTagList.Length
			If StringUtil.GetNthChar(newtagList[i], 0) == "-"
				targetTagList = PapyrusUtil.RemoveString(targetTagList, "~" + newTagList[i])
				targetTagList = PapyrusUtil.RemoveString(targetTagList, StringUtil.Substring(newtagList[i],1))
			
			ElseIf StringUtil.GetNthChar(newtagList[i], 0) == "~"
				targetTagList = PapyrusUtil.RemoveString(targetTagList, "-" + newTagList[i])
				targetTagList = PapyrusUtil.RemoveString(targetTagList, StringUtil.Substring(newtagList[i],1))
			
			Else
				targetTagList = PapyrusUtil.RemoveString(targetTagList, "-" + newTagList[i])
				targetTagList = PapyrusUtil.RemoveString(targetTagList, "~" + newTagList[i])
			
			EndIf
			i += 1

		EndWhile
	EndIf

	; Merge unique and return joined string
	Return PapyrusUtil.StringJoin(PapyrusUtil.MergeStringArray(targetTagList, newTagList, True))
EndFunction
String Function TagListStringRemove(String targetTags, String removeTags)
	String[] targetTagList = PapyrusUtil.StringSplit(targetTags)
	targetTagList = PapyrusUtil.ClearEmpty(targetTagList)
	String[] removeTagList = PapyrusUtil.StringSplit(removeTags)
	removeTagList = PapyrusUtil.ClearEmpty(removeTagList)
	
	; Redundancy check
	If targetTagList.Length < 1
		Return ""
	ElseIf removeTagList.Length < 1
		Return PapyrusUtil.StringJoin(targetTagList)
	EndIf
	
	; Remove each tag
	Int i = 0
	While i < removeTagList.Length
		targetTagList = PapyrusUtil.RemoveString(targetTagList,removeTagList[i])
		i += 1

	EndWhile
	
	; Return joined string
	Return PapyrusUtil.StringJoin(targetTagList)
EndFunction
Bool Function TagListStringHas(String targetTags, String searchTags, Bool All = True)
	String[] targetTagList = PapyrusUtil.StringSplit(targetTags)
	targetTagList = PapyrusUtil.ClearEmpty(targetTagList)
	String[] searchTagList = PapyrusUtil.StringSplit(searchTags)
	searchTagList = PapyrusUtil.ClearEmpty(searchTagList)
	
	; Redundancy check
	If targetTagList.Length < 1 || searchTagList.Length < 1
		Return False
	EndIf
	
	; Check each tag
	Int i = 0
	While i < searchTagList.Length
		If All && PapyrusUtil.CountString(targetTagList, searchTagList[i]) < 1
			Return False
		ElseIf !All && PapyrusUtil.CountString(targetTagList, searchTagList[i]) > 0
			Return True
		EndIf
		i += 1
	EndWhile
	
	; True = all tags found, False = no tags found)
	Return All
EndFunction


; Update target reference
Bool Function UpdateTargetActor(Actor target = None, Bool quiet = False)
	; Clear current target and aliases
	slacConfig.targetActor = None

	If !slacConfig.slac_FollowerDialogueScene.IsPlaying()
		;slacConfig.slac_FollowerDialogue.Reset()
		FollowerDialogueCreatureRef.Clear()
		FollowerDialogueTargetRef.Clear()
		slacConfig.slac_FollowerDialogueSignal.SetValue(0)

	EndIf

	If !slacConfig.slac_CreatureDialogueScene.IsPlaying()
		;slacConfig.slac_CreatureDialogue.Reset()
		CreatureDialogueVictimRef.Clear()
		CreatureDialogueTargetRef.Clear()

	EndIf

	; Select new target
	If target && target as Actor
		slacConfig.targetActor = target as Actor
		String validity = "Not Valid"
		String testResult = ""
		Bool IsCreature = False

		If slacConfig.debugSLAC
			Actor debugactor = target as Actor
			Log("UpdateTargetActor: Actor " + GetActorNameRef(debugactor))
			Log("UpdateTargetActor: ActorTypeNPC KWRD " + debugactor.HasKeyword(ActorTypeNPC))
			Log("UpdateTargetActor: ActorTypeCreature KWRD " + debugactor.HasKeyword(ActorTypeCreature))
			Log("UpdateTargetActor: CreatureFaction FACT " + debugactor.IsInFaction(CreatureFaction))
			Log("UpdateTargetActor: ActorTypeFamiliar KWRD " + debugactor.HasKeyword(ActorTypeFamiliar))
			Log("UpdateTargetActor: ActorTypeHorse KWRD " + debugactor.HasKeyword(ActorTypeHorse))
			Log("UpdateTargetActor: ClaimedActor KWRD " + debugactor.HasKeyword(slac_ClaimedActor))
			Log("UpdateTargetActor: ActorMonitored KWRD " + debugactor.HasKeyword(slac_ActorMonitored))
			Log("UpdateTargetActor: QueueingVictim KWRD " + debugactor.HasKeyword(slacConfig.slac_QueueingVictim))
			Log("UpdateTargetActor: QueueingCreature KWRD " + debugactor.HasKeyword(slacConfig.slac_QueueingCreature))
			Log("UpdateTargetActor: SuitorCreature KWRD " + debugactor.HasKeyword(slacConfig.slac_SuitorCreature))
			Log("UpdateTargetActor: engagedActor FACT " + debugactor.IsInFaction(slac_engagedActor))
			Log("UpdateTargetActor: victimActor FACT " + debugactor.IsInFaction(slac_victimActor))
			Log("UpdateTargetActor: InvitingFaction FACT " + debugactor.IsInFaction(slacConfig.slac_InvitingFaction))
			Log("UpdateTargetActor: InvitedFaction FACT " + debugactor.IsInFaction(slacConfig.slac_InvitedFaction))
			Log("UpdateTargetActor: PursuitFaction FACT " + debugactor.IsInFaction(slacConfig.slac_PursuitFaction))
			Log("UpdateTargetActor: AutoEngageBlockedFaction FACT " + debugactor.IsInFaction(slacConfig.slac_AutoEngageBlockedFaction))
			Log("UpdateTargetActor: LastIntimidateDayFaction FACT " + debugactor.IsInFaction(slacConfig.slac_LastIntimidateDayFaction))
			Log("UpdateTargetActor: LastPersuadeDayFaction FACT " + debugactor.IsInFaction(slacConfig.slac_LastPersuadeDayFaction))
			Log("UpdateTargetActor: LastBribeDayFaction FACT " + debugactor.IsInFaction(slacConfig.slac_LastBribeDayFaction))
			Log("UpdateTargetActor: DefeatFaction FACT " + (slacConfig.DefeatFaction && debugactor.IsInFaction(slacConfig.DefeatFaction)))
			Log("UpdateTargetActor: NakedDefeatActorFaction FACT " + (slacConfig.NakedDefeatActorFaction && debugactor.IsInFaction(slacConfig.NakedDefeatActorFaction)))
			Log("UpdateTargetActor: DefeatRapistFaction FACT " + (slacConfig.DefeatRapistFaction && debugactor.IsInFaction(slacConfig.DefeatRapistFaction)))
			Log("UpdateTargetActor: dse_dm_FactionActorUsingDevice FACT " + (slacConfig.dse_dm_FactionActorUsingDevice && debugactor.IsInFaction(slacConfig.dse_dm_FactionActorUsingDevice)))
			Log("UpdateTargetActor: PlayerHorseFaction FACT " + debugactor.IsInFaction(slacConfig.PlayerHorseFaction))
			Log("UpdateTargetActor: MagicInfluenceCharm KWRD " + debugactor.HasKeyword(slacConfig.MagicInfluenceCharm))
			Log("UpdateTargetActor: MagicAllegianceFaction FACT " + debugactor.IsInFaction(slacConfig.MagicAllegianceFaction))
			Log("UpdateTargetActor: MagicCharmFaction FACT " + debugactor.IsInFaction(slacConfig.MagicCharmFaction))
		EndIf

		If !target.HasKeyword(ActorTypeNPC) ; target.HasKeyword(ActorTypeCreature) || target.IsInfaction(CreatureFaction) || SexLab.AllowedCreature(target.GetRace())
			; Is Creature
			IsCreature = True
			testResult = CheckCreature(target,PlayerRef)
			If testResult == ""
				; Check for hostility with player
				testResult = CheckVictim(PlayerRef,target,inviting = True)
				If testResult != "_hostile"
					testResult = ""
					If !slacConfig.slac_FollowerDialogueScene.IsPlaying()
						FollowerDialogueCreatureRef.ForceRefTo(target as ObjectReference)
						FollowerDialogueTargetRef.ForceRefTo(target as ObjectReference)

					EndIf
					validity = "Valid Creature"

				EndIf

			Else
				validity = "Creature Not Valid"
				slacConfig.UpdateFailedCreatures(target,testResult)

			EndIf

		Else
			; Is NPC or PC
			testResult = CheckVictim(target)
			If testResult == ""
				If target != PlayerRef && !slacConfig.slac_CreatureDialogueScene.IsPlaying()
					CreatureDialogueVictimRef.ForceRefTo(target as ObjectReference)
					CreatureDialogueTargetRef.ForceRefTo(target as ObjectReference)

				EndIf
				validity = "Valid NPC"
				If target == PlayerRef
					validity = "Valid Player"

				EndIf

			Else
				validity = "NPC Not Valid"
				If target == PlayerRef
					validity = "Player Not Valid"
				EndIf
				slacConfig.UpdateFailedNPCs(target,testResult)

			EndIf

		EndIf
		
		; Update last selected actors for slac_Notify testing.
		!slacConfig.InInitMaintenance && slacConfig.slacPlayerScript.UpdateLastSelectedActor(target)
		
		; Format result
		String resultPre = "<font color='#00FF00'>"
		If testResult != ""
			; Add name of blocking scene quest
			If testResult == "_quest"
				Scene currentScene = target.GetCurrentScene()
				If currentScene
					Quest currentQuest = currentScene.GetOwningQuest()
					If currentQuest
						testResult = "_quest: " + currentQuest.GetID()
					EndIf

				EndIf

			EndIf
			testResult = " (" + StringUtil.SubString(testResult,1) + ") "
			resultPre = "<font color='#FF6666'>"

		EndIf
		
		If slacConfig.showNotificationsNPC && slacConfig.debugSLAC
			Race akRace = target.GetRace()
			Int tempSex = TreatAsSex(target)
			Log(resultPre + "Selecting actor " + GetActorNameRef(target) + " (" + slacConfig.CondString(target.GetLeveledActorBase().GetSex() == 0,"M","F") + "/" + slacConfig.CondString(tempSex % 2 == 0,"M","F") + ") - arousal " + (GetActorArousal(target)) + ", " + validity + testResult + " " + Math.Floor(PlayerRef.GetDistance(target) / UNITFOOTRATIO) + "ft " + slacConfig.CondString(IsQueued(target),"In Queue","") + "</font>", forceNote = True)
		
		ElseIf slacConfig.showNotificationsNPC && !quiet
			If testResult == ""
				IsCreature && slacNotify.Show("TargetSelectPass", PlayerRef, target)
				!IsCreature && slacNotify.Show("TargetSelectPass", target)

			Else
				IsCreature && slacNotify.Show("TargetSelectFail", PlayerRef, target)
				!IsCreature && slacNotify.Show("TargetSelectFail", target)

			EndIf
			Log(resultPre + "Selecting actor " + target.GetLeveledActorBase().GetName() + " - arousal " + GetActorArousal(target) + "</font>")
		
		EndIf
		
		Return True

	Else
		Log("Clearing selected actor")
	EndIf
	
	Return False
EndFunction


; Updates a global variable to a random value for use randomising quest comments
Function SetRandomValue(Int min = 0, Int max = 99)
	slac_RandomValue.SetValueInt(Utility.RandomInt(min,max))
EndFunction


; Generates a list of animations in the log for debugging
Function ListAnims(sslBaseAnimation[] anims)
	Int i = 0
	While i < anims.length
		If anims[i]
			Int[] GT = anims[i].Genders
			Log("anim " + anims[i].Name + " (" + PapyrusUtil.StringJoin(anims[i].GetTags(),",") + ") [M:" + GT[0] + ",F" + GT[1] + ",MC:" + GT[2] + ",FC:" + GT[3] + "]")
		EndIf
		i += 1
	EndWhile
EndFunction
Function ListScenes(String[] scenes)
	Int i = 0
	While i < scenes.length
		If scenes[i]
			Int[] GT = SexLabRegistry.GetPositionSexA(scenes[i])
			Log("scene " + SexLabRegistry.GetSceneName(scenes[i]) + " (" + PapyrusUtil.StringJoin(SexLabRegistry.GetSceneTags(scenes[i]),",") + ")")
		Else
			Log("scene Empty")
		EndIf
		i += 1
	EndWhile
EndFunction


; Helper function for getting basic race name
String Function GetCreatureRaceKeyString(Actor creatureActor)
	If creatureActor
		If slacConfig.UsingSLPP()
			Return SexLabRegistry.GetRaceKey(creatureActor)
		Endif
		Return sslCreatureAnimationSlots.GetRaceKeyByID(MiscUtil.GetActorRaceEditorID(creatureActor))
	EndIf
	Return ""
EndFunction


; Helper function for normalising arousal acquisition
Int Function GetActorArousal(Actor akSubject)
	int arousal = akSubject.GetFactionRank(slaArousal)
	
	; Occasionally arousal will return a negative value (not in faction) which we will treat as zero
	If arousal < 0
		arousal = 0
	EndIf
	
	Return arousal
EndFunction


; Helper function - get actor from quest alias index
Actor Function GetAliasActor(Quest fromQuest, Int aliasIndex)
	ReferenceAlias refAlias = fromQuest.GetNthAlias(aliasIndex) as ReferenceAlias
	Return refAlias.getActorRef() as Actor
EndFunction


; Helper function - Return human-readable actor name/ref for debug output.
String Function GetActorNameRef(Actor akActor = None)
	If akActor == None
		Return "[No Actor]"
	EndIf
	String refString = "" + akActor
	String id = StringUtil.SubString("" + refString, (StringUtil.GetLength(refString) - 11), 8)
	Int SLGender = SexLab.GetGender(akActor)
	Int VanillaSex = akActor.GetLeveledActorBase().GetSex()
	String sex = "(" + vanillaSex + "/" + SLGender + ")"
	Return "" + akActor.GetLeveledActorBase().GetName() + " " + sex + " [" + id + "]"
EndFunction
String Function GetActorNameRefArray(Actor[] akActors)
	Int i = 0
	String result = ""
	While i < akActors.Length
		result = result + GetActorNameRef(akActors[i])
		If i < akActors.Length - 1
			result = result + ", "
		EndIf
		i += 1
	EndWhile
	Return result
EndFunction

; Helper function - return form ID as a hex string
String Function GetFormIDHex(Form subject)
	Return StringUtil.SubString(subject,(StringUtil.GetLength(subject) - 11), 8)
EndFunction


; Helper function - Return max stamina value for actor - slow and not 100% reliable
Float Function GetMaximumStamina(Actor akActor)
	Float BaseValue = akActor.GetBaseActorValue("Stamina")
	Float CurrentMaxValue = Math.Ceiling(akActor.GetActorValue("Stamina") * akActor.GetActorValuePercentage("Stamina"))
	If BaseValue < CurrentMaxValue
		Return BaseValue
	Else
		Return CurrentMaxValue
	EndIf
EndFunction

Bool Function GetIsCreature(Actor akActor)
	Return !akActor.HasKeyword(ActorTypeNPC)
EndFunction
Bool Function GetIsNPC(Actor akActor)
	Return akActor.HasKeyword(ActorTypeNPC)
EndFunction

; A local sex determination option to normalize various returned indexes from the game and frameworks
; Right now this is specifically for creatures, where male might be 0, 2 or 3 depending on the call.
; Male == 0; Female == 1
Int Function GetSex(Actor akActor)
	If slacCOnfig.UsingSLPP()
		; SexLab P+
		Int	ActorSexIndex = SexLab.GetSex(akActor)
		If ActorSexIndex == 0 || ActorSexIndex == 3
			Return 0
		ElseIf ActorSexIndex == 1 || ActorSexIndex == 4
			Return 1
		EndIf
	Else
		; SexLab
		Int	ActorSexIndex = SexLab.GetGender(akActor)
		If ActorSexIndex == 0 || ActorSexIndex == 2
			Return 0
		ElseIf ActorSexIndex == 1 || ActorSexIndex == 3
			Return 1
		EndIf
	EndIf
EndFunction


; Helper function - Return the usable sex of a transgender actor based on trans options or current disposition
Int Function TreatAsSex(Actor akActor, Actor akPartner = None)
	; The roll of this function is in question as there are areas where we need to know 
	; both vanilla and sexlab gender but also the fact that they are different. As such 
	; a simple resolution system like this may end up being bypasses in many situations.
	;Return SexLab.GetGender(akActor)
	
	Int SLGender = SexLab.GetGender(akActor)
	Int VanillaSex = akActor.GetLeveledActorBase().GetSex()
	Int ReturnSex = VanillaSex
	Bool isPlayer = akActor == PlayerRef
	Bool IsTrans = SLGender != vanillaSex
	Bool IsMaleRoll = slacData.GetAllBool(akActor,"IsMaleRoll")
	Int partnerSex = 0
	If akPartner
		partnerSex = GetSex(akPartner)
	EndIf
	
	
	If IsMaleRoll
		ReturnSex == 0
	ElseIf IsTrans
		If isPlayer
			; PC
			If akPartner && akPartner != None && ((vanillaSex == 0 && slacConfig.TransMFTreatAsPC == 2) || (vanillaSex == 1 && slacConfig.TransFMTreatAsPC == 2))
				; Adaptive
				If partnerSex == 0
					; Male creature = female pc
					ReturnSex = 1

				Else
					; Female creature = male pc
					ReturnSex = 0

				EndIf

			ElseIf vanillaSex == 0 && slacConfig.TransMFTreatAsPC < 2
				; Use selected PC sex for MF
				ReturnSex = slacConfig.TransMFTreatAsPC

			ElseIf vanillaSex == 1 && slacConfig.TransFMTreatAsPC < 2
				; Use selected PC sex for FM
				ReturnSex = slacConfig.TransFMTreatAsPC

			EndIf

		Else
			; NPC
			If akPartner && akPartner != None && ((vanillaSex == 0 && slacConfig.TransMFTreatAsNPC == 2) || (vanillaSex == 1 && slacConfig.TransFMTreatAsNPC == 2))
				; Adaptive
				If partnerSex == 0
					; Male creature = female npc
					ReturnSex = 1

				Else
					; Female creature = male npc
					ReturnSex = 0

				EndIf

			ElseIf vanillaSex == 0 && slacConfig.TransMFTreatAsNPC < 2
				; Use selected NPC sex for MF
				ReturnSex = slacConfig.TransMFTreatAsNPC

			ElseIf vanillaSex == 1 && slacConfig.TransFMTreatAsNPC < 2
				; Use selected NPC sex for FM
				ReturnSex = slacConfig.TransFMTreatAsNPC

			EndIf
		EndIf
	EndIf
	; This function may get called A LOT so only uncomment this in dev
	;slacConfig.debugSLAC && Log("TreatAsSex: " + GetActorNameRef(akActor) + " " + slacConfig.CondString(isPlayer,"PC","NPC") + " sex Vanilla:" + slacConfig.CondString(vanillaSex == 0,"male","female") + ", SexLab:" + slacConfig.CondString(SLGender == 0,"male","female") + slacConfig.CondString(IsMaleRoll," using male roll","") + " Trans:" + slacConfig.CondString(IsTrans,"Yes","No") + " slacConfig.TransMFTreatAsNPC:" + slacConfig.TransMFTreatAsNPC + ", will be treated as " + slacConfig.CondString(ReturnSex == 0,"male","female") + " with partner:" + GetActorNameRef(akPartner))
	Return ReturnSex
EndFunction


; Get actor animation roll
; Returns the sex index that should be used to determine the actors position
Int Function GetAnimationRoll(Int victimGender, Int attackerGender, Bool IsPlayer)

	If victimGender == 0
		; Use sex-based animation selection settings for male victim
		If attackerGender == 0
			; Male creature
			Return slacConfig.CondInt(IsPlayer, slacConfig.MalePCRoleWithMaleCreature, slacConfig.MaleNPCRoleWithMaleCreature)
		
		Else
			; Female creature
			Return slacConfig.CondInt(IsPlayer, slacConfig.MalePCRoleWithFemaleCreature, slacConfig.MaleNPCRoleWithFemaleCreature)
		
		EndIf
	
	Else
		; Use sex-based animation selection settings for female victim
		If attackerGender == 0
			; Male creature
			Return slacConfig.CondInt(IsPlayer, slacConfig.FemalePCRoleWithMaleCreature, slacConfig.FemaleNPCRoleWithMaleCreature)
		
		Else
			; Female creature
			Return slacConfig.CondInt(IsPlayer, slacConfig.FemalePCRoleWithFemaleCreature, slacConfig.FemaleNPCRoleWithFemaleCreature)
	
		EndIf
		
	EndIf
EndFunction


; Get always MF option for non-con engagements
Bool Function GetAlwaysMF(Bool IsPlayer)
	Return (IsPlayer && slacConfig.NonConsensualIsAlwaysMFPC) || (!IsPlayer && slacConfig.NonConsensualIsAlwaysMFNPC)
EndFunction


; Check if menus are open
Bool Function MenuOpen(String menuName = "")
	If menuName == "ForceAll"
		Return Utility.IsInMenuMode() || \
			UI.IsMenuOpen("Dialogue Menu") || \
			UI.IsMenuOpen("Console") || \
			UI.IsMenuOpen("Crafting Menu") || \
			UI.IsMenuOpen("BarterMenu") || \
			UI.IsMenuOpen("MessageBoxMenu") || \
			UI.IsMenuOpen("ContainerMenu") || \
			UI.IsTextInputEnabled()

	ElseIf menuName == "Dialogue Menu"
		Return UI.IsMenuOpen("Dialogue Menu") && !slacConfig.allowDialogueAutoEngage

	ElseIf menuName != ""
		Return UI.IsMenuOpen(menuName)

	ElseIf !slacConfig.allowMenuAutoEngage
		Return Utility.IsInMenuMode() || \
			(UI.IsMenuOpen("Dialogue Menu") && !slacConfig.allowDialogueAutoEngage) || \
			UI.IsMenuOpen("Console") || \
			UI.IsMenuOpen("Crafting Menu") || \
			UI.IsMenuOpen("BarterMenu") || \
			UI.IsMenuOpen("MessageBoxMenu") || \
			UI.IsMenuOpen("ContainerMenu") || \
			UI.IsTextInputEnabled()

	EndIF
	
	Return False
EndFunction
; Legacy
Bool Function MenuTest(String m = "")
	Return MenuOpen(m)
EndFunction

; Check permissions for current location
Bool Function LocationTest(Bool ForPlayer = True, Bool ForNPC = True)
	Location currentLocation = PlayerRef.GetCurrentLocation()
	If !currentLocation
		Return True
	EndIf
	
	; Minor Types
	
	If currentLocation.HasKeyword(slacConfig.LocTypeInn)
		If (ForPlayer && slacConfig.LocationInnAllowPC) || (ForNPC && slacConfig.LocationInnAllowNPC)
			Return True
		EndIf
		Return False
	EndIf
	
	If currentLocation.HasKeyword(slacConfig.LocTypePlayerHouse)
		If (ForPlayer && slacConfig.LocationPlayerHouseAllowPC) || (ForNPC && slacConfig.LocationPlayerHouseAllowNPC)
			Return True
		EndIf
		Return False
	EndIf
	
	If currentLocation.HasKeyword(slacConfig.LocTypeDungeon) && currentLocation.IsCleared()
		If (ForPlayer && slacConfig.LocationDungeonClearedAllowPC) || (ForNPC && slacConfig.LocationDungeonClearedAllowNPC)
			Return True
		EndIf
	EndIf
	
	; Major Types
	
	If currentLocation.HasKeyword(slacConfig.LocTypeCity)
		If (ForPlayer && slacConfig.LocationCityAllowPC) || (ForNPC && slacConfig.LocationCityAllowNPC)
			Return True
		EndIf
		Return False
	EndIf
	
	If currentLocation.HasKeyword(slacConfig.LocTypeTown)
		If (ForPlayer && slacConfig.LocationTownAllowPC) || (ForNPC && slacConfig.LocationTownAllowNPC)
			Return True
		EndIf
		Return False
	EndIf
	
	If currentLocation.HasKeyword(slacConfig.LocTypeDwelling)
		If (ForPlayer && slacConfig.LocationDwellingAllowPC) || (ForNPC && slacConfig.LocationDwellingAllowNPC)
			Return True
		EndIf
		Return False
	EndIF
	
	If currentLocation.HasKeyword(slacConfig.LocTypeDungeon)
		If (ForPlayer && slacConfig.LocationDungeonAllowPC) || (ForNPC && slacConfig.LocationDungeonAllowNPC)
			Return True
		EndIf
		Return False
	EndIf
	
	; Other types
	
	If (ForPlayer && !slacConfig.LocationOtherAllowPC) || (ForNPC && !slacConfig.LocationOtherAllowNPC)
		Return False
	EndIf
	
	Return True
EndFunction
Bool Function LocationTestPC()
	Return LocationTest(ForNPC = False)
EndFunction
Bool Function LocationTestNPC()
	Return LocationTest(ForPlayer = False)
EndFunction

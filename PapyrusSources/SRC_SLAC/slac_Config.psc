Scriptname slac_Config extends SKI_ConfigBase
{SexLab Aroused Creatures MCM configuration implementation.}

; SLAC
slac_Utility Property slacUtility Auto
slac_PlayerScript Property slacPlayerScript Auto
slac_Data Property slacData Auto
Spell Property slac_ScanCloakCreatureSpell Auto
Bool Property setAggressiveTagsAuto Auto
Float MenuOpenTime = 0.0
Faction Property slac_InvitingFaction Auto
Faction Property slac_InvitedFaction Auto
Bool modActiveLast = True
String[] textSexString ; Used for interpolative text replacement where necessary
Int OIDCount = 0

; MCM
String slacmcmCurrentPage
String slacmcmLastSelectedPage
Bool Property configUpdate = true Auto
Bool SLACMCMUpdateRaceKeys = False

; SexLab
SexLabFramework Property SexLab Auto
sslCreatureAnimationSlots CreatureSlots

; Constants
Float UNITFOOTRATIO = 21.3333 ; Approximate CK Unit to Foot ratio

; Interface
	;DXScanCodes
	Int KeyLCtrl = 29
	Int KeyLShift = 42
	Int KeyLAlt = 56
	
	
; General Settings
	; Global
	Bool Property requireLos Auto
	Int Property engageRadius Auto
	GlobalVariable Property slac_EngageRadius Auto
	Bool Property noSittingActors Auto
	Bool Property onHitInterrupt Auto
	Int Property actorPreferenceIndex Auto
	String[] actorPreferenceList
	Bool Property allowEnemies Auto
	
	; Performance
	Bool Property modActive Auto
	GlobalVariable Property slac_ModActive Auto
	Bool Property debugSLAC Auto
	Bool Property debugScanShaders = False Auto
	GlobalVariable Property slac_DebugScanShaders Auto
	Int Property SLAnimationMax = 15 Auto
	Int Property countMax Auto
	Int Property creatureCountMax Auto
	Int Property scanMethodIndex Auto
	String[] scanMethodList
	Int Property checkFrequency Auto
	Int Property cloakRadius Auto
	Float[] executionTimes


; PC/NPC Auto Settings
	; Player/NPC Settings
	Bool Property pcActive Auto
	Bool Property npcActive Auto
	Int Property cooldownPC Auto
	Int Property cooldownNPC Auto
	Int Property cooldownNPCType = 0 Auto
	String[] cooldownNPCTypeList
	Bool Property allowFamiliarsPC Auto
	Bool Property allowFamiliarsNPC Auto
	Int Property allowedNPCFollowers = 0 Auto
	String[] allowedNPCFollowersList
	Int Property allowedPCCreatureFollowers = 0 Auto
	Int Property allowedNPCCreatureFollowers = 0 Auto
	String[] allowedCreatureFollowersList
	Bool Property OnlyPermittedNPCs = False Auto
	Bool Property OnlyPermittedCreaturesPC = False Auto
	Bool Property OnlyPermittedCreaturesNPC = False Auto
	
	; Gender, Arousal & Consent
	Int Property pcVictimSexValue Auto
	Int Property npcVictimSexValue Auto
	String[] victimSexList
	Bool Property allowPCMM = False Auto
	Bool Property allowPCFF = False Auto
	Bool Property allowNPCMM = False Auto
	Bool Property allowNPCFF = False Auto
	String[] AllowedSameSexList
	GlobalVariable Property slac_AllowMM Auto
	GlobalVariable Property slac_AllowFF Auto
	Int Property pcCreatureArousalMin Auto
	Int Property npcCreatureArousalMin Auto
	Int Property pcArousalMin = 80 Auto
	Int Property npcArousalMin = 80 Auto
	Int Property pcRequiredArousalIndex Auto
	Int Property npcRequiredArousalIndex Auto
	String[] pcRequiredArousalList
	String[] npcRequiredArousalList
	String[] pcnpcRequiredArousalList
	Int Property pcConsensualIndex Auto
	String[] pcConsensualList
	Int Property npcConsensualIndex Auto
	String[] npcConsensualList
	
	; Armor & Clothing
	Bool Property AllowHeavyArmorPC = True Auto
	Bool Property AllowLightArmorPC = True Auto
	Bool Property AllowClothingPC = True Auto
	Bool Property AllowHeavyArmorNPC = True Auto
	Bool Property AllowLightArmorNPC = True Auto
	Bool Property AllowClothingNPC = True Auto
	String[] ArmorClassList
	Armor PCBodyArmor = None
	Armor NPCBodyArmor = None
	Int Property CreatureNakedArousalModPC = 100 Auto
	Int Property CreatureNakedArousalModNPC = 100 Auto
	
	; Orgy Mode - NPC orgy variants are currently unused save for the orgyModeNPC toggle - tests will use PC values.
	Bool Property orgyModePC = False Auto
	Bool Property orgyModeNPC = False Auto
	Int Property orgyArousalMinPC Auto
	Int Property orgyArousalMinNPC Auto
	Int Property orgyArousalMinPCCreature Auto
	Int Property orgyArousalMinNPCCreature Auto
	Int Property orgyRequiredArousalPCIndex Auto
	Int Property orgyRequiredArousalNPCIndex Auto
	Int Property orgyConsentPCIndex Auto
	Int Property orgyConsentNPCIndex Auto

	; Creature Grouping
	Int Property groupChancePC Auto
	Int Property groupChanceNPC Auto
	Int Property groupMaxExtrasPC Auto
	Int Property groupMaxExtrasNPC Auto
	Int Property groupArousalPC Auto
	Int Property groupArousalNPC Auto

	; Pursuit
	Bool Property pursuitQuestPC Auto
	Bool Property pursuitQuestNPC Auto
	Int Property pursuitMaxTimePC Auto
	Int Property pursuitMaxTimeNPC Auto
	Float Property pursuit00LastStartTime Auto
	Float Property pursuit01LastStartTime Auto
	GlobalVariable Property slac_PursuitCaptureRadiusPC Auto
	GlobalVariable Property slac_PursuitCaptureRadiusPCSafe Auto
	GlobalVariable Property slac_PursuitCaptureRadiusNPC Auto
	GlobalVariable Property slac_PursuitCaptureRadiusNPCSafe Auto
	GlobalVariable Property slac_PursuitEscapeRadiusPC Auto
	GlobalVariable Property slac_PursuitEscapeRadiusNPC Auto
	Quest Property slac_Pursuit_00 Auto
	Quest Property slac_Pursuit_01 Auto
	Scene Property slac_Pursuit_00_Scene Auto
	Scene Property slac_Pursuit_01_Scene Auto
	GlobalVariable Property slac_Pursuit00Type Auto
	GlobalVariable Property slac_Pursuit00Pounce Auto
	GlobalVariable Property slac_Pursuit01Type Auto
	GlobalVariable Property slac_Pursuit01Pounce Auto
	GlobalVariable Property slac_Pursuit01Flee Auto
	GlobalVariable Property slac_ScanRadius Auto
	Package Property slac_PounceOnPlayer Auto
	Package Property slac_PounceOnVictim Auto
	Int Property pursuitCaptureRadiusPC Auto
	Int Property pursuitCaptureRadiusNPC Auto
	Int Property pursuitEscapeRadiusPC Auto
	Int Property pursuitEscapeRadiusNPC Auto
	Faction Property slac_PursuitFaction Auto

	; Creature queueing
	Int Property queueLengthMaxPC Auto
	Int Property queueLengthMaxNPC Auto
	Bool Property allowQueueLeaversPC Auto
	Bool Property allowQueueLeaversNPC Auto
	Quest Property slac_Queue Auto
	GlobalVariable Property slac_AllowQueueing Auto
	Int Property queueTypePC = 1 Auto
	GlobalVariable Property slac_QueueTypePC Auto
	Int Property queueTypeNPC = 1 Auto
	String[]	queueTypeList
	GlobalVariable Property slac_QueueTypeNPC Auto
	Keyword Property slac_QueueingVictim Auto
	Keyword Property slac_QueueingCreature Auto
	Int Property consensualQueuePC = 2 Auto
	Int Property consensualQueueNPC = 2 Auto
	String[]	consensualQueueList
	
	; Location
	Bool Property LocationCityAllowPC = True Auto
	Bool Property LocationTownAllowPC = True Auto
	Bool Property LocationDwellingAllowPC = True Auto
	Bool Property LocationInnAllowPC = True Auto
	Bool Property LocationPlayerHouseAllowPC = True Auto
	Bool Property LocationDungeonAllowPC = False Auto
	Bool Property LocationDungeonClearedAllowPC = True Auto
	Bool Property LocationOtherAllowPC = True Auto
	Bool Property LocationCityAllowNPC = True Auto
	Bool Property LocationTownAllowNPC = True Auto
	Bool Property LocationDwellingAllowNPC = True Auto
	Bool Property LocationInnAllowNPC = True Auto
	Bool Property LocationPlayerHouseAllowNPC = True Auto
	Bool Property LocationDungeonAllowNPC = False Auto
	Bool Property LocationDungeonClearedAllowNPC = True Auto
	Bool Property LocationOtherAllowNPC = True Auto
	Keyword Property LocTypeCity Auto
	Keyword Property LocTypeTown Auto
	Keyword Property LocTypeDwelling Auto
	Keyword Property LocTypeInn Auto
	Keyword Property LocTypePlayerHouse Auto
	Keyword Property LocTypeDungeon Auto
	
	; PC Only
	Int Property pcCrouchIndex Auto
	String[] pcCrouchList
	Int Property pursuitInviteAnimationPC Auto
	Bool Property pcAllowWeapons Auto
	Bool Property pcAllowFemalePursuit Auto

	; NPC Only
	Bool Property noSleepingActors Auto
	Bool Property allowElders = False Auto

	; Male NPCs
	Int Property NPCMaleArousalMin Auto
	Int Property NPCMaleCreatureArousalMin Auto
	Int Property NPCMaleRequiredArousalIndex Auto
	Int Property NPCMaleConsensualIndex Auto
	Bool Property NPCMaleQueuing = False Auto
	Int Property NPCMaleAllowVictim = 3 Auto
	String[] NPCMaleAllowVictimList
	
	Int Property pcCreatureSexValue = 0 Auto
	Int Property npcCreatureSexValue = 0 Auto
	String[] creatureSexList


; SLAC Dialogue & Interactions
	; Invitation
	Int Property inviteTargetKey Auto
	Int Property inviteArousalMin Auto
	Int Property inviteConsentPCIndex Auto
	Int Property inviteAnimationPC Auto
	Int Property inviteAnimationNPC Auto
	Int Property inviteStripDelayPC Auto
	Bool Property inviteOpensHorseDialogue = False Auto
	Bool Property inviteOpensCreatureDialogue = False Auto
	Int Property inviteCreatureSex = 2 Auto
	
	; Suitors
	Int Property suitorsMaxPC = 0 Auto
	Int Property suitorsPCArousalMin = 60 Auto
	Bool Property suitorsPCAllowWeapons = False Auto
	Bool Property suitorsPCAllowLeave = False Auto
	Quest	Property slac_Suitors Auto
	Keyword Property slac_SuitorCreature Auto
	Int Property suitorsPCCrouchEffect = 0 Auto
	String[] suitorsPCCrouchEffectList
	Bool Property suitorsPCAllowFollowers = False Auto
	Bool Property suitorsPCOnlyNaked = False Auto

	; Struggle
	Bool Property struggleEnabled Auto
	Int Property struggleKeyOne Auto
	Int Property struggleKeyTwo Auto
	Float Property struggleStaminaDamage Auto
	Float Property struggleStaminaDamageMultiplier Auto
	Float Property struggleTimingOne Auto
	Float Property struggleTimingTwo Auto
	Bool Property struggleMeterHidden Auto
	Bool Property struggleFailureEnabled Auto
	Int Property struggleExhaustionMode = 1 Auto
	String[] struggleExhaustionModeList
	Bool Property struggleQueueEscape = False Auto
	Float Property widgetXPositionNPC = 925.0 Auto
	Float Property widgetYPositionNPC = 655.0 Auto
	
	; Actor Selection
	Int Property targetKey Auto
	
	
	; Player Horse
	Bool Property horseRefusalPCMounting = False Auto
	Bool Property horseRefusalPCRiding = False Auto
	Int Property horseRefusalPCThreshold Auto
	Int Property horseRefusalPCSex = 0 Auto
	Bool Property horseRefusalPCEngage = False Auto
	GlobalVariable Property slac_HorseRefusalPCThreshold Auto
	
	
	; Follower Commands
	Bool Property followerDialogueEnabled Auto
	Bool Property nonFollowerDialogueEnabled Auto
	GlobalVariable Property slac_nonFollowerDialogueEnabled Auto
	Int Property followerCommandThreshold Auto
	GlobalVariable Property slac_FollowerDialogueArousalMin Auto
	GlobalVariable Property slac_FollowerDialogueArousalEager Auto
	Int Property creatureCommandThreshold = 40 Auto
	GlobalVariable Property slac_CreatureDialogueArousalMin Auto
	Int followerDialogueGenderIndex = 1
	GlobalVariable Property slac_AllowFemaleDialogue Auto
	GlobalVariable Property slac_AllowMaleDialogue Auto
	Quest Property slac_FollowerDialogue Auto
	Scene Property slac_FollowerDialogueScene Auto
	Float Property FollowerDialogueLastStartTime Auto
	Quest Property slac_CreatureDialogue Auto
	Scene Property slac_CreatureDialogueScene Auto
	Float Property CreatureDialogueLastStartTime Auto
	GlobalVariable Property slac_FollowerDialogueSignal Auto
	GlobalVariable Property slac_CreatureDialogueSignal Auto
	GlobalVariable Property slac_CurrentGameTimeModulo Auto
	Faction Property slac_LastIntimidateDayFaction Auto
	Faction Property slac_LastPersuadeDayFaction Auto
	Faction Property slac_LastBribeDayFaction Auto


	; Creature Dialogue
	Bool Property creatureDialogueEnabled Auto
	Bool Property allCreatureDialogueEnabled Auto
	GlobalVariable Property slac_allCreatureDialogueEnabled Auto
	Bool Property creatureDialogueAllowSilent Auto
	Bool Property creatureDialogueAllowHorses Auto
	Bool Property creatureDialogueAllowSteal Auto
	Int Property creatureDialogueSex = 2 Auto
	GlobalVariable Property slac_AllowCreatureDialogueMale Auto
	GlobalVariable Property slac_AllowCreatureDialogueFemale Auto


; Allowed Creatures
	String[] raceKeyList
	Int allowedTogglesPage = 0
	Int totalAllowedTogglesPages = 1
	Bool allowedSync = True
	String[] DisallowedRaceKeyFPCList  ; Female PC
	String[] DisallowedRaceKeyMPCList  ; Male PC
	String[] DisallowedRaceKeyFNPCList  ; Female NPC
	String[] DisallowedRaceKeyMNPCList  ; Male NPC
	String[] disallowedRaceKeyPCList ; LEGACY PC disallowed
	Int[] allowedRacesPCOID
	Int[] allowedRacesNPCOID
	String[] allowedOptionsList
	Bool Property checkPCCreatureRace = False Auto
	Bool Property checkNPCCreatureRace = False Auto


; Aggressive Toggles
	sslBaseAnimation[] creatureAnimations
	Int[] aggressiveToggles
	Int[] aggressiveTogglesOID
	Int togglesPage = 0
	Int totalTogglesPages
	String[] togglesRecentPCAnim
	String[] togglesRecentNPCAnim
	Int[] togglesRecentPCOID
	Int[] togglesRecentNPCOID
	String[] aggressiveTogglesRaceKeyOptions
	String aggressiveTogglesRaceKey = "$SLAC_All"
	String aggressiveTogglesTags = ""
	Int animationsPerPage = 80
	Bool aggressiveTogglesTagsNegate = False
	Bool aggressiveTogglesShowRecent = False


; Profiles
	Bool slacProfileLoadTags = True
	Int[] slacProfileLoadOID
	Int[] slacProfileSaveOID
	String filePrefix = "slacSettingsProfile"
	String filePath = "../ArousedCreatures/"
	String slacProfileSaveName = "Unnamed Profile"
	
	
; Other Settings
	; Notification
	Bool Property showNotifications Auto
	Bool Property showNotificationsNPC Auto
	
	; Trans Options
	Int Property TransMFTreatAsPC Auto
	Int Property TransFMTreatAsPC Auto
	Int Property TransMFTreatAsNPC Auto
	Int Property TransFMTreatAsNPC Auto
	String[] TransTreatAsList

	; Animation Selection
	String[] ActorPositionSexList
	Int Property FemalePCRoleWithMaleCreature = 1 Auto ; Female
	Int Property FemalePCRoleWithFemaleCreature = 0 Auto ; Male
	Int Property MalePCRoleWithMaleCreature = 0 Auto ; Male
	Int Property MalePCRoleWithFemaleCreature = 0 Auto ; Male
	Int Property FemaleNPCRoleWithMaleCreature = 1 Auto ; Female
	Int Property FemaleNPCRoleWithFemaleCreature = 0 Auto ; Male
	Int Property MaleNPCRoleWithMaleCreature = 0 Auto ; Male
	Int Property MaleNPCRoleWithFemaleCreature = 0 Auto ; Male
	Bool Property NonConsensualIsAlwaysMFPC = True Auto
	Bool Property NonConsensualIsAlwaysMFNPC = True Auto
	Bool Property restrictAggressivePC Auto
	Bool Property restrictAggressiveNPC Auto
	Bool Property restrictConsensualPC Auto
	Bool Property restrictConsensualNPC Auto
	
	
	; Compatibility & Fixes - Submit, Defeat, Deviously Helpless, Convenient Horses and others.
	Bool Property submit = True Auto
	Bool Property defeat = True Auto
	Bool Property deviouslyHelpless = True Auto
	Bool Property softDependanciesChecked = True Auto
	Bool Property softDependanciesTest = False Auto
	Bool Property allowInScene = False Auto
	Bool Property claimActiveActors = True Auto
	Bool Property claimQueuedActors = True Auto
	MagicEffect Property SubmitCalm = None Auto
	MagicEffect Property DefeatCalm = None Auto
	MagicEffect Property DefeatAltCalm = None Auto
	Faction Property DefeatFaction = None Auto
	Faction Property DefeatRapistFaction = None Auto
	Keyword Property DefeatActiveKeyword = None Auto
	MagicEffect Property DeviouslyHelplessCalm = None Auto
	Bool Property convenientHorses = True Auto
	ObjectReference Property ConvenientHorsesTalker = None Auto
	Bool Property submitLoaded = False Auto
	Bool Property defeatLoaded = False Auto
	Bool Property deviouslyHelplessLoaded = False Auto
	Bool Property convenientHorsesLoaded = False Auto
	Bool Property immersiveHorsesLoaded = False Auto
	Bool Property DeviousDevicesLoaded = False Auto
	Bool Property DeviousDevicesFilter = True Auto
	Faction Property NakedDefeatActorFaction = None Auto
	Bool Property NakedDefeatLoaded = False Auto
	Bool Property NakedDefeatFilter = True Auto
	Keyword Property zad_DeviousBelt Auto
	Keyword Property zad_DeviousGag Auto
	Keyword Property zad_DeviousHood Auto
	Keyword Property zad_PermitOral Auto
	Keyword Property zad_PermitAnal Auto
	Keyword Property zad_PermitVaginal Auto
	Bool Property ToysLoaded = False Auto
	Bool Property ToysFilter = True Auto
	Keyword Property toys_BlockOral Auto
	Keyword Property toys_BlockAnal Auto
	Keyword Property toys_BlockVaginal Auto
	Bool Property DHLPBlockAuto = True Auto
	Bool Property DHLPIsSuspended = False Auto
	Bool Property DCURBlockAuto = True Auto
	Int Property AutoToggleKey = -1 Auto
	Bool Property AutoToggleState = False Auto
	Bool LastPCActive = False
	Bool LastNPCActive = False
	Bool SexLabPPlusMode = True
	Bool Property DisplayModelBlockAuto = True Auto
	Bool Property DisplayModelLoaded = False Auto
	Faction Property dse_dm_FactionActorUsingDevice = None Auto

	Faction Property PlayerHorseFaction Auto ; 00068d78
	Bool Property disallowMagicInfluenceCharm = False Auto
	Keyword Property MagicInfluenceCharm Auto	; 000424ee
	Bool Property disallowMagicAllegianceFaction = False Auto
	Faction Property MagicAllegianceFaction Auto ; 0009e0c9
	Bool Property disallowMagicCharmFaction = False Auto
	Faction Property MagicCharmFaction Auto ; 0008f3e8
	Int Property combatStateChangeCooldown = 0 Auto
	Float Property lastCombatStateChange = -60.0 Auto
	Int Property lastCombatState = 0 Auto
	Bool Property weaponsPreventAutoEngagement = False Auto
	Int Property FailedPursuitCooldown = 0 Auto 
	Int initMCMPage = 0
	String[] MCMPagesList
	Bool Property useVRCompatibility = False Auto
	Bool suppressVersionWarning = False
	
	; Testing
	Bool Property skipFilteringStartSex = False Auto
	Bool Property allowHostileEngagements Auto
	Bool Property allowCombatEngagements Auto
	Int Property hostileArousalMin = 0 Auto
	GlobalVariable Property slac_AllowCombatEngagements Auto
	Bool Property disableSLACStripping = False Auto
	Bool Property allowDialogueAutoEngage = False Auto
	Bool Property allowMenuAutoEngage = False Auto

	; Collars
	Bool Property onlyCollared Auto
	Bool Property collarAttraction Auto
	Int Property collaredArousalMin Auto
	Int Property kSlotMask35 = 0x00000020 AutoReadOnly ; Amulet
	Int Property kSlotMask45 = 0x00008000 AutoReadOnly ; DD Collar
	int Property kSlotMask46 = 0x00010000 AutoReadOnly ; DD Suit
	Actor Property targetActor = none Auto
	FormList Property slac_CollarsFormList Auto
	Form playerAmuletForm
	Form playerCollarForm
	Form playerSuitForm
	Form targetAmuletForm
	Form targetCollarForm
	Form targetSuitForm
	Int[] collarsOID

	; Notify Testing
	String[] EventIDs
	Int NTEventIDIndex = 0
	Bool NTConsensual = False
	Bool NTGroup = False
	Bool NTCreatureVictim = False
	Bool NTOral = False
	Bool NTAnal = False
	Int NTTypeIndex = 0
	String[] NTTypeList
	Bool NTMasturbation = False
	Bool NTGet = False


; Help
	Bool Property InMaintenance = True Auto
	Bool Property InInitMaintenance = True Auto
	String[] failedActorsNPCs
	String[] failedActorsCreatures
	String[] failedActorsNPCsString
	String[] failedActorsCreaturesString
	Actor[] failedActorsNPCsRef
	Actor[] failedActorsCreaturesRef
	Int[] failedActorsNPCsOID
	Int[] failedActorsCreaturesOID
	Faction Property slac_AutoEngageBlockedFaction Auto
	Faction Property slac_AutoEngagePermittedFaction Auto


; Unused - Should be removed for v5+
	Bool Property weaponsPreventAutoEnagagment = False Auto ; spelling
	Int Property nextEngageTime = 0 Auto ; cooldown
	Bool Property cooldownNPCGlobal Auto
	Bool Property allowMaleReceiverPC Auto
	Bool Property allowMaleReceiverNPC Auto
	Int pcVictimTransSexIndex = 0
	Int npcVictimTransSexIndex = 0
	String[] victimTransSexList
	Int Property pcVictimTransSexValue Auto
	Int Property npcVictimTransSexValue Auto
	MagicEffect Property slac_ActiveCreatureEffect Auto
	MagicEffect Property slac_IgnoreCreature Auto
	EffectShader Property LifeDetected Auto
	EffectShader Property LifeDetectedEnemy Auto
	Bool Property allowPCMultiple Auto
	Bool Property allowNPCMultiple Auto
	Float Property ignoreDuration Auto
	Int Property relationshipRankMin Auto
	Bool Property debugHitShaders Auto
	Bool Property pcOnlyNaked Auto
	Bool Property npcOnlyNaked Auto
	Bool Property allowNPCFollowers Auto
	Bool Property allowCreatureFollowers Auto
	Bool Property struggleExhaustionEnabled Auto


; Version
Int Function GetVersion()
    Return 40037
EndFunction
String Function GetVersionString()
    Return "4.16"
EndFunction


Event OnConfigInit()
	; Menu Lists
	Pages = new String[8]
	Pages[0] = "$SLAC_General_Settings"
	Pages[1] = "$SLAC_PC_NPC_Settings"
	Pages[2] = "$SLAC_Dialogue_and_Interactions"
	Pages[3] = "$SLAC_Allowed_Creatures"
	Pages[4] = "$SLAC_Aggressive_Animation_Toggles"
	Pages[5] = "$SLAC_Other_Settings"
	Pages[6] = "$SLAC_Profiles"
	Pages[7] = "$SLAC_Help"
	
	actorPreferenceList = new String[4]
	actorPreferenceList[0] = "$SLAC_No_Preference"
	actorPreferenceList[1] = "$SLAC_Prefers_PC"
	actorPreferenceList[2] = "$SLAC_Prefers_NPCs"
	actorPreferenceList[3] = "$SLAC_Fifty_Fifty"
	
	pcConsensualList = new String[3]
	pcConsensualList[0] = "$SLAC_Consensual"
	pcConsensualList[1] = "$SLAC_Non_Consensual"
	pcConsensualList[2] = "$SLAC_Adaptive"
	
	npcConsensualList = new String[3]
	npcConsensualList[0] = "$SLAC_Consensual"
	npcConsensualList[1] = "$SLAC_Non_Consensual"
	npcConsensualList[2] = "$SLAC_Adaptive"
	
	consensualQueueList = new String[4]
	consensualQueueList[0] = "$SLAC_Consensual"
	consensualQueueList[1] = "$SLAC_Non_Consensual"
	consensualQueueList[2] = "$SLAC_Adaptive"
	consensualQueueList[3] = "$SLAC_Same"
	
	creatureSexList = new String[3]
	creatureSexList[0] = "$SLAC_Male"
	creatureSexList[1] = "$SLAC_Female"
	creatureSexList[2] = "$SLAC_Both"
	
	victimSexList = new String[3]
	victimSexList[0] = "$SLAC_Male"
	victimSexList[1] = "$SLAC_Female"
	victimSexList[2] = "$SLAC_Both"
	
	; victimTransSexList no longer used 40002
	victimTransSexList = new String[5]
	victimTransSexList[0] = "$SLAC_Disabled"
	victimTransSexList[1] = "$SLAC_Female_Male"
	victimTransSexList[2] = "$SLAC_Male_Female"
	victimTransSexList[3] = "$SLAC_Both"
	victimTransSexList[4] = "$SLAC_Neither"
	
	TransTreatAsList = new String[4]
	TransTreatAsList[0] = "$SLAC_Male"
	TransTreatAsList[1] = "$SLAC_Female"
	TransTreatAsList[2] = "$SLAC_Either"
	TransTreatAsList[3] = "$SLAC_Ignored"
	
	allowedOptionsList = New String[4]
	allowedOptionsList[0] = "$SLAC_Not_Allowed"
	allowedOptionsList[1] = "$SLAC_Allow_Female_Partners"
	allowedOptionsList[2] = "$SLAC_Allow_Male_Partners"
	allowedOptionsList[3] = "$SLAC_Allow_Male_And_Female_Partners"

	pcCrouchList = new String[4]
	pcCrouchList[0] = "$SLAC_No_Effect"
	pcCrouchList[1] = "$SLAC_Allow"
	pcCrouchList[2] = "$SLAC_Prevent"
	pcCrouchList[3] = "$SLAC_Invite"

	suitorsPCCrouchEffectList = new String[3]
	suitorsPCCrouchEffectList[0] = "$SLAC_No_Effect"
	suitorsPCCrouchEffectList[1] = "$SLAC_Allow"
	suitorsPCCrouchEffectList[2] = "$SLAC_Prevent"
	
	pcRequiredArousalList = new String[5]
	pcRequiredArousalList[0] = "$SLAC_Both"
	pcRequiredArousalList[1] = "$SLAC_Either"
	pcRequiredArousalList[2] = "$SLAC_Creature_Only"
	pcRequiredArousalList[3] = "$SLAC_PC_Only"
	pcRequiredArousalList[4] = "$SLAC_Either_With_Invite"
	
	npcRequiredArousalList = new String[5]
	npcRequiredArousalList[0] = "$SLAC_Both"
	npcRequiredArousalList[1] = "$SLAC_Either"
	npcRequiredArousalList[2] = "$SLAC_Creature_Only"
	npcRequiredArousalList[3] = "$SLAC_NPC_Only"
	npcRequiredArousalList[4] = "$SLAC_Either_With_Invite"
	
	pcnpcRequiredArousalList = new String[4]
	pcnpcRequiredArousalList[0] = "$SLAC_Both"
	pcnpcRequiredArousalList[1] = "$SLAC_Either"
	pcnpcRequiredArousalList[2] = "$SLAC_Creature_Only"
	pcnpcRequiredArousalList[3] = "$SLAC_PCNPC_Only"
	
	scanMethodList = new String[3]
	scanMethodList[0] = "$SLAC_Cloak_Spell"
	scanMethodList[1] = "$SLAC_Quest_Alias"
	scanMethodList[2] = "$SLAC_SL_Cell_Scan"
	
	; Performance profile times
	executionTimes = new Float[20]
	Int i = 0
	While i < executionTimes.length
		executionTimes[i] = -1.0
		i += 1
	EndWhile
	
	; Recent animations lists
	togglesRecentPCAnim = new String[5]
	togglesRecentNPCAnim = new String[5]
	togglesRecentPCOID = new Int[5]
	togglesRecentNPCOID = new Int[5]
		
	; Debugging
	failedActorsNPCs = new String[10]
	failedActorsCreatures = new String[10]
	failedActorsNPCsString = new String[10]
	failedActorsCreaturesString = new String[10]
	failedActorsNPCsOID = new Int[10]
	failedActorsCreaturesOID = new Int[10]
	
	; Queuing
	queueTypeList = new String[2]
	queueTypeList[0] = "$SLAC_Line"
	queueTypeList[1] = "$SLAC_Circle"
	
	ArmorClassList = new String[5]
	ArmorClassList[0] = "$SLAC_Light"
	ArmorClassList[1] = "$SLAC_Heavy"
	ArmorClassList[2] = "$SLAC_Clothing"
	ArmorClassList[3] = "$SLAC_Naked"
	ArmorClassList[4] = "$SLAC_Default"
	
	ActorPositionSexList = new String[3]
	ActorPositionSexList[0] = "$SLAC_Male"
	ActorPositionSexList[1] = "$SLAC_Female"
	ActorPositionSexList[2] = "$SLAC_Either"
	
	FemalePCRoleWithMaleCreature = 1 ; Female
	FemalePCRoleWithFemaleCreature = 0 ; Male
	MalePCRoleWithMaleCreature = 0 ; Male
	MalePCRoleWithFemaleCreature = 0 ; Male
	
	FemaleNPCRoleWithMaleCreature = 1 ; Female
	FemaleNPCRoleWithFemaleCreature = 0 ; Male
	MaleNPCRoleWithMaleCreature = 0 ; Male
	MaleNPCRoleWithFemaleCreature = 0 ; Male
		
	NonConsensualIsAlwaysMFPC = True
	NonConsensualIsAlwaysMFNPC = True
	
	textSexString = new String[3] ; Used for interpolative text replacement where necessary
	textSexString[0] = "Male"
	textSexString[1] = "Female"
	textSexString[2] = "Both"
	
	; NPC Types
	allowedNPCFollowersList = new String[3]
	allowedNPCFollowersList[0] = "$SLAC_Followers_and_NonFollowers"
	allowedNPCFollowersList[1] = "$SLAC_Followers_Only"
	allowedNPCFollowersList[2] = "$SLAC_NonFollowers_Only"
	
	; Creature Types
	allowedCreatureFollowersList = new String[3]
	allowedCreatureFollowersList[0] = "$SLAC_Followers_and_NonFollowers"
	allowedCreatureFollowersList[1] = "$SLAC_Followers_Only"
	allowedCreatureFollowersList[2] = "$SLAC_NonFollowers_Only"

	; Creature sexes for male NPC as victim
	NPCMaleAllowVictimList = new String[4] 
	NPCMaleAllowVictimList[0] = "$SLAC_Males"
	NPCMaleAllowVictimList[1] = "$SLAC_Females"
	NPCMaleAllowVictimList[2] = "$SLAC_Both"
	NPCMaleAllowVictimList[3] = "$SLAC_None"

	; Notify Testing
	NTTypeList = new String[4]
	NTTypeList[0] = "$SLAC_Normal"
	NTTypeList[1] = "$SLAC_Oral"
	NTTypeList[2] = "$SLAC_Anal"
	NTTypeList[3] = "$SLAC_Masturbation"

	; Compressed FF/MM options
	AllowedSameSexList = new String[4]
	AllowedSameSexList[0] = "$SLAC_Allow_None"
	AllowedSameSexList[1] = "$SLAC_Allow_MM"
	AllowedSameSexList[2] = "$SLAC_Allow_FF"
	AllowedSameSexList[3] = "$SLAC_Allow_Both"

	; NPC Cooldown Type
	cooldownNPCTypeList = new String[4]
	cooldownNPCTypeList[0] = "$SLAC_Global"
	cooldownNPCTypeList[1] = "$SLAC_Personal_NPC"
	cooldownNPCTypeList[2] = "$SLAC_Personal_Creature"
	cooldownNPCTypeList[3] = "$SLAC_Personal_Both"

	; Struggle Mode
	struggleExhaustionModeList = new String[4]
	struggleExhaustionModeList[0] = "$SLAC_Disabled"
	struggleExhaustionModeList[1] = "$SLAC_After_Failure"
	struggleExhaustionModeList[2] = "$SLAC_After_Non-Con"
	struggleExhaustionModeList[3] = "$SLAC_Always"
EndEvent

Event OnVersionUpdate(Int newVersion)
	If CurrentVersion == 0
		Log("Aroused Creatures v" + newVersion + " installed", ForceTrace = True)
		Return
	ElseIf newVersion == CurrentVersion
		Log("Aroused Creatures v" + newVersion, ForceTrace = True)
		Return
	EndIf
	
	Log("Aroused Creatures updating from v" + CurrentVersion + " to " + newVersion + " (" + GetVersionString() + ")", True, True, True)
	
	; v04.0 Beta 05 (SE Conversion)
    If newVersion >= 32019 && CurrentVersion < 32019
		; Update workaround transsexual options to match new conditions
		If pcVictimTransSexValue == 1
			pcVictimTransSexValue = 2
			pcVictimTransSexIndex = 2
			Log("Aroused Creatures PC Transgender settings updated to Male->Female", True, True, True)
		ElseIf pcVictimTransSexValue == 2
			pcVictimTransSexValue = 1
			pcVictimTransSexIndex = 1
			Log("Aroused Creatures PC Transgender settings updated to Female->Male", True, True, True)
		EndIf
		If npcVictimTransSexValue == 1
			npcVictimTransSexValue = 2
			npcVictimTransSexIndex = 2
			Log("Aroused Creatures NPC Transgender settings updated to Male->Female", True, True, True)
		ElseIf npcVictimTransSexValue == 2
				npcVictimTransSexValue = 1
				npcVictimTransSexIndex = 1
			Log("Aroused Creatures NPC Transgender settings updated to Female->Male", True, True, True)
		EndIf
		
		; Update scan frequency to new default if it is currently at old default
		If checkFrequency == 5
			checkFrequency == 15
			Log("Aroused Creatures default Scan Frequency updated to 15sec", True, True, True)
		EndIF
	EndIf
	
	; v04.0 Beta 06
	If newVersion >= 32020 && CurrentVersion < 32020
		; new Allowed Creatures page
		Pages = New String[5]
		Pages[0] = "$SLAC_General_Settings"
		Pages[1] = "$SLAC_PC_NPC_Settings"
		Pages[2] = "$SLAC_Other_Settings"
		Pages[3] = "$SLAC_Aggressive_Animation_Toggles"
		Pages[4] = "$SLAC_Allowed_Creatures"
		Log("Aroused Creatures Allowed Creatures MCM page added", True, True, True)
		
		; New Allowed Creatures props
		checkPCCreatureRace = False
		checkNPCCreatureRace = False
		
		; New orgy mode props
		orgyModePC = False
		orgyModeNPC = False
		orgyArousalMinPC = 10
		orgyArousalMinNPC = 10
		orgyArousalMinPCCreature = 5
		orgyArousalMinNPCCreature = 5
		orgyRequiredArousalPCIndex = 1
		orgyRequiredArousalNPCIndex = 1
		orgyConsentPCIndex = 0
		orgyConsentNPCIndex = 0
		pcnpcRequiredArousalList = new String[4]
		pcnpcRequiredArousalList[0] = "$SLAC_Both"
		pcnpcRequiredArousalList[1] = "$SLAC_Either"
		pcnpcRequiredArousalList[2] = "$SLAC_Creature_Only"
		pcnpcRequiredArousalList[3] = "$SLAC_PCNPC_Only"
		
		; New elder actor filter
		allowElders = False
	EndIf
	
	; v04.0 Beta 07
	If newVersion >= 32021 && CurrentVersion < 32021
		showNotificationsNPC = True
		; Multi-position animation props
		groupChancePC = 0
		groupChanceNPC = 0
		groupMaxExtrasPC = 3
		groupMaxExtrasNPC = 3
		groupArousalPC = 20
		groupArousalNPC = 20
		Log("Aroused Creatures multi-position animation support added", True, True, True)
		
	EndIf
	
	; v04.0 Beta 08
	If newVersion >= 32022 && CurrentVersion < 32022
		; Male NPCs
		NPCMaleArousalMin = 60
		NPCMaleCreatureArousalMin = 80
		NPCMaleRequiredArousalIndex = 3
		NPCMaleConsensualIndex = 1
		allowMaleReceiverPC = False
		allowMaleReceiverNPC = False
		Log("Aroused Creatures male NPC settings added", True, True, True)
	EndIf
	
	; v04.0 Beta 09
	If newVersion >= 32023 && CurrentVersion < 32023
		; Pursuit tuning
		pursuitCaptureRadiusPC = 15
		pursuitEscapeRadiusPC = 250
		pursuitCaptureRadiusNPC = 15
		pursuitEscapeRadiusNPC = 250
		UpdateGlobals()
		
		; performance profiling
		executionTimes = new Float[20]
		Int i = 0
		While i < executionTimes.length
			executionTimes[i] = -1.0
			i += 1
		EndWhile
	EndIf
	
	; v04.0 Beta 10
	If newVersion >= 32024 && CurrentVersion < 32024
		; Unset pursuit
		;pursuitNPCPounceOID = -1
		; Male PC invite consent option
		inviteConsentPCIndex = 2
		Log("Aroused Creatures invite consent settings added", True, True, True)
	EndIf
	
	; v04.0 Beta 11
	If newVersion >= 32034 && CurrentVersion < 32034
		; New default check frequency (will reduce unnecessary checks in empty cells)
		If checkFrequency < 10
			checkFrequency == 10
		EndIf
		
		; Aggressive Toggles options
		togglesPage = 0
		togglesRecentPCAnim = new String[5]
		togglesRecentNPCAnim = new String[5]
		togglesRecentPCOID = new Int[5]
		togglesRecentNPCOID = new Int[5]
		
		; Dialogue
		horseRefusalPCMounting = False
		horseRefusalPCRiding = False
		horseRefusalPCThreshold = 50
		followerCommandThreshold = 50
		creatureCommandThreshold = 40
		followerDialogueEnabled = True
		nonFollowerDialogueEnabled = False
		followerDialogueGenderIndex = 1
		creatureDialogueAllowSilent = False
		creatureDialogueAllowHorses = False
		creatureDialogueAllowSteal = False
		
		; Struggle
		struggleEnabled = True
		struggleKeyOne = 30
		struggleKeyTwo = 32
		struggleStaminaDamage = 4.0
		struggleStaminaDamageMultiplier = 1.0
		struggleTimingOne = 0.0
		struggleTimingTwo = 5.0
		struggleFailureEnabled = True
		struggleQueueEscape = False
		
		; Debugging
		failedActorsNPCs = new String[10]
		failedActorsCreatures = new String[10]
		failedActorsNPCsString = new String[10]
		failedActorsCreaturesString = new String[10]
		failedActorsNPCsOID = new Int[10]
		failedActorsCreaturesOID = new Int[10]
		
		; MCM
		Pages = new String[7]
		Pages[0] = "$SLAC_General_Settings"
		Pages[1] = "$SLAC_PC_NPC_Settings"
		Pages[2] = "$SLAC_Dialogue_and_Interactions"
		Pages[3] = "$SLAC_Allowed_Creatures"
		Pages[4] = "$SLAC_Aggressive_Animation_Toggles"
		Pages[5] = "$SLAC_Other_Settings"
		Pages[6] = "$SLAC_Help"
		
		Log("Aroused Creatures MCM options updated", True, True, True)
		
		; Queueing
		queueLengthMaxPC = 2
		queueLengthMaxNPC = 2
		allowQueueLeaversPC = False
		allowQueueLeaversNPC = False
		
		; Invite
		inviteAnimationPC = 1
		inviteAnimationNPC = 1
		
		; New preference option (50/50)
		actorPreferenceList = new String[4]
		actorPreferenceList[0] = "$SLAC_No_Preference"
		actorPreferenceList[1] = "$SLAC_Prefers_PC"
		actorPreferenceList[2] = "$SLAC_Prefers_NPCs"
		actorPreferenceList[3] = "$SLAC_Fifty_Fifty"
	EndIf
	
	If newVersion >= 32035 && CurrentVersion < 32035
		Log("Aroused Creatures Compatibility options updated", True, True, True)
		; Other Settings
		convenientHorses = True
		disallowMagicInfluenceCharm = False
		disallowMagicAllegianceFaction = False
		disallowMagicCharmFaction = False
		combatStateChangeCooldown = 0
		lastCombatStateChange = -60.0
		lastCombatState = 0
		weaponsPreventAutoEnagagment = False
	EndIf
	
	If newVersion >= 32036 && CurrentVersion < 32036
		Log("Aroused Creatures Suitor options added", True, True, True)
		pursuitInviteAnimationPC = 1
		suitorsMaxPC = 0
		suitorsPCArousalMin = 60
	EndIf
	
	If newVersion >= 40001 && CurrentVersion < 40001
		Log("Aroused Creatures MCM options updated", True, True, True)
		
		Pages = new String[8]
		Pages[0] = "$SLAC_General_Settings"
		Pages[1] = "$SLAC_PC_NPC_Settings"
		Pages[2] = "$SLAC_Dialogue_and_Interactions"
		Pages[3] = "$SLAC_Allowed_Creatures"
		Pages[4] = "$SLAC_Aggressive_Animation_Toggles"
		Pages[5] = "$SLAC_Other_Settings"
		Pages[6] = "$SLAC_Profiles"
		Pages[7] = "$SLAC_Help"
		
		struggleMeterHidden = False
		
		aggressiveTogglesRaceKey = "$SLAC_All"
		aggressiveTogglesTags = ""
	EndIf
	
	If newVersion >= 40006 && CurrentVersion < 40006
		TransTreatAsList = new String[4]
		TransTreatAsList[0] = "$SLAC_Male"
		TransTreatAsList[1] = "$SLAC_Female"
		TransTreatAsList[2] = "$SLAC_Either"
		TransTreatAsList[3] = "$SLAC_Ignored"
		TransMFTreatAsPC = 1
		TransFMTreatAsPC = 0
		TransMFTreatAsNPC = 1
		TransFMTreatAsNPC = 0
	
		; Convert PC Trans Settings
		If pcVictimTransSexIndex == 0 || pcVictimTransSexIndex == 4
			TransMFTreatAsPC = 3
			TransFMTreatAsPC = 3
		ElseIf pcVictimTransSexIndex == 1
			TransMFTreatAsPC = 3
			TransFMTreatAsPC = 0
		ElseIf pcVictimTransSexIndex == 2
			TransMFTreatAsPC = 1
			TransFMTreatAsPC = 3
		ElseIf pcVictimTransSexIndex == 3
			TransMFTreatAsPC = 1
			TransFMTreatAsPC = 0
			TransMFTreatAsPC = 1
			TransFMTreatAsPC = 0
		EndIf
		
		; Convert NPC Trans Settings
		If npcVictimTransSexIndex == 0 || npcVictimTransSexIndex == 4
			TransMFTreatAsNPC = 3
			TransFMTreatAsNPC = 3
		ElseIf npcVictimTransSexIndex == 1
			TransMFTreatAsNPC = 3
			TransFMTreatAsNPC = 0
		ElseIf npcVictimTransSexIndex == 2
			TransMFTreatAsNPC = 1
			TransFMTreatAsNPC = 3
		ElseIf npcVictimTransSexIndex == 3
			TransMFTreatAsNPC = 1
			TransFMTreatAsNPC = 0
			TransMFTreatAsNPC = 1
			TransFMTreatAsNPC = 0
		EndIf
	
		inviteOpensHorseDialogue = False
		inviteOpensCreatureDialogue = False
		consensualQueuePC = 2
		consensualQueueNPC = 2
		consensualQueueList = new String[4]
		consensualQueueList[0] = "$SLAC_Consensual"
		consensualQueueList[1] = "$SLAC_Non_Consensual"
		consensualQueueList[2] = "$SLAC_Adaptive"
		consensualQueueList[3] = "$SLAC_Same"
		
		cooldownPC = 0
		cooldownNPC = 0
		cooldownNPCGlobal = False
		
		LocationCityAllowPC = True
		LocationTownAllowPC = True
		LocationDwellingAllowPC = True
		LocationInnAllowPC = True
		LocationPlayerHouseAllowPC = True
		LocationDungeonAllowPC = False
		LocationDungeonClearedAllowPC = True
		LocationOtherAllowPC = True
		
		LocationCityAllowNPC = True
		LocationTownAllowNPC = True
		LocationDwellingAllowNPC = True
		LocationInnAllowNPC = True
		LocationPlayerHouseAllowNPC = True
		LocationDungeonAllowNPC = False
		LocationDungeonClearedAllowNPC = True
		LocationOtherAllowNPC = True
		
		skipFilteringStartSex = False
		
		Log("Aroused Creatures options updated", True, True, True)
	EndIf
	
	If newVersion >= 40007 && CurrentVersion < 40007
		; Queuing
		queueTypePC = 1
		queueTypeNPC = 1
		queueTypeList = new String[2]
		queueTypeList[0] = "$SLAC_Line"
		queueTypeList[1] = "$SLAC_Circle"
		
		Log("Aroused Creatures queuing options updated", True, True, True)
	EndIf
	
	If newVersion >= 40009 && CurrentVersion < 40009
		inviteStripDelayPC = 3
		
		Log("Aroused Creatures strip delay updated", True, True, True)
	EndIf
	
	If newVersion >= 40010 && CurrentVersion < 40010 ; v4.08
		allowFamiliarsPC = True
		allowFamiliarsNPC = True
		initMCMPage = 0
		debugScanShaders = False
		slac_DebugScanShaders.SetValue(debugScanShaders as Int)
		useVRCompatibility = False
		animationsPerPage = 80
		
		Log("Aroused Creatures MCM settings updated", True, True, True)
	EndIf
	
	If newVersion >= 40012 && CurrentVersion < 40012 ; v4.09
		AllowHeavyArmorPC = !pcOnlyNaked
		AllowLightArmorPC = !pcOnlyNaked
		AllowClothingPC = !pcOnlyNaked
		AllowHeavyArmorNPC = !npcOnlyNaked
		AllowLightArmorNPC = !npcOnlyNaked
		AllowClothingNPC = !npcOnlyNaked
		
		suitorsPCAllowWeapons = False
		
		Log("Aroused Creatures: Armor & Clothing settings updated", True, True, True)
	EndIf
	
	If newVersion >= 40017 && CurrentVersion < 40017 ; v4.09
		pcRequiredArousalList = new String[5]
		pcRequiredArousalList[0] = "$SLAC_Both"
		pcRequiredArousalList[1] = "$SLAC_Either"
		pcRequiredArousalList[2] = "$SLAC_Creature_Only"
		pcRequiredArousalList[3] = "$SLAC_PC_Only"
		pcRequiredArousalList[4] = "$SLAC_Either_With_Invite"
		
		npcRequiredArousalList = new String[5]
		npcRequiredArousalList[0] = "$SLAC_Both"
		npcRequiredArousalList[1] = "$SLAC_Either"
		npcRequiredArousalList[2] = "$SLAC_Creature_Only"
		npcRequiredArousalList[3] = "$SLAC_NPC_Only"
		npcRequiredArousalList[4] = "$SLAC_Either_With_Invite"
	
		ArmorClassList = new String[5]
		ArmorClassList[0] = "$SLAC_Light"
		ArmorClassList[1] = "$SLAC_Heavy"
		ArmorClassList[2] = "$SLAC_Clothing"
		ArmorClassList[3] = "$SLAC_Naked"
		ArmorClassList[4] = "$SLAC_Default"
		
		horseRefusalPCSex = 0
		
		allowedOptionsList = New String[4]
		allowedOptionsList[0] = "$SLAC_Not_Allowed"
		allowedOptionsList[1] = "$SLAC_Allow_Female_Partners"
		allowedOptionsList[2] = "$SLAC_Allow_Male_Partners"
		allowedOptionsList[3] = "$SLAC_Allow_Male_And_Female_Partners"
		
		; Convert old allowed creatures
		disallowedRaceKeyFPCList = disallowedRaceKeyPCList
		disallowedRaceKeyMPCList = disallowedRaceKeyPCList
		disallowedRaceKeyFNPCList = disallowedRaceKeyPCList
		disallowedRaceKeyMNPCList = disallowedRaceKeyPCList
		
		aggressiveTogglesTagsNegate = False
		
		DeviousDevicesFilter = True
		
		Log("Aroused Creatures: Allowed Creatures updated", True, True, True)
		Log("Aroused Creatures: New settings available", True, True, True)
	EndIf
	
	If newVersion >= 40020 && CurrentVersion < 40020 ; v4.10
		; Cooldown
		nextEngageTime = 0
		
		; Max SL anim performance limit
		SLAnimationMax = 15
		
		; Stamina widget default positions
		widgetXPositionNPC = 925.0
		widgetYPositionNPC = 655.0
		slacUtility.WidgetManager.SetXPosition(widgetXPositionNPC)
		slacUtility.WidgetManager.SetYPosition(widgetYPositionNPC)
		
		; Expand same-sex options to separate PC / NPC settings
		allowPCMM = allowNPCMM
		allowPCFF = allowNPCFF
		
		; Add follower NPC/Creature option
		allowedNPCFollowers = 0 ; all
		allowedNPCFollowersList = new String[3]
		allowedNPCFollowersList[0] = "$SLAC_Followers_and_NonFollowers"
		allowedNPCFollowersList[1] = "$SLAC_Followers_Only"
		allowedNPCFollowersList[2] = "$SLAC_NonFollowers_Only"
		allowedPCCreatureFollowers = 0 ; all
		allowedNPCCreatureFollowers = 0 ; all
		allowedCreatureFollowersList = new String[3]
		allowedCreatureFollowersList[0] = "$SLAC_Followers_and_NonFollowers"
		allowedCreatureFollowersList[1] = "$SLAC_Followers_Only"
		allowedCreatureFollowersList[2] = "$SLAC_NonFollowers_Only"

		; Add Sex After Refusal option
		horseRefusalPCEngage = False
		
		; Add Male Queuing option
		NPCMaleQueuing = False
		
		; Creature invite/dialogue sex restriction
		inviteCreatureSex = 2 ; both
		creatureDialogueSex = 2 ; both
		
		; PC/NPC animation selection for actor/creature sex combinations
		ActorPositionSexList = new String[3]
		ActorPositionSexList[0] = "$SLAC_Male"
		ActorPositionSexList[1] = "$SLAC_Female"
		ActorPositionSexList[2] = "$SLAC_Either"
		
		FemalePCRoleWithMaleCreature = 1 ; Female
		FemalePCRoleWithFemaleCreature = 0 ; Male
		MalePCRoleWithMaleCreature = CondInt(allowMaleReceiverPC,1,0) ; Female / Male
		MalePCRoleWithFemaleCreature = 0 ; Male
		
		FemaleNPCRoleWithMaleCreature = 1 ; Female
		FemaleNPCRoleWithFemaleCreature = 0 ; Male
		MaleNPCRoleWithMaleCreature = CondInt(allowMaleReceiverNPC,1,0) ; Female / Male
		MaleNPCRoleWithFemaleCreature = 0 ; Male
		
		NonConsensualIsAlwaysMFPC = True
		NonConsensualIsAlwaysMFNPC = True
		
		 ; Used for interpolative text replacement where necessary
		textSexString = new String[3]
		textSexString[0] = "Male"
		textSexString[1] = "Female"
		textSexString[2] = "Both"
	
		
		; Rationalise victim sex selection
		; was [0] Both, [1] Male, [2] Female
		victimSexList = new String[3]
		victimSexList[0] = "$SLAC_Male"
		victimSexList[1] = "$SLAC_Female"
		victimSexList[2] = "$SLAC_Both"
		
		; pc/npcVictimSexValue was previously index based with a -1 offset, so we just need to wrap the indexes around
		pcVictimSexValue = CondInt(pcVictimSexValue == -1, 2, pcVictimSexValue)
		npcVictimSexValue = CondInt(npcVictimSexValue == -1, 2, npcVictimSexValue)
		
		;Log("Aroused Creatures: Converting PC/NPC Victim Sex Values - " + textSexString[pcVictimSexValue] + "/" + textSexString[npcVictimSexValue], ForceNote = True)
		
		; pc/npcCreatureSexvalue was previously an index with a -2 offset but no change in index order
		; - 2 = convert existing value, 0 = male
		pcCreatureSexValue = CondInt(pcCreatureSexValue > 1, pcCreatureSexValue - 2, 0)
		npcCreatureSexValue = CondInt(npcCreatureSexValue > 1, npcCreatureSexValue - 2, 0)
		
		;Log("Aroused Creatures: Converting PC/NPC Creature Sex Values - " + textSexString[pcCreatureSexValue] + "/" + textSexString[npcCreatureSexValue], ForceNote = True)
		
		; For followerDialogueGenderIndex the [0] Both index becomes [2]
		followerDialogueGenderIndex = CondInt(followerDialogueGenderIndex == 0, 2, followerDialogueGenderIndex - 1)
		
		; Suitors
		suitorsPCAllowLeave = False

		; Compatibility
		disableSLACStripping = False
		toysFilter = True

		; Testing
		hostileArousalMin = 0

		Log("Aroused Creatures: Converting PC/NPC/Creature sex values converted")
		Log("Aroused Creatures: New settings available", ForceNote = True)
		
		UpdateGlobals()
	EndIf
	
	If newVersion >= 40026 && CurrentVersion < 40026 ; v4.11
		; Creature sexes for male NPC as victim
		NPCMaleAllowVictim = 3 
		NPCMaleAllowVictimList = new String[4] 
		NPCMaleAllowVictimList[0] = "$SLAC_Male"
		NPCMaleAllowVictimList[1] = "$SLAC_Female"
		NPCMaleAllowVictimList[2] = "$SLAC_Both"
		NPCMaleAllowVictimList[3] = "$SLAC_None"

		; Notify Testing
		NTTypeList = new String[4]
		NTTypeList[0] = "$SLAC_Normal"
		NTTypeList[1] = "$SLAC_Oral"
		NTTypeList[2] = "$SLAC_Anal"
		NTTypeList[3] = "$SLAC_Masturbation"

		; Compressed FF/MM options
		AllowedSameSexList = new String[4]
		AllowedSameSexList[0] = "$SLAC_Allow_None"
		AllowedSameSexList[1] = "$SLAC_Allow_MM"
		AllowedSameSexList[2] = "$SLAC_Allow_FF"
		AllowedSameSexList[3] = "$SLAC_Allow_Both"

		; Naked Arousal threshold modifier 
		CreatureNakedArousalModPC = 100
		CreatureNakedArousalModNPC = 100

		; Cooldown Type
		cooldownNPCType = 0
		cooldownNPCTypeList = new String[4]
		cooldownNPCTypeList[0] = "$SLAC_Global"
		cooldownNPCTypeList[1] = "$SLAC_Personal_NPC"
		cooldownNPCTypeList[2] = "$SLAC_Personal_Creature"
		cooldownNPCTypeList[3] = "$SLAC_Personal_Both"

		; Replace nextEngageTime
		If cooldownNPC > 0
			; Personal NPC
			cooldownNPCType = 1
			nextEngageTime = 0

		ElseIf nextEngageTime >= 1
			; Global
			cooldownNPCType = 0
			cooldownNPC = nextEngageTime
			nextEngageTime = 0

		EndIf
		
		; Round up cooldown duration to multiples of 60.
		; While the MCM will show minutes the value will still be stored in seconds to simplify use in code.
		If cooldownPC > 0
			cooldownPC = Math.Ceiling(cooldownPC / 60) * 60
		EndIf
		If cooldownNPC > 0
			cooldownNPC = Math.Ceiling(cooldownNPC / 60) * 60
		EndIf
	EndIf

	If newVersion >= 40029 && CurrentVersion < 40029 ; v4.12
		; Spelling correction
		weaponsPreventAutoEngagement = weaponsPreventAutoEnagagment

		; Swapping animation name to registry lookup so we need to clear recorded animation names
		togglesRecentPCAnim = new String[5]
		togglesRecentNPCAnim = new String[5]

	EndIf

	If newVersion >= 40030 && CurrentVersion < 40030 ; v4.13
		; DHLP mod event compatibility option
		DHLPBlockAuto = True
		DHLPIsSuspended = False

		; Deviously Cursed Loot scene compatibility
		DCURBlockAuto = True

		; Auto engagement toggle key (compatibility)
		AutoToggleKey = -1
		AutoToggleState = False

		; SexLab P+ Support Option
		SexLabPPlusMode = True
		
	EndIf

	If newVersion >= 40032 && CurrentVersion < 40032 ; v4.13.2
		; Actor Permissions
		OnlyPermittedNPCs = False
		OnlyPermittedCreaturesPC = False
		OnlyPermittedCreaturesNPC = False

		; Display Model Compatibility
		DisplayModelBlockAuto = True

		; Suitor Crouch Effect
		suitorsPCCrouchEffect = 0
		suitorsPCCrouchEffectList = new String[3]
		suitorsPCCrouchEffectList[0] = "$SLAC_No_Effect"
		suitorsPCCrouchEffectList[1] = "$SLAC_Allow"
		suitorsPCCrouchEffectList[2] = "$SLAC_Prevent"
	
	EndIf

	If newVersion >= 40035 && CurrentVersion < 40035 ; v4.15
		; Struggle Mode
		struggleExhaustionMode = 1
		struggleExhaustionModeList = new String[4]
		struggleExhaustionModeList[0] = "$SLAC_Disabled"
		struggleExhaustionModeList[1] = "$SLAC_After_Failure"
		struggleExhaustionModeList[2] = "$SLAC_After_Non-Con"
		struggleExhaustionModeList[3] = "$SLAC_Always"
	EndIf
EndEvent


; Logging
Function Log(String logMessage, Bool forceTrace = False, Bool forceNote = False, Bool forceConsole = False)
	slacUtility.Log(logMessage, forceTrace, forceNote, forceConsole)
EndFunction


; Compare script versions and generate warning message on mismatch.
Function VersionCheck()
	String warningMessage = ""
	If GetVersion() != slacUtility.GetVersion() && GetVersion() != slacPlayerScript.GetVersion()
		warningMessage = "The slac_Utility.pex and slac_PlayerScript.pex script versions do not match the version of slac_Config.pex (" + slacUtility.GetVersion() + "/" + slacPlayerScript.GetVersion()
	ElseIf GetVersion() != slacUtility.GetVersion()
		warningMessage = "The slac_Utility.pex script version does not match the version of slac_Config.pex (" + slacUtility.GetVersion()
	ElseIf GetVersion() != slacPlayerScript.GetVersion()
		warningMessage = "The slac_PlayerScript.pex script version does not match the version of slac_Config.pex (" + slacPlayerScript.GetVersion()
	EndIf
	!suppressVersionWarning && warningMessage != "" && Debug.MessageBox("Aroused Creatures Version Warning!\n\n" + warningMessage + "/" + GetVersion() + ")\n\nThis may prevent Aroused Creatures from functioning normally. Uninstall any patches and reinstall Aroused Creatures.\n\nThis warning can be disabled under Other Settings > Fixes > Suppress Version Warning.")
EndFunction


; Open Config Menu
Event OnConfigOpen()
	MenuOpenTime = Utility.GetCurrentRealTime()
	modActiveLast = modActive
	;UpdateRaceKeys()
EndEvent


; Close Config Menu
Event OnConfigClose()
	If inMaintenance
		; This is to prevent the MCM from locking up when opened during new game maintenance
		Log("Config closing operations suspended during maintenance", forceTrace = True)
		Return
	EndIf

	configUpdate = True
	slacmcmCurrentPage = ""
	togglesPage = 0
	ClearAllOID()
	
	If SLACMCMUpdateRaceKeys
		UpdateRaceKeys()
		SLACMCMUpdateRaceKeys = False
	EndIf
	UpdateGlobals()
	
	; Clear suitors if necessary
	suitorsMaxPC < 1 && slacUtility.ClearSuitors()
	
	If !InMaintenance
		If modActiveLast != modActive
			; Need to shut down or reinitialize SLAC events.
			slacPlayerScript.OnPlayerLoadGame()
		Else
			slacPlayerScript.UpdateKeyRegistery()
		EndIf
	Else
		Log("Config closing operations limited during maintenance")
	EndIf
	
	; Struggle
	slacUtility.WidgetManager.SetXPosition(widgetXPositionNPC)
	slacUtility.WidgetManager.SetYPosition(widgetYPositionNPC)
	If !struggleEnabled
		slacUtility.WidgetManager.StopMeter()
	EndIf
	
	; Clear all Failed Pursuit Cooldown times if cooldown has been set to 0 mins.
	If FailedPursuitCooldown < 60
		slacData.ClearSessionAll("LastFailedPursuitTime")
	EndIf

	; Quest syncing is now handled in the playerScript OnUpdate()
EndEvent


Event OnPageReset(string page)
	GoToState("")
	ClearAllOID()
	Actor playerRef = Game.GetPlayer()
	PCBodyArmor = slacUtility.GetEquippedArmor(PlayerRef,"Body")
	NPCBodyArmor = None
	If TargetActor != PlayerRef
		NPCBodyArmor = slacUtility.GetEquippedArmor(TargetActor,"Body")
	EndIf
	
	If page == "" && !Input.IsKeyPressed(KeyLCtrl) ; bypass by holding down CTRL when opening AC MCM
		; Update list for initial page selection
		String[] TempPagesList = new String[1]
		TempPagesList[0] = "$SLAC_Splash_Page"
		MCMPagesList = PapyrusUtil.MergeStringArray(TempPagesList, Pages)
		TempPagesList[0] = "$SLAC_Last_Page"
		MCMPagesList = PapyrusUtil.MergeStringArray(MCMPagesList, TempPagesList)
		If initMCMPage < 0 || initMCMPage >= MCMPagesList.Length
			initMCMPage = 0
		EndIf
		
		; Initial Page selection
		page = MCMPagesList[initMCMPage]
		;Log("MCMPagesList: " + PapyrusUtil.StringJoin(MCMPagesList, ", "))
		;Log("MCM Page: " + page + " initMCMPage: " + initMCMPage + " MCMPagesList[initMCMPage]: " + MCMPagesList[initMCMPage])
		If initMCMPage == 0
			; Splash Page
			page = ""
		ElseIf initMCMPage == MCMPagesList.Length - 1
			; Last Selected Page
			page = slacmcmLastSelectedPage
		EndIf
		slacmcmCurrentPage = page
		If page == ""
			SetTitleText("$SLAC_Aroused_Creatures")
		Else
			SetTitleText(page)
		EndIf
	Else
		; Clear splash page
		UnloadCustomContent()
	EndIf
	
	slacmcmLastSelectedPage = page

	SetCursorFillMode(TOP_TO_BOTTOM)
	If page == "$SLAC_General_Settings"
		
		SetCursorPosition(0)
		AddHeaderOption("$SLAC_Global_Settings")
		AddToggleOptionST("modActive_ST", "$SLAC_ModActive", modActive)
		;AddSliderOptionST("nextEngageTime_ST", "$SLAC_Cooldown", nextEngageTime, "$SLAC_Secs")
		AddToggleOptionST("requireLos_ST", "$SLAC_ReqLOS", requireLos)
		AddSliderOptionST("EnagageRadius_ST", "$SLAC_EngageRad", engageRadius, "$SLAC_Feet")
		AddToggleOptionST("noSittingActors_ST", "$SLAC_Ignore_Sitting_Actors", noSittingActors)
		AddToggleOptionST("onHitInterrupt_ST", "$SLAC_On_Hit_Interrupt", onHitInterrupt)
		SetOID("actorPreferenceIndex",AddTextOption("$SLAC_Preference", actorPreferenceList[actorPreferenceIndex]))
		AddToggleOptionST("allowEnemies_ST", "$SLAC_Allow_Enemy_Creatures", allowEnemies)

		AddHeaderOption("$SLAC_Debugging")
		AddToggleOptionST("debugSLAC_ST", "$SLAC_Debug", debugSLAC)
		SetOID("debugScanShaders",AddToggleOption("$SLAC_Debug_Shaders", debugScanShaders, CondInt(debugSLAC, OPTION_FLAG_NONE, OPTION_FLAG_DISABLED)))
		SetOID("dumpSettings", AddTextOption("$SLAC_Dump_Current_Settings_To_Log","$SLAC_Dump"))

		SetCursorPosition(1)
		AddHeaderOption("$SLAC_Performance")
		AddSliderOptionST("creaturecountMax_ST", "$SLAC_Creatures_to_Check", creatureCountMax, "{0}")
		AddSliderOptionST("countMax_ST", "$SLAC_NPCs_to_Check", countMax, "{0}")
		AddSliderOptionST("checkFrequency_ST", "$SLAC_Scan_Delay", checkFrequency, "$SLAC_Secs")
		AddSliderOptionST("cloakRadius_ST", "$SLAC_CloakRadius", cloakRadius, "$SLAC_Feet")
		SetOID("SLAnimationMax", AddSliderOption("$SLAC_Max_SexLab_Animations", SLAnimationMax))
		AddTextOption("Current SexLab Animation Count", SexLab.ActiveAnimations + "/15")
		
		; Show execution times
		Float minTime = 99999.0
		Float maxTime = 0.0
		Float totalTime = 0.0
		Int timesCounted = 0
		Int i = 0
		While i < executionTimes.length
			If executionTimes[i] > 0.0
				totalTime = totalTime + executionTimes[i]
				If executionTimes[i] > maxTime
					maxTime = executionTimes[i]
				EndIf
				If executionTimes[i] < minTime
					minTime = executionTimes[i]
				EndIf
				timesCounted += 1
			Endif
			i += 1
		EndWhile
		AddHeaderOption("$SLAC_Recent_Scan_Performance")
		AddTextOption("$SLAC_Min_Execution_Time", PrecisionFloatString(minTime,2) + " secs")
		If timesCounted > 0
			AddTextOption("$SLAC_Average_Execution_Time", PrecisionFloatString(totalTime/timesCounted,2) + " secs")
		Else
			AddTextOption("$SLAC_Average_Execution_Time", PrecisionFloatString(totalTime,2) + " secs")
		EndIf
		AddTextOption("$SLAC_Max_Execution_Time", PrecisionFloatString(maxTime,2) + " secs")
		
		GoToState("GeneralSettings_ST")
		
	ElseIf page == "$SLAC_PC_NPC_Settings"
		; PC
		SetCursorPosition(0)
		AddHeaderOption("$SLAC_PC_Settings")
		AddToggleOptionST("pcActive_ST", "$SLAC_PCActive", pcActive)
		AddEmptyOption()
		SetOID("allowedPCCreatureFollowers",AddTextOption("$SLAC_Allowed_Creature_Followers", allowedCreatureFollowersList[allowedPCCreatureFollowers]))
		SetOID("allowFamiliarsPC", AddToggleOption("$SLAC_Allow_Familiars", allowFamiliarsPC))
		SetOID("cooldownPC", AddSliderOption("$SLAC_Cooldown", Math.Ceiling(cooldownPC / 60), "$SLAC_Mins"))
		AddEmptyOption()
		AddEmptyOption()
		SetOID("OnlyPermittedCreaturesPC", AddToggleOption("$SLAC_Only_Permitted_Creatures", OnlyPermittedCreaturesPC))
		
		AddHeaderOption("$SLAC_Gender_Arousal_And_Consent")
		SetOID("pcVictimSexValue", AddTextOption("$SLAC_PC_Sex", victimSexList[pcVictimSexValue]))
		SetOID("pcCreatureSexValue", AddTextOption("$SLAC_Creature_Sex", creatureSexList[pcCreatureSexValue]))
		Int SSFlagsPC = (allowPCMM as Int) + ((allowPCFF as Int) * 2)
		SetOID("AllowedSameSexPC", AddTextOption("$SLAC_Allow_Same_Sex", AllowedSameSexList[SSFlagsPC]))
		AddSliderOptionST("pcCreatureArousalMin_ST", "$SLAC_Creature_Arousal_Threshold", pcCreatureArousalMin, "{0}")
		AddSliderOptionST("pcArousalMin_ST", "$SLAC_PC_Arousal_Threshold", pcArousalMin, "{0}")
		SetOID("pcRequiredArousalIndex", AddTextOption("$SLAC_Required_Arousal", pcRequiredArousalList[pcRequiredArousalIndex]))
		SetOID("pcConsensualIndex", AddTextOption("$SLAC_Consent", pcConsensualList[pcConsensualIndex]))
				
		AddHeaderOption("$SLAC_Armor_and_Clothing")
		SetOID("AllowHeavyArmorPC", AddToggleOption("$SLAC_Allow_Heavy_Armor", AllowHeavyArmorPC))
		SetOID("AllowLightArmorPC", AddToggleOption("$SLAC_Allow_Light_Armor", AllowLightArmorPC))
		SetOID("AllowClothingPC", AddToggleOption("$SLAC_Allow_Clothing", AllowClothingPC))
		
		If PCBodyArmor
			String ArmorName = PCBodyArmor.GetName()
			If ArmorName == ""
				ArmorName = "Armor ID " + slacUtility.GetFormIDHex(PCBodyArmor)
			EndIf
			SetOID("TreatCurrentArmorAsPC",AddTextOption("Treat " + ArmorName + " as ",ArmorClassList[slacData.GetPersistInt(PCBodyArmor,"ArmorClassOverride",4)]))
		Else
			SetOID("TreatCurrentArmorAsPC",AddTextOption("$SLAC_Equipped_Armor","$SLAC_None"))
		EndIf
		SetOID("CreatureNakedArousalModPC",AddSliderOption("$SLAC_Naked_Arousal_Modifier", CreatureNakedArousalModPC, "$SLAC_Percent"))
		
		AddHeaderOption("$SLAC_Orgy_Mode")
		AddToggleOptionST("orgyModePC_ST", "$SLAC_Orgy_Mode_PC", orgyModePC)
		AddSliderOptionST("orgyArousalMinPCCreature_ST", "$SLAC_Creature_Arousal_Threshold", orgyArousalMinPCCreature, "{0}")
		AddSliderOptionST("orgyArousalMinPC_ST", "$SLAC_PCNPC_Arousal_Threshold", orgyArousalMinPC, "{0}")
		SetOID("orgyRequiredArousalPCIndex", AddTextOption("$SLAC_Required_Arousal", pcnpcRequiredArousalList[orgyRequiredArousalPCIndex]))
		SetOID("orgyConsentPCIndex", AddTextOption("$SLAC_Consent", pcConsensualList[orgyConsentPCIndex]))
		
		AddHeaderOption("$SLAC_Creature_Group")
		AddSliderOptionST("groupChancePC_ST", "$SLAC_Group_Chance", groupChancePC, "$SLAC_Percent")
		AddSliderOptionST("groupMaxExtrasPC_ST", "$SLAC_Group_Max_Extras", groupMaxExtrasPC, "{0}")
		AddSliderOptionST("groupArousalPC_ST", "$SLAC_Group_Arousal", groupArousalPC, "{0}")
		
		AddHeaderOption("$SLAC_Pursuit")
		AddToggleOptionST("pursuitQuestPC_ST", "$SLAC_Pursuit_Quest_PC", pursuitQuestPC)
		AddSliderOptionST("pursuitMaxTimePC_ST", "$SLAC_Pursuit_Max_Time", pursuitMaxTimePC, "$SLAC_Secs")
		SetOID("pursuitInviteAnimationPC",AddToggleOption("$SLAC_Play_PC_Invite_Animation", pursuitInviteAnimationPC > 0))
		AddSliderOptionST("pursuitCaptureRadiusPC_ST", "$SLAC_Capture_Radius", pursuitCaptureRadiusPC, "$SLAC_Feet")
		AddSliderOptionST("pursuitEscapeRadiusPC_ST", "$SLAC_Escape_Radius", pursuitEscapeRadiusPC, "$SLAC_Feet")
		
		AddHeaderOption("$SLAC_Queueing")
		AddSliderOptionST("queueLengthMaxPC_ST", "$SLAC_Max_Queued_Creatures", queueLengthMaxPC)
		AddToggleOptionST("allowQueueLeaversPC_ST", "$SLAC_Allow_Queue_Leavers", allowQueueLeaversPC)
		SetOID("consensualQueuePC",AddTextOption("$SLAC_Queue_Consent", consensualQueueList[consensualQueuePC]))
		SetOID("queueTypePC",AddTextOption("$SLAC_Queue_Type", queueTypeList[queueTypePC]))
		
		AddHeaderOption("$SLAC_Locations")
		SetOID("LocationCityAllowPC", AddToggleOption("$SLAC_Location_Allow_City", LocationCityAllowPC))
		SetOID("LocationTownAllowPC", AddToggleOption("$SLAC_Location_Allow_Town", LocationTownAllowPC))
		SetOID("LocationDwellingAllowPC", AddToggleOption("$SLAC_Location_Allow_Dwelling", LocationDwellingAllowPC))
		SetOID("LocationInnAllowPC", AddToggleOption("$SLAC_Location_Allow_Inn", LocationInnAllowPC))
		SetOID("LocationPlayerHouseAllowPC", AddToggleOption("$SLAC_Location_Allow_Player_House", LocationPlayerHouseAllowPC))
		SetOID("LocationDungeonAllowPC", AddToggleOption("$SLAC_Location_Allow_Dungeon", LocationDungeonAllowPC))
		SetOID("LocationDungeonClearedAllowPC", AddToggleOption("$SLAC_Location_Allow_Dungeon_Cleared", LocationDungeonClearedAllowPC))
		SetOID("LocationOtherAllowPC", AddToggleOption("$SLAC_Location_Allow_Other", LocationOtherAllowPC))
		SetOID("LocationCurrent", AddTextOption("$SLAC_Current_Location",LocationString()))
		
		AddHeaderOption("$SLAC_PC_Only")
		SetOID("pcCrouchIndex",AddTextOption("$SLAC_Crouch_Effect", pcCrouchList[pcCrouchIndex]))
		AddToggleOptionST("pcAllowWeapons_ST", "$SLAC_Allow_Weapons", pcAllowWeapons)
		
		; NPC
		SetCursorPosition(1)
		AddHeaderOption("$SLAC_NPC_Settings")
		AddToggleOptionST("npcActive_ST", "$SLAC_NPCActive", npcActive)
		SetOID("allowedNPCFollowers",AddTextOption("$SLAC_Allowed_NPC_Followers", allowedNPCFollowersList[allowedNPCFollowers]))
		SetOID("allowedNPCCreatureFollowers",AddTextOption("$SLAC_Allowed_Creature_Followers", allowedCreatureFollowersList[allowedNPCCreatureFollowers]))
		SetOID("allowFamiliarsNPC", AddToggleOption("$SLAC_Allow_Familiars", allowFamiliarsNPC))
		SetOID("cooldownNPC",AddSliderOption("$SLAC_Cooldown",Math.Ceiling(cooldownNPC / 60),"$SLAC_Mins"))
		SetOID("cooldownNPCType",AddTextOption("$SLAC_Cooldown_Type", cooldownNPCTypeList[cooldownNPCType]))
		;SetOID("cooldownNPCGlobal",AddToggleOption("$SLAC_Global_NPC_Cooldown",cooldownNPCGlobal))
		SetOID("OnlyPermittedNPCs", AddToggleOption("$SLAC_Only_Permitted_NPCs", OnlyPermittedNPCs))
		SetOID("OnlyPermittedCreaturesNPC", AddToggleOption("$SLAC_Only_Permitted_Creatures", OnlyPermittedCreaturesNPC))

		AddHeaderOption("$SLAC_Gender_Arousal_And_Consent")
		SetOID("npcVictimSexValue",AddTextOption("$SLAC_NPC_Sex", victimSexList[npcVictimSexValue]))
		SetOID("npcCreatureSexValue",AddTextOption("$SLAC_Creature_Sex", creatureSexList[npcCreatureSexValue]))
		Int SSFlagsNPC = (allowNPCMM as Int) + ((allowNPCFF as Int) * 2)
		SetOID("AllowedSameSexNPC", AddTextOption("$SLAC_Allow_Same_Sex", AllowedSameSexList[SSFlagsNPC]))
		AddSliderOptionST("npcCreatureArousalMin_ST", "$SLAC_Creature_Arousal_Threshold", npcCreatureArousalMin, "{0}")
		AddSliderOptionST("npcArousalMin_ST", "$SLAC_NPC_Arousal_Threshold", npcArousalMin, "{0}")
		SetOID("npcRequiredArousalIndex",AddTextOption("$SLAC_Required_Arousal", npcRequiredArousalList[npcRequiredArousalIndex]))
		SetOID("npcConsensualIndex",AddTextOption("$SLAC_Consent", npcConsensualList[npcConsensualIndex]))
		
		AddHeaderOption("$SLAC_Armor_and_Clothing")
		SetOID("AllowHeavyArmorNPC",AddToggleOption("$SLAC_Allow_Heavy_Armor", AllowHeavyArmorNPC))
		SetOID("AllowLightArmorNPC",AddToggleOption("$SLAC_Allow_Light_Armor", AllowLightArmorNPC))
		SetOID("AllowClothingNPC",AddToggleOption("$SLAC_Allow_Clothing", AllowClothingNPC))
		
		If NPCBodyArmor
			String ArmorName = NPCBodyArmor.GetName()
			If ArmorName == ""
				ArmorName = "Armor ID " + slacUtility.GetFormIDHex(NPCBodyArmor)
			EndIf
			SetOID("TreatCurrentArmorAsNPC",AddTextOption("Treat " + ArmorName + " as ",ArmorClassList[slacData.GetPersistInt(NPCBodyArmor,"ArmorClassOverride",4)]))
		ElseIf TargetActor && TargetActor != PlayerRef
			SetOID("TreatCurrentArmorAsNPC",AddTextOption("$SLAC_No_NPC_Selected",""))
		Else
			SetOID("TreatCurrentArmorAsNPC",AddTextOption("$SLAC_Equipped_Armor","$SLAC_None"))
		EndIf
		SetOID("CreatureNakedArousalModNPC",AddSliderOption("$SLAC_Naked_Arousal_Modifier", CreatureNakedArousalModNPC, "$SLAC_Percent"))
		
		AddHeaderOption("$SLAC_Orgy_Mode")
		AddToggleOptionST("orgyModeNPC_ST", "$SLAC_Orgy_Mode_NPC", orgyModeNPC)
		AddSliderOptionST("orgyArousalMinNPCCreature_ST", "$SLAC_Creature_Arousal_Threshold", orgyArousalMinNPCCreature, "{0}")
		AddSliderOptionST("orgyArousalMinNPC_ST", "$SLAC_PCNPC_Arousal_Threshold", orgyArousalMinNPC, "{0}")
		SetOID("orgyRequiredArousalNPCIndex", AddTextOption("$SLAC_Required_Arousal", pcnpcRequiredArousalList[orgyRequiredArousalNPCIndex]))
		SetOID("orgyConsentNPCIndex", AddTextOption("$SLAC_Consent", pcConsensualList[orgyConsentNPCIndex]))
		
		AddHeaderOption("$SLAC_Creature_Group")
		AddSliderOptionST("groupChanceNPC_ST", "$SLAC_Group_Chance", groupChanceNPC, "$SLAC_Percent")
		AddSliderOptionST("groupMaxExtrasNPC_ST", "$SLAC_Group_Max_Extras", groupMaxExtrasNPC, "{0}")
		AddSliderOptionST("groupArousalNPC_ST", "$SLAC_Group_Arousal", groupArousalNPC, "{0}")
		
		AddHeaderOption("$SLAC_Pursuit")
		AddToggleOptionST("pursuitQuestNPC_ST", "$SLAC_Pursuit_Quest_NPC", pursuitQuestNPC)
		AddSliderOptionST("pursuitMaxTimeNPC_ST", "$SLAC_Pursuit_Max_Time", pursuitMaxTimeNPC, "$SLAC_Secs")
		AddToggleOptionST("pursuitNPCFlee_ST", "$SLAC_NPC_Flees", (slac_Pursuit01Flee.GetValue() > 0))
		AddSliderOptionST("pursuitCaptureRadiusNPC_ST", "$SLAC_Capture_Radius", pursuitCaptureRadiusNPC, "$SLAC_Feet")
		AddSliderOptionST("pursuitEscapeRadiusNPC_ST", "$SLAC_Escape_Radius", pursuitEscapeRadiusNPC, "$SLAC_Feet")
		
		AddHeaderOption("$SLAC_Queueing")
		AddSliderOptionST("queueLengthMaxNPC_ST", "$SLAC_Max_Queued_Creatures", queueLengthMaxNPC)
		AddToggleOptionST("allowQueueLeaversNPC_ST", "$SLAC_Allow_Queue_Leavers", allowQueueLeaversNPC)
		SetOID("consensualQueueNPC",AddTextOption("$SLAC_Queue_Consent", consensualQueueList[consensualQueueNPC]))
		SetOID("queueTypeNPC",AddTextOption("$SLAC_Queue_Type", queueTypeList[queueTypeNPC]))
		
		AddHeaderOption("$SLAC_Locations")
		SetOID("LocationCityAllowNPC", AddToggleOption("$SLAC_Location_Allow_City", LocationCityAllowNPC))
		SetOID("LocationTownAllowNPC", AddToggleOption("$SLAC_Location_Allow_Town", LocationTownAllowNPC))
		SetOID("LocationDwellingAllowNPC", AddToggleOption("$SLAC_Location_Allow_Dwelling", LocationDwellingAllowNPC))
		SetOID("LocationInnAllowNPC", AddToggleOption("$SLAC_Location_Allow_Inn", LocationInnAllowNPC))
		SetOID("LocationPlayerHouseAllowNPC", AddToggleOption("$SLAC_Location_Allow_Player_House", LocationPlayerHouseAllowNPC))
		SetOID("LocationDungeonAllowNPC", AddToggleOption("$SLAC_Location_Allow_Dungeon", LocationDungeonAllowNPC))
		SetOID("LocationDungeonClearedAllowNPC", AddToggleOption("$SLAC_Location_Allow_Dungeon_Cleared", LocationDungeonClearedAllowNPC))
		SetOID("LocationOtherAllowNPC", AddToggleOption("$SLAC_Location_Allow_Other", LocationOtherAllowNPC))
		AddEmptyOption()

		AddHeaderOption("$SLAC_NPC_Only")
		AddToggleOptionST("inviteAnimationNPC_ST", "$SLAC_Play_PC_Invite_Animation", inviteAnimationNPC as Bool)
		AddToggleOptionST("noSleepingActors_ST", "$SLAC_Ignore_Sleeping_NPCs", noSleepingActors)
		AddToggleOptionST("allowElders_ST", "$SLAC_Allow_Elders", allowElders)
		
		AddHeaderOption("$SLAC_NPC_Male_Arousal_and_Consent")
		SetOID("NPCMaleArousalMin",AddSliderOption("$SLAC_Male_NPC_Arousal_Threshold", NPCMaleArousalMin, "{0}"))
		SetOID("NPCMaleCreatureArousalMin",AddSliderOption("$SLAC_Creature_Arousal_Threshold", NPCMaleCreatureArousalMin, "{0}"))
		SetOID("NPCMaleRequiredArousalIndex",AddTextOption("$SLAC_Required_Arousal", npcRequiredArousalList[NPCMaleRequiredArousalIndex]))
		SetOID("NPCMaleConsensualIndex",AddTextOption("$SLAC_Consent", pcConsensualList[NPCMaleConsensualIndex]))
		SetOID("NPCMaleAllowVictim",AddTextOption("$SLAC_Male_NPCs_Pursued_By", NPCMaleAllowVictimList[NPCMaleAllowVictim]))
		SetOID("NPCMaleQueuing", AddToggleOption("$SLAC_Male_Queuing", NPCMaleQueuing))

		GoToState("PCNPCSettings_ST")
		
	ElseIf page == "$SLAC_Dialogue_and_Interactions"
		SetCursorFillMode(TOP_TO_BOTTOM)
		
		SetCursorPosition(0)
		
		AddHeaderOption("$SLAC_Invitation")
		AddKeyMapOptionST("inviteTargetKey_ST", "$SLAC_Invite_Target_Select_Key", inviteTargetKey, OPTION_FLAG_WITH_UNMAP)
		AddSliderOptionST("inviteArousalMin_ST", "$SLAC_Invite_Arousal", inviteArousalMin, "{0}")
		SetOID("inviteConsentPCIndex", AddTextOption("$SLAC_Consent", pcConsensualList[inviteConsentPCIndex]))
		AddToggleOptionST("inviteAnimationPC_ST", "$SLAC_Play_PC_Invite_Animation", inviteAnimationPC as Bool)
		SetOID("inviteStripDelayPC", AddSliderOption("$SLAC_Invite_Strip_Delay", inviteStripDelayPC, "$SLAC_Secs"))
		SetOID("inviteOpensCreatureDialogue", AddToggleOption("$SLAC_Invite_Opens_Creature_Dialogue", inviteOpensCreatureDialogue, CondInt(creatureDialogueEnabled, OPTION_FLAG_NONE, OPTION_FLAG_DISABLED)))
		SetOID("inviteOpensHorseDialogue", AddToggleOption("$SLAC_Invite_Opens_Horse_Dialogue", inviteOpensHorseDialogue, CondInt(creatureDialogueEnabled && creatureDialogueAllowHorses, OPTION_FLAG_NONE, OPTION_FLAG_DISABLED)))
		SetOID("inviteCreatureSex", AddTextOption("$SLAC_Invite_Creature_Sex", creatureSexList[inviteCreatureSex]))

		AddHeaderOption("$SLAC_Player_Horse")
		SetOID("horseRefusalPCMounting", AddToggleOption("$SLAC_Horse_Refusal_Mounting", horseRefusalPCMounting))
		SetOID("horseRefusalPCRiding", AddToggleOption("$SLAC_Horse_Refusal_Riding", horseRefusalPCRiding))
		SetOID("horseRefusalPCThreshold", AddSliderOption("$SLAC_Horse_Refusal_Threshold", horseRefusalPCThreshold))
		SetOID("horseRefusalPCSex", AddTextOption("$SLAC_Horse_Refusal_Sex", creatureSexList[horseRefusalPCSex]))
		SetOID("horseRefusalPCEngage", AddToggleOption("$SLAC_Sex_After_Refusal", horseRefusalPCEngage))
		
		AddHeaderOption("$SLAC_Player_Struggle")
		AddToggleOptionST("struggleEnabled_ST", "$SLAC_Enable_Player_Struggle", struggleEnabled)
		AddKeyMapOptionST("struggleKeyOne_ST", "$SLAC_Struggle_Key_One", struggleKeyOne, OPTION_FLAG_WITH_UNMAP)
		AddKeyMapOptionST("struggleKeyTwo_ST", "$SLAC_Struggle_Key_Two", struggleKeyTwo, OPTION_FLAG_WITH_UNMAP)
		AddSliderOptionST("struggleStaminaDamage_ST", "$SLAC_Stamina_Damage_Value", struggleStaminaDamage, "{0}")
		AddSliderOptionST("struggleStaminaDamageMultiplier_ST", "$SLAC_Stamina_Damage_Multiplier", struggleStaminaDamageMultiplier, "{1}")
		AddSliderOptionST("struggleTimingOne_ST", "$SLAC_Struggle_Timing_One", struggleTimingOne, "$SLAC_Secs_Float")
		AddSliderOptionST("struggleTimingTwo_ST", "$SLAC_Struggle_Timing_Two", struggleTimingTwo, "$SLAC_Secs_Float")
		SetOID("struggleMeterHidden", AddToggleOption("$SLAC_Hide_Struggle_Meter", struggleMeterHidden))
		AddToggleOptionST("struggleFailureEnabled_ST", "$SLAC_Enable_Failure", struggleFailureEnabled)
		SetOID("struggleExhaustionMode", AddTextOption("$SLAC_Exhaustion_Mode", struggleExhaustionModeList[struggleExhaustionMode]))
		AddSliderOptionST("struggleExhaustionDuration_ST", "$SLAC_Exhaustion_Duration", slacUtility.slac_StaminaDrainSpell.GetNthEffectDuration(0), "$SLAC_Secs")
		AddToggleOptionST("struggleQueueEscape_ST", "$SLAC_Struggle_Queue_Escape", struggleQueueEscape)
		SetOID("widgetXPositionNPC", AddSliderOption("$SLAC_Stamina_Widget_X", widgetXPositionNPC))
		SetOID("widgetYPositionNPC", AddSliderOption("$SLAC_Stamina_Widget_Y", widgetYPositionNPC))
		
		SetCursorPosition(1)
		
		AddHeaderOption("$SLAC_Actor_Selection")
		AddKeyMapOptionST("targetKey_ST", "$SLAC_Target_Select_Key", targetKey, OPTION_FLAG_WITH_UNMAP)
		
		AddHeaderOption("$SLAC_Follower_Commands")
		AddToggleOptionST("followerDialogueEnabled_ST", "$SLAC_Enable_Follower_Commands", followerDialogueEnabled)
		AddSliderOptionST("followerCommandThreshold_ST", "$SLAC_Follower_Threshold", followerCommandThreshold)
		AddToggleOptionST("nonFollowerDialogueEnabled_ST", "$SLAC_Enable_Non_Follower_Commands", nonFollowerDialogueEnabled)
		SetOID("followerDialogueGenderIndex", AddTextOption("$SLAC_Follower_Dialogue_Gender", victimSexList[followerDialogueGenderIndex]))
		
		AddHeaderOption("$SLAC_Creature_Commands")
		AddToggleOptionST("creatureDialogueEnabled_ST", "$SLAC_Enable_Creature_Commands", creatureDialogueEnabled)
		AddSliderOptionST("creatureCommandThreshold_ST", "$SLAC_Creature_Threshold", creatureCommandThreshold)

		If creatureDialogueEnabled
			AddToggleOptionST("allCreatureDialogueEnabled_ST", "$SLAC_Enable_Creature_Commands_All", allCreatureDialogueEnabled, OPTION_FLAG_NONE)
			AddToggleOptionST("creatureDialogueAllowSilent_ST", "$SLAC_Allow_Silent_Creature_Dialogue", creatureDialogueAllowSilent, OPTION_FLAG_NONE)
		Else
			AddToggleOptionST("allCreatureDialogueEnabled_ST", "$SLAC_Enable_Creature_Commands_All", allCreatureDialogueEnabled, OPTION_FLAG_DISABLED)
			AddToggleOptionST("creatureDialogueAllowSilent_ST", "$SLAC_Allow_Silent_Creature_Dialogue", creatureDialogueAllowSilent, OPTION_FLAG_DISABLED)
		EndIf
		
		If creatureDialogueEnabled && creatureDialogueAllowSilent
			AddToggleOptionST("creatureDialogueAllowHorses_ST", "$SLAC_Allow_Dialogue_With_Horses", creatureDialogueAllowHorses, OPTION_FLAG_NONE)
		Else
			AddToggleOptionST("creatureDialogueAllowHorses_ST", "$SLAC_Allow_Dialogue_With_Horses", creatureDialogueAllowHorses, OPTION_FLAG_DISABLED)
		EndIf
		
		If creatureDialogueEnabled && creatureDialogueAllowHorses
			AddToggleOptionST("creatureDialogueAllowSteal_ST", "$SLAC_Allow_Dialogue_Horse_Theft", creatureDialogueAllowSteal, OPTION_FLAG_NONE)
		Else
			AddToggleOptionST("creatureDialogueAllowSteal_ST", "$SLAC_Allow_Dialogue_Horse_Theft", creatureDialogueAllowSteal, OPTION_FLAG_DISABLED)
		EndIf
		SetOID("creatureDialogueSex", AddTextOption("$SLAC_Creature_Dialogue_Sex", creatureSexList[creatureDialogueSex]))

		AddHeaderOption("$SLAC_Player_Suitors")
		SetOID("suitorsMaxPC",AddSliderOption("$SLAC_Max_Player_Suitors", suitorsMaxPC, "{0}"))
		SetOID("suitorsPCArousalMin",AddSliderOption("$SLAC_PC_Arousal_Threshold", suitorsPCArousalMin, "{0}"))
		SetOID("suitorsPCAllowWeapons", AddToggleOption("$SLAC_Allow_Weapons", suitorsPCAllowWeapons))
		SetOID("suitorsPCCrouchEffect", AddTextOption("$SLAC_Suitor_Crouch_Effect", suitorsPCCrouchEffectList[suitorsPCCrouchEffect]))
		SetOID("suitorsPCOnlyNaked", AddToggleOption("$SLAC_Only_When_Naked", suitorsPCOnlyNaked))
		SetOID("suitorsPCAllowLeave", AddToggleOption("$SLAC_Allow_Suitors_to_Leave", suitorsPCAllowLeave))
		SetOID("suitorsPCAllowFollowers", AddToggleOption("$SLAC_Allow_Follower_Suitors", suitorsPCAllowFollowers))

		GoToState("dialogueAndInteractions_ST")
		
	ElseIf page == "$SLAC_Allowed_Creatures"
		; refresh race key list from SexLab
		UpdateRaceKeys()
		
		SetCursorFillMode(LEFT_TO_RIGHT)
		
		; Calculate List Pagination
		totalAllowedTogglesPages = Math.Ceiling(raceKeyList.Length / 60)
		If allowedTogglesPage > totalAllowedTogglesPages || allowedTogglesPage < 1
			allowedTogglesPage = 0
		EndIf
		
		; Pagination controls
		If totalAllowedTogglesPages > 1
			If allowedTogglesPage >= totalAllowedTogglesPages
				AddTextOptionST("allowedTogglesPage_ST", "Go to Page 1 of " + totalAllowedTogglesPages, allowedTogglesPage + 1)
			Else
				AddTextOptionST("allowedTogglesPage_ST", "Go to Page " + (allowedTogglesPage+1) + " of " + totalAllowedTogglesPages, allowedTogglesPage + 1)
			EndIf
		Else
			AddTextOption("Page 1 of 1 (" + raceKeyList.Length + " Races)",1)
		EndIf
		SetOID("allowedSync",AddToggleOption("$SLAC_Use_PC_Settings_For_NPCs",allowedSync))
		
		SetOID("allowedAllPC",AddTextOption("$SLAC_Allow_All_Green","$SLAC_Click"))
		SetOID("allowedAllNPC",AddTextOption("$SLAC_Allow_All_Green","$SLAC_Click", CondInt(allowedSync,OPTION_FLAG_DISABLED,OPTION_FLAG_NONE)))
		
		SetOID("allowedNonePC",AddTextOption("$SLAC_Allow_None_Red","$SLAC_Click"))
		SetOID("allowedNoneNPC",AddTextOption("$SLAC_Allow_None_Red","$SLAC_Click", CondInt(allowedSync,OPTION_FLAG_DISABLED,OPTION_FLAG_NONE)))
		
		AddHeaderOption("$SLAC_PC_Allowed_Creatures")
		AddHeaderOption("$SLAC_NPC_Allowed_Creatures")
		
		allowedRacesPCOID = PapyrusUtil.IntArray(raceKeyList.Length,-1)
		allowedRacesNPCOID = PapyrusUtil.IntArray(raceKeyList.Length,-1)
		Int i = 60 * allowedTogglesPage
		While i < ((60 * allowedTogglesPage) + 60) && i < raceKeyList.length
			If raceKeyList[i]
				Int FPCallowed = CondInt(DisallowedRaceKeyFPCList.Find(raceKeyList[i]) < 0,1,0)
				Int MPCallowed = CondInt(DisallowedRaceKeyMPCList.Find(raceKeyList[i]) < 0,2,0)
				Int FNPCallowed = CondInt(DisallowedRaceKeyFNPCList.Find(raceKeyList[i]) < 0,1,0)
				Int MNPCallowed = CondInt(DisallowedRaceKeyMNPCList.Find(raceKeyList[i]) < 0,2,0)
				
				allowedRacesPCOID[i] = AddTextOption(raceKeyList[i], allowedOptionsList[FPCallowed + MPCallowed])
				allowedRacesNPCOID[i] = AddTextOption(raceKeyList[i], allowedOptionsList[FNPCallowed + MNPCallowed], CondInt(allowedSync,OPTION_FLAG_DISABLED,OPTION_FLAG_NONE))
			EndIf
			i += 1
		EndWhile
		
		GoToState("allowedCreaturesToggle_ST")
		
	;ElseIf page == "$SLAC_Aggressive_Animation_Toggles" && UsingSLPP()
		; SLP+ compatibility note
	;	SetOID("AggressiveSLPPNote", AddTextOption("$SLAC_SLPP_Aggressive_Toggles_Not_Available", ""))
	;	GoToState("AggressiveTogglesHome_ST")

	ElseIf page == "$SLAC_Aggressive_Animation_Toggles"
		; Collect Anim Registry from SexLab
		Form SexLabQuestRegistry = Game.GetFormFromFile(0x664FB, "SexLab.esm")
		
		; Reset filters by holding ctrl while switching to the Aggressive Animations page.
		If Input.IsKeyPressed(KeyLCtrl)
			aggressiveTogglesRaceKey = "$SLAC_All"
			aggressiveTogglesTags = ""
		EndIf
		
		If SexLabQuestRegistry
			
			; List Pagination
			If togglesPage < 0
				togglesPage = 0
			EndIf
			
			; We need to know if there are no creature animations to work with. OGSL only.
			sslBaseAnimation[] testAnimations
			If !UsingSLPP()
				CreatureSlots = SexLabQuestRegistry as sslCreatureAnimationSlots
				testAnimations = CreatureSlots.GetSlots(1, 10)
			EndIf
			
			If testAnimations.Length > 0 || UsingSLPP()
			
				SetCursorFillMode(LEFT_TO_RIGHT)
				
				If togglesPage == 0 ; Home Page
					
					AddTextOption("$SLAC_Aggressive_Toggles_Page", "$SLAC_Home")
					AddTextOptionST("togglesPageHome_ST", "$SLAC_Go_to_Animation_List", "$SLAC_Start", CondInt(!UsingSLPP(),OPTION_FLAG_NONE,OPTION_FLAG_DISABLED))
					
					AddEmptyOption()
					SetOID("animationsPerPage", AddSliderOption("$SLAC_Animations_Per_Page", animationsPerPage))
					
					; Hide slow recent animations list until user requests it
					If !UsingSLPP() && !aggressiveTogglesShowRecent
						AddHeaderOption("$SLAC_Recent_PC_Animations")
						AddHeaderOption("$SLAC_Recent_NPC_Animations")
						SetOID("aggressiveTogglesShowRecent",AddTextOption("$SLAC_Display_Recent_Animations","$SLAC_Show"))

					Else
						; Recent PC/NPC animation toggles
						AddHeaderOption("$SLAC_Last_PC_Animation")
						AddHeaderOption("$SLAC_Last_NPC_Animation")
						sslBaseAnimation anim = none
						if togglesRecentPCAnim.Length > 0 && togglesRecentPCAnim[0] && togglesRecentPCAnim[0] != ""
							If UsingSLPP()
								; SexLab P+
								If SexLabRegistry.SceneExists(togglesRecentPCAnim[0])
									togglesRecentPCOID[0] = AddTextOption(SexLabRegistry.GetSceneName(togglesRecentPCAnim[0]), togglesRecentPCAnim[0], CondInt(SexLabRegistry.IsSceneEnabled(togglesRecentPCAnim[0]),OPTION_FLAG_NONE,OPTION_FLAG_DISABLED))
								Else
									AddEmptyOption()
								EndIf
							Else
								; SexLab
								anim = SexLab.GetCreatureAnimationByRegistry(togglesRecentPCAnim[0])
								If anim && anim.Name
									togglesRecentPCOID[0] = AddTextOption(anim.Name, CondString(IsAggressiveScene(togglesRecentPCAnim[0]), "$SLAC_Aggressive_Color", "$SLAC_Consensual_Color"), CondInt(anim.Enabled,OPTION_FLAG_NONE,OPTION_FLAG_DISABLED))
								Else
									AddEmptyOption()
								EndIf
							EndIf
						Else
							AddEmptyOption()
						EndIf
						If togglesRecentNPCAnim.Length > 0 && togglesRecentNPCAnim[0] && togglesRecentNPCAnim[0] != ""
							If UsingSLPP()
								; SexLab P+
								If SexLabRegistry.SceneExists(togglesRecentNPCAnim[0])
									togglesRecentNPCOID[0] = AddTextOption(SexLabRegistry.GetSceneName(togglesRecentNPCAnim[0]), togglesRecentNPCAnim[0], CondInt(SexLabRegistry.IsSceneEnabled(togglesRecentNPCAnim[0]),OPTION_FLAG_NONE,OPTION_FLAG_DISABLED))
								Else
									AddEmptyOption()
								EndIf
							Else
								; SexLab
								anim = SexLab.GetCreatureAnimationByRegistry(togglesRecentNPCAnim[0])
								If anim && anim.Name
									togglesRecentNPCOID[0] = AddTextOption(anim.Name, CondString(IsAggressiveScene(togglesRecentNPCAnim[0]), "$SLAC_Aggressive_Color", "$SLAC_Consensual_Color"), CondInt(anim.Enabled,OPTION_FLAG_NONE,OPTION_FLAG_DISABLED))
								Else
									AddEmptyOption()
								EndIf
							EndIf
						Else
							AddEmptyOption()
						EndIf

						AddHeaderOption("$SLAC_Recent_PC_Animations")
						AddHeaderOption("$SLAC_Recent_NPC_Animations")
						Int i = 1
						While i < togglesRecentPCAnim.Length || i < togglesRecentNPCAnim.Length
							if i < togglesRecentPCAnim.Length && togglesRecentPCAnim[i] && togglesRecentPCAnim[i] != ""
								If UsingSLPP()
									; SexLab P+
									If SexLabRegistry.SceneExists(togglesRecentPCAnim[i])
										togglesRecentPCOID[i] = AddTextOption(SexLabRegistry.GetSceneName(togglesRecentPCAnim[i]), togglesRecentPCAnim[i], CondInt(SexLabRegistry.IsSceneEnabled(togglesRecentPCAnim[i]),OPTION_FLAG_NONE,OPTION_FLAG_DISABLED))
									Else
										AddEmptyOption()
									EndIf

								Else
									; SexLab
									;anim = SexLab.GetCreatureAnimationByName(togglesRecentPCAnim[i])
									anim = SexLab.GetCreatureAnimationByRegistry(togglesRecentPCAnim[i])
									If anim && anim.Name
										togglesRecentPCOID[i] = AddTextOption(anim.Name, CondString(IsAggressiveScene(togglesRecentPCAnim[i]), "$SLAC_Aggressive_Color", "$SLAC_Consensual_Color"), CondInt(anim.Enabled,OPTION_FLAG_NONE,OPTION_FLAG_DISABLED))
									Else
										AddEmptyOption()
									EndIf

								EndIf

							Else
								AddEmptyOption()
							EndIf
							If i < togglesRecentNPCAnim.Length && togglesRecentNPCAnim[i] && togglesRecentNPCAnim[i] != ""
								If UsingSLPP()
									; SexLab P+
									If SexLabRegistry.SceneExists(togglesRecentNPCAnim[i])
										togglesRecentNPCOID[i] = AddTextOption(SexLabRegistry.GetSceneName(togglesRecentNPCAnim[i]), togglesRecentNPCAnim[i], CondInt(SexLabRegistry.IsSceneEnabled(togglesRecentNPCAnim[i]),OPTION_FLAG_NONE,OPTION_FLAG_DISABLED))
									Else
										AddEmptyOption()
									EndIf

								Else
									; SexLab
									;anim = SexLab.GetCreatureAnimationByName(togglesRecentNPCAnim[i])
									anim = SexLab.GetCreatureAnimationByRegistry(togglesRecentNPCAnim[i])
									If anim && anim.Name
										If anim.Enabled
											togglesRecentNPCOID[i] = AddTextOption(anim.Name, CondString(IsAggressiveScene(togglesRecentNPCAnim[i]), "$SLAC_Aggressive_Color", "$SLAC_Consensual_Color"))
										Else
											togglesRecentNPCOID[i] = AddTextOption(anim.Name, "$SLAC_Disabled", OPTION_FLAG_DISABLED)
										EndIf
									EndIf
								
								EndIf

							Else
								AddEmptyOption()
							EndIf
							i += 1
						EndWhile
					EndIf
					GoToState("AggressiveTogglesHome_ST")
				EndIf
				; Reset recent animation display for next page load
				aggressiveTogglesShowRecent = False
				
				If togglesPage > 0 ; List Pages
				
					; Refresh race key list from SexLab
					;UpdateRaceKeys()
					
					; Build race key options array
					aggressiveTogglesRaceKeyOptions =  PapyrusUtil.MergeStringArray(Utility.CreateStringArray(1,"$SLAC_All"), raceKeyList)
					
					; Make sure current race key is valid and reset if not
					If raceKeyList.find(aggressiveTogglesRaceKey) < 0
						aggressiveTogglesRaceKey = "$SLAC_All"
					EndIf
					
					; Race or tags selected
					Bool allowAutoTag = False
					If aggressiveTogglesRaceKey != "$SLAC_All" || aggressiveTogglesTags != ""
						allowAutoTag = True
						creatureAnimations = sslUtility.AnimationArray(0)
						
						; Collect animations for each actor count: 2,3,4,5
						Int posCount = 2
						While posCount < 6
							sslBaseAnimation[] tempAnims = sslUtility.AnimationArray(0)
							If aggressiveTogglesRaceKey != "$SLAC_All" && aggressiveTogglesTags != ""
								; Race and tags
								tempAnims = SexLab.GetCreatureAnimationsByRaceKeyTags(posCount, aggressiveTogglesRaceKey, Tags = CondString(!aggressiveTogglesTagsNegate,aggressiveTogglesTags), TagSuppress = CondString(aggressiveTogglesTagsNegate,aggressiveTogglesTags))
							ElseIf aggressiveTogglesRaceKey != "$SLAC_All"
								; Race
								tempAnims = SexLab.GetCreatureAnimationsByRaceKey(posCount, aggressiveTogglesRaceKey)
							Else
								; Tags
								tempAnims = SexLab.GetCreatureAnimationsByTags(posCount, Tags = CondString(!aggressiveTogglesTagsNegate,aggressiveTogglesTags), TagSuppress = CondString(aggressiveTogglesTagsNegate,aggressiveTogglesTags))
							EndIf
							
							debugSLAC && Log("Adding " + tempAnims.Length + " " + posCount + "p anims to MCM list (now " + creatureAnimations.Length + ")")
							
							If tempAnims.Length > 0
								; MergeAnimationLists seems to be broken and regularly inserts empty elements
								; creatureAnimations = SexLab.MergeAnimationLists(creatureAnimations, tempAnims)
								Int i = 0
								While i < tempAnims.Length
									creatureAnimations = sslUtility.PushAnimation(tempAnims[i], creatureAnimations)
									i += 1
								EndWhile
							EndIf
							posCount += 1
						EndWhile
						
						totalTogglesPages = Math.Ceiling(creatureAnimations.Length / (animationsPerPage as Float))
						If togglesPage > totalTogglesPages
							togglesPage = 1
						EndIf
						
						; Slice anim array for current page
						sslBaseAnimation[] tempAnims = sslUtility.AnimationArray(0)
						Int sourceIndex = (togglesPage - 1) * animationsPerPage
						Int targetIndex = 0
						While targetIndex < animationsPerPage && sourceIndex < creatureAnimations.Length
							tempAnims = sslUtility.PushAnimation(creatureAnimations[sourceIndex], tempAnims)
							sourceIndex += 1
							targetIndex += 1
						EndWhile
						creatureAnimations = tempAnims
						
					Else
						; Get total pages for all animations
						totalTogglesPages = CreatureSlots.PageCount(animationsPerPage)
						If togglesPage > totalTogglesPages
							togglesPage = 1
						EndIf
						creatureAnimations = CreatureSlots.GetSlots(togglesPage, animationsPerPage)
						
					EndIf
			
					debugSLAC && Log("AggAnims: " + creatureAnimations.Length + " pages " + totalTogglesPages)
					
					AddTextOption("$SLAC_Aggressive_Toggles_Page", togglesPage)
					AddTextOptionST("togglesPageHome_ST", "$SLAC_Return_to_First_Page", "$SLAC_Home")
					SetOID("aggressiveTogglesPagePrev", AddTextOption(CondString(togglesPage > 1,"Go to Page " + (togglesPage - 1) + " of " + totalTogglesPages, "Go to Page " + totalTogglesPages + " of " + totalTogglesPages), "Prev"))
					SetOID("aggressiveTogglesPageNext", AddTextOption(CondString(togglesPage < totalTogglesPages,"Go to Page " + (togglesPage + 1) + " of " + totalTogglesPages, "Go to Page 1 of " + totalTogglesPages), "Next"))
					SetOID("aggressiveTogglesRaceKey", AddMenuOption(CondString(aggressiveTogglesRaceKey == "$SLAC_All", "$SLAC_Filter_By_Race", "$SLAC_Filter_By_Race_warning"), aggressiveTogglesRaceKey))
					SetOID("aggressiveTogglesTags", AddInputOption(CondString(aggressiveTogglesTags == "", "$SLAC_Filter_By_Tags", "$SLAC_Filter_By_Tags_warning"), aggressiveTogglesTags))
					SetOID("defaultAggressiveTag", AddTextOption("$SLAC_Animations_to_Default", "$SLAC_Click"))
					SetOID("aggressiveTogglesTagsNegate", AddTextOption("$SLAC_Negate_Tags", CondString(!aggressiveTogglesTagsNegate, "$SLAC_Has_Tags", "$SLAC_Does_Not_Have_Tags")))
					SetOID("addAggressiveTag", AddTextOption("$SLAC_Tag_Current_Animations_As", "$SLAC_Aggressive_Color", CondInt(allowAutoTag, OPTION_FLAG_NONE, OPTION_FLAG_DISABLED)))
					SetOID("removeAggressiveTag", AddTextOption("$SLAC_Tag_Current_Animations_As", "$SLAC_Consensual_Color", CondInt(allowAutoTag, OPTION_FLAG_NONE, OPTION_FLAG_DISABLED)))
					;AddTextOptionST("togglesRough_ST", "$SLAC_Rough_Animations_to_Aggressive", "$SLAC_Click")
					
					AddHeaderOption("")
					AddHeaderOption("")
				
					; Animation toggles
					aggressiveTogglesOID = PapyrusUtil.IntArray(creatureAnimations.Length)
					Int i = 0
					While i < creatureAnimations.Length
						If creatureAnimations[i]
							If creatureAnimations[i].Enabled
								aggressiveTogglesOID[i] = AddTextOption(creatureAnimations[i].Name, CondString(creatureAnimations[i].HasTag("Aggressive"), "$SLAC_Aggressive_Color", "$SLAC_Consensual_Color"))
							Else 
								aggressiveTogglesOID[i] = AddTextOption(creatureAnimations[i].Name, "$SLAC_Disabled", OPTION_FLAG_DISABLED)
							EndIf
						EndIf
						If debugSLAC
							If creatureAnimations[i]
								Log("adding to list: " + creatureAnimations[i].Name + " at " + i)
							Else
								Log("missing anim at " + i)
							EndIf
						EndIf
						i += 1
					EndWhile
					
					GoToState("AggressiveTogglesList_ST")
				EndIf
			Else
				AddHeaderOption("SexLab Registry Error:")
				AddHeaderOption("No animations found")
				AddHeaderOption("Install SexLab via MCM")
				AddHeaderOption("Enable Allow Creature Animations")
			EndIf
		Else
			AddHeaderOption("SexLab Registry Error:")
			AddHeaderOption("Quest registry not available")
			AddHeaderOption("Install SexLab via MCM")
			AddHeaderOption("Rebuild & Clean > Clean System")
		EndIf
		
	ElseIf page == "$SLAC_Other_Settings"
		Int slppflag = CondInt(UsingSLPP(), OPTION_FLAG_DISABLED, OPTION_FLAG_NONE)

		SetCursorFillMode(TOP_TO_BOTTOM)
		
		SetCursorPosition(0)
		AddHeaderOption("$SLAC_Notifications_For_PC")
		AddToggleOptionST("showNotifications_ST", "$SLAC_Show_Engagement_Messages", showNotifications)		

		AddHeaderOption("$SLAC_Trans_PC")
		SetOID("TransMFTreatAsPC",AddTextOption("$SLAC_Trans_MF_Treat_As", TransTreatAsList[TransMFTreatAsPC]))
		SetOID("TransFMTreatAsPC",AddTextOption("$SLAC_Trans_FM_Treat_As", TransTreatAsList[TransFMTreatAsPC]))

		AddHeaderOption("$SLAC_Animation_Selection_PC")
		SetOID("restrictAggressivePC",AddToggleOption("$SLAC_Restrict_Aggressive", restrictAggressivePC))
		SetOID("restrictConsensualPC",AddToggleOption("$SLAC_Restrict_Consensual", restrictConsensualPC))
		SetOID("FemalePCRoleWithMaleCreature",AddTextOption("$SLAC_Female_Roll_With_Male_Creature", ActorPositionSexList[FemalePCRoleWithMaleCreature], slppflag))
		SetOID("FemalePCRoleWithFemaleCreature",AddTextOption("$SLAC_Female_Roll_With_Female_Creature", ActorPositionSexList[FemalePCRoleWithFemaleCreature], slppflag))
		SetOID("MalePCRoleWithMaleCreature",AddTextOption("$SLAC_Male_Roll_With_Male_Creature", ActorPositionSexList[MalePCRoleWithMaleCreature], slppflag))
		SetOID("MalePCRoleWithFemaleCreature",AddTextOption("$SLAC_Male_Roll_With_Female_Creature", ActorPositionSexList[MalePCRoleWithMaleCreature], slppflag))
		SetOID("NonConsensualIsAlwaysMFPC",AddToggleOption("$SLAC_Non_Consensual_Is_Always_MF", NonConsensualIsAlwaysMFPC, slppflag))
		
		SetCursorPosition(1)
		AddHeaderOption("$SLAC_Notifications_For_NPCs")
		AddToggleOptionST("showNotificationsNPC_ST", "$SLAC_Show_Engagement_Messages", showNotificationsNPC)		
		
		AddHeaderOption("$SLAC_Trans_NPC")
		SetOID("TransMFTreatAsNPC",AddTextOption("$SLAC_Trans_MF_Treat_As", TransTreatAsList[TransMFTreatAsNPC]))
		SetOID("TransFMTreatAsNPC",AddTextOption("$SLAC_Trans_FM_Treat_As", TransTreatAsList[TransFMTreatAsNPC]))

		AddHeaderOption("$SLAC_Animation_Selection_NPC")
		SetOID("restrictAggressiveNPC",AddToggleOption("$SLAC_Restrict_Aggressive", restrictAggressiveNPC))
		SetOID("restrictConsensualNPC",AddToggleOption("$SLAC_Restrict_Consensual", restrictConsensualNPC))
		SetOID("FemaleNPCRoleWithMaleCreature",AddTextOption("$SLAC_Female_Roll_With_Male_Creature",ActorPositionSexList[FemaleNPCRoleWithMaleCreature], slppflag))
		SetOID("FemaleNPCRoleWithFemaleCreature",AddTextOption("$SLAC_Female_Roll_With_Female_Creature",ActorPositionSexList[FemaleNPCRoleWithFemaleCreature], slppflag))
		SetOID("MaleNPCRoleWithMaleCreature",AddTextOption("$SLAC_Male_Roll_With_Male_Creature",ActorPositionSexList[MaleNPCRoleWithMaleCreature], slppflag))
		SetOID("MaleNPCRoleWithFemaleCreature",AddTextOption("$SLAC_Male_Roll_With_Female_Creature",ActorPositionSexList[MaleNPCRoleWithFemaleCreature], slppflag))
		SetOID("NonConsensualIsAlwaysMFNPC",AddToggleOption("$SLAC_Non_Consensual_Is_Always_MF",NonConsensualIsAlwaysMFNPC, slppflag))

		If SubmitCalm == none
			submitLoaded = false
		EndIf
		If DefeatCalm == none || DefeatAltCalm == none || DefeatFaction == none
			defeatLoaded = false
		EndIf
		If DeviouslyHelplessCalm == none
			deviouslyHelplessLoaded = false
		EndIf
		
		; Collect scene info
		Scene currentScene
		String sceneQuest = "No Scene"
		If !TargetActor
			currentScene = PlayerRef.GetCurrentScene()
			sceneQuest = "No PC Scene"
		Else
			currentScene = TargetActor.GetCurrentScene()
			sceneQuest = "No NPC Scene"
		EndIf
		If currentScene
			Quest currentQuest = currentScene.GetOwningQuest()
			If currentQuest
				sceneQuest = currentQuest.GetID()
			EndIf
		EndIf
		
		SetCursorPosition(26)
		
		AddHeaderOption("$SLAC_Compatibility")

		submitLoaded && SetOID("submit",AddToggleOption("$SLAC_Disallow_Submit", submit))
		!submitLoaded && SetOID("submit_false",AddTextOption("$SLAC_Disallow_Submit", "$SLAC_N_A"))

		defeatLoaded && SetOID("defeat", AddToggleOption("$SLAC_Disallow_Defeat", defeat))
		!defeatLoaded && SetOID("defeat_false", AddTextOption("$SLAC_Disallow_Defeat", "$SLAC_N_A"))
		
		deviouslyHelplessLoaded && SetOID("deviouslyHelpless", AddToggleOption("$SLAC_Disallow_Deviously_Helpless", deviouslyHelpless))
		!deviouslyHelplessLoaded && SetOID("deviouslyHelpless_false", AddTextOption("$SLAC_Disallow_Deviously_Helpless", "$SLAC_N_A"))
		
		DisplayModelLoaded && SetOID("DisplayModelBlockAuto", AddToggleOption("$SLAC_Disallow_Display_Model_Actors", DisplayModelBlockAuto))
		!DisplayModelLoaded && SetOID("DisplayModelBlockAuto_false", AddTextOption("$SLAC_Disallow_Display_Model_Actors", "$SLAC_N_A"))
		
		DeviousDevicesLoaded && SetOID("DeviousDevicesFilter", AddToggleOption("$SLAC_Disallow_Devious_Device_Blocked", DeviousDevicesFilter))
		!DeviousDevicesLoaded && SetOID("DeviousDevicesFilter_false", AddTextOption("$SLAC_Disallow_Devious_Device_Blocked", "$SLAC_N_A"))
		
		NakedDefeatLoaded && SetOID("NakedDefeatFilter", AddToggleOption("$SLAC_Naked_Defeat_Filter", NakedDefeatFilter))
		!NakedDefeatLoaded && SetOID("NakedDefeatFilter_false", AddTextOption("$SLAC_Naked_Defeat_Filter", "$SLAC_N_A"))
		
		ToysLoaded && SetOID("ToysFilter", AddToggleOption("$SLAC_Disallow_Toys_Blocked", ToysFilter))
		!ToysLoaded && SetOID("ToysFilter_false", AddTextOption("$SLAC_Disallow_Toys_Blocked", "$SLAC_N_A"))
		
		SetOID("DHLPBlockAuto", AddToggleOption("$SLAC_Disallow_DHLP", DHLPBlockAuto))
		SetOID("DCURBlockAuto", AddToggleOption("$SLAC_Disallow_DCUR", DCURBlockAuto))
		SetOID("convenientHorses", AddToggleOption("$SLAC_Convenient_Horses_Fix", convenientHorses))

		If SexLab.GetVersion() >= 20000
			SetOID("SexLabPPlusMode", AddToggleOption("$SLAC_SexLabPPlus_Compatibility", SexLabPPlusMode))
		Else
			SetOID("SexLabPPlusMode_false", AddTextOption("$SLAC_SexLabPPlus_Compatibility", "$SLAC_N_A"))
		EndIf
		
		SetOID("softDependanciesTest", AddTextOption("$SLAC_Mods_Check", "$SLAC_Click_to_Check"))
		SetOID("AutoToggleKey", AddKeyMapOption("$SLAC_Toggle_AutoEngagement_Key", AutoToggleKey, OPTION_FLAG_WITH_UNMAP))

		; Collect claim data
		Int aliasesTotal = slacUtility.slac_Claimed.GetNumAliases()
		Int aliasesFilled = 0
		Int ci = 0
		While ci < aliasesTotal
			ReferenceAlias thisRefAlias = slacUtility.slac_Claimed.GetNthAlias(ci) as ReferenceAlias
			Actor actorRef = thisRefAlias.GetActorRef() as Actor
			If actorRef
				aliasesFilled += 1
			EndIf
			ci += 1
		EndWhile
		
		AddHeaderOption("$SLAC_Fixes")
		SetOID("allowInScene", AddToggleOption("$SLAC_Allow_In_Scene", allowInScene))
		SetOID("currentPCSceneQuest", AddTextOption("$SLAC_Current_PC_Scene_Quest", sceneQuest))
		SetOID("claimActiveActors", AddToggleOption("$SLAC_Claim_Active_Actors", claimActiveActors))
		SetOID("claimQueuedActors", AddToggleOption("$SLAC_Claim_Queued_Actors", claimQueuedActors))
		SetOID("releaseClaimedActors", AddTextOption("$SLAC_Release_Claimed_Actors", "Remove " + aliasesFilled + "/" + aliasesTotal))
		SetOID("disallowMagicInfluenceCharm", AddToggleOption("$SLAC_Disallow_Magic_Influence_Charm", disallowMagicInfluenceCharm))
		SetOID("disallowMagicAllegianceFaction", AddToggleOption("$SLAC_Disallow_Magic_Allegiance_Faction", disallowMagicAllegianceFaction))
		SetOID("disallowMagicCharmFaction", AddToggleOption("$SLAC_Disallow_Magic_Charm_Faction", disallowMagicCharmFaction))
		SetOID("combatStateChangeCooldown", AddSliderOption("$SLAC_Combat_State_Change_Cooldown", combatStateChangeCooldown, "$SLAC_Secs"))
		SetOID("FailedPursuitCooldown", AddSliderOption("$SLAC_Failed_Pursuit_Cooldown", CondInt(FailedPursuitCooldown < 60, 0, Math.Floor(FailedPursuitCooldown / 60)), "$SLAC_Mins"))
		SetOID("weaponsPreventAutoEngagement", AddToggleOption("$SLAC_Weapons_Prevent_Auto_Engagement", weaponsPreventAutoEngagement))
		SetOID("useVRCompatibility", AddToggleOption("$SLAC_Use_VR_Compatibility", useVRCompatibility))
		SetOID("initMCMPage",AddMenuOption("$SLAC_Initial_MCM_Page", MCMPagesList[initMCMPage]))
		SetOID("suppressVersionWarning", AddToggleOption("$SLAC_Suppress_Version_Warning", suppressVersionWarning))
		SetOID("disableSLACStripping", AddToggleOption("$SLAC_Disable_AC_Stripping", disableSLACStripping))
		SetOID("PurgeRaceKeyLists", AddTextOption("$SLAC_Purge_Race_Key_Lists", "$SLAC_Purge"))

		AddHeaderOption("$SLAC_Testing")
		SetOID("skipFilteringStartSex", AddToggleOption("$SLAC_Skip_Animation_Filtering", skipFilteringStartSex))
		SetOID("allowHostileEngagements", AddToggleOption("$SLAC_Allow_Hostile_Engagements", allowHostileEngagements))
		SetOID("allowCombatEngagements", AddToggleOption("$SLAC_Allow_Combat_Engagements", allowCombatEngagements))
		SetOID("hostileArousalMin", AddSliderOption("$SLAC_Hostile_Engagement_Arousal", hostileArousalMin))
		SetOID("allowDialogueAutoEngage", AddToggleOption("$SLAC_Allow_Dialogue_Auto_Engagement", allowDialogueAutoEngage))
		SetOID("allowMenuAutoEngage", AddToggleOption("$SLAC_Allow_Menu_Auto_Engagement", allowMenuAutoEngage))
		SetOID("ClearStoredData", AddTextOption("$SLAC_Clear_Stored_Data", "$SLAC_Clear"))

		SetCursorPosition(27)
		AddHeaderOption("$SLAC_Victim_Collars")
		SetOID("onlyCollared", AddToggleOption("$SLAC_Only_Collared_Victims", onlyCollared))
		SetOID("collarAttraction", AddToggleOption("$SLAC_Creatures_Prefer_Collars", collarAttraction))
		SetOID("collaredArousalMin", AddSliderOption("$SLAC_Collared_Arousal", collaredArousalMin, "{0}"))
		SetOID("clearAllCollarData", AddTextOption("$SLAC_Clear_All_Collar_Data","$SLAC_Click"))
		
		
		playerAmuletForm = slacUtility.GetEquippedArmor(PlayerRef,"Amulet") ; Vanilla Amulet
		playerCollarForm = slacUtility.GetEquippedArmor(PlayerRef,"Neck") ; Mod Collar
		playerSuitForm = slacUtility.GetEquippedArmor(PlayerRef,"Chest"); DD Suit
		
		Int formSize = slac_CollarsFormList.GetSize()
		
		; Convert old storage data
		If slac_CollarsFormList.GetSize() <= 100
			If playerAmuletForm && StorageUtil.UnsetIntValue(playerAmuletForm, "SLArousedCreatures.IsVictimCollar")
				!slac_CollarsFormList.HasForm(playerAmuletForm) && slac_CollarsFormlist.AddForm(playerAmuletForm)
			EndIf
			If playerCollarForm && StorageUtil.UnsetIntValue(playerCollarForm, "SLArousedCreatures.IsVictimCollar")
				!slac_CollarsFormList.HasForm(playerCollarForm) && slac_CollarsFormlist.AddForm(playerCollarForm)
			EndIf
			If playerSuitForm && StorageUtil.UnsetIntValue(playerSuitForm, "SLArousedCreatures.IsVictimCollar")
				!slac_CollarsFormList.HasForm(playerSuitForm) && slac_CollarsFormlist.AddForm(playerSuitForm)
			EndIf
		EndIf

		; Player Collar
		AddHeaderOption("$SLAC_PC_Equipped_Collars")
		playerAmuletForm && SetOID("playerAmulet", AddTextOption(GetFormName(playerAmuletForm, "Amulet ID "), CondString(!slac_CollarsFormList.HasForm(playerAmuletForm), "$SLAC_Add", "$SLAC_Remove")))
		playerCollarForm && SetOID("playerCollar", AddTextOption(GetFormName(playerCollarForm, "Collar ID "), CondString(!slac_CollarsFormList.HasForm(playerCollarForm), "$SLAC_Add", "$SLAC_Remove")))
		playerSuitForm && SetOID("playerSuit", AddTextOption(GetFormName(playerSuitForm, "Suit ID "), CondString(!slac_CollarsFormList.HasForm(playerSuitForm), "$SLAC_Add", "$SLAC_Remove")))
		
		If !playerAmuletForm && !playerCollarForm && !playerSuitForm
			AddTextOption("$SLAC_No_Suitable_Items_Equipped","",OPTION_FLAG_DISABLED)
		EndIf
		
		; Targeted Actor Collar
		AddHeaderOption("$SLAC_NPC_Equipped_Collars")
		If targetActor != None && targetActor != playerRef && targetActor.HasKeyword(slacUtility.ActorTypeNPC)
			targetAmuletForm = targetActor.GetWornForm(kSlotMask35) ; Amulet
			targetCollarForm = targetActor.GetWornForm(kSlotMask45) ; DD Collar
			targetSuitForm = targetActor.GetWornForm(kSlotMask46) ; DD Suit
			
			; Convert old storage data
			If slac_CollarsFormList.GetSize() <= 100
				If targetAmuletForm && StorageUtil.UnsetIntValue(targetAmuletForm, "SLArousedCreatures.IsVictimCollar")
					!slac_CollarsFormList.HasForm(targetAmuletForm) && slac_CollarsFormlist.AddForm(targetAmuletForm)
				EndIf
				If targetCollarForm && StorageUtil.UnsetIntValue(targetCollarForm, "SLArousedCreatures.IsVictimCollar")
					!slac_CollarsFormList.HasForm(targetCollarForm) && slac_CollarsFormlist.AddForm(targetCollarForm)
				EndIf
				If targetSuitForm && StorageUtil.UnsetIntValue(targetSuitForm, "SLArousedCreatures.IsVictimCollar")
					!slac_CollarsFormList.HasForm(targetSuitForm) && slac_CollarsFormlist.AddForm(targetSuitForm)
				EndIf
			EndIf
			
			targetAmuletForm && SetOID("targetAmulet", AddTextOption(GetFormName(targetAmuletForm, "Amulet ID "), CondString(!slac_CollarsFormList.HasForm(targetAmuletForm), "$SLAC_Add", "$SLAC_Remove")))
			targetCollarForm && SetOID("targetCollar", AddTextOption(GetFormName(targetCollarForm, "Collar ID "), CondString(!slac_CollarsFormList.HasForm(targetCollarForm), "$SLAC_Add", "$SLAC_Remove")))
			targetSuitForm && SetOID("targetSuit", AddTextOption(GetFormName(targetSuitForm, "Suit ID "), CondString(!slac_CollarsFormList.HasForm(targetSuitForm), "$SLAC_Add", "$SLAC_Remove")))
		
			If !targetAmuletForm && !targetCollarForm && !targetSuitForm
				AddTextOption("$SLAC_No_Suitable_Items_Equipped","",OPTION_FLAG_DISABLED)
			EndIf
		Else
			AddTextOption("$SLAC_No_NPC_Selected","",OPTION_FLAG_DISABLED)
		EndIf
		
		AddHeaderOption("$SLAC_Current_Collars")
		
		collarsOID = Utility.CreateIntArray(formSize,-1)
		Int i = 0
		While i < formSize
			Armor collarForm = slac_CollarsFormList.GetAt(i) as Armor
			If collarForm != None
				String prefix = "Item ID "
				If Math.LogicalAnd(collarForm.GetSlotMask(), slacUtility.ArmorSlotNameToMask("Amulet"))
					prefix = "Amulet ID "
				ElseIf Math.LogicalAnd(collarForm.GetSlotMask(), slacUtility.ArmorSlotNameToMask("Collar"))
					prefix = "Collar ID "
				ElseIf Math.LogicalAnd(collarForm.GetSlotMask(), slacUtility.ArmorSlotNameToMask("Chest"))
					prefix = "Suit ID "
				EndIf
				collarsOID[i] = AddTextOption(GetFormName(collarForm,prefix), "$SLAC_Remove")
			EndIf
			i += 1
		EndWhile
		
		; Notifications testing
		Int NTEnable = CondInt(debugSLAC,OPTION_FLAG_NONE,OPTION_FLAG_DISABLED)
		EventIDs = slacUtility.slacNotify.GetEventIDs()
		AddHeaderOption("$SLAC_Notification_Testing")
		If !InMaintenance
			SetOID("NTSelectedNPC", AddTextOption("$SLAC_Selected_NPC", slacUtility.GetActorNameRef(slacPlayerScript.LastSelectedNPC),NTEnable))
			SetOID("NTSelectedCreature", AddTextOption("$SLAC_Selected_Creature", slacUtility.GetActorNameRef(slacPlayerScript.LastSelectedCreature),NTEnable))
		Else
			SetOID("NTSelectedNPC", AddTextOption("$SLAC_Selected_NPC", "$SLAC_None", OPTION_FLAG_DISABLED))
			SetOID("NTSelectedCreature", AddTextOption("$SLAC_Selected_Creature", "$SLAC_None", OPTION_FLAG_DISABLED))
		EndIf
		SetOID("NTEventIDIndex", AddMenuOption("$SLAC_Event_ID", EventIDs[NTEventIDIndex], NTEnable))
		SetOID("NTConsensual", AddToggleOption("$SLAC_Consensual", NTConsensual, NTEnable))
		SetOID("NTGroup", AddToggleOption("$SLAC_Group", NTGroup, NTEnable))
		SetOID("NTCreatureVictim", AddToggleOption("$SLAC_Creature_Victim", NTCreatureVictim, NTEnable))
		SetOID("NTTypeIndex", AddTextOption("$SLAC_Animation_Type", NTTypeList[NTTypeIndex], NTEnable))
		SetOID("NTGet", AddTextOption("$SLAC_Victim_Getting_Giving", CondString(NTGet,"$SLAC_Get","$SLAC_Give"), NTEnable))
		SetOID("NTDump", AddTextOption("$SLAC_Dump_Results", "$SLAC_Dump", NTEnable))
		SetOID("NTReload", AddTextOption("$SLAC_Reload_Notifications_JSON", "$SLAC_Reload", NTEnable))
		SetOID("NTModVersion", AddTextOption("$SLAC_Notifications_Mod_Version", slacUtility.slacNotify.GetModVersion(), NTEnable))
		SetOID("NTFileVersion", AddTextOption("$SLAC_Notifications_File_Version", slacUtility.slacNotify.GetFileVersion(), NTEnable))

		GoToState("slacOtherSettings_ST")
		
	ElseIf page == "$SLAC_Profiles"
		slacProfileLoadOID = New Int[6]
		slacProfileSaveOID = New Int[6]
	
		; Settings Profile options
		SetCursorFillMode(TOP_TO_BOTTOM)
		
		SetCursorPosition(0)
		AddHeaderOption("$SLAC_Load_Settings_Profile")
		SetOID("slacProfileLoadTags", AddToggleOption("$SLAC_Settings_Profile_Load_Tags", slacProfileLoadTags))
		slacProfileLoadOID[0] = AddTextOption("$SLAC_Settings_Profile_Default", "$SLAC_Load")
		slacProfileLoadOID[1] = AddTextOption("Profile 1 " + GetProfileName(1), "$SLAC_Load", CondInt(ProfileAvailable(1), OPTION_FLAG_NONE, OPTION_FLAG_DISABLED))
		slacProfileLoadOID[2] = AddTextOption("Profile 2 " + GetProfileName(2), "$SLAC_Load", CondInt(ProfileAvailable(2), OPTION_FLAG_NONE, OPTION_FLAG_DISABLED))
		slacProfileLoadOID[3] = AddTextOption("Profile 3 " + GetProfileName(3), "$SLAC_Load", CondInt(ProfileAvailable(3), OPTION_FLAG_NONE, OPTION_FLAG_DISABLED))
		slacProfileLoadOID[4] = AddTextOption("Profile 4 " + GetProfileName(4), "$SLAC_Load", CondInt(ProfileAvailable(4), OPTION_FLAG_NONE, OPTION_FLAG_DISABLED))
		slacProfileLoadOID[5] = AddTextOption("Profile 5 " + GetProfileName(5), "$SLAC_Load", CondInt(ProfileAvailable(5), OPTION_FLAG_NONE, OPTION_FLAG_DISABLED))
		
		SetCursorPosition(1)
		AddHeaderOption("$SLAC_Save_Settings_Profile")
		SetOID("slacProfileSaveName", AddInputOption("$SLAC_Current_Profile_Name", slacProfileSaveName))
		AddEmptyOption()
		slacProfileSaveOID[1] = AddTextOption("Profile 1 " + GetProfileName(1), CondString(ProfileAvailable(1), "$SLAC_Save_Over", "$SLAC_Save"))
		slacProfileSaveOID[2] = AddTextOption("Profile 2 " + GetProfileName(2), CondString(ProfileAvailable(2), "$SLAC_Save_Over", "$SLAC_Save"))
		slacProfileSaveOID[3] = AddTextOption("Profile 3 " + GetProfileName(3), CondString(ProfileAvailable(3), "$SLAC_Save_Over", "$SLAC_Save"))
		slacProfileSaveOID[4] = AddTextOption("Profile 4 " + GetProfileName(4), CondString(ProfileAvailable(4), "$SLAC_Save_Over", "$SLAC_Save"))
		slacProfileSaveOID[5] = AddTextOption("Profile 5 " + GetProfileName(5), CondString(ProfileAvailable(5), "$SLAC_Save_Over", "$SLAC_Save"))
	
		GoToState("slacProfiles_ST")
		
	ElseIf page == "$SLAC_Help"
		; We want to know if SL installation via the MCM has been completed. There is no working direct
		; option right now so we are just looking for generic animations for any default type (MF,MM,FF).
		; Trying to speed this up by breaking it into sequential searches until something is found.
		Int TestAnimCount = 0
		If !UsingSLPP()
			sslBaseAnimation[] testAnims = SexLab.GetAnimationsByTags(2,"vaginal",requireAll = False)
			If testAnims.Length < 1
				testAnims = SexLab.GetAnimationsByTags(2,"oral",requireAll = False)
			EndIf
			If testAnims.Length < 1
				testAnims = SexLab.GetAnimationsByTags(2,"anal",requireAll = False)
			EndIf
			Log("Config Help SexLab.GetAnimationsByTags() returned " + testAnims.Length)
			If testAnims.Length < 1
				testAnims = SexLab.GetCreatureAnimationsByTags(2,"vaginal",requireAll = False)
			EndIf
			If testAnims.Length < 1
				testAnims = SexLab.GetCreatureAnimationsByTags(2,"oral",requireAll = False)
			EndIf
			If testAnims.Length < 1
				testAnims = SexLab.GetCreatureAnimationsByTags(2,"anal",requireAll = False)
			EndIf
			TestAnimCount = testAnims.Length
			Log("Config Help SexLab.GetCreatureAnimationsByTags() returned " + testAnims.Length)
		EndIf

		SetCursorFillMode(TOP_TO_BOTTOM)
		
		SetCursorPosition(0)
		
		Int slv = SexLab.GetVersion()
		Int puv = PapyrusUtil.GetVersion()

		AddTextOption("$SLAC_Aroused_Creatures_Version", GetVersionString())
		AddTextOption("$SLAC_SL_Version_Name", SexLab.GetStringVer())
		AddTextOption("$SLAC_PapyrusUtil_Version_Number", puv)
		SetOID("SexLabVersionTest", AddTextOption("$SLAC_SL_Version", CondString((slv >= 16000 && slv < 20000) || slv >= 25000, "$SLAC_Pass_Green", "$SLAC_Caution_Orange")))
		AddTextOptionST("slEnabled_ST", "$SLAC_SL_Enabled", CondString(SexLab.Enabled,"$SLAC_Pass_Green","$SLAC_Fail_Red"))
		AddTextOptionST("inMaintenance_ST", "$SLAC_Aroused_Creatures_Maintenance", CondString(inMaintenance || InInitMaintenance,"$SLAC_In_Progress_Orange","$SLAC_Complete_Green"))
		SetOID("skipFilteringTest", AddTextOption("$SLAC_Animation_Filtering_Enabled", CondString(!skipFilteringStartSex,"$SLAC_OK_Green","$SLAC_Caution_Orange")))
		SetOID("versionTestUtility", AddTextOption("$SLAC_Utility_Script_Version", CondString(GetVersion() == slacUtility.GetVersion(),"$SLAC_OK_Green","$SLAC_Fail_Red")))

		SetCursorPosition(1)
		AddTextOption("$SLAC_Aroused_Creatures_MCM_Version", GetVersion())
		AddTextOption("$SLAC_SL_Version_Number", slv)
		SetOID("PapyrusUtilVersionTest", AddTextOption("$SLAC_PapyrusUtil_Compatibility",CondString(puv >= 40,"$SLAC_Pass_Green","$SLAC_Caution_Orange")))
		AddTextOptionST("slInstall_ST", "$SLAC_SL_Install_Complete", CondString(TestAnimCount > 0 || (UsingSLPP() && SexLab.Enabled),"$SLAC_Pass_Green","$SLAC_Fail_Red"))
		AddTextOptionST("slCreatures_ST", "$SLAC_SL_Creatures_Enabled", CondString(SexLab.AllowCreatures,"$SLAC_Pass_Green","$SLAC_Fail_Red"))
		AddTextOptionST("slDisableTeleport_ST", "$SLAC_SL_Disable_Teleport_Disabled", CondString(!SexLab.Config.DisableTeleport,"$SLAC_Pass_Green","$SLAC_Problem_Orange"))
		AddTextOptionST("slMatchCreatureGenders_ST", "$SLAC_SL_Match_Creature_Genders", CondString((pcCreatureSexValue > 0 || npcCreatureSexValue > 0) && !SexLab.Config.UseCreatureGender,"$SLAC_Problem_Orange","$SLAC_Pass_Green"))
		String[] tempRaceKeyList = FrameworkGetAllRaceKeys()
		SetOID("raceKeyTest", AddTextOption("$SLAC_SL_Creature_Races", CondString(tempRaceKeyList.Length > 0,"$SLAC_Pass_Green","$SLAC_Fail_Red")))
		SetOID("debugTest", AddTextOption("$SLAC_Debug_Disabled", CondString(!debugSLAC,"$SLAC_OK_Green","$SLAC_Caution_Orange")))
		If !InInitMaintenance
			SetOID("versionTestPlayer", AddTextOption("$SLAC_Player_Script_Version", CondString(GetVersion() == slacPlayerScript.GetVersion(),"$SLAC_OK_Green","$SLAC_Fail_Red")))
		Else
			SetOID("versionTestPlayer", AddTextOption("$SLAC_Player_Script_Version", "$SLAC_Working_Ellipsis", OPTION_FLAG_DISABLED))
		EndIf

		SetCursorFillMode(LEFT_TO_RIGHT)
		SetCursorPosition(18)

		; Actor Cleaning
		AddHeaderOption("$SLAC_Clean_Actors")
		AddHeaderOption(" ")
		AddTextOptionST("cleanPC_ST", "$SLAC_Clean_PC", Game.GetPlayer().GetLeveledActorBase().GetName())
		If targetActor && targetActor != None && targetActor != Game.GetPlayer()
			AddTextOptionST("cleanNPC_ST", "$SLAC_Clean_NPC", targetActor.GetLeveledActorBase().GetName())
			AddEmptyOption()
			If targetActor.IsInFaction(slac_AutoEngageBlockedFaction)
				SetOID("autoEngageBlocked", AddTextOption("$SLAC_Auto_Engage_Permission", "$SLAC_Blocked"))
			ElseIf targetActor.IsInFaction(slac_AutoEngagePermittedFaction)
				SetOID("autoEngageBlocked", AddTextOption("$SLAC_Auto_Engage_Permission", "$SLAC_Allowed"))
			Else
				SetOID("autoEngageBlocked", AddTextOption("$SLAC_Auto_Engage_Permission", "$SLAC_Default"))
			EndIf
		Else
			AddTextOptionST("cleanNPC_ST", "$SLAC_Clean_NPC", "$SLAC_No_NPC_Selected")
		EndIf

		AddHeaderOption("$SLAC_NPCPC_Engagement_Failures")
		AddHeaderOption("$SLAC_Creature_Engagement_Failures")
		
		Int i = 0
		While i < failedActorsNPCs.length && (failedActorsNPCs[i] || failedActorsCreatures[i])
		
			If failedActorsNPCs[i]
				failedActorsNPCsOID[i] = AddTextOption(failedActorsNPCs[i], StringUtil.SubString(failedActorsNPCsString[i],1))
			Else
				failedActorsNPCsOID[i] = -1
				AddEmptyOption()
			EndIf
			
			If failedActorsCreatures[i]
				failedActorsCreaturesOID[i] = AddTextOption(failedActorsCreatures[i], StringUtil.SubString(failedActorsCreaturesString[i],1))
			Else
				failedActorsCreaturesOID[i] = -1
				AddEmptyOption()
			EndIf
				
			i += 1
		EndWhile
		
		AddTextOptionST("clearFailedLists_ST", "$SLAC_Clear_Failed_Lists", "$SLAC_Clear")

		GoToState("help_ST")
	Else
		; Splash Page
		LoadCustomContent("arousedcreatures/aroused_creatures_logo.dds", 208, 50)

	EndIf
EndEvent


; ===========================
; =                         =
; =    General Settings     =
; =                         =
; ===========================

	; ====================== Global ======================
	
	; Cooldown
	State nextEngageTime_ST
		Event OnSliderOpenST()
			SetSliderDialogStartValue(nextEngageTime as float)
			SetSliderDialogDefaultValue(0)
			SetSliderDialogRange(0,6000)
			SetSliderDialogInterval(10.0)
		EndEvent
		Event OnSliderAcceptST(Float value)
			nextEngageTime = value as Int
			SetSliderOptionValueST(nextEngageTime, "$SLAC_Secs")
		EndEvent
		Event OnDefaultST()
			nextEngageTime = 0
			SetSliderOptionValueST(nextEngageTime, "$SLAC_Secs")
		EndEvent
		Event OnHighlightST()
			SetInfoText("$SLAC_Cooldown_info")
		EndEvent
	EndState

	; Require LoS
	State requireLos_ST
		Event OnSelectST()
			requireLos = !requireLos
			SetToggleOptionValueST(requireLos)
		EndEvent
		Event OnHighlightST()
			SetInfoText("$SLAC_LOS_info")
		EndEvent
	EndState
	
	; Engage Radius
	State EnagageRadius_ST
		Event OnSliderOpenST()
			SetSliderDialogStartValue(engageRadius as float)
			SetSliderDialogDefaultValue(60)
			SetSliderDialogRange(0,384)
			SetSliderDialogInterval(1.0)
		EndEvent
		Event OnSliderAcceptST(Float value)
			engageRadius = value as Int
			SetSliderOptionValueST(engageRadius, "$SLAC_Feet")
		EndEvent
		Event OnDefaultST()
			engageRadius = 60
			SetSliderOptionValueST(engageRadius, "$SLAC_Feet")
		EndEvent
		Event OnHighlightST()
			SetInfoText("$SLAC_EngageRad_info")
		EndEvent
	EndState

	; Ignore Sitting Actors
	State noSittingActors_ST
		Event OnSelectST()
			noSittingActors = !noSittingActors
			SetToggleOptionValueST(noSittingActors)
		EndEvent
		Event OnHighlightST()
			SetInfoText("$SLAC_Ignore_Sitting_Actors_info")
		EndEvent
	EndState

	; On-Hit Interruption
	State onHitInterrupt_ST
		Event OnSelectST()
			onHitInterrupt = !onHitInterrupt
			SetToggleOptionValueST(onHitInterrupt)
		EndEvent
		Event OnHighlightST()
			SetInfoText("$SLAC_On_Hit_Interrupt_info")
		EndEvent
	EndState

	; Allow Enemy Creatures
	State allowEnemies_ST
		Event OnSelectST()
			allowEnemies = !allowEnemies
			SetToggleOptionValueST(allowEnemies)
		EndEvent
		Event OnHighlightST()
			SetInfoText("$SLAC_Allow_Enemy_Creatures_info")
		EndEvent
	EndState

	; ====================== Performance ======================
	
	; Mod Active
	State modActive_ST
		Event OnSelectST()
			If InMaintenance
				ShowMessage("$SLAC_Maintenance_Option_Warning_msg")
				Return
			EndIf

			If !ShowMessage("$SLAC_EnableDisable_msg", True, CondString(modActive, "$SLAC_Disable", "$SLAC_Enable"), "$SLAC_Cancel")
				Return
			EndIf

			modActive = !modActive
			SetToggleOptionValueST(modActive)
			If modActive
				; Activate inactive mod
				slacPlayerScript.UnregisterForUpdate()
				slacPlayerScript.RegisterForSingleUpdate(1)
				Log("Aroused Creatures Activated",true,true)
			Else
				; Deactivate active mod
				slacUtility.EndPursuitQuest(slac_Pursuit_00,True)
				slacUtility.EndPursuitQuest(slac_Pursuit_01,True)
				slacUtility.EndPursuitQuest(slac_FollowerDialogue,True)
				slacUtility.EndPursuitQuest(slac_CreatureDialogue,True)
				slacUtility.ClearSuitors()
				; Stop quests after MCM closes to prevent UI locking up.
				; Note this requires testing for race condition for any on-going scan in the player script
				slacPlayerScript.UnregisterForUpdate()
				slacPlayerScript.RegisterForSingleUpdate(1)
				Log("Aroused Creatures Disabled",true,true)
			EndIf
		EndEvent
		Event OnHighlightST()
			SetInfoText("$SLAC_EnableDisable_info")
		EndEvent
	EndState

	; Debug SLAC
	State debugSLAC_ST
		Event OnSelectST()
			; INI condition message
			Bool iniLog =  Utility.GetINIBool("bEnableLogging:Papyrus")
			Bool iniTrace = Utility.GetINIBool("bEnableTrace:Papyrus")
			Bool iniDebug = Utility.GetINIBool("bLoadDebugInformation:Papyrus")
			!debugSLAC && ((iniLog && iniTrace && iniDebug) || ShowMessage("For full debugging info your Skyrimcustom.ini must be updated to enable logging:\n\n[Papyrus]\nbEnableLogging = 1 " + CondString(!iniLog,"(currently 0)") + "\nbEnableTrace = 1 " + CondString(!iniTrace,"(currently 0)") + "\nbLoadDebugInformation = 1 " + CondString(!iniDebug,"(currently 0)") + "\n\nUse BethINI to update your INIs for Papyrus logging. Aroused Creatures debugging will still be enabled for console output, notifications and debug shaders.", False))
			
			debugSLAC = !debugSLAC
			SetToggleOptionValueST(debugSLAC)
			
			; Update debug shader option
			If !debugSLAC
				debugScanShaders = False
				SetToggleOptionValue(GetOID("debugScanShaders"), debugScanShaders)
				SetOptionFlags(GetOID("debugScanShaders"), OPTION_FLAG_DISABLED)
			Else
				SetOptionFlags(GetOID("debugScanShaders"), OPTION_FLAG_NONE)
			EndIf
		EndEvent
		Event OnHighlightST()
			SetInfoText("$SLAC_Debug_info")
		EndEvent
	EndState
	
	; NPC Count Max
	State countMax_ST
		Event OnSliderOpenST()
			SetSliderDialogStartValue(countMax)
			SetSliderDialogDefaultValue(4)
			SetSliderDialogRange(1,10)
			SetSliderDialogInterval(1.0)
		EndEvent
		Event OnSliderAcceptST(Float value)
			countMax = value as Int
			SetSliderOptionValueST(countMax, "{0}")
		EndEvent
		Event OnDefaultST()
			countMax = 10
			SetSliderOptionValueST(countMax, "{0}")
		EndEvent
		Event OnHighlightST()
			SetInfoText("$SLAC_NPCs_to_Check_info")
		EndEvent
	EndState

	; Creature Count Max
	State creaturecountMax_ST
		Event OnSliderOpenST()
			SetSliderDialogStartValue(creatureCountMax)
			SetSliderDialogDefaultValue(10)
			SetSliderDialogRange(1,20)
			SetSliderDialogInterval(1.0)
		EndEvent
		Event OnSliderAcceptST(Float value)
			creatureCountMax = value as Int
			SetSliderOptionValueST(creatureCountMax, "{0}")
		EndEvent
		Event OnDefaultST()
			creatureCountMax = 10
			SetSliderOptionValueST(creatureCountMax, "{0}")
		EndEvent
		Event OnHighlightST()
			SetInfoText("$SLAC_Creatures_to_Check_info")
		EndEvent
	EndState

	; Check Frequency
	State checkFrequency_ST
		Event OnSliderOpenST()
			SetSliderDialogStartValue(checkFrequency as float)
			SetSliderDialogDefaultValue(5)
			SetSliderDialogRange(1,120)
			SetSliderDialogInterval(1.0)
		EndEvent
		Event OnSliderAcceptST(Float value)
			checkFrequency = value as Int
			SetSliderOptionValueST(checkFrequency, "$SLAC_Secs")
		EndEvent
		Event OnDefaultST()
			checkFrequency = 5
			SetSliderOptionValueST(checkFrequency, "$SLAC_Secs")
		EndEvent
		Event OnHighlightST()
			SetInfoText("$SLAC_Scan_Delay_info")
		EndEvent
	EndState

	; Cloak Radius
	State cloakRadius_ST
		Event OnSliderOpenST()
			SetSliderDialogStartValue(cloakRadius as float)
			SetSliderDialogDefaultValue(192)
			SetSliderDialogRange(0,384)
			SetSliderDialogInterval(1.0)
		EndEvent
		Event OnSliderAcceptST(Float value)
			cloakRadius = value as Int
			SetSliderOptionValueST(cloakRadius, "$SLAC_Feet")
		EndEvent
		Event OnDefaultST()
			cloakRadius = 192
			SetSliderOptionValueST(cloakRadius, "$SLAC_Feet")
		EndEvent
		Event OnHighlightST()
			SetInfoText("$SLAC_CloakRad_info")
		EndEvent
	EndState

	State GeneralSettings_ST
	
		Event OnOptionSelect(Int option)

			; General
			
			If option == GetOID("actorPreferenceIndex")
				actorPreferenceIndex = AdvIndex(actorPreferenceIndex,actorPreferenceList, 0)
				SetTextOptionValue(option, actorPreferenceList[actorPreferenceIndex])
				
			; Performance 

			ElseIf option == GetOID("debugScanShaders")
				; Shaders should only be visible in debug mode
				; This means shader activity is covered by the Debug warning on the Help page.
				If debugSLAC
					debugScanShaders = !debugScanShaders
					SetToggleOptionValue(option, debugScanShaders)
				Else
					debugScanShaders = False
					SetToggleOptionValue(option, debugScanShaders)
					SetOptionFlags(option, OPTION_FLAG_DISABLED)
				EndIf
				
			ElseIf option == GetOID("dumpSettings")
				If ShowMessage("$SLAC_Dump_Current_Settings_To_Log_msg", true, "$SLAC_Dump", "$SLAC_Cancel")
					DumpSettings()
				EndIf

			EndIf

		EndEvent
				
		Event OnOptionSliderOpen(Int option)
			If option == GetOID("SLAnimationMax")
				SetSliderDialogStartValue(SLAnimationMax)
				SetSliderDialogDefaultValue(15)
				SetSliderDialogRange(1,15)
				SetSliderDialogInterval(1.0)
			EndIf
		EndEvent
		
		Event OnOptionSliderAccept(Int option, Float value)
			If option == GetOID("SLAnimationMax")
				SLAnimationMax = value as Int
				SetSliderOptionValue(option, SLAnimationMax)
			EndIf
		EndEvent
		
		Event OnOptionHighlight(Int option)
			
			; General
			
			If option == GetOID("actorPreferenceIndex")
				SetInfoText("$SLAC_Preference_info")
				
			; Performance 
			
			ElseIf option == GetOID("debugScanShaders")
				SetInfoText("$SLAC_Debug_Shaders_info")
				
			ElseIf option == GetOID("dumpSettings")
				SetInfoText("$SLAC_Dump_Current_Settings_To_Log_info")
				
			ElseIf option == GetOID("SLAnimationMax")
				SetInfoText("$SLAC_Max_SexLab_Animations_info")
				
			EndIf

		EndEvent
	EndState
	

; ==============================
; =                            =
; =    PC/NPC Auto Settings    =
; =                            =
; ==============================


	; ====================== General ======================
	
	
	; PC Active
	State pcActive_ST
		Event OnSelectST()
			pcActive = !pcActive
			SetToggleOptionValueST(pcActive)
			AutoToggleState = False ; Forget hotkey override
		EndEvent
		Event OnHighlightST()
			SetInfoText("$SLAC_PCActive_info")
		EndEvent
	EndState

	; NPC Active
	State npcActive_ST
		Event OnSelectST()
			npcActive = !npcActive
			SetToggleOptionValueST(npcActive)
			AutoToggleState = False ; Forget hotkey override
		EndEvent
		Event OnHighlightST()
			SetInfoText("$SLAC_NPCActive_info")
		EndEvent
	EndState

	; Show Notifications for PC
	State showNotifications_ST
		Event OnSelectST()
			showNotifications = !showNotifications
			SetToggleOptionValueST(showNotifications)
		EndEvent
		Event OnHighlightST()
			SetInfoText("$SLAC_Show_Engagement_Messages_info")
		EndEvent
	EndState

	; Show Notifications for NPCs
	State showNotificationsNPC_ST
		Event OnSelectST()
			showNotificationsNPC = !showNotificationsNPC
			SetToggleOptionValueST(showNotificationsNPC)
		EndEvent
		Event OnHighlightST()
			SetInfoText("$SLAC_Show_Engagement_Messages_info")
		EndEvent
	EndState

	
	; ================== Arousal & Consent ================
	
	
	; PC Creature Arousal
	State pcCreatureArousalMin_ST
		Event OnSliderOpenST()
			SetSliderDialogStartValue(pcCreatureArousalMin as float)
			SetSliderDialogDefaultValue(60)
			SetSliderDialogRange(0,100)
			SetSliderDialogInterval(1.0)
		EndEvent
		Event OnSliderAcceptST(Float value)
			pcCreatureArousalMin = value as Int
			SetSliderOptionValueST(pcCreatureArousalMin, "{0}")
		EndEvent
		Event OnDefaultST()
			pcCreatureArousalMin = 60
			SetSliderOptionValueST(pcCreatureArousalMin, "{0}")
		EndEvent
		Event OnHighlightST()
			SetInfoText("$SLAC_Creature_Arousal_info")
		EndEvent
	EndState

	; NPC Creature Arousal
	State npcCreatureArousalMin_ST
		Event OnSliderOpenST()
			SetSliderDialogStartValue(npcCreatureArousalMin as float)
			SetSliderDialogDefaultValue(60)
			SetSliderDialogRange(0,100)
			SetSliderDialogInterval(1.0)
		EndEvent
		Event OnSliderAcceptST(Float value)
			npcCreatureArousalMin = value as Int
			SetSliderOptionValueST(npcCreatureArousalMin, "{0}")
		EndEvent
		Event OnDefaultST()
			npcCreatureArousalMin = 60
			SetSliderOptionValueST(npcCreatureArousalMin, "{0}")
		EndEvent
		Event OnHighlightST()
			SetInfoText("$SLAC_Creature_Arousal_info")
		EndEvent
	EndState

	; PC Arousal Threshold
	State pcArousalMin_ST
		Event OnSliderOpenST()
			SetSliderDialogStartValue(pcArousalMin as float)
			SetSliderDialogDefaultValue(0)
			SetSliderDialogRange(0,100)
			SetSliderDialogInterval(1.0)
		EndEvent
		Event OnSliderAcceptST(Float value)
			pcArousalMin = value as Int
			SetSliderOptionValueST(pcArousalMin, "{0}")
		EndEvent
		Event OnDefaultST()
			pcArousalMin = 0
			SetSliderOptionValueST(pcArousalMin, "{0}")
		EndEvent
		Event OnHighlightST()
			SetInfoText("$SLAC_Arousal_Threshold_info")
		EndEvent
	EndState

	; NPC Arousal Threshold
	State npcArousalMin_ST
		Event OnSliderOpenST()
			SetSliderDialogStartValue(npcArousalMin as float)
			SetSliderDialogDefaultValue(0)
			SetSliderDialogRange(0,100)
			SetSliderDialogInterval(1.0)
		EndEvent
		Event OnSliderAcceptST(Float value)
			npcArousalMin = value as Int
			SetSliderOptionValueST(npcArousalMin, "{0}")
		EndEvent
		Event OnDefaultST()
			npcArousalMin = 0
			SetSliderOptionValueST(npcArousalMin, "{0}")
		EndEvent
		Event OnHighlightST()
			SetInfoText("$SLAC_Arousal_Threshold_info")
		EndEvent
	EndState

	
	; ===================== Orgy Mode =====================
	
	
	; Orgy Mode PC
	State orgyModePC_ST
		Event OnSelectST()
			orgyModePC = !orgyModePC
			SetToggleOptionValueST(orgyModePC)
		EndEvent
		Event OnHighlightST()
			SetInfoText("$SLAC_Orgy_Mode_Enable_PC_info")
		EndEvent
	EndState

	; Orgy Mode NPC
	State orgyModeNPC_ST
		Event OnSelectST()
			orgyModeNPC = !orgyModeNPC
			SetToggleOptionValueST(orgyModeNPC)
		EndEvent
		Event OnHighlightST()
			SetInfoText("$SLAC_Orgy_Mode_Enable_NPC_info")
		EndEvent
	EndState

	; PC Orgy Creature Arousal Threshold
	State orgyArousalMinPCCreature_ST
		Event OnSliderOpenST()
			SetSliderDialogStartValue(orgyArousalMinPCCreature)
			SetSliderDialogDefaultValue(10)
			SetSliderDialogRange(0,100)
			SetSliderDialogInterval(1.0)
		EndEvent
		Event OnSliderAcceptST(Float value)
			orgyArousalMinPCCreature = value as Int
			SetSliderOptionValueST(orgyArousalMinPCCreature, "{0}")
		EndEvent
		Event OnDefaultST()
			orgyArousalMinPCCreature = 15
			SetSliderOptionValueST(orgyArousalMinPCCreature, "{0}")
		EndEvent
		Event OnHighlightST()
			SetInfoText("$SLAC_Orgy_Mode_PCNPC_Creature_Arousal_info")
		EndEvent
	EndState
	
	; NPC Orgy Creature Arousal Threshold
	State orgyArousalMinNPCCreature_ST
		Event OnSliderOpenST()
			SetSliderDialogStartValue(orgyArousalMinNPCCreature)
			SetSliderDialogDefaultValue(10)
			SetSliderDialogRange(0,100)
			SetSliderDialogInterval(1.0)
		EndEvent
		Event OnSliderAcceptST(Float value)
			orgyArousalMinNPCCreature = value as Int
			SetSliderOptionValueST(orgyArousalMinNPCCreature, "{0}")
		EndEvent
		Event OnDefaultST()
			orgyArousalMinNPCCreature = 15
			SetSliderOptionValueST(orgyArousalMinNPCCreature, "{0}")
		EndEvent
		Event OnHighlightST()
			SetInfoText("$SLAC_Orgy_Mode_PCNPC_Creature_Arousal_info")
		EndEvent
	EndState
	
	; PC Orgy Arousal Threshold
	State orgyArousalMinPC_ST
		Event OnSliderOpenST()
			SetSliderDialogStartValue(orgyArousalMinPC)
			SetSliderDialogDefaultValue(15)
			SetSliderDialogRange(0,100)
			SetSliderDialogInterval(1.0)
		EndEvent
		Event OnSliderAcceptST(Float value)
			orgyArousalMinPC = value as Int
			SetSliderOptionValueST(orgyArousalMinPC, "{0}")
		EndEvent
		Event OnDefaultST()
			orgyArousalMinPC = 15
			SetSliderOptionValueST(orgyArousalMinPC, "{0}")
		EndEvent
		Event OnHighlightST()
			SetInfoText("$SLAC_Orgy_Mode_PCNPC_Arousal_info")
		EndEvent
	EndState
	
	; NPC Orgy Arousal Threshold
	State orgyArousalMinNPC_ST
		Event OnSliderOpenST()
			SetSliderDialogStartValue(orgyArousalMinNPC)
			SetSliderDialogDefaultValue(15)
			SetSliderDialogRange(0,100)
			SetSliderDialogInterval(1.0)
		EndEvent
		Event OnSliderAcceptST(Float value)
			orgyArousalMinNPC = value as Int
			SetSliderOptionValueST(orgyArousalMinNPC, "{0}")
		EndEvent
		Event OnDefaultST()
			orgyArousalMinNPC = 15
			SetSliderOptionValueST(orgyArousalMinNPC, "{0}")
		EndEvent
		Event OnHighlightST()
			SetInfoText("$SLAC_Orgy_Mode_PCNPC_Arousal_info")
		EndEvent
	EndState
	
	
	; ================== Creature Group ===================
	
	
	; PC Creature Group Chance
	State groupChancePC_ST
		Event OnSliderOpenST()
			SetSliderDialogStartValue(groupChancePC as float)
			SetSliderDialogDefaultValue(0)
			SetSliderDialogRange(0,100)
			SetSliderDialogInterval(1.0)
		EndEvent
		Event OnSliderAcceptST(Float value)
			groupChancePC = value as Int
			SetSliderOptionValueST(groupChancePC, "$SLAC_Percent")
		EndEvent
		Event OnDefaultST()
			groupChancePC = 0
			SetSliderOptionValueST(groupChancePC, "$SLAC_Percent")
		EndEvent
		Event OnHighlightST()
			SetInfoText("$SLAC_Group_Chance_info")
		EndEvent
	EndState
	
	; NPC Creature Group Chance
	State groupChanceNPC_ST
		Event OnSliderOpenST()
			SetSliderDialogStartValue(groupChanceNPC as float)
			SetSliderDialogDefaultValue(0)
			SetSliderDialogRange(0,100)
			SetSliderDialogInterval(1.0)
		EndEvent
		Event OnSliderAcceptST(Float value)
			groupChanceNPC = value as Int
			SetSliderOptionValueST(groupChanceNPC, "$SLAC_Percent")
		EndEvent
		Event OnDefaultST()
			groupChanceNPC = 0
			SetSliderOptionValueST(groupChanceNPC, "$SLAC_Percent")
		EndEvent
		Event OnHighlightST()
			SetInfoText("$SLAC_Group_Chance_info")
		EndEvent
	EndState
	
	; PC Group Max Extras
	State groupMaxExtrasPC_ST
		Event OnSliderOpenST()
			SetSliderDialogStartValue(groupMaxExtrasPC as float)
			SetSliderDialogDefaultValue(3)
			SetSliderDialogRange(1,3)
			SetSliderDialogInterval(1.0)
		EndEvent
		Event OnSliderAcceptST(Float value)
			groupMaxExtrasPC = value as Int
			SetSliderOptionValueST(groupMaxExtrasPC, "{0}")
		EndEvent
		Event OnDefaultST()
			groupMaxExtrasPC = 3
			SetSliderOptionValueST(groupMaxExtrasPC, "{0}")
		EndEvent
		Event OnHighlightST()
			SetInfoText("$SLAC_Group_Max_Extras_info")
		EndEvent
	EndState
	
	; NPC Group Max Extras
	State groupMaxExtrasNPC_ST
		Event OnSliderOpenST()
			SetSliderDialogStartValue(groupMaxExtrasNPC as float)
			SetSliderDialogDefaultValue(3)
			SetSliderDialogRange(1,3)
			SetSliderDialogInterval(1.0)
		EndEvent
		Event OnSliderAcceptST(Float value)
			groupMaxExtrasNPC = value as Int
			SetSliderOptionValueST(groupMaxExtrasNPC, "{0}")
		EndEvent
		Event OnDefaultST()
			groupMaxExtrasNPC = 3
			SetSliderOptionValueST(groupMaxExtrasNPC, "{0}")
		EndEvent
		Event OnHighlightST()
			SetInfoText("$SLAC_Group_Max_Extras_info")
		EndEvent
	EndState
	
	; PC Group Arousal
	State groupArousalPC_ST
		Event OnSliderOpenST()
			SetSliderDialogStartValue(groupArousalPC as float)
			SetSliderDialogDefaultValue(20)
			SetSliderDialogRange(0,100)
			SetSliderDialogInterval(1.0)
		EndEvent
		Event OnSliderAcceptST(Float value)
			groupArousalPC = value as Int
			SetSliderOptionValueST(groupArousalPC, "{0}")
		EndEvent
		Event OnDefaultST()
			groupArousalPC = 20
			SetSliderOptionValueST(groupArousalPC, "{0}")
		EndEvent
		Event OnHighlightST()
			SetInfoText("$SLAC_Group_Arousal_info")
		EndEvent
	EndState
	
	; NPC Group Arousal
	State groupArousalNPC_ST
		Event OnSliderOpenST()
			SetSliderDialogStartValue(groupArousalNPC as float)
			SetSliderDialogDefaultValue(20)
			SetSliderDialogRange(0,100)
			SetSliderDialogInterval(1.0)
		EndEvent
		Event OnSliderAcceptST(Float value)
			groupArousalNPC = value as Int
			SetSliderOptionValueST(groupArousalNPC, "{0}")
		EndEvent
		Event OnDefaultST()
			groupArousalNPC = 20
			SetSliderOptionValueST(groupArousalNPC, "{0}")
		EndEvent
		Event OnHighlightST()
			SetInfoText("$SLAC_Group_Arousal_info")
		EndEvent
	EndState
	
	
	; ================= Creature Queueing =================
	
	
	; PC Queue Max Length
	State queueLengthMaxPC_ST
		Event OnSliderOpenST()
			SetSliderDialogStartValue(queueLengthMaxPC)
			SetSliderDialogDefaultValue(2)
			SetSliderDialogRange(0,5)
			SetSliderDialogInterval(1)
		EndEvent
		Event OnSliderAcceptST(Float value)
			queueLengthMaxPC = value as Int
			SetSliderOptionValueST(queueLengthMaxPC, "{0}")
			; Clear player's queue
			queueLengthMaxPC < 1 && slacUtility.ClearQueue(Game.GetPlayer())
		EndEvent
		Event OnDefaultST()
			queueLengthMaxPC = 0
			SetSliderOptionValueST(queueLengthMaxPC, "{0}")
		EndEvent
		Event OnHighlightST()
			SetInfoText("$SLAC_Max_Queued_Creatures_PC_info")
		EndEvent
	EndState
	
	; NPC Queue Max Length
	State queueLengthMaxNPC_ST
		Event OnSliderOpenST()
			SetSliderDialogStartValue(queueLengthMaxNPC)
			SetSliderDialogDefaultValue(2)
			SetSliderDialogRange(0,5)
			SetSliderDialogInterval(1)
		EndEvent
		Event OnSliderAcceptST(Float value)
			queueLengthMaxNPC = value as Int
			SetSliderOptionValueST(queueLengthMaxNPC, "{0}")
		EndEvent
		Event OnDefaultST()
			queueLengthMaxNPC = 0
			SetSliderOptionValueST(queueLengthMaxNPC, "{0}")
		EndEvent
		Event OnHighlightST()
			SetInfoText("$SLAC_Max_Queued_Creatures_NPC_info")
		EndEvent
	EndState
	
	; PC Allow Queue Leavers
	State allowQueueLeaversPC_ST
		Event OnSelectST()
			allowQueueLeaversPC = !allowQueueLeaversPC
			SetToggleOptionValueST(allowQueueLeaversPC)
		EndEvent
		Event OnHighlightST()
			SetInfoText("$SLAC_Allow_Queue_Leavers_PC_info")
		EndEvent
	EndState
	
	; NPC Allow Queue Leavers
	State allowQueueLeaversNPC_ST
		Event OnSelectST()
			allowQueueLeaversNPC = !allowQueueLeaversNPC
			SetToggleOptionValueST(allowQueueLeaversNPC)
		EndEvent
		Event OnHighlightST()
			SetInfoText("$SLAC_Allow_Queue_Leavers_NPC_info")
		EndEvent
	EndState
	
	
	; ====================== Pursuit ======================
	
	
	; PC Pursuit
	State pursuitQuestPC_ST
		Event OnSelectST()
			pursuitQuestPC = !pursuitQuestPC
			SetToggleOptionValueST(pursuitQuestPC)
		EndEvent
		Event OnHighlightST()
			SetInfoText("$SLAC_Pursuit_Quest_PC_info")
		EndEvent
	EndState
	
	; NPC Pursuit
	State pursuitQuestNPC_ST
		Event OnSelectST()
			pursuitQuestNPC = !pursuitQuestNPC
			SetToggleOptionValueST(pursuitQuestNPC)
		EndEvent
		Event OnHighlightST()
			SetInfoText("$SLAC_Pursuit_Quest_NPC_info")
		EndEvent
	EndState
	
	; PC Pursuit Max Time
	State pursuitMaxTimePC_ST
		Event OnSliderOpenST()
			SetSliderDialogStartValue(pursuitMaxTimePC)
			SetSliderDialogDefaultValue(30)
			SetSliderDialogRange(0,240)
			SetSliderDialogInterval(10.0)
		EndEvent
		Event OnSliderAcceptST(Float value)
			pursuitMaxTimePC = value as Int
			SetSliderOptionValueST(pursuitMaxTimePC, "$SLAC_Secs")
		EndEvent
		Event OnDefaultST()
			pursuitMaxTimePC = 30
			SetSliderOptionValueST(pursuitMaxTimePC, "$SLAC_Secs")
		EndEvent
		Event OnHighlightST()
			SetInfoText("$SLAC_Pursuit_Max_Time_info")
		EndEvent
	EndState
	
	; NPC Pursuit Max Time
	State pursuitMaxTimeNPC_ST
		Event OnSliderOpenST()
			SetSliderDialogStartValue(pursuitMaxTimeNPC)
			SetSliderDialogDefaultValue(30)
			SetSliderDialogRange(0,240)
			SetSliderDialogInterval(10.0)
		EndEvent
		Event OnSliderAcceptST(Float value)
			pursuitMaxTimeNPC = value as Int
			SetSliderOptionValueST(pursuitMaxTimeNPC, "$SLAC_Secs")
		EndEvent
		Event OnDefaultST()
			pursuitMaxTimeNPC = 30
			SetSliderOptionValueST(pursuitMaxTimeNPC, "$SLAC_Secs")
		EndEvent
		Event OnHighlightST()
			SetInfoText("$SLAC_Pursuit_Max_Time_info")
		EndEvent
	EndState
	
	; NPC Flees
	State pursuitNPCFlee_ST
		Event OnSelectST()
			If slac_Pursuit01Flee.GetValue() > 0
				slac_Pursuit01Flee.SetValue(0)
				SetToggleOptionValueST(False)
			Else
				slac_Pursuit01Flee.SetValue(1)
				SetToggleOptionValueST(True)
			EndIf
		EndEvent
		Event OnHighlightST()
			SetInfoText("$SLAC_NPC_Flees_info")
		EndEvent
	EndState
	
	; PC Pursuit Capture Radius
	State pursuitCaptureRadiusPC_ST
		Event OnSliderOpenST()
			SetSliderDialogStartValue(pursuitCaptureRadiusPC)
			SetSliderDialogDefaultValue(15)
			SetSliderDialogRange(10,100)
			SetSliderDialogInterval(1.0)
		EndEvent
		Event OnSliderAcceptST(Float value)
			pursuitCaptureRadiusPC = value as Int
			SetSliderOptionValueST(pursuitCaptureRadiusPC, "$SLAC_Feet")
		EndEvent
		Event OnDefaultST()
			pursuitCaptureRadiusPC = 15
			SetSliderOptionValueST(pursuitCaptureRadiusPC, "$SLAC_Feet")
		EndEvent
		Event OnHighlightST()
			SetInfoText("$SLAC_Capture_Radius_info")
		EndEvent
	EndState
	
	; NPC Pursuit Capture Radius
	State pursuitCaptureRadiusNPC_ST
		Event OnSliderOpenST()
			SetSliderDialogStartValue(pursuitCaptureRadiusNPC)
			SetSliderDialogDefaultValue(15)
			SetSliderDialogRange(10,100)
			SetSliderDialogInterval(1.0)
		EndEvent
		Event OnSliderAcceptST(Float value)
			pursuitCaptureRadiusNPC = value as Int
			SetSliderOptionValueST(pursuitCaptureRadiusNPC, "$SLAC_Feet")
		EndEvent
		Event OnDefaultST()
			pursuitCaptureRadiusNPC = 15
			SetSliderOptionValueST(pursuitCaptureRadiusNPC, "$SLAC_Feet")
		EndEvent
		Event OnHighlightST()
			SetInfoText("$SLAC_Capture_Radius_info")
		EndEvent
	EndState
	
	; PC Pursuit Escape Radius
	State pursuitEscapeRadiusPC_ST
		Event OnSliderOpenST()
			SetSliderDialogStartValue(pursuitEscapeRadiusPC)
			SetSliderDialogDefaultValue(250)
			SetSliderDialogRange(100,500)
			SetSliderDialogInterval(1.0)
		EndEvent
		Event OnSliderAcceptST(Float value)
			pursuitEscapeRadiusPC = value as Int
			SetSliderOptionValueST(pursuitEscapeRadiusPC, "$SLAC_Feet")
		EndEvent
		Event OnDefaultST()
			pursuitEscapeRadiusPC = 250
			SetSliderOptionValueST(pursuitEscapeRadiusPC, "$SLAC_Feet")
		EndEvent
		Event OnHighlightST()
			SetInfoText("$SLAC_Escape_Radius_info")
		EndEvent
	EndState
	
	; NPC Pursuit Escape Radius
	State pursuitEscapeRadiusNPC_ST
		Event OnSliderOpenST()
			SetSliderDialogStartValue(pursuitEscapeRadiusNPC)
			SetSliderDialogDefaultValue(250)
			SetSliderDialogRange(100,500)
			SetSliderDialogInterval(1.0)
		EndEvent
		Event OnSliderAcceptST(Float value)
			pursuitEscapeRadiusNPC = value as Int
			SetSliderOptionValueST(pursuitEscapeRadiusNPC, "$SLAC_Feet")
		EndEvent
		Event OnDefaultST()
			pursuitEscapeRadiusNPC = 250
			SetSliderOptionValueST(pursuitEscapeRadiusNPC, "$SLAC_Feet")
		EndEvent
		Event OnHighlightST()
			SetInfoText("$SLAC_Escape_Radius_info")
		EndEvent
	EndState
	
	
	; ====================== PC Only ======================
	
	
	; Allow Weapons for PC
	State pcAllowWeapons_ST
		Event OnSelectST()
			pcAllowWeapons = !pcAllowWeapons
			SetToggleOptionValueST(pcAllowWeapons)
		EndEvent
		Event OnHighlightST()
			SetInfoText("$SLAC_Allow_Weapons_info")
		EndEvent
	EndState
	
	
	; ===================== NPC Only ======================
	
	
	; NPC Invite Animation
	State inviteAnimationNPC_ST
		Event OnSelectST()
			If inviteAnimationNPC > 0
				inviteAnimationNPC = 0
			Else
				inviteAnimationNPC = 1
			EndIf
			SetToggleOptionValueST(inviteAnimationNPC as Bool)
		EndEvent
		Event OnDefaultST()
			inviteAnimationNPC = 1
			SetToggleOptionValueST(inviteAnimationNPC as Bool)
		EndEvent
		Event OnHighlightST()
			SetInfoText("$SLAC_Play_NPC_Invite_Animation_info")
		EndEvent
	EndState
	
	; NPC No Sleeping Actors
	State noSleepingActors_ST
		Event OnSelectST()
			noSleepingActors = !noSleepingActors
			SetToggleOptionValueST(noSleepingActors)
		EndEvent
		Event OnHighlightST()
			SetInfoText("$SLAC_Ignore_Sleeping_NPCs_info")
		EndEvent
	EndState
	
	; NPC No Elders
	State allowElders_ST
		Event OnSelectST()
			allowElders = !allowElders
			SetToggleOptionValueST(allowElders)
		EndEvent
		Event OnHighlightST()
			SetInfoText("$SLAC_Allow_Elders_info")
		EndEvent
	EndState
	
	State PCNPCSettings_ST
		
		; Toggle Option
		
		Event OnOptionSelect(Int option)
	
			; General Auto Settings
	
			If option == GetOID("pcVictimSexValue")
				pcVictimSexValue = AdvIndex(pcVictimSexValue,victimSexList, 1)
				SetTextOptionValue(option, victimSexList[pcVictimSexValue])

			ElseIf option == GetOID("npcVictimSexValue")
				npcVictimSexValue = AdvIndex(npcVictimSexValue,victimSexList, 1)
				SetTextOptionValue(option, victimSexList[npcVictimSexValue])
			
			ElseIf option == GetOID("pcCreatureSexValue")
				pcCreatureSexValue = AdvIndex(pcCreatureSexValue,creatureSexList, 0)
				SetTextOptionValue(option, creatureSexList[pcCreatureSexValue])
				
			ElseIf option == GetOID("npcCreatureSexValue")
				npcCreatureSexValue = AdvIndex(npcCreatureSexValue,creatureSexList, 0)
				SetTextOptionValue(option, creatureSexList[npcCreatureSexValue])

			ElseIf option == GetOID("AllowedSameSexPC")
				Int SSFlagsPC = (allowPCMM as Int) + ((allowPCFF as Int) * 2)
				SSFlagsPC = AdvIndex(SSFlagsPC,AllowedSameSexList,0)
				allowPCMM = Math.LogicalAnd(SSFlagsPC,1)
				allowPCFF = Math.LogicalAnd(SSFlagsPC,2)
				SetTextOptionValue(option, AllowedSameSexList[SSFlagsPC])

			ElseIf option == GetOID("AllowedSameSexNPC")
				Int SSFlagsNPC = (allowNPCMM as Int) + ((allowNPCFF as Int) * 2)
				SSFlagsNPC = AdvIndex(SSFlagsNPC,AllowedSameSexList,0)
				allowNPCMM = Math.LogicalAnd(SSFlagsNPC,1)
				allowNPCFF = Math.LogicalAnd(SSFlagsNPC,2)
				SetTextOptionValue(option, AllowedSameSexList[SSFlagsNPC])
		
			ElseIf option == GetOID("allowedNPCFollowers")
				allowedNPCFollowers = AdvIndex(allowedNPCFollowers,allowedNPCFollowersList, 0)
				SetTextOptionValue(option, allowedNPCFollowersList[allowedNPCFollowers])
				
			ElseIf option == GetOID("allowedPCCreatureFollowers")
				allowedPCCreatureFollowers = AdvIndex(allowedPCCreatureFollowers,allowedCreatureFollowersList, 0)
				SetTextOptionValue(option, allowedCreatureFollowersList[allowedPCCreatureFollowers])
				
			ElseIf option == GetOID("allowedNPCCreatureFollowers")
				allowedNPCCreatureFollowers = AdvIndex(allowedNPCCreatureFollowers,allowedCreatureFollowersList, 0)
				SetTextOptionValue(option, allowedCreatureFollowersList[allowedNPCCreatureFollowers])
				
			ElseIf option == GetOID("allowFamiliarsPC")
				allowFamiliarsPC = !allowFamiliarsPC
				SetToggleOptionValue(option, allowFamiliarsPC)
			
			ElseIf option == GetOID("allowFamiliarsNPC")
				allowFamiliarsNPC = !allowFamiliarsNPC
				SetToggleOptionValue(option, allowFamiliarsNPC)
				
			ElseIf option == GetOID("OnlyPermittedCreaturesPC")
				OnlyPermittedCreaturesPC = !OnlyPermittedCreaturesPC
				SetToggleOptionValue(option, OnlyPermittedCreaturesPC)
				
			ElseIf option == GetOID("OnlyPermittedCreaturesNPC")
				OnlyPermittedCreaturesNPC = !OnlyPermittedCreaturesNPC
				SetToggleOptionValue(option, OnlyPermittedCreaturesNPC)
				
			;ElseIf option == GetOID("cooldownNPCGlobal")
			;	cooldownNPCGlobal = !cooldownNPCGlobal
			;	SetToggleOptionValue(option, cooldownNPCGlobal)

			ElseIf option == GetOID("cooldownNPCType")
				cooldownNPCType = AdvIndex(cooldownNPCType,cooldownNPCTypeList, 0)
				SetTextOptionValue(option,cooldownNPCTypeList[cooldownNPCType])
				
			; Arousal & Consent
			
			ElseIf option == GetOID("pcRequiredArousalIndex")
				pcRequiredArousalIndex = AdvIndex(pcRequiredArousalIndex,pcRequiredArousalList, 2)
				SetTextOptionValue(option,pcRequiredArousalList[pcRequiredArousalIndex])
				
			ElseIf option == GetOID("npcRequiredArousalIndex")
				npcRequiredArousalIndex = AdvIndex(npcRequiredArousalIndex,npcRequiredArousalList, 2)
				SetTextOptionValue(option,npcRequiredArousalList[npcRequiredArousalIndex])
				
			ElseIf option == GetOID("pcConsensualIndex")
				pcConsensualIndex = AdvIndex(pcConsensualIndex,pcConsensualList, 1)
				SetTextOptionValue(option,pcConsensualList[pcConsensualIndex])
				
			ElseIf option == GetOID("npcConsensualIndex")
				npcConsensualIndex = AdvIndex(npcConsensualIndex,npcConsensualList, 1)
				SetTextOptionValue(option,npcConsensualList[npcConsensualIndex])
			
			; Armor & Clothing
			
			ElseIf option == GetOID("AllowHeavyArmorPC")
				AllowHeavyArmorPC = !AllowHeavyArmorPC
				SetToggleOptionValue(option, AllowHeavyArmorPC)
			
			ElseIf option == GetOID("AllowLightArmorPC")
				AllowLightArmorPC = !AllowLightArmorPC
				SetToggleOptionValue(option, AllowLightArmorPC)
			
			ElseIf option == GetOID("AllowClothingPC")
				AllowClothingPC = !AllowClothingPC
				SetToggleOptionValue(option, AllowClothingPC)
			
			ElseIf option == GetOID("AllowHeavyArmorNPC")
				AllowHeavyArmorNPC = !AllowHeavyArmorNPC
				SetToggleOptionValue(option, AllowHeavyArmorNPC)
			
			ElseIf option == GetOID("AllowLightArmorNPC")
				AllowLightArmorNPC = !AllowLightArmorNPC
				SetToggleOptionValue(option, AllowLightArmorNPC)
			
			ElseIf option == GetOID("AllowClothingNPC")
				AllowClothingNPC = !AllowClothingNPC
				SetToggleOptionValue(option, AllowClothingNPC)
			
			ElseIf option == GetOID("TreatCurrentArmorAsPC")
				If PCBodyArmor
					Int ArmorClassMod = slacData.GetPersistInt(PCBodyArmor,"ArmorClassOverride",4) ; No setting == default option
					ArmorClassMod = AdvIndex(ArmorClassMod,ArmorClassList, 4)
					If ArmorClassMod == 4
						slacData.ClearPersist(PCBodyArmor,"ArmorClassOverride") ; Default
					Else
						slacData.SetPersistInt(PCBodyArmor,"ArmorClassOverride",ArmorClassMod) ; Override
					EndIf
					SetTextOptionValue(option,ArmorClassList[ArmorClassMod])
				EndIf
				
			ElseIf option == GetOID("TreatCurrentArmorAsNPC") && targetactor
				If NPCBodyArmor
					Int ArmorClassMod = slacData.GetPersistInt(NPCBodyArmor,"ArmorClassOverride",4)
					ArmorClassMod = AdvIndex(ArmorClassMod,ArmorClassList, 4)
					If ArmorClassMod == 4
						slacData.ClearPersist(NPCBodyArmor,"ArmorClassOverride") ; Default
					Else
						slacData.SetPersistInt(NPCBodyArmor,"ArmorClassOverride",ArmorClassMod) ; Override
					EndIf
					SetTextOptionValue(option,ArmorClassList[ArmorClassMod])
				EndIf
			
			; Orgy Mode
			
			ElseIf option == GetOID("orgyRequiredArousalPCIndex")
				orgyRequiredArousalPCIndex = AdvIndex(orgyRequiredArousalPCIndex, pcnpcRequiredArousalList, 1)
				SetTextOptionValue(option, pcnpcRequiredArousalList[orgyRequiredArousalPCIndex])
				
			ElseIf option == GetOID("orgyRequiredArousalNPCIndex")
				orgyRequiredArousalNPCIndex = AdvIndex(orgyRequiredArousalNPCIndex, pcnpcRequiredArousalList, 1)
				SetTextOptionValue(option, pcnpcRequiredArousalList[orgyRequiredArousalNPCIndex])
				
			ElseIf option == GetOID("orgyConsentPCIndex")
				orgyConsentPCIndex = AdvIndex(orgyConsentPCIndex, pcConsensualList, 0)
				SetTextOptionValue(option, pcConsensualList[orgyConsentPCIndex])
				
			ElseIf option == GetOID("orgyConsentNPCIndex")
				orgyConsentNPCIndex = AdvIndex(orgyConsentNPCIndex, pcConsensualList, 0)
				SetTextOptionValue(option, pcConsensualList[orgyConsentNPCIndex])
			
			; Animation
			
			ElseIf option == GetOID("pursuitInviteAnimationPC")
				; Working with an Int as we might want to use this for an index in future 
				pursuitInviteAnimationPC = CondInt(pursuitInviteAnimationPC != 0, 0, 1)
				SetToggleOptionValue(option, pursuitInviteAnimationPC as Bool)
			
			; Pursuit
			
			ElseIf option == GetOID("pcAllowFemalePursuit")
				pcAllowFemalePursuit = !pcAllowFemalePursuit
				SetToggleOptionValue(option, pcAllowFemalePursuit)
			
			; Queuing
			
			ElseIf option == GetOID("consensualQueuePC")
				consensualQueuePC = AdvIndex(consensualQueuePC, consensualQueueList, 2)
				SetTextOptionValue(option, consensualQueueList[consensualQueuePC])
				
			ElseIf option == GetOID("consensualQueueNPC")
				consensualQueueNPC = AdvIndex(consensualQueueNPC, consensualQueueList, 2)
				SetTextOptionValue(option, consensualQueueList[consensualQueueNPC])
				
			ElseIf option == GetOID("queueTypePC")
				queueTypePC = AdvIndex(queueTypePC, queueTypeList, 1)
				SetTextOptionValue(option, queueTypeList[queueTypePC])
				
			ElseIf option == GetOID("queueTypeNPC")
				queueTypeNPC = AdvIndex(queueTypeNPC, queueTypeList, 1)
				SetTextOptionValue(option, queueTypeList[queueTypeNPC])
			
			; Location
			
			ElseIf option == GetOID("LocationCityAllowPC")
				LocationCityAllowPC = !LocationCityAllowPC
				SetToggleOptionValue(option, LocationCityAllowPC)
				
			ElseIf option == GetOID("LocationTownAllowPC")
				LocationTownAllowPC = !LocationTownAllowPC
				SetToggleOptionValue(option, LocationTownAllowPC)
			
			ElseIf option == GetOID("LocationDwellingAllowPC")
				LocationDwellingAllowPC = !LocationDwellingAllowPC
				SetToggleOptionValue(option, LocationDwellingAllowPC)
			
			ElseIf option == GetOID("LocationInnAllowPC")
				LocationInnAllowPC = !LocationInnAllowPC
				SetToggleOptionValue(option, LocationInnAllowPC)
			
			ElseIf option == GetOID("LocationPlayerHouseAllowPC")
				LocationPlayerHouseAllowPC = !LocationPlayerHouseAllowPC
				SetToggleOptionValue(option, LocationPlayerHouseAllowPC)
			
			ElseIf option == GetOID("LocationDungeonAllowPC")
				LocationDungeonAllowPC = !LocationDungeonAllowPC
				SetToggleOptionValue(option, LocationDungeonAllowPC)
			
			ElseIf option == GetOID("LocationDungeonClearedAllowPC")
				LocationDungeonClearedAllowPC = !LocationDungeonClearedAllowPC
				SetToggleOptionValue(option, LocationDungeonClearedAllowPC)
			
			ElseIf option == GetOID("LocationOtherAllowPC")
				LocationOtherAllowPC = !LocationOtherAllowPC
				SetToggleOptionValue(option, LocationOtherAllowPC)
			
			ElseIf option == GetOID("LocationCityAllowNPC")
				LocationCityAllowNPC = !LocationCityAllowNPC
				SetToggleOptionValue(option, LocationCityAllowNPC)
			
			ElseIf option == GetOID("LocationTownAllowNPC")
				LocationTownAllowNPC = !LocationTownAllowNPC
				SetToggleOptionValue(option, LocationTownAllowNPC)
			
			ElseIf option == GetOID("LocationDwellingAllowNPC")
				LocationDwellingAllowNPC = !LocationDwellingAllowNPC
				SetToggleOptionValue(option, LocationDwellingAllowNPC)
			
			ElseIf option == GetOID("LocationInnAllowNPC")
				LocationInnAllowNPC = !LocationInnAllowNPC
				SetToggleOptionValue(option, LocationInnAllowNPC)
			
			ElseIf option == GetOID("LocationPlayerHouseAllowNPC")
				LocationPlayerHouseAllowNPC = !LocationPlayerHouseAllowNPC
				SetToggleOptionValue(option, LocationPlayerHouseAllowNPC)
			
			ElseIf option == GetOID("LocationDungeonAllowNPC")
				LocationDungeonAllowNPC = !LocationDungeonAllowNPC
				SetToggleOptionValue(option, LocationDungeonAllowNPC)
			
			ElseIf option == GetOID("LocationDungeonClearedAllowNPC")
				LocationDungeonClearedAllowNPC = !LocationDungeonClearedAllowNPC
				SetToggleOptionValue(option, LocationDungeonClearedAllowNPC)
			
			ElseIf option == GetOID("LocationOtherAllowNPC")
				LocationOtherAllowNPC = !LocationOtherAllowNPC
				SetToggleOptionValue(option, LocationOtherAllowNPC)
			
			; PC Only
			
			ElseIf option == GetOID("OnlyPermittedNPCs")
				OnlyPermittedNPCs = !OnlyPermittedNPCs
				SetToggleOptionValue(option, OnlyPermittedNPCs)
			
			ElseIf option == GetOID("pcCrouchIndex")
				pcCrouchIndex = AdvIndex(pcCrouchIndex, pcCrouchList, 0)
				SetTextOptionValue(option, pcCrouchList[pcCrouchIndex])
			
			; Male NPCs
			
			ElseIf option == GetOID("NPCMaleRequiredArousalIndex")
				NPCMaleRequiredArousalIndex = AdvIndex(NPCMaleRequiredArousalIndex, pcnpcRequiredArousalList, 3)
				SetTextOptionValue(option, pcnpcRequiredArousalList[NPCMaleRequiredArousalIndex])
				
			ElseIf option == GetOID("NPCMaleConsensualIndex")
				NPCMaleConsensualIndex = AdvIndex(NPCMaleConsensualIndex, pcConsensualList, 1)
				SetTextOptionValue(option, pcConsensualList[NPCMaleConsensualIndex])
	
			ElseIf option == GetOID("NPCMaleQueuing")
				NPCMaleQueuing = !NPCMaleQueuing
				SetToggleOptionValue(option, NPCMaleQueuing)

			ElseIf option == GetOID("NPCMaleAllowVictim")
				NPCMaleAllowVictim = AdvIndex(NPCMaleAllowVictim, NPCMaleAllowVictimList, 3)
				SetTextOptionValue(option, NPCMaleAllowVictimList[NPCMaleAllowVictim])
	
			EndIf
		EndEvent
		
		; Slider Open
		
		Event OnOptionSliderOpen(Int option)
			If option == GetOID("cooldownPC")
				SetSliderDialogStartValue(Math.Ceiling(cooldownPC / 60))
				SetSliderDialogDefaultValue(0)
				SetSliderDialogRange(0,120)
				SetSliderDialogInterval(1.0)
				
			ElseIf option == GetOID("cooldownNPC")
				SetSliderDialogStartValue(Math.Ceiling(cooldownNPC / 60))
				SetSliderDialogDefaultValue(0)
				SetSliderDialogRange(0,120)
				SetSliderDialogInterval(1.0)
				
			ElseIf option == GetOID("CreatureNakedArousalModPC")
				SetSliderDialogStartValue(CreatureNakedArousalModPC)
				SetSliderDialogDefaultValue(100)
				SetSliderDialogRange(0,100)
				SetSliderDialogInterval(1.0)

			ElseIf option == GetOID("CreatureNakedArousalModNPC")
				SetSliderDialogStartValue(CreatureNakedArousalModNPC)
				SetSliderDialogDefaultValue(100)
				SetSliderDialogRange(0,100)
				SetSliderDialogInterval(1.0)

			ElseIf option == GetOID("NPCMaleArousalMin")
				SetSliderDialogStartValue(NPCMaleArousalMin)
				SetSliderDialogDefaultValue(60)
				SetSliderDialogRange(0,100)
				SetSliderDialogInterval(1.0)
			
			ElseIf option == GetOID("NPCMaleCreatureArousalMin")
				SetSliderDialogStartValue(NPCMaleCreatureArousalMin)
				SetSliderDialogDefaultValue(80)
				SetSliderDialogRange(0,100)
				SetSliderDialogInterval(1.0)

			EndIf
		EndEvent
		
		; Slider Accept
		
		Event OnOptionSliderAccept(Int option, Float value)
		
			If option == GetOID("cooldownPC")
				cooldownPC = Math.Ceiling(value) * 60
				SetSliderOptionValue(option, Math.Ceiling(cooldownPC / 60), "$SLAC_Mins")
				
			ElseIf option == GetOID("cooldownNPC")
				cooldownNPC = Math.Ceiling(value) * 60
				SetSliderOptionValue(option, Math.Ceiling(cooldownNPC / 60), "$SLAC_Mins")
				
			ElseIf option == GetOID("CreatureNakedArousalModPC")
				CreatureNakedArousalModPC = value as Int
				SetSliderOptionValue(option, CreatureNakedArousalModPC, "$SLAC_Percent")
				
			ElseIf option == GetOID("CreatureNakedArousalModNPC")
				CreatureNakedArousalModNPC = value as Int
				SetSliderOptionValue(option, CreatureNakedArousalModNPC, "$SLAC_Percent")

			ElseIf option == GetOID("NPCMaleArousalMin")
				NPCMaleArousalMin = value as Int
				SetSliderOptionValue(option, NPCMaleArousalMin, "{0}")
				
			ElseIf option == GetOID("NPCMaleCreatureArousalMin")
				NPCMaleCreatureArousalMin = value as Int
				SetSliderOptionValue(option, NPCMaleCreatureArousalMin, "{0}")
			
			EndIf
		EndEvent
		
		; Menu Open	

		Event OnOptionMenuOpen(Int option)
		EndEvent
		
		; Menu Accept
		
		Event OnOptionMenuAccept(Int option, Int index)
		EndEvent
		
		; Option Defaults
		
		Event OnOptionDefault(Int option)
		
			If option == GetOID("cooldownPC")
				cooldownPC = 0
				SetSliderOptionValue(option, cooldownPC, "$SLAC_Mins")
				
			ElseIf option == GetOID("cooldownNPC")
				cooldownNPC = 0
				SetSliderOptionValue(option, cooldownNPC, "$SLAC_Mins")
				
			ElseIf option == GetOID("CreatureNakedArousalModPC")
				CreatureNakedArousalModPC = 100
				SetSliderOptionValue(option, CreatureNakedArousalModPC, "$SLAC_Percent")
				
			ElseIf option == GetOID("CreatureNakedArousalModNPC")
				CreatureNakedArousalModNPC = 100
				SetSliderOptionValue(option, CreatureNakedArousalModNPC, "$SLAC_Percent")
				
			ElseIf option == GetOID("pursuitInviteAnimationPC")
				pursuitInviteAnimationPC = 1
				SetToggleOptionValue(option, pursuitInviteAnimationPC as Bool)

			ElseIf option == GetOID("NPCMaleArousalMin")
				NPCMaleArousalMin = 60
				SetSliderOptionValue(option, NPCMaleArousalMin, "{0}")
				
			ElseIf option == GetOID("NPCMaleCreatureArousalMin")
				NPCMaleCreatureArousalMin = 80
				SetSliderOptionValue(option, NPCMaleCreatureArousalMin, "{0}")
			
			EndIf
		EndEvent
		
		; Option Highlight
		
		Event OnOptionHighlight(Int option)
			
			If option == GetOID("allowFamiliarsPC") || option == GetOID("allowFamiliarsNPC")
				SetInfoText("$SLAC_Allow_Familiars_info")
				
			ElseIf option == GetOID("cooldownPC")
				SetInfoText("$SLAC_Cooldown_PC_info")
				
			ElseIf option == GetOID("cooldownNPC")
				SetInfoText("$SLAC_Cooldown_NPC_info")
			
			;ElseIf option == GetOID("cooldownNPCGlobal")
			;	SetInfoText("$SLAC_Global_NPC_Cooldown_info")
			
			ElseIf option == GetOID("cooldownNPCType")
				SetInfoText("$SLAC_Cooldown_Type_info")

			ElseIf option == GetOID("OnlyPermittedCreaturesPC") || option == GetOID("OnlyPermittedCreaturesNPC")
				SetInfoText("$SLAC_Only_Permitted_Creatures_info")

			; Sex
			
			ElseIf option == GetOID("pcVictimSexValue")
				SetInfoText("$SLAC_PC_Sex_info")
			
			ElseIf option == GetOID("npcVictimSexValue")
				SetInfoText("$SLAC_NPC_Sex_info")
			
			ElseIf option == GetOID("pcCreatureSexValue") || option == GetOID("npcCreatureSexValue")
				SetInfoText("$SLAC_Creature_Sex_info")
			
			ElseIf option == GetOID("AllowedSameSexPC") || option == GetOID("AllowedSameSexNPC")
				SetInfoText("$SLAC_Allow_Same_Sex_info")
			
			ElseIf option == GetOID("allowedNPCFollowers")
				SetInfoText("$SLAC_Allowed_NPC_Followers_info")
			
			ElseIf option == GetOID("allowedPCCreatureFollowers") || option == GetOID("allowedNPCCreatureFollowers")
				SetInfoText("$SLAC_Allowed_Creature_Followers_info")
			
			; Arousal & Consent
			
			ElseIf option == GetOID("pcRequiredArousalIndex") || option == GetOID("npcRequiredArousalIndex")
				SetInfoText("$SLAC_Required_Arousal_info")
			
			ElseIf option == GetOID("pcConsensualIndex") || option == GetOID("npcConsensualIndex")
				SetInfoText("$SLAC_Consensual_info")
			
			; Armor & Clothing
			
			ElseIf option == GetOID("AllowHeavyArmorPC") || option == GetOID("AllowHeavyArmorNPC")
				SetInfoText("$SLAC_Allow_Heavy_Armor_info")
			
			ElseIf option == GetOID("AllowLightArmorPC") || option == GetOID("AllowLightArmorNPC")
				SetInfoText("$SLAC_Allow_Light_Armor_info")
			
			ElseIf option == GetOID("AllowClothingPC") || option == GetOID("AllowClothingNPC")
				SetInfoText("$SLAC_Allow_Clothing_info")
			
			ElseIf option == GetOID("TreatCurrentArmorAsPC")
				If PCBodyArmor
					SetInfoText("$SLAC_Treat_Armor_As_info_" + PCBodyArmor.GetWeightClass())				
				Else
					SetInfoText("$SLAC_Treat_Armor_As_info_default")
				EndIf
				
			ElseIf option == GetOID("TreatCurrentArmorAsNPC")
				If NPCBodyArmor
					SetInfoText("$SLAC_Treat_Armor_As_info_" + NPCBodyArmor.GetWeightClass())				
				Else
					SetInfoText("$SLAC_Treat_Armor_As_info_default")
				EndIf
			
			ElseIf option == GetOID("CreatureNakedArousalModPC") || option == GetOID("CreatureNakedArousalModNPC")
				SetInfoText("$SLAC_Naked_Arousal_Modifier_info")

			; Orgy
			
			ElseIf option == GetOID("orgyRequiredArousalPCIndex") || option == GetOID("orgyRequiredArousalNPCIndex")
				SetInfoText("$SLAC_Required_Arousal_2_info")
					
			ElseIf option == GetOID("orgyConsentPCIndex") || option == GetOID("orgyConsentNPCIndex")
				SetInfoText("$SLAC_Consensual_info")
				
			; Pursuit
			
			ElseIf option == GetOID("pursuitInviteAnimationPC")
				SetInfoText("$SLAC_Pursuit_Invite_Animation_info")
			
			; Queuing
			
			ElseIf option == GetOID("consensualQueuePC") || option == GetOID("consensualQueueNPC")
				SetInfoText("$SLAC_Queue_Consent_info")
				
			ElseIf option == GetOID("queueTypePC") || option == GetOID("queueTypeNPC")
				SetInfoText("$SLAC_Queue_Type_info")
			
			; Location
			
			ElseIf option == GetOID("LocationCityAllowPC") || option == GetOID("LocationCityAllowNPC")
				SetInfoText("$SLAC_Location_Allow_City_info")
				
			ElseIf option == GetOID("LocationTownAllowPC") || option == GetOID("LocationTownAllowNPC")
				SetInfoText("$SLAC_Location_Allow_Town_info")
			
			ElseIf option == GetOID("LocationDwellingAllowPC") || option == GetOID("LocationDwellingAllowNPC")
				SetInfoText("$SLAC_Location_Allow_Dwelling_info")
			
			ElseIf option == GetOID("LocationInnAllowPC") || option == GetOID("LocationInnAllowNPC")
				SetInfoText("$SLAC_Location_Allow_Inn_info")
			
			ElseIf option == GetOID("LocationPlayerHouseAllowPC") || option == GetOID("LocationPlayerHouseAllowNPC")
				SetInfoText("$SLAC_Location_Allow_Player_House_info")
			
			ElseIf option == GetOID("LocationDungeonAllowPC") || option == GetOID("LocationDungeonAllowNPC")
				SetInfoText("$SLAC_Location_Allow_Dungeon_info")
			
			ElseIf option == GetOID("LocationDungeonClearedAllowPC") || option == GetOID("LocationDungeonClearedAllowNPC")
				SetInfoText("$SLAC_Location_Allow_Dungeon_Cleared_info")
			
			ElseIf option == GetOID("LocationOtherAllowPC") || option == GetOID("LocationOtherAllowNPC")
				SetInfoText("$SLAC_Location_Allow_Other_info")
			
			; PC Only
			
			ElseIf option == GetOID("OnlyPermittedNPCs")
				SetInfoText("$SLAC_Only_Permitted_NPCs_info")
			
			ElseIf option == GetOID("pcCrouchIndex")
				SetInfoText("$SLAC_PC_Crouch_info")
			
			; NPCs Only
			
			ElseIf option == GetOID("pcAllowFemalePursuit")
				SetInfoText("$SLAC_Allow_Female_Pursuit_info")
			
			; Male NPCs
			
			ElseIf option == GetOID("NPCMaleArousalMin")
				SetInfoText("$SLAC_Arousal_Threshold_info")
				
			ElseIf option == GetOID("NPCMaleCreatureArousalMin")
				SetInfoText("$SLAC_Creature_Arousal_info")
				
			ElseIf option == GetOID("NPCMaleRequiredArousalIndex")
				SetInfoText("$SLAC_Required_Arousal_3_info")
			
			ElseIf option == GetOID("NPCMaleConsensualIndex")
				SetInfoText("$SLAC_Consensual_info")
			
			ElseIf option == GetOID("NPCMaleQueuing")
				SetInfoText("$SLAC_Male_Queuing_info")
			
			ElseIf option == GetOID("NPCMaleAllowVictim")
				SetInfoText("$SLAC_Male_NPCs_Pursued_By_info")
				
			EndIf
		EndEvent
				
	EndState
	
; ===================================
; =                                 =
; =     Dialogue & Interactions     =
; =                                 =
; ===================================


	; ===================== Invitation ====================
	
	
	; Invite Target Key 
	State inviteTargetKey_ST
		Event OnKeyMapChangeST(int keyCode, string conflictControl, string conflictName)
			If keyCode == 1
				inviteTargetKey = -1
			ElseIf conflictControl == "" || ShowMessage("Key already mapped to:\n" + conflictControl + "\n\nUse this key anyway?", true, "Use", "Cancel")
				inviteTargetKey = keyCode
			EndIf
			SetKeyMapOptionValueST(inviteTargetKey)
		EndEvent
		Event OnDefaultST()
			inviteTargetKey = -1
			SetKeyMapOptionValueST(inviteTargetKey)
		EndEvent
		Event OnHighlightST()
			SetInfotext("$SLAC_Invite_Target_Select_Key_info")
		EndEvent
	EndState
	
	; Invite Arousal Min
	State inviteArousalMin_ST
		Event OnSliderOpenST()
			SetSliderDialogStartValue(inviteArousalMin as float)
			SetSliderDialogDefaultValue(40)
			SetSliderDialogRange(0,100)
			SetSliderDialogInterval(1.0)
		EndEvent
		Event OnSliderAcceptST(Float value)
			inviteArousalMin = value as Int
			SetSliderOptionValueST(inviteArousalMin, "{0}")
		EndEvent
		Event OnDefaultST()
			inviteArousalMin = 10
			SetSliderOptionValueST(inviteArousalMin, "{0}")
		EndEvent
		Event OnHighlightST()
			SetInfoText("$SLAC_Invite_Arousal_info")
		EndEvent
	EndState
	
	; Play Invite Animation
	; This may converted to an animation duration slider in future, hence an Int instead of a Bool
	State inviteAnimationPC_ST
		Event OnSelectST()
			If inviteAnimationPC > 0
				inviteAnimationPC = 0
			Else
				inviteAnimationPC = 1
			EndIf
			SetToggleOptionValueST(inviteAnimationPC as Bool)
		EndEvent
		Event OnDefaultST()
			inviteAnimationPC = 1
			SetToggleOptionValueST(inviteAnimationPC as Bool)
		EndEvent
		Event OnHighlightST()
			SetInfoText("$SLAC_Play_PC_Invite_Animation_info")
		EndEvent
	EndState
	
	
	; ================== Player Struggle ==================
	
	
	; Struggle Enable
	State struggleEnabled_ST
		Event OnSelectST()
			struggleEnabled = !struggleEnabled
			SetToggleOptionValueST(struggleEnabled)
		EndEvent
		Event OnHighlightST()
			SetInfoText("$SLAC_Enable_Player_Struggle_info")
		EndEvent
	EndState
	
	; Struggle Key One
	State struggleKeyOne_ST
		Event OnKeyMapChangeST(int keyCode, string conflictControl, string conflictName)
			If keyCode == 1
				struggleKeyOne = -1
			ElseIf conflictControl == "" || ShowMessage("Key already mapped to:\n" + conflictControl + "\n\nUse this key anyway?", true, "Use", "Cancel")
				struggleKeyOne = keyCode
			EndIf
			SetKeyMapOptionValueST(struggleKeyOne)
		EndEvent
		Event OnDefaultST()
			struggleKeyOne = 30
			SetKeyMapOptionValueST(struggleKeyOne)
		EndEvent
		Event OnHighlightST()
			SetInfoText("$SLAC_Struggle_Key_info")
		EndEvent
	EndState
	
	; Struggle Key Two
	State struggleKeyTwo_ST
		Event OnKeyMapChangeST(int keyCode, string conflictControl, string conflictName)
			If keyCode == 1
				struggleKeyTwo = -1
			ElseIf conflictControl == "" || ShowMessage("Key already mapped to:\n" + conflictControl + "\n\nUse this key anyway?", true, "Use", "Cancel")
				struggleKeyTwo = keyCode
			EndIf
			SetKeyMapOptionValueST(struggleKeyTwo)
		EndEvent
		Event OnDefaultST()
			struggleKeyTwo = 32
			SetKeyMapOptionValueST(struggleKeyTwo)
		EndEvent
		Event OnHighlightST()
			SetInfoText("$SLAC_Struggle_Key_info")
		EndEvent
	EndState
	
	; Struggle Stamina Damage
	State struggleStaminaDamage_ST
		Event OnSliderOpenST()
			SetSliderDialogStartValue(struggleStaminaDamage)
			SetSliderDialogDefaultValue(4)
			SetSliderDialogRange(0,100)
			SetSliderDialogInterval(1.0)
		EndEvent
		Event OnSliderAcceptST(Float value)
			struggleStaminaDamage = value as Float
			SetSliderOptionValueST(struggleStaminaDamage, "{0}")
		EndEvent
		Event OnDefaultST()
			struggleStaminaDamage = 4.0
			SetSliderOptionValueST(struggleStaminaDamage, "{0}")
		EndEvent
		Event OnHighlightST()
			SetInfoText("$SLAC_Stamina_Damage_Value_info")
		EndEvent
	EndState
	
	; Struggle Stamina Damage Multiplier 
	State struggleStaminaDamageMultiplier_ST
		Event OnSliderOpenST()
			SetSliderDialogStartValue(struggleStaminaDamageMultiplier)
			SetSliderDialogDefaultValue(1.0)
			SetSliderDialogRange(0.1,4.0)
			SetSliderDialogInterval(0.1)
		EndEvent
		Event OnSliderAcceptST(Float value)
			struggleStaminaDamageMultiplier = value as Float
			SetSliderOptionValueST(struggleStaminaDamageMultiplier, "{0}")
		EndEvent
		Event OnDefaultST()
			struggleStaminaDamageMultiplier = 1.0
			SetSliderOptionValueST(struggleStaminaDamageMultiplier, "{0}")
		EndEvent
		Event OnHighlightST()
			SetInfoText("$SLAC_Stamina_Damage_Multiplier_info")
		EndEvent
	EndState
	
	; Struggle Timing One 
	State struggleTimingOne_ST
		Event OnSliderOpenST()
			If struggleTimingTwo <= struggleTimingOne
				struggleTimingOne = struggleTimingTwo - 0.1
			EndIf
			SetSliderDialogStartValue(struggleTimingOne)
			SetSliderDialogRange(0.0,struggleTimingTwo)
			SetSliderDialogInterval(0.1)
			SetSliderDialogDefaultValue(0.0)
		EndEvent
		Event OnSliderAcceptST(Float value)
			struggleTimingOne = value as Float
			If struggleTimingOne >= struggleTimingTwo
				struggleTimingOne = struggleTimingTwo - 0.1
			EndIf
			SetSliderOptionValueST(struggleTimingOne, "$SLAC_Secs_Float")
		EndEvent
		Event OnDefaultST()
			struggleTimingOne = 0.0
			SetSliderOptionValueST(struggleTimingOne, "$SLAC_Secs_Float")
		EndEvent
		Event OnHighlightST()
			SetInfoText("$SLAC_Struggle_Timing_info")
		EndEvent
	EndState
	
	; Struggle Timing Two 
	State struggleTimingTwo_ST
		Event OnSliderOpenST()
			If struggleTimingOne <= struggleTimingTwo
				struggleTimingTwo = struggleTimingOne + 0.1
			EndIf
			SetSliderDialogStartValue(struggleTimingTwo)
			SetSliderDialogDefaultValue(5.0)
			SetSliderDialogRange(struggleTimingOne,5.1)
			SetSliderDialogInterval(0.1)
		EndEvent
		Event OnSliderAcceptST(Float value)
			struggleTimingTwo = value as Float
			If struggleTimingTwo <= struggleTimingOne
				struggleTimingTwo = struggleTimingOne + 0.1
			EndIf
			SetSliderOptionValueST(struggleTimingTwo, "$SLAC_Secs_Float")
		EndEvent
		Event OnDefaultST()
			struggleTimingTwo = 5.0
			SetSliderOptionValueST(struggleTimingTwo, "$SLAC_Secs_Float")
		EndEvent
		Event OnHighlightST()
			SetInfoText("$SLAC_Struggle_Timing_info")
		EndEvent
	EndState
	
	; Struggle Failure Enabled
	State struggleFailureEnabled_ST
		Event OnSelectST()
			struggleFailureEnabled = !struggleFailureEnabled
			SetToggleOptionValueST(struggleFailureEnabled)
		EndEvent
		Event OnHighlightST()
			SetInfoText("$SLAC_Enable_Failure_info")
		EndEvent
	EndState
	
	; Struggle Exhaustion Duration
	State struggleExhaustionDuration_ST
		Event OnSliderOpenST()
			SetSliderDialogStartValue(slacUtility.slac_StaminaDrainSpell.GetNthEffectDuration(0))
			SetSliderDialogDefaultValue(60)
			SetSliderDialogRange(5,300)
			SetSliderDialogInterval(5)
		EndEvent
		Event OnSliderAcceptST(Float value)
			slacUtility.slac_StaminaDrainSpell.SetNthEffectDuration(0,value as Int)
			SetSliderOptionValueST(value as Int, "$SLAC_Secs")
		EndEvent
		Event OnDefaultST()
			slacUtility.slac_StaminaDrainSpell.SetNthEffectDuration(0,60)
			SetSliderOptionValueST(60, "$SLAC_Secs")
		EndEvent
		Event OnHighlightST()
			SetInfoText("$SLAC_Exhaustion_Duration_info")
		EndEvent
	EndState
	
	State struggleQueueEscape_ST
		Event OnSelectST()
			struggleQueueEscape = !struggleQueueEscape
			SetToggleOptionValueST(struggleQueueEscape)
		EndEvent
		Event OnHighlightST()
			SetInfoText("$SLAC_Struggle_Queue_Escape_info")
		EndEvent
	EndState
	
	
	; ================== Actor Selection ==================
	
	
	; Struggle Key One
	State targetKey_ST
		Event OnKeyMapChangeST(Int keyCode, String conflictControl, String conflictName)
			If keyCode == 1
				targetKey = -1
			ElseIf conflictControl == "" || ShowMessage("Key already mapped to:\n" + conflictControl + "\n\nUse this key anyway?", true, "Use", "Cancel")
				targetKey = keyCode
			EndIf
			SetKeyMapOptionValueST(targetKey)
		EndEvent
		Event OnDefaultST()
			targetKey = 49 ; [N]
			SetKeyMapOptionValueST(targetKey)
		EndEvent
		Event OnHighlightST()
			SetInfoText("$SLAC_Target_Select_Key_info")
		EndEvent
	EndState
	
	
	; ================== Follower Commands ================
	
	
	; Follower Dialogue Enable
	State followerDialogueEnabled_ST
		Event OnSelectST()
			followerDialogueEnabled = !followerDialogueEnabled
			SetToggleOptionValueST(followerDialogueEnabled)
		EndEvent
		Event OnHighlightST()
			SetInfoText("$SLAC_Enable_Follower_Commands_info")
		EndEvent
	EndState
	
	; Non-Follower Dialogue Enable
	State nonFollowerDialogueEnabled_ST
		Event OnSelectST()
			nonFollowerDialogueEnabled = !nonFollowerDialogueEnabled
			SetToggleOptionValueST(nonFollowerDialogueEnabled)
		EndEvent
		Event OnHighlightST()
			SetInfoText("$SLAC_Enable_Non_Follower_Commands_info")
		EndEvent
	EndState
	
	; Follower Command Threshold
	State followerCommandThreshold_ST
		Event OnSliderOpenST()
			SetSliderDialogStartValue(followerCommandThreshold)
			SetSliderDialogDefaultValue(50)
			SetSliderDialogRange(0,100)
			SetSliderDialogInterval(1.0)
		EndEvent
		Event OnSliderAcceptST(Float value)
			followerCommandThreshold = value as Int
			SetSliderOptionValueST(followerCommandThreshold, "{0}")
		EndEvent
		Event OnDefaultST()
			followerCommandThreshold = 50
			SetSliderOptionValueST(followerCommandThreshold, "{0}")
		EndEvent
		Event OnHighlightST()
			SetInfoText("$SLAC_Follower_Threshold_info")
		EndEvent
	EndState
	
	; Creature Command Threshold
	State creatureCommandThreshold_ST
		Event OnSliderOpenST()
			SetSliderDialogStartValue(creatureCommandThreshold)
			SetSliderDialogDefaultValue(40)
			SetSliderDialogRange(0,100)
			SetSliderDialogInterval(1.0)
		EndEvent
		Event OnSliderAcceptST(Float value)
			creatureCommandThreshold = value as Int
			SetSliderOptionValueST(creatureCommandThreshold, "{0}")
		EndEvent
		Event OnDefaultST()
			creatureCommandThreshold = 40
			SetSliderOptionValueST(creatureCommandThreshold, "{0}")
		EndEvent
		Event OnHighlightST()
			SetInfoText("$SLAC_Creature_Threshold_info")
		EndEvent
	EndState
	
	
	; ================== Creature Commands ================
	
	
	; Creature Dialogue Enabled (Followers / Player Horse)
	State creatureDialogueEnabled_ST
		Event OnSelectST()
			creatureDialogueEnabled = !creatureDialogueEnabled
			SetToggleOptionValueST(creatureDialogueEnabled)
			If !creatureDialogueEnabled
				creatureDialogueAllowSilent = False
				creatureDialogueAllowHorses = False
				creatureDialogueAllowSteal = False
				inviteOpensCreatureDialogue = False
				inviteOpensHorseDialogue = False
			EndIf
			ForcePageReset()
		EndEvent
		Event OnHighlightST()
			SetInfoText("$SLAC_Enable_Creature_Commands_info")
		EndEvent
	EndState
	
	; All Creature Dialogue Enabled
	State allCreatureDialogueEnabled_ST
		Event OnSelectST()
			allCreatureDialogueEnabled = !allCreatureDialogueEnabled
			SetToggleOptionValueST(allCreatureDialogueEnabled)
		EndEvent
		Event OnHighlightST()
			SetInfoText("$SLAC_Enable_Creature_Commands_All_info")
		EndEvent
	EndState
	
	; Silent Creature Dialogue Enabled
	State creatureDialogueAllowSilent_ST
		Event OnSelectST()
			creatureDialogueAllowSilent = !creatureDialogueAllowSilent
			SetToggleOptionValueST(creatureDialogueAllowSilent)
			If !creatureDialogueAllowSilent
				creatureDialogueAllowHorses = False
				inviteOpensHorseDialogue = False
			EndIf
			ForcePageReset()
		EndEvent
		Event OnHighlightST()
			SetInfoText("$SLAC_Allow_Silent_Creature_Dialogue_info")
		EndEvent
	EndState
	
	; Horse Dialogue Allow
	State creatureDialogueAllowHorses_ST
		Event OnSelectST()
			creatureDialogueAllowHorses = !creatureDialogueAllowHorses
			SetToggleOptionValueST(creatureDialogueAllowHorses)
			If !creatureDialogueAllowHorses
				inviteOpensHorseDialogue = False
			EndIf
			ForcePageReset()
		EndEvent
		Event OnHighlightST()
			SetInfoText("$SLAC_Allow_Dialogue_With_Horses_info")
		EndEvent
	EndState
	
	; Horse Theft Through Dialogue Allow
	State creatureDialogueAllowSteal_ST
		Event OnSelectST()
			creatureDialogueAllowSteal = !creatureDialogueAllowSteal
			SetToggleOptionValueST(creatureDialogueAllowSteal)
		EndEvent
		Event OnHighlightST()
			SetInfoText("$SLAC_Allow_Dialogue_Horse_Theft_info")
		EndEvent
	EndState
	
	
	; ==================== Player Horse ===================
	
	State dialogueAndInteractions_ST
	
		Event OnOptionSelect(Int option)
		
			; Invite
			
			If option == GetOID("inviteConsentPCIndex")
				inviteConsentPCIndex = AdvIndex(inviteConsentPCIndex, pcConsensualList, 2)
				SetTextOptionValue(option, pcConsensualList[inviteConsentPCIndex])
				
			ElseIf option == GetOID("inviteOpensHorseDialogue")
				inviteOpensHorseDialogue = !inviteOpensHorseDialogue
				SetToggleOptionValue(option, inviteOpensHorseDialogue)
				
			ElseIf option == GetOID("inviteOpensCreatureDialogue")
				inviteOpensCreatureDialogue = !inviteOpensCreatureDialogue
				SetToggleOptionValue(option, inviteOpensCreatureDialogue)
			
			ElseIf option == GetOID("inviteCreatureSex")
				inviteCreatureSex = AdvIndex(inviteCreatureSex, creatureSexList, 2)
				SetTextOptionValue(option, creatureSexList[inviteCreatureSex])
				
			; Suitors
			
			ElseIf option == GetOID("suitorsPCAllowWeapons")
				suitorsPCAllowWeapons = !suitorsPCAllowWeapons
				SetToggleOptionValue(option, suitorsPCAllowWeapons)
				
			ElseIf option == GetOID("suitorsPCAllowLeave")
				suitorsPCAllowLeave = !suitorsPCAllowLeave
				SetToggleOptionValue(option, suitorsPCAllowLeave)
				
			ElseIf option == GetOID("suitorsPCAllowFollowers")
				suitorsPCAllowFollowers = !suitorsPCAllowFollowers
				SetToggleOptionValue(option, suitorsPCAllowFollowers)
				
			ElseIf option == GetOID("suitorsPCCrouchEffect")
				suitorsPCCrouchEffect = AdvIndex(suitorsPCCrouchEffect, suitorsPCCrouchEffectList, 0)
				SetTextOptionValue(option, suitorsPCCrouchEffectList[suitorsPCCrouchEffect])
				
			ElseIf option == GetOID("suitorsPCOnlyNaked")
				suitorsPCOnlyNaked = !suitorsPCOnlyNaked
				SetToggleOptionValue(option, suitorsPCOnlyNaked)
				
			; Struggle
			
			ElseIf option == GetOID("struggleMeterHidden")
				struggleMeterHidden = !struggleMeterHidden
				SetToggleOptionValue(option, struggleMeterHidden)

			ElseIf option == GetOID("struggleExhaustionMode")
				struggleExhaustionMode = AdvIndex(struggleExhaustionMode, struggleExhaustionModeList, 1)
				SetTextOptionValue(option, struggleExhaustionModeList[struggleExhaustionMode])
		
			; Follower Dialogue
			
			ElseIf option == GetOID("followerDialogueGenderIndex")
				followerDialogueGenderIndex = AdvIndex(followerDialogueGenderIndex, victimSexList, 1)
				SetTextOptionValue(option, victimSexList[followerDialogueGenderIndex])
			
			; Creature Dialogue
			
			ElseIf option == GetOID("creatureDialogueSex")
				creatureDialogueSex = AdvIndex(creatureDialogueSex, CreatureSexList, 2)
				SetTextOptionValue(option, creatureSexList[creatureDialogueSex])
			
			; Horse Refusal
			
			ElseIf option == GetOID("horseRefusalPCMounting")
				horseRefusalPCMounting = !horseRefusalPCMounting
				SetToggleOptionValue(option, horseRefusalPCMounting)
				
			ElseIf option == GetOID("horseRefusalPCRiding")
				horseRefusalPCRiding = !horseRefusalPCRiding
				SetToggleOptionValue(option, horseRefusalPCRiding)
			
			ElseIf option == GetOID("horseRefusalPCSex")
				horseRefusalPCSex = AdvIndex(horseRefusalPCSex, CreatureSexList, 0)
				SetTextOptionValue(option, CreatureSexList[horseRefusalPCSex])
				
			ElseIf option == GetOID("horseRefusalPCEngage")
				horseRefusalPCEngage = !horseRefusalPCEngage
				SetToggleOptionValue(option, horseRefusalPCEngage)
				
			EndIf
		EndEvent
		
		Event OnOptionSliderOpen(Int option)
		
			; Suitors
			
			If option == GetOID("inviteStripDelayPC")
				SetSliderDialogStartValue(inviteStripDelayPC)
				SetSliderDialogDefaultValue(3)
				SetSliderDialogRange(0,10)
				SetSliderDialogInterval(1.0)
				
			ElseIf option == GetOID("widgetXPositionNPC")
				SetSliderDialogStartValue(widgetXPositionNPC)
				SetSliderDialogDefaultValue(925)
				SetSliderDialogRange(0,1250)
				SetSliderDialogInterval(5.0)
			
			ElseIf option == GetOID("widgetYPositionNPC")
				SetSliderDialogStartValue(widgetYPositionNPC)
				SetSliderDialogDefaultValue(655)
				SetSliderDialogRange(0,700)
				SetSliderDialogInterval(5.0)
			
			ElseIf option == GetOID("suitorsMaxPC")
				SetSliderDialogStartValue(suitorsMaxPC)
				SetSliderDialogDefaultValue(0)
				SetSliderDialogRange(0,5)
				SetSliderDialogInterval(1.0)
				
			ElseIf option == GetOID("suitorsPCArousalMin")
				SetSliderDialogStartValue(suitorsPCArousalMin)
				SetSliderDialogDefaultValue(60)
				SetSliderDialogRange(0,100)
				SetSliderDialogInterval(1.0)
				
			; Horse Refusal
			
			ElseIf option == GetOID("horseRefusalPCThreshold")
				SetSliderDialogStartValue(horseRefusalPCThreshold)
				SetSliderDialogDefaultValue(50)
				SetSliderDialogRange(0,100)
				SetSliderDialogInterval(1.0)
				
			EndIf
		EndEvent
		
		Event OnOptionSliderAccept(Int option, Float value)
			
			; Suitors
			
			If option == GetOID("inviteStripDelayPC")
				inviteStripDelayPC = value as Int
				SetSliderOptionValue(option, inviteStripDelayPC, "$SLAC_Secs")
				
			ElseIf option == GetOID("widgetXPositionNPC")
				widgetXPositionNPC = value
				SetSliderOptionValue(option, widgetXPositionNPC)
			
			ElseIf option == GetOID("widgetYPositionNPC")
				widgetYPositionNPC = value
				SetSliderOptionValue(option, widgetYPositionNPC)
			
			ElseIf option == GetOID("suitorsMaxPC")
				suitorsMaxPC = value as Int
				SetSliderOptionValue(option, suitorsMaxPC, "{0}")
			
			ElseIf option == GetOID("suitorsPCArousalMin")
				suitorsPCArousalMin = value as Int
				SetSliderOptionValue(option, suitorsPCArousalMin, "{0}")
				
			; Horse Refusal
			
			ElseIf option == GetOID("horseRefusalPCThreshold")
				horseRefusalPCThreshold = value as Int
				SetSliderOptionValue(option, horseRefusalPCThreshold, "{0}")
				
			EndIf
		EndEvent
		
		
		Event OnOptionMenuOpen(Int option)
		EndEvent
		
		
		Event OnOptionMenuAccept(Int option, Int index)
		EndEvent
		
		
		Event OnOptionDefault(Int option)
		
			; Invite 
			
			If option == GetOID("inviteStripDelayPC")
				inviteStripDelayPC = 3
				SetSliderOptionValue(option, inviteStripDelayPC, "$SLAC_Secs")
			
			; Suitors
			
			ElseIf option == GetOID("suitorsMaxPC")
				suitorsMaxPC = 0
				SetSliderOptionValue(option, suitorsMaxPC, "{0}")
				
			ElseIf option == GetOID("suitorsPCArousalMin")
				suitorsPCArousalMin = 60
				SetSliderOptionValue(option, suitorsPCArousalMin, "{0}")
			
			; Horse Refusal
			
			ElseIf option == GetOID("horseRefusalPCThreshold")
				horseRefusalPCThreshold = 50
				SetSliderOptionValue(option, horseRefusalPCThreshold, "{0}")
				
			EndIf
		EndEvent
		
		Event OnOptionHighlight(Int option)
			
			; Invite
			
			If option == GetOID("inviteConsentPCIndex")
				SetInfoText("$SLAC_Invite_Consent_info")
	
			ElseIf option == GetOID("inviteStripDelayPC")
				SetInfoText("$SLAC_Invite_Strip_Delay_info")
				
			ElseIf option == GetOID("inviteOpensHorseDialogue")
				SetInfoText("$SLAC_Invite_Opens_Horse_Dialogue_info")
				
			ElseIf option == GetOID("inviteOpensCreatureDialogue")
				SetInfoText("$SLAC_Invite_Opens_Creature_Dialogue_info")
				
			ElseIf option == GetOID("inviteCreatureSex")
				SetInfoText("$SLAC_Invite_Creature_Sex_info")
			
			; Struggle
			
			ElseIf option == GetOID("struggleExhaustionMode")
				SetInfoText("$SLAC_Exhaustion_Mode_info")
			
			ElseIf option == GetOID("struggleMeterHidden")
				SetInfoText("$SLAC_Hide_Struggle_Meter_info")
		
			ElseIf option == GetOID("widgetXPositionNPC")
				SetInfoText("$SLAC_Stamina_Widget_X_info")
			
			ElseIf option == GetOID("widgetYPositionNPC")
				SetInfoText("$SLAC_Stamina_Widget_Y_info")
			
			; Follower Dialogue
			
			ElseIf option == GetOID("followerDialogueGenderIndex")
				SetInfoText("$SLAC_Follower_Dialogue_Gender_Info")
			
			; Creature Dialogue
			
			ElseIf option == GetOID("creatureDialogueSex")
				SetInfoText("$SLAC_Creature_Dialogue_Sex_info")
			
			; Suitors
			
			ElseIf option == GetOID("suitorsMaxPC")
				SetInfoText("$SLAC_Max_Player_Suitors_info")
				
			ElseIf option == GetOID("suitorsPCArousalMin")
				SetInfoText("$SLAC_Suitors_PC_Required_Arousal_info")
			
			ElseIf option == GetOID("suitorsPCAllowWeapons")
				SetInfoText("$SLAC_Allow_Weapons_Suitors_info")

			ElseIf option == GetOID("suitorsPCAllowLeave")
				SetInfoText("$SLAC_Allow_Suitors_to_Leave_info")
				
			ElseIf option == GetOID("suitorsPCAllowFollowers")
				SetInfoText("$SLAC_Allow_Follower_Suitors_Info")
				
			ElseIf option == GetOID("suitorsPCCrouchEffect")
				SetInfoText("$SLAC_Suitor_Crouch_Effect_info")
				
			ElseIf option == GetOID("suitorsPCOnlyNaked")
				SetInfoText("$SLAC_Only_When_Naked_info")
				
			; Horse Refusal
			
			ElseIf option == GetOID("horseRefusalPCMounting")
				SetInfoText("$SLAC_Horse_Refusal_Mounting_info")
				
			ElseIf option == GetOID("horseRefusalPCRiding")
				SetInfoText("$SLAC_Horse_Refusal_Riding_info")
				
			ElseIf option == GetOID("horseRefusalPCThreshold")
				SetInfoText("$SLAC_Horse_Refusal_Threshold_info")
				
			ElseIf option == GetOID("horseRefusalPCSex")
				SetInfoText("$SLAC_Horse_Refusal_Sex_info")
			
			ElseIf option == GetOID("horseRefusalPCEngage")
				SetInfoText("$SLAC_Sex_After_Refusal_info")
				
			EndIf
		EndEvent
	EndState
	
	
	
; ===================================
; =                                 =
; =        Allowed Creatures        =
; =                                 =
; ===================================

	; Allowed Creatures Next Page
	State allowedTogglesPage_ST
		Event OnSelectST()
			allowedTogglesPage += 1
			If allowedTogglesPage > totalAllowedTogglesPages || allowedTogglesPage < 1
				allowedTogglesPage = 1
			EndIf
			ForcePageReset()
		EndEvent
		Event OnDefaultST()
			allowedTogglesPage = 1
			ForcePageReset()
		EndEvent
		Event OnHighlightST()
			SetInfoText("")
		EndEvent
	EndState

	; Allowed Creatures List Toggles
	State allowedCreaturesToggle_ST
	
		Event OnOptionSelect(Int option)
			Int allowedPCIndex = allowedRacesPCOID.Find(option)
			Int allowedNPCIndex = allowedRacesNPCOID.Find(option)
			Bool shiftHeld = Input.IsKeyPressed(KeyLShift)
			Bool ctrlHeld = Input.IsKeyPressed(KeyLCtrl)
			
			SLACMCMUpdateRaceKeys = True

			If option == GetOID("allowedSync")
				allowedSync = !allowedSync
				ForcePageReset()
				
			ElseIf option == GetOID("allowedAllPC")
				; Allow all races for both male and female PC
				If ShowMessage("$SLAC_Allow_All_PC_msg", True)
					; Normal
					SetTextOptionValue(option,"$SLAC_Working_Ellipsis",OPTION_FLAG_DISABLED)
					If !ctrlHeld ; Ctrl Allow Male PC onlu
						disallowedRaceKeyFPCList = PapyrusUtil.StringArray(0)
					EndIf
					If !shiftHeld ; Shift Allow Female PC only
						disallowedRaceKeyMPCList = PapyrusUtil.StringArray(0)
					EndIf
					ForcePageReset()
				EndIf
				
			ElseIf option == GetOID("allowedAllNPC")
				; Allow all races for male and female NPCs
				If ShowMessage("$SLAC_Allow_All_NPC_msg", True)
					SetTextOptionValue(option,"$SLAC_Working_Ellipsis",OPTION_FLAG_DISABLED)
					If !ctrlHeld ; Ctrl Allow Male NPC only
						disallowedRaceKeyFNPCList = PapyrusUtil.StringArray(0)
					EndIf
					If !shiftHeld ; Shift Allow Female NPC only
						disallowedRaceKeyMNPCList = PapyrusUtil.StringArray(0)
					EndIf
					ForcePageReset()
				EndIf
				
			ElseIf option == GetOID("allowedNonePC")
				; Disallow all races for male and female PC
				If ShowMessage("$SLAC_Allow_None_PC_msg", True)
					SetTextOptionValue(option,"$SLAC_Working_Ellipsis",OPTION_FLAG_DISABLED)
					If !ctrlHeld ; Ctrl Disallow Male NPC only
						disallowedRaceKeyFPCList = raceKeyList
					EndIf
					If !shiftHeld ; Shift Disallow Female NPC only
						disallowedRaceKeyMPCList = raceKeyList
					EndIf
					ForcePageReset()
				EndIf
			
			ElseIf option == GetOID("allowedNoneNPC")
				; Disallow all races for male and female NPCs
				If ShowMessage("$SLAC_Allow_None_NPC_msg", True)
					SetTextOptionValue(option,"$SLAC_Working_Ellipsis",OPTION_FLAG_DISABLED)
					If !ctrlHeld ; Ctrl Disallow Male NPC only
						disallowedRaceKeyFNPCList = raceKeyList
					EndIf
					If !shiftHeld ; Shift Disallow Female NPC only
						disallowedRaceKeyMNPCList = raceKeyList
					EndIf
					ForcePageReset()
				EndIf
			
			; PC Race Switches
			
			ElseIf allowedPCIndex > -1
				; Calculate race key index position
				allowedPCIndex += (60 * allowedTogglesPage)
				
				; Calculate current option
				Int current = 0
				If disallowedRaceKeyFPCList.Find(raceKeyList[allowedPCIndex]) < 0
					current += 1 ; Allow Female
				EndIf
				If disallowedRaceKeyMPCList.Find(raceKeyList[allowedPCIndex]) < 0
					current += 2 ; Allow Male
				EndIf
				
				; Advance option
				If Input.IsKeyPressed(KeyLShift)
					; Shift toggle allow / disallow
					current = CondInt(current == 3,0,3)
				Else
					; Increment option
					current += 1
				EndIf
				Int next = CondInt(current > 3,0,current)

				; Apply new option
				If next == 0
					; Allow None
					disallowedRaceKeyFPCList = PapyrusUtil.RemoveString(disallowedRaceKeyFPCList, raceKeyList[allowedPCIndex])
					disallowedRaceKeyMPCList = PapyrusUtil.RemoveString(disallowedRaceKeyMPCList, raceKeyList[allowedPCIndex])
				EndIf
				If Math.LogicalAnd(next,1)
					; Allow Female PC
					disallowedRaceKeyFPCList = PapyrusUtil.RemoveString(disallowedRaceKeyFPCList, raceKeyList[allowedPCIndex])
				Else
					; Disallow Female PC
					disallowedRaceKeyFPCList = PapyrusUtil.PushString(disallowedRaceKeyFPCList, raceKeyList[allowedPCIndex])
				EndIf
				If Math.LogicalAnd(next,2)
					; Allow Male PC
					disallowedRaceKeyMPCList = PapyrusUtil.RemoveString(disallowedRaceKeyMPCList, raceKeyList[allowedPCIndex])
				Else
					; Disallow Male PC
					disallowedRaceKeyMPCList = PapyrusUtil.PushString(disallowedRaceKeyMPCList, raceKeyList[allowedPCIndex])
				EndIf
				
				SetTextOptionValue(option,allowedOptionsList[next])
				
			; NPC Race Switches
				
			ElseIf allowedNPCIndex > -1
				; Calculate race key index position
				allowedNPCIndex += (60 * allowedTogglesPage)
				
				; Calculate current option
				Int current = 0
				If disallowedRaceKeyFNPCList.Find(raceKeyList[allowedNPCIndex]) < 0
					current += 1 ; Allow Female
				EndIf
				If disallowedRaceKeyMNPCList.Find(raceKeyList[allowedNPCIndex]) < 0
					current += 2 ; Allow Male
				EndIf
				
				; Advance option
				If Input.IsKeyPressed(KeyLShift)
					; Shift toggle allow / disallow
					current = CondInt(current == 3,0,3)
				Else
					; Increment option
					current += 1
				EndIf
				Int next = CondInt(current > 3,0,current)

				; Apply new option
				If next == 0
					; Allow None
					disallowedRaceKeyFNPCList = PapyrusUtil.RemoveString(disallowedRaceKeyFNPCList, raceKeyList[allowedNPCIndex])
					disallowedRaceKeyMNPCList = PapyrusUtil.RemoveString(disallowedRaceKeyMNPCList, raceKeyList[allowedNPCIndex])
				EndIf
				If Math.LogicalAnd(next,1)
					; Allow Female NPC
					disallowedRaceKeyFNPCList = PapyrusUtil.RemoveString(disallowedRaceKeyFNPCList, raceKeyList[allowedNPCIndex])
				Else
					; Disallow Female NPC
					disallowedRaceKeyFNPCList = PapyrusUtil.PushString(disallowedRaceKeyFNPCList, raceKeyList[allowedNPCIndex])
				EndIf
				If Math.LogicalAnd(next,2)
					; Allow Male NPC
					disallowedRaceKeyMNPCList = PapyrusUtil.RemoveString(disallowedRaceKeyMNPCList, raceKeyList[allowedNPCIndex])
				Else
					; Disallow Male NPC
					disallowedRaceKeyMNPCList = PapyrusUtil.PushString(disallowedRaceKeyMNPCList, raceKeyList[allowedNPCIndex])
				EndIf
				
				SetTextOptionValue(option,allowedOptionsList[next])
			EndIf
			
		EndEvent
		
		Event OnOptionHighlight(Int option)
			
			If option == GetOID("allowedSync")
				SetInfoText("$SLAC_Use_PC_Settings_For_NPCs_info")
				
			ElseIf option == GetOID("allowedAllPC")
				SetInfoText("$SLAC_Allow_All_PC_info")
				
			ElseIf option == GetOID("allowedAllNPC")
				SetInfoText("$SLAC_Allow_All_NPC_info")
				
			ElseIf option == GetOID("allowedNonePC")
				SetInfoText("$SLAC_Allow_None_PC_info")
				
			ElseIf option == GetOID("allowedNoneNPC")
				SetInfoText("$SLAC_Allow_None_NPC_info")
			
			ElseIf allowedRacesPCOID.Find(option) > -1 || allowedRacesNPCOID.Find(option) > -1
				SetInfoText("$SLAC_Allowed_info")
				
			EndIf
				
		EndEvent
	EndState

; ===================================
; =                                 =
; =  Aggressive Animations Toggles	=
; =                                 =
; ===================================


	; Aggressive Toggles Home Page
	State togglesPageHome_ST
		Event OnSelectST()
			If togglesPage > 0
				togglesPage = 0
			Else
				togglesPage = 1
			EndIf
			SetOptionFlagsST(OPTION_FLAG_DISABLED)
			SetTextOptionValueST("$SLAC_Working_Ellipsis")
			ForcePageReset()
		EndEvent
		Event OnHighlightST()
			If togglesPage != 0
				SetInfoText("$SLAC_Return_to_First_Page_info")
			Else
				SetInfoText("$SLAC_Go_to_Animation_List_info")
			EndIF
		EndEvent
	EndState
	

	; Recent Aggressive Animation Toggles
	State AggressiveTogglesHome_ST
	
		Event OnOptionSelect(Int option)
			If option == GetOID("aggressiveTogglesShowRecent")
				; Show slow recent animations list (this is a one-way operation until the MCM is closed)
				aggressiveTogglesShowRecent = True
				SetTextOptionValue(option, "$SLAC_Working_Ellipsis")
				SetOptionFlags(option, OPTION_FLAG_DISABLED)
				ForcePageReset()

			ElseIf togglesRecentPCOID.Find(option) > -1
				If UsingSLPP()
					ShowMessage("$SLAC_SLPP_Aggressive_Toggles_Not_Available_msg", False)
					Return
				EndIf

				; Toggle recent PC animation
				Int index = togglesRecentPCOID.Find(option)
				
				; Match NPC toggle if applicable
				Int npcindex = togglesRecentNPCAnim.Find(togglesRecentPCAnim[index])
				
				If togglesRecentPCAnim[index]
					; Disable options
					SetTextOptionValue(option, "$SLAC_Working_Ellipsis")
					SetOptionFlags(option, OPTION_FLAG_DISABLED)
					If npcindex > -1
						SetTextOptionValue(togglesRecentNPCOID[npcindex], "$SLAC_Working_Ellipsis")
						SetOptionFlags(togglesRecentNPCOID[npcindex], OPTION_FLAG_DISABLED)
					EndIf

					;sslBaseAnimation anim = SexLab.GetCreatureAnimationByName(togglesRecentPCAnim[index])
					sslBaseAnimation anim = SexLab.GetCreatureAnimationByRegistry(togglesRecentPCAnim[index])
					If anim != none
						; PC toggle
						If ToggleAggressiveTag(anim)
							; Aggressive
							SetTextOptionValue(option, "$SLAC_Aggressive_Color")
							npcindex > -1 && SetTextOptionValue(togglesRecentNPCOID[npcindex], "$SLAC_Aggressive_Color")
						Else
							; Consensual
							SetTextOptionValue(option, "$SLAC_Consensual_Color")
							npcindex > -1 && SetTextOptionValue(togglesRecentNPCOID[npcindex], "$SLAC_Consensual_Color")
						EndIf
						SexLab.AnimSlots.InvalidateByAnimation(anim)
					Else
						; Error
						SetTextOptionValue(option, "$SLAC_Error")
						npcindex > -1 && SetTextOptionValue(togglesRecentNPCOID[npcindex], "$SLAC_Error")
					EndIf
					; Enable options
					SetOptionFlags(option, OPTION_FLAG_NONE)
					npcindex > -1 && SetOptionFlags(togglesRecentNPCOID[npcindex], OPTION_FLAG_NONE)
				EndIf
				
			ElseIf togglesRecentNPCOID.Find(option) > -1
				If UsingSLPP()
					ShowMessage("$SLAC_SLPP_Aggressive_Toggles_Not_Available_msg", False)
					Return
				EndIf

				; Toggle recent NPC animation
				Int index = togglesRecentNPCOID.Find(option)

				; Match NPC toggle if applicable
				Int pcindex = togglesRecentPCAnim.Find(togglesRecentNPCAnim[index])
				
				If togglesRecentNPCAnim[index]
					; Disable options
					SetTextOptionValue(option, "$SLAC_Working_Ellipsis")
					SetOptionFlags(option, OPTION_FLAG_DISABLED)
					If pcindex > -1
						SetTextOptionValue(togglesRecentNPCOID[pcindex], "$SLAC_Working_Ellipsis")
						SetOptionFlags(togglesRecentNPCOID[pcindex], OPTION_FLAG_DISABLED)
					EndIf

					;sslBaseAnimation anim = SexLab.GetCreatureAnimationByName(togglesRecentNPCAnim[index])
					sslBaseAnimation anim = SexLab.GetCreatureAnimationByRegistry(togglesRecentNPCAnim[index])
					If anim != none
						; NPC toggle
						If ToggleAggressiveTag(anim)
							; Aggressive
							SetTextOptionValue(option, "$SLAC_Aggressive_Color")
							pcindex > -1 && SetTextOptionValue(togglesRecentPCOID[pcindex], "$SLAC_Aggressive_Color")
						Else
							; Consensual
							SetTextOptionValue(option, "$SLAC_Consensual_Color")
							pcindex > -1 && SetTextOptionValue(togglesRecentPCOID[pcindex], "$SLAC_Consensual_Color")
						EndIf
						SexLab.AnimSlots.InvalidateByAnimation(anim)
					Else
						; Error
						SetTextOptionValue(option, "$SLAC_Error")
						pcindex > -1 && SetTextOptionValue(togglesRecentNPCOID[pcindex], "$SLAC_Error")
					EndIf
					; Enable options
					SetOptionFlags(option, OPTION_FLAG_NONE)
					pcindex > -1 && SetOptionFlags(togglesRecentNPCOID[pcindex], OPTION_FLAG_NONE)
				EndIf
				
			EndIf
		EndEvent
		
		
		Event OnOptionSliderOpen(Int option)
			If option == GetOID("animationsPerPage")
				SetSliderDialogStartValue(animationsPerPage)
				SetSliderDialogDefaultValue(80)
				SetSliderDialogRange(20,116)
				SetSliderDialogInterval(2.0)
			EndIf
		EndEvent
		
		
		Event OnOptionSliderAccept(Int option, Float value)
			If option == GetOID("animationsPerPage")
				animationsPerPage = value as Int
				SetSliderOptionValue(option, animationsPerPage)
			EndIf
		EndEvent
		
		
		Event OnOptionHighlight(Int option)
			If option == GetOID("AggressiveSLPPNote")
				SetInfoText("$SLAC_SLPP_Aggressive_Toggles_Not_Available_info")
				
			ElseIf option == GetOID("aggressiveTogglesShowRecent")
				SetInfoText("$SLAC_Display_Recent_Animations_info")
			
			ElseIf option == GetOID("animationsPerPage")
				SetInfoText("$SLAC_Animations_Per_Page_info")
			
			ElseIf togglesRecentPCOID.Find(option) > -1
				SetInfoText(togglesRecentPCAnim[togglesRecentPCOID.Find(option)] + "\nTags: " + GetAllTagsRegsitry(togglesRecentPCAnim[togglesRecentPCOID.Find(option)]))
			
			ElseIf togglesRecentNPCOID.Find(option) > -1
				SetInfoText(togglesRecentNPCAnim[togglesRecentNPCOID.Find(option)] + "\nTags: " + GetAllTagsRegsitry(togglesRecentNPCAnim[togglesRecentNPCOID.Find(option)]))
			
			EndIf
		EndEvent
	EndState

	; Aggressive Toggles List
	State AggressiveTogglesList_ST
	
		Event OnOptionSelect(Int option)
		
			If option == GetOID("aggressiveTogglesPagePrev")
				; Aggressive toggles go to previous page
				togglesPage -= 1
				If togglesPage < 1 || togglesPage > totalTogglesPages
					togglesPage = totalTogglesPages
				EndIf
				SetOptionFlags(option, OPTION_FLAG_DISABLED)
				SetTextOptionValue(option, "$SLAC_Working_Ellipsis")
				ForcePageReset()
				
			ElseIf option == GetOID("aggressiveTogglesPageNext")
				togglesPage += 1
				If togglesPage > totalTogglesPages || togglesPage < 0
					togglesPage = 1
				EndIf
				SetOptionFlags(option, OPTION_FLAG_DISABLED)
				SetTextOptionValue(option, "$SLAC_Working_Ellipsis")
				ForcePageReset()
				
			ElseIf option == GetOID("aggressiveTogglesTagsNegate")
				aggressiveTogglesTagsNegate = !aggressiveTogglesTagsNegate
				SetTextOptionValue(option, CondString(!aggressiveTogglesTagsNegate, "$SLAC_Has_Tags", "$SLAC_Does_Not_Have_Tags"))
				If aggressiveTogglesTags != ""
					; Indicate delay in refreshing page
					SetTextOptionValue(GetOID("addAggressiveTag"), "$SLAC_Please_Wait_Ellipsis")
					SetTextOptionValue(GetOID("removeAggressiveTag"), "$SLAC_Please_Wait_Ellipsis")
					SetTextOptionValue(GetOID("defaultAggressiveTag"), "$SLAC_Please_Wait_Ellipsis")
					ForcePageReset()
				EndIf
				
			ElseIf option == GetOID("addAggressiveTag") || option == GetOID("removeAggressiveTag") || option == GetOID("defaultAggressiveTag")
				If UsingSLPP()
					ShowMessage("$SLAC_SLPP_Aggressive_Toggles_Not_Available_msg", False)
					Return
				EndIf
				
				Bool setAggressive = option == GetOID("addAggressiveTag")
				Bool setDefaults = option == GetOID("defaultAggressiveTag")

				; Warning message
				If (aggressiveTogglesRaceKey != "$SLAC_All" || aggressiveTogglesTags != "" || setDefaults) && ShowMessage(CondString(setAggressive,"$SLAC_Animations_to_Aggressive_msg","$SLAC_Animations_to_Consensual_msg"), true, "$SLAC_Accept", "$SLAC_Cancel")
					
					; Indicate process status and disable options
					SetOptionFlags(GetOID("addAggressiveTag"), OPTION_FLAG_DISABLED)
					SetTextOptionValue(GetOID("addAggressiveTag"), "$SLAC_Working_Ellipsis")
					SetOptionFlags(GetOID("removeAggressiveTag"), OPTION_FLAG_DISABLED)
					SetTextOptionValue(GetOID("removeAggressiveTag"), "$SLAC_Working_Ellipsis")
					SetOptionFlags(GetOID("defaultAggressiveTag"), OPTION_FLAG_DISABLED)
					SetTextOptionValue(GetOID("defaultAggressiveTag"), "$SLAC_Working_Ellipsis")
					
					; Clear caches to ensure changes will take effect
					SexLab.AnimSlots.ClearAnimCache()
						
					; Add Aggressive tag to all filtered animations
					sslBaseAnimation[] filteredAnims
					
					; Iterate through animation tag filters by actor count
					; We need to repeat the process from the OnPageReset event as the previously compiled 
					; creatureAnimations array may be truncated due to pagination
					Int addCount = 0
					Int p = 2
					While p <= 5
						; Filter animations on Race and/or Tag
						If aggressiveTogglesRaceKey != "$SLAC_All" && aggressiveTogglesTags != ""
							; Race and tags
							filteredAnims = SexLab.GetCreatureAnimationsByRaceKeyTags(p, aggressiveTogglesRaceKey, Tags = CondString(!aggressiveTogglesTagsNegate,aggressiveTogglesTags), TagSuppress = CondString(aggressiveTogglesTagsNegate,aggressiveTogglesTags))
						
						ElseIf aggressiveTogglesRaceKey != "$SLAC_All"
							; Race
							filteredAnims = SexLab.GetCreatureAnimationsByRaceKey(p, aggressiveTogglesRaceKey)
						
						ElseIf aggressiveTogglesTags != ""
							; Tags
							filteredAnims = SexLab.GetCreatureAnimationsByTags(p, Tags = CondString(!aggressiveTogglesTagsNegate,aggressiveTogglesTags), TagSuppress = CondString(aggressiveTogglesTagsNegate,aggressiveTogglesTags))
							
						ElseIf setDefaults
							; If there are no filters then get all Aggressive || DefaultAggressive tagged anims
							filteredAnims = SexLab.GetCreatureAnimationsByTags(ActorCount = p, Tags = "Aggressive", TagSuppress = "AggressiveDefault", RequireAll = False)
							; MergeAnimationLists has proven unreliable
							; filteredAnims = SexLab.MergeAnimationLists(filteredAnims, SexLab.GetCreatureAnimationsByTags(ActorCount = p, Tags = "AggressiveDefault", TagSuppress = "Aggressive", RequireAll = False))
							sslBaseAnimation[] tempAnims = SexLab.GetCreatureAnimationsByTags(ActorCount = p, Tags = "AggressiveDefault", TagSuppress = "Aggressive", RequireAll = False)
							Int i = 0
							While i < tempAnims.Length
								filteredAnims = sslUtility.PushAnimation(tempAnims[i], filteredAnims)
								i += 1
							EndWhile

						EndIf

						debugSLAC && Log("Found " + filteredAnims.Length + " " + p + "p animations to tag as " + CondString(setAggressive,"Aggressive","Consensual") + ". Race: " + CondString(aggressiveTogglesRaceKey == "$SLAC_All", "All", aggressiveTogglesRaceKey) + " Tags: " + aggressiveTogglesTags)
						
						; Add/Remove Aggressive tags for each anim
						String report = ""
						Int i = 0
						While i < filteredAnims.Length
							report = "Filtered Animation: " + filteredAnims[i].Name
							If setDefaults
								If filteredAnims[i].HasTag("AggressiveDefault")
									filteredAnims[i].AddTag("Aggressive")
									report += " Default: Aggressive"
								Else
									filteredAnims[i].RemoveTag("Aggressive")
									report += " Default: Consensual"
								EndIf
							ElseIf setAggressive
								filteredAnims[i].AddTag("Aggressive")
								report += " Adding: Aggressive"
							Else
								filteredAnims[i].RemoveTag("Aggressive")
								report += " Removing: Aggressive"
							EndIf
							addCount += 1
							Log(report)
							i += 1
						EndWhile
						
						p += 1
					EndWhile
					
					; Indicate delay in refreshing page
					SetTextOptionValue(GetOID("addAggressiveTag"), "$SLAC_Please_Wait_Ellipsis")
					SetTextOptionValue(GetOID("removeAggressiveTag"), "$SLAC_Please_Wait_Ellipsis")
					SetTextOptionValue(GetOID("defaultAggressiveTag"), "$SLAC_Please_Wait_Ellipsis")

					; Report result counts
					If setDefaults
						ShowMessage(addCount + " animations restored to default Aggressive/Consensual tags.\nIt may take some time for the page to update.", false)
					Else
						ShowMessage(addCount + " animations updated to " + CondString(setAggressive,"Aggressive","Consensual") + ".\nIt may take some time for the page to update.", false)
					EndIf
					
					; Update animations listed on the current page
					ForcePageReset()
				EndIf
			
			ElseIf aggressiveTogglesOID.Find(option) > -1
				If UsingSLPP()
					ShowMessage("$SLAC_SLPP_Aggressive_Toggles_Not_Available_msg", False)
					Return
				EndIf
				
				Int animIndex = aggressiveTogglesOID.Find(option)
				; Disable option
				SetTextOptionValue(option, "$SLAC_Working_Ellipsis")
				SetOptionFlags(option, OPTION_FLAG_DISABLED)

				; Toggle animation Aggressive tag
				;Log("animIndex " + animIndex + " option " + option,false,false,true)

				If creatureAnimations[animIndex]
					; Add/remove Aggressive tag and switch toggle
					SetTextOptionValue(option, CondString(ToggleAggressiveTag(creatureAnimations[animIndex]), "$SLAC_Aggressive_Color", "$SLAC_Consensual_Color"))
					SexLab.AnimSlots.InvalidateByAnimation(creatureAnimations[animIndex])
				Else
					; Error
					SetTextOptionValue(option, "$SLAC_Error")
				EndIf
				; Enable option
				SetOptionFlags(option, OPTION_FLAG_NONE)
				
			EndIf
		EndEvent
		
		Event OnOptionMenuOpen(Int option)
			If option == GetOID("aggressiveTogglesRaceKey")
				SetMenuDialogOptions(aggressiveTogglesRaceKeyOptions)
				SetMenuDialogStartIndex(aggressiveTogglesRaceKeyOptions.find(aggressiveTogglesRaceKey)) 
				SetMenuDialogDefaultIndex(0)
			EndIf
			
		EndEvent
		
		Event OnOptionMenuAccept(Int option, Int index)
			If option == GetOID("aggressiveTogglesRaceKey")
				If index >= aggressiveTogglesRaceKeyOptions.Length
					index = 0
				EndIf
				aggressiveTogglesRaceKey = aggressiveTogglesRaceKeyOptions[index]
				SetOptionFlags(option, OPTION_FLAG_DISABLED)
				SetMenuOptionValue(option, "$SLAC_Working_Ellipsis")
				ForcePageReset()
			EndIf
			
		EndEvent
		
		Event OnOptionInputOpen(Int option)
			If option == GetOID("aggressiveTogglesTags")
				SetInputDialogStartText(aggressiveTogglesTags)
			EndIf
			
		EndEvent
		
		Event OnOptionInputAccept(Int option, String inputString)
			If option == GetOID("aggressiveTogglesTags")
				aggressiveTogglesTags = inputString
				SetOptionFlags(option, OPTION_FLAG_DISABLED)
				SetInputOptionValue(option, "$SLAC_Working_Ellipsis")
				ForcePageReset()
			EndIf
			
		EndEvent
		
		Event OnOptionHighlight(Int option)
			Int index = aggressiveTogglesOID.Find(option)
			If option == GetOID("aggressiveTogglesPagePrev")
				SetInfoText("$SLAC_Previous_Page_Aggressive_Toggles_info")
				
			ElseIf option == GetOID("aggressiveTogglesPageNext")
				SetInfoText("$SLAC_Next_Page_Aggressive_Toggles_info")
				
			ElseIf option == GetOID("aggressiveTogglesTags")
				SetInfoText("$SLAC_Filter_By_Tags_info")
				
			ElseIf option == GetOID("aggressiveTogglesRaceKey")
				SetInfoText("$SLAC_Filter_By_Race_info")
				
			ElseIf option == GetOID("aggressiveTogglesTagsNegate")
				SetInfoText("$SLAC_Negate_Tags_info")
				
			ElseIf option == GetOID("addAggressiveTag")
				SetInfoText("$SLAC_Tag_Current_Animations_As_Aggressive_info")
				
			ElseIf option == GetOID("removeAggressiveTag")
				SetInfoText("$SLAC_Tag_Current_Animations_As_Consensual_info")
				
			ElseIf index > -1
				If UsingSLPP()
					; SexLab P+
					SetInfoText(creatureAnimations[index].Name + "\nTags: " + GetAllTagsRegsitry(creatureAnimations[index].GetSceneID()))
				Else 
					; SexLab
					SetInfoText(creatureAnimations[index].Name + "\nTags: " + GetAllTagsRegsitry(creatureAnimations[index].Registry))
				EndIf
			EndIf
			
		EndEvent
	EndState
	
	
; ===================================
; =                                 =
; =         Other Settings          =
; =                                 =
; ===================================


	State slacOtherSettings_ST
	
		Event OnOptionSelect(Int option)
			; Animation Selection
			
			If option == GetOID("TransMFTreatAsPC")
				Int val = TransMFTreatAsPC
				val = CondInt(val >= TransTreatAsList.Length - 1,0,val + 1)
				TransMFTreatAsPC = val
				SetTextOptionValue(option,TransTreatAsList[val])

			ElseIf option == GetOID("TransFMTreatAsPC")
				Int val = TransFMTreatAsPC
				val = CondInt(val >= TransTreatAsList.Length - 1,0,val + 1)
				TransFMTreatAsPC = val
				SetTextOptionValue(option,TransTreatAsList[val])

			ElseIf option == GetOID("TransMFTreatAsNPC")
				Int val = TransMFTreatAsNPC
				val = CondInt(val >= TransTreatAsList.Length - 1,0,val + 1)
				TransMFTreatAsNPC = val
				SetTextOptionValue(option,TransTreatAsList[val])

			ElseIf option == GetOID("TransFMTreatAsNPC")
				Int val = TransFMTreatAsNPC
				val = CondInt(val >= TransTreatAsList.Length - 1,0,val + 1)
				TransFMTreatAsNPC = val
				SetTextOptionValue(option,TransTreatAsList[val])

			ElseIf option == GetOID("restrictAggressivePC")
				restrictAggressivePC = !restrictAggressivePC
				SetToggleOptionValue(option, restrictAggressivePC)
				
			ElseIf option == GetOID("restrictAggressiveNPC")
				restrictAggressiveNPC = !restrictAggressiveNPC
				SetToggleOptionValue(option, restrictAggressiveNPC)
			
			ElseIf option == GetOID("restrictConsensualPC")
				restrictConsensualPC = !restrictConsensualPC
				SetToggleOptionValue(option, restrictConsensualPC)
			
			ElseIf option == GetOID("restrictConsensualNPC")
				restrictConsensualNPC = !restrictConsensualNPC
				SetToggleOptionValue(option, restrictConsensualNPC)
			
			ElseIf option == GetOID("FemalePCRoleWithMaleCreature")
				Int val = FemalePCRoleWithMaleCreature
				val = CondInt(val >= ActorPositionSexList.Length - 1,0,val + 1)
				FemalePCRoleWithMaleCreature = val
				SetTextOptionValue(option,ActorPositionSexList[val])

			ElseIf option == GetOID("FemalePCRoleWithFemaleCreature")
				Int val = FemalePCRoleWithFemaleCreature
				val = CondInt(val >= ActorPositionSexList.Length - 1,0,val + 1)
				FemalePCRoleWithFemaleCreature = val
				SetTextOptionValue(option,ActorPositionSexList[val])

			ElseIf option == GetOID("MalePCRoleWithMaleCreature")
				Int val = MalePCRoleWithMaleCreature
				val = CondInt(val >= ActorPositionSexList.Length - 1,0,val + 1)
				MalePCRoleWithMaleCreature = val
				SetTextOptionValue(option,ActorPositionSexList[val])

			ElseIf option == GetOID("MalePCRoleWithFemaleCreature")
				Int val = MalePCRoleWithFemaleCreature
				val = CondInt(val >= ActorPositionSexList.Length - 1,0,val + 1)
				MalePCRoleWithFemaleCreature = val
				SetTextOptionValue(option,ActorPositionSexList[val])

			ElseIf option == GetOID("FemaleNPCRoleWithMaleCreature")
				Int val = FemaleNPCRoleWithMaleCreature
				val = CondInt(val >= ActorPositionSexList.Length - 1,0,val + 1)
				FemaleNPCRoleWithMaleCreature = val
				SetTextOptionValue(option,ActorPositionSexList[val])

			ElseIf option == GetOID("FemaleNPCRoleWithFemaleCreature")
				Int val = FemaleNPCRoleWithFemaleCreature
				val = CondInt(val >= ActorPositionSexList.Length - 1,0,val + 1)
				FemaleNPCRoleWithFemaleCreature = val
				SetTextOptionValue(option,ActorPositionSexList[val])

			ElseIf option == GetOID("MaleNPCRoleWithMaleCreature")
				Int val = MaleNPCRoleWithMaleCreature
				val = CondInt(val >= ActorPositionSexList.Length - 1,0,val + 1)
				MaleNPCRoleWithMaleCreature = val
				SetTextOptionValue(option,ActorPositionSexList[val])

			ElseIf option == GetOID("MaleNPCRoleWithFemaleCreature")
				Int val = MaleNPCRoleWithFemaleCreature
				val = CondInt(val >= ActorPositionSexList.Length - 1,0,val + 1)
				MaleNPCRoleWithFemaleCreature = val
				SetTextOptionValue(option,ActorPositionSexList[val])
			
			ElseIf option == GetOID("NonConsensualIsAlwaysMFPC")
				NonConsensualIsAlwaysMFPC = !NonConsensualIsAlwaysMFPC
				SetToggleOptionValue(option,NonConsensualIsAlwaysMFPC)
				
			ElseIf option == GetOID("NonConsensualIsAlwaysMFNPC")
				NonConsensualIsAlwaysMFNPC = !NonConsensualIsAlwaysMFNPC
				SetToggleOptionValue(option,NonConsensualIsAlwaysMFNPC)
				
			; Compatibility
				
			ElseIf option == GetOID("submit")
				submit = !submit
				SetToggleOptionValue(option, submit)
				
			ElseIf option == GetOID("defeat")
				defeat = !defeat
				SetToggleOptionValue(option, defeat)
				
			ElseIf option == GetOID("deviouslyHelpless")
				deviouslyHelpless = !deviouslyHelpless
				SetToggleOptionValue(option, deviouslyHelpless)
				
			ElseIf option == GetOID("DisplayModelBlockAuto")
				DisplayModelBlockAuto = !DisplayModelBlockAuto
				SetToggleOptionValue(option, DisplayModelBlockAuto)
				
			ElseIf option == GetOID("DeviousDevicesFilter")
				DeviousDevicesFilter = !DeviousDevicesFilter
				SetToggleOptionValue(option, DeviousDevicesFilter)

			ElseIf option == GetOID("NakedDefeatFilter")
				NakedDefeatFilter = !NakedDefeatFilter
				SetToggleOptionValue(option, NakedDefeatFilter)

			ElseIf option == GetOID("ToysFilter")
				ToysFilter = !ToysFilter
				SetToggleOptionValue(option, ToysFilter)
				
			ElseIf option == GetOID("DHLPBlockAuto")
				DHLPBlockAuto = !DHLPBlockAuto
				SetToggleOptionValue(option, DHLPBlockAuto)
				
			ElseIf option == GetOID("DCURBlockAuto")
				DCURBlockAuto = !DCURBlockAuto
				SetToggleOptionValue(option, DCURBlockAuto)
				
			ElseIf option == GetOID("convenientHorses")
				convenientHorses = !convenientHorses
				SetToggleOptionValue(option, convenientHorses)
				
			ElseIf option == GetOID("SexLabPPlusMode")
				SexLabPPlusMode = !SexLabPPlusMode
				SetToggleOptionValue(option, SexLabPPlusMode)
				
			ElseIf option == GetOID("softDependanciesTest")
				softDependanciesTest = !softDependanciesTest
				SetTextOptionValue(option, CondString(softDependanciesTest,"$SLAC_Exit_Menu","$SLAC_Click_to_Check"))
			
			; Fixes
			
			ElseIf option == GetOID("allowInScene")
				allowInScene = !allowInScene
				SetToggleOptionValue(option, allowInScene)
				
			ElseIf option == GetOID("currentPCSceneQuest")
				; Collect scene info
				Scene currentScene
				If !TargetActor
					currentScene = Game.GetPlayer().GetCurrentScene()
				Else
					currentScene = TargetActor.GetCurrentScene()
				EndIf
				If currentScene
					Quest currentQuest = currentScene.GetOwningQuest()
					If currentQuest
						String actorname = CondString(TargetActor, slacUtility.GetActorNameRef(TargetActor), slacUtility.GetActorNameRef(Game.GetPlayer()))
						String questformid = StringUtil.SubString(currentQuest, (StringUtil.GetLength(currentQuest) - 11), 8)
						String lopos = StringUtil.SubString(questformid, 0, 2)
						Int decpos = Math.RightShift(currentQuest.GetFormID(),24)
						String modname = Game.GetModName(decpos)
						ShowMessage("Actor: " + actorname + "\nQuest: " + currentQuest.GetID() + "\nScene Playing: " + currentScene.IsPlaying() + "\nForm ID: " + questformid + "\nMod: " + modname + "\nLoad Order Position Hex: " + lopos + "\nLoad Order Position Dec: " + decpos, False)
					EndIf
				EndIf
			
			ElseIf option == GetOID("claimActiveActors")
				claimActiveActors = !claimActiveActors
				SetToggleOptionValue(option, claimActiveActors)
				
			ElseIf option == GetOID("claimQueuedActors")
				claimQueuedActors = !claimQueuedActors
				SetToggleOptionValue(option, claimQueuedActors)
				
			ElseIf option == GetOID("releaseClaimedActors")
				SetTextOptionValue(option, "$SLAC_Working_Ellipsis")
				If Input.IsKeyPressed(KeyLShift)
					slacUtility.DumpAllClaimedActors()
				Else
					Int releaseCount = slacUtility.ReleaseAllClaimedActors()
					ShowMessage(releaseCount + " actors release from SLAC claim scene.", False)
				EndIf
				SetTextOptionValue(option, "$SLAC_Remove")

			ElseIf option == GetOID("allowHostileEngagements")
				If allowHostileEngagements || ShowMessage("$SLAC_Allow_Hostile_Engagements_msg", true, "$SLAC_Yes", "$SLAC_No")
					allowHostileEngagements = !allowHostileEngagements
					SetToggleOptionValue(option, allowHostileEngagements)
				EndIf
				
			ElseIf option == GetOID("allowCombatEngagements")
				If allowCombatEngagements || ShowMessage("$SLAC_Allow_Combat_Engagements_msg", true, "$SLAC_Yes", "$SLAC_No")
					allowCombatEngagements = !allowCombatEngagements
					SetToggleOptionValue(option, allowCombatEngagements)
					slac_AllowCombatEngagements.SetValue(allowCombatEngagements as Int)
				EndIf
				
			ElseIf option == GetOID("allowDialogueAutoEngage")
				allowDialogueAutoEngage = !allowDialogueAutoEngage
				SetToggleOptionValue(option, allowDialogueAutoEngage)
				
			ElseIf option == GetOID("allowMenuAutoEngage")
				allowMenuAutoEngage = !allowMenuAutoEngage
				SetToggleOptionValue(option, allowMenuAutoEngage)

			ElseIf option == GetOID("ClearStoredData")
				If ShowMessage("$SLAC_Clear_Stored_Data_confirm", True, "$SLAC_Accept", "$SLAC_Cancel")
					SetTextOptionValue(option, "$SLAC_Working_Ellipsis")
					StorageUtil.ClearAllPrefix("SLArousedCreatures.")
					SetTextOptionValue(option, "$SLAC_Clear")
				EndIf

			ElseIf option == GetOID("disallowMagicInfluenceCharm")
				disallowMagicInfluenceCharm = !disallowMagicInfluenceCharm
				SetToggleOptionValue(option, disallowMagicInfluenceCharm)
			
			ElseIf option == GetOID("disallowMagicAllegianceFaction")
				disallowMagicAllegianceFaction = !disallowMagicAllegianceFaction
				SetToggleOptionValue(option, disallowMagicAllegianceFaction)
			
			ElseIf option == GetOID("disallowMagicCharmFaction")
				disallowMagicCharmFaction = !disallowMagicCharmFaction
				SetToggleOptionValue(option, disallowMagicCharmFaction)
			
			ElseIf option == GetOID("weaponsPreventAutoEngagement")
				weaponsPreventAutoEngagement = !weaponsPreventAutoEngagement
				SetToggleOptionValue(option, weaponsPreventAutoEngagement)
			
			ElseIf option == GetOID("useVRCompatibility")
				useVRCompatibility = !useVRCompatibility
				SetToggleOptionValue(option, useVRCompatibility)

			ElseIf option == GetOID("suppressVersionWarning")
				suppressVersionWarning = !suppressVersionWarning
				SetToggleOptionValue(option, suppressVersionWarning)
				
			ElseIf option == GetOID("disableSLACStripping")
				disableSLACStripping = !disableSLACStripping
				SetToggleOptionValue(option, disableSLACStripping)
				
			ElseIf option == GetOID("PurgeRaceKeyLists")
				SetTextOptionValue(option, "$SLAC_Working_Ellipsis")
				UpdateRaceKeys(True)
				SetTextOptionValue(option, "$SLAC_Purge")

			ElseIf option == GetOID("skipFilteringStartSex")
				skipFilteringStartSex = !skipFilteringStartSex
				SetToggleOptionValue(option, skipFilteringStartSex)
			
			; Collars
				
			ElseIf option == GetOID("onlyCollared")
				onlyCollared = !onlyCollared
				SetToggleOptionValue(option, onlyCollared)
				
			ElseIf option == GetOID("collarAttraction")
				collarAttraction = !collarAttraction
				SetToggleOptionValue(option, collarAttraction)
				
			ElseIf option == GetOID("playerAmulet")
				If slac_CollarsFormList.HasForm(playerAmuletForm)
					slac_CollarsFormList.RemoveAddedForm(playerAmuletForm)
				ElseIf slac_CollarsFormList.GetSize() < 100
					slac_CollarsFormList.AddForm(playerAmuletForm)
				EndIf
				ForcePageReset()
				
			ElseIf option == GetOID("playerCollar")
				If slac_CollarsFormList.HasForm(playerCollarForm)
					slac_CollarsFormList.RemoveAddedForm(playerCollarForm)
				ElseIf slac_CollarsFormList.GetSize() < 100
					slac_CollarsFormList.AddForm(playerCollarForm)
				EndIf
				ForcePageReset()
				
			ElseIf option == GetOID("playerSuit")
				If slac_CollarsFormList.HasForm(playerSuitForm)
					slac_CollarsFormList.RemoveAddedForm(playerSuitForm)
				ElseIf slac_CollarsFormList.GetSize() < 100
					slac_CollarsFormList.AddForm(playerSuitForm)
				EndIf
				ForcePageReset()
				
			ElseIf option == GetOID("targetAmulet")
				If slac_CollarsFormList.HasForm(targetAmuletForm)
					slac_CollarsFormList.RemoveAddedForm(targetAmuletForm)
				ElseIf slac_CollarsFormList.GetSize() < 100
					slac_CollarsFormList.AddForm(targetAmuletForm)
				EndIf
				ForcePageReset()
				
			ElseIf option == GetOID("targetCollar")
				If slac_CollarsFormList.HasForm(targetCollarForm)
					slac_CollarsFormList.RemoveAddedForm(targetCollarForm)
				ElseIf slac_CollarsFormList.GetSize() < 100
					slac_CollarsFormList.AddForm(targetCollarForm)
				EndIf
				ForcePageReset()
				
			ElseIf option == GetOID("targetSuit")
				If slac_CollarsFormList.HasForm(targetSuitForm)
					slac_CollarsFormList.RemoveAddedForm(targetSuitForm)
				ElseIf slac_CollarsFormList.GetSize() < 100
					slac_CollarsFormList.AddForm(targetSuitForm)
				EndIf
				ForcePageReset()
				
			ElseIf option == GetOID("clearAllCollarData")
				If ShowMessage("$SLAC_Clear_All_Collar_Data_confirm", True, "$SLAC_Accept", "$SLAC_Cancel")
					slacData.ClearPersistAll("IsVictimCollar")
					slac_CollarsFormList.Revert()
					ForcePageReset()
				EndIf
				
			ElseIf collarsOID.Find(option) > -1
				Form tempCollar = slac_CollarsFormList.GetAt(collarsOID.Find(option))
				slac_CollarsFormList.RemoveAddedForm(tempCollar)
				ForcePageReset()
				
			; Notify Testing

			ElseIf option == GetOID("NTSelectedNPC")
				If Input.IsKeyPressed(KeyLCtrl) && !InInitMaintenance
					; Clear Last Selected NPC if LCtrl Held
					slacPlayerScript.LastSelectedNPC = None
					SetTextOptionValue(option,slacUtility.GetActorNameRef(slacPlayerScript.LastSelectedNPC))
				EndIf

			ElseIf option == GetOID("NTSelectedCreature")
				If Input.IsKeyPressed(KeyLCtrl) && !InInitMaintenance
					; Clear Last Selected Creature if LCtrl Held
					slacPlayerScript.LastSelectedCreature = None
					SetTextOptionValue(option,slacUtility.GetActorNameRef(slacPlayerScript.LastSelectedCreature))
				EndIf

			ElseIf option == GetOID("NTConsensual")
				NTConsensual = !NTConsensual
				SetToggleOptionValue(option, NTConsensual)

			ElseIf option == GetOID("NTGroup")
				NTGroup = !NTGroup
				SetToggleOptionValue(option, NTGroup)

			ElseIf option == GetOID("NTCreatureVictim")
				NTCreatureVictim = !NTCreatureVictim
				SetToggleOptionValue(option, NTCreatureVictim)
				
			ElseIf option == GetOID("NTGet")
				NTGet = !NTGet
				SetTextOptionValue(option, CondString(NTGet,"$SLAC_Get","$SLAC_Give"))

			ElseIf option == GetOID("NTTypeIndex")
				NTTypeIndex = AdvIndex(NTTypeIndex, NTTypeList, 0)
				SetTextOptionValue(option,NTTypeList[NTTypeIndex])

			ElseIf option == GetOID("NTDump")
				If InMaintenance
					ShowMessage("$SLAC_Maintenance_Option_Warning_msg")
					Return
				EndIf

				; Establish participants
				If !slacPlayerScript.LastSelectedCreature && !slacPlayerScript.LastSelectedNPC
					; Actors not selected
					Log("Use Target Select to mark an NPC and Creature", forceNote = True, forceConsole = True, forceTrace = True)
					Return
				EndIf

				Log("------ SLAC Notifications Dump [START] ------", forceNote = True, forceConsole = True, forceTrace = True)

				SetTextOptionValue(option,"$SLAC_Working_Ellipsis")
				SetOptionFlags(option, OPTION_FLAG_DISABLED)

				Actor TestNPC = slacPlayerScript.LastSelectedNPC
				Actor TestCreature = slacPlayerScript.LastSelectedCreature

				If !TestNPC
					TestNPC = Game.GetPlayer()
				EndIf

				Int CreatureSex = slacUtility.GetSex(TestCreature)
				Int VictimSex = slacUtility.TreatAsSex(TestNPC)

				; Reset signal data
				; This will break ongoing scene signaling for the actors, but it's not worth screening out
				slacData.ClearSignal(TestNPC)
				slacData.ClearSignal(TestCreature)

				; Add type signals
				NTCreatureVictim && slacData.SetSignalBool(TestNPC, "NPCIsAggressor", True)
				If NTTypeIndex == 1
					; Deduce oral type and direction
					; Female NPC
						; Male Creature
					VictimSex == 1 && CreatureSex == 0 && NTGet && slacData.SetSignalBool(TestNPC, "GettingCunnilingus", True)
					VictimSex == 1 && CreatureSex == 0 && !NTGet && slacData.SetSignalBool(TestNPC, "GivingBlowJob", True)
						; Female Creature
					VictimSex == 1 && CreatureSex == 1 && NTGet && slacData.SetSignalBool(TestNPC, "GettingCunnilingus", True)
					VictimSex == 1 && CreatureSex == 1 && !NTGet && slacData.SetSignalBool(TestNPC, "GivingCunnilingus", True)
					
					; Male NPC
						; Male Creature
					VictimSex == 0 && CreatureSex == 0 && NTGet && slacData.SetSignalBool(TestNPC, "GettingBlowJob", True)
					VictimSex == 0 && CreatureSex == 0 && !NTGet && slacData.SetSignalBool(TestNPC, "GivingBlowJob", True)
						; Female Creature
					VictimSex == 0 && CreatureSex == 1 && NTGet && slacData.SetSignalBool(TestNPC, "GettingBlowJob", True)
					VictimSex == 0 && CreatureSex == 1 && !NTGet && slacData.SetSignalBool(TestNPC, "GivingCunnilingus", True)
				
				ElseIf NTTypeIndex == 2
					; Anal
					NTGet && slacData.SetSignalBool(TestNPC, "GettingAnilingus", True)
					!NTGet && slacData.SetSignalBool(TestNPC, "GivingAnilingus", True)
				
				ElseIf NTTypeIndex == 3
					; Masturbation
					NTGet && slacData.SetSignalBool(TestNPC, "GettingMasturbation", True)
					!NTGet && slacData.SetSignalBool(TestNPC, "GivingMasturbation", True)
				
				EndIf

				; Show Test Notification
				slacData.SetSignalBool(TestNPC, "NotifyTestSubject", True)
				slacUtility.slacNotify.Show(EventIDs[NTEventIDIndex], TestNPC, TestCreature, NTConsensual, NTGroup)

				; Clean up signal data
				slacData.ClearSignal(TestNPC)
				slacData.ClearSignal(TestCreature)

				Log("------ SLAC Notifications Dump [END] ------", forceNote = True, forceConsole = True, forceTrace = True)

				SetTextOptionValue(option,"$SLAC_Dump")
				SetOptionFlags(option, OPTION_FLAG_NONE)

			ElseIf option == GetOID("NTReload")
				If ShowMessage("$SLAC_Reload_Notifications_JSON_msg", true, "$SLAC_Reload", "$SLAC_Cancel")
					SetTextOptionValue(option,"$SLAC_Working_Ellipsis")
					SetOptionFlags(option, OPTION_FLAG_DISABLED)

					If slacUtility.slacNotify.UpdateNotes(ForceUpdate = True)
						Log("Notifications Update Success!", forceNote = True, forceConsole = True, forceTrace = True)
						ShowMessage("$SLAC_Reload_Notifications_JSON_success",False)
						SetTextOptionValue(GetOID("NTModVersion"), slacUtility.slacNotify.GetModVersion())
						SetTextOptionValue(GetOID("NTFileVersion"), slacUtility.slacNotify.GetFileVersion())
					Else
						Log("Notifications Update Failure!", forceNote = True, forceConsole = True, forceTrace = True)
						ShowMessage("$SLAC_Reload_Notifications_JSON_fail",False)
					EndIf

					SetTextOptionValue(option,"$SLAC_Reload")
					SetOptionFlags(option, OPTION_FLAG_NONE)
				EndIf

			ElseIf option == GetOID("submit_false") || option == GetOID("defeat_false") || \
				option == GetOID("deviouslyHelpless_false") || option == GetOID("DisplayModelBlockAuto_false") || \
				option == GetOID("DeviousDevicesFilter_false") || option == GetOID("NakedDefeatFilter_false") || \
				option == GetOID("ToysFilter_false") || option == GetOID("SexLabPPlusMode")
					ShowMessage("$SLAC_Mod_Compatibility_msg", False)
	
			EndIf
		EndEvent
		
		Event OnOptionSliderOpen(Int option)
		
			; Fixes
		
			If option == GetOID("combatStateChangeCooldown")
				SetSliderDialogStartValue(combatStateChangeCooldown)
				SetSliderDialogDefaultValue(0)
				SetSliderDialogRange(0,180)
				SetSliderDialogInterval(1.0)
			
			ElseIf option == GetOID("FailedPursuitCooldown")
				If FailedPursuitCooldown < 60
					SetSliderDialogStartValue(0)
				Else
					SetSliderDialogStartValue(Math.Floor(FailedPursuitCooldown/60))
				EndIf
				SetSliderDialogDefaultValue(0)
				SetSliderDialogRange(0,60)
				SetSliderDialogInterval(1.0)

			; Testing

			ElseIf option == GetOID("hostileArousalMin")
				SetSliderDialogStartValue(hostileArousalMin)
				SetSliderDialogDefaultValue(0)
				SetSliderDialogRange(0,100)
				SetSliderDialogInterval(1.0)

			; Collars
		
			ElseIf option == GetOID("collaredArousalMin")
				SetSliderDialogStartValue(collaredArousalMin)
				SetSliderDialogDefaultValue(5)
				SetSliderDialogRange(0,100)
				SetSliderDialogInterval(1.0)
			EndIf
		EndEvent
		
		Event OnOptionSliderAccept(Int option, Float value)
			
			; Fixes
		
			If option == GetOID("combatStateChangeCooldown")
				combatStateChangeCooldown = value as Int
				SetSliderOptionValue(option, combatStateChangeCooldown, "$SLAC_Secs")
			
			ElseIf option == GetOID("FailedPursuitCooldown")
				FailedPursuitCooldown = (value as Int) * 60
				SetSliderOptionValue(option, value as Int, "$SLAC_Mins")
				
			; Testing
			
			ElseIf option == GetOID("hostileArousalMin")
				hostileArousalMin = value as Int
				SetSliderOptionValue(option, hostileArousalMin, "{0}")
				
			; Collars
			
			ElseIf option == GetOID("collaredArousalMin")
				collaredArousalMin = value as Int
				SetSliderOptionValue(option, collaredArousalMin, "{0}")
				
			EndIf
		EndEvent
		
		
		Event OnOptionMenuOpen(Int option)
			If option == GetOID("initMCMPage")
				SetMenuDialogOptions(MCMPagesList)
				SetMenuDialogStartIndex(initMCMPage) 
				SetMenuDialogDefaultIndex(0)

			ElseIf option == GetOID("NTEventIDIndex")
				Log("EventsIDs (" + EventIDs.Length + "): " + PapyrusUtil.StringJoin(EventIDs,","))
				SetMenuDialogOptions(EventIDs)
				SetMenuDialogStartIndex(NTEventIDIndex) 
				SetMenuDialogDefaultIndex(0)
				
			EndIf
		EndEvent
		
		Event OnOptionMenuAccept(Int option, Int index)
			If option == GetOID("initMCMPage")
				If index < 0 || index >= MCMPagesList.Length
					index = 0
				EndIf
				initMCMPage = index
				SetMenuOptionValue(option, MCMPagesList[initMCMPage])
				
			ElseIf option == GetOID("NTEventIDIndex")
				NTEventIDIndex = 0
				If index < EventIDs.Length
					NTEventIDIndex = index
				EndIf
				SetMenuOptionValue(option, EventIDs[NTEventIDIndex])
				
			EndIf
		EndEvent
		
		Event OnOptionKeyMapChange(int option, int keyCode, string conflictControl, string conflictName)
			If option == GetOID("AutoToggleKey")
				If keyCode == 1
					AutoToggleKey = -1
				ElseIf conflictControl == "" || ShowMessage("Key already mapped to:\n" + conflictControl + "\n\nUse this key anyway?", true, "Use", "Cancel")
					AutoToggleKey = keyCode
				EndIf
				SetKeyMapOptionValue(option, AutoToggleKey)

			EndIf
		EndEvent
		
		Event OnOptionDefault(Int option)
		
			; Fixes
			
			If option == GetOID("initMCMPage")
				initMCMPage = 0
				SetMenuOptionValue(option, MCMPagesList[initMCMPage])
				
			ElseIf option == GetOID("combatStateChangeCooldown")
				combatStateChangeCooldown = 0
				SetSliderOptionValue(option, combatStateChangeCooldown, "$SLAC_Secs")
			
			ElseIf option == GetOID("FailedPursuitCooldown")
				FailedPursuitCooldown = 0
				SetSliderOptionValue(option, FailedPursuitCooldown, "$SLAC_Secs")
			
			ElseIf option == GetOID("AutoToggleKey")
				AutoToggleKey = -1
				SetKeyMapOptionValue(option, AutoToggleKey)

			; Testing
			
			ElseIf option == GetOID("hostileArousalMin")
				hostileArousalMin = 0
				SetSliderOptionValue(option, hostileArousalMin, "{0}")
				
			; Collars
				
			ElseIf option == GetOID("collaredArousalMin")
				collaredArousalMin = 5
				SetSliderOptionValue(option, collaredArousalMin, "{0}")
			
			; Notification Testing

			ElseIf option == GetOID("NTEventIDIndex")
				NTEventIDIndex = 0
				SetMenuOptionValue(option, EventIDs[NTEventIDIndex])

			EndIf
		EndEvent
		
		
		Event OnOptionHighlight(Int option)
			
			; Trans Options
			
			If option == GetOID("TransMFTreatAsPC") || option == GetOID("TransFMTreatAsPC") || option == GetOID("TransMFTreatAsNPC") || option == GetOID("TransFMTreatAsNPC")
				SetInfoText("$SLAC_Trans_Treat_As_info")
			
			; Animation Selection
			
			ElseIf option == GetOID("restrictAggressivePC") || option == GetOID("restrictAggressiveNPC")
				SetInfoText("$SLAC_Restrict_Aggressive_info")
				
			ElseIf option == GetOID("restrictConsensualPC") || option == GetOID("restrictConsensualNPC")
				SetInfoText("$SLAC_Restrict_Consensual_info")
			
			ElseIf option == GetOID("FemalePCRoleWithMaleCreature") || option == GetOID("FemaleNPCRoleWithMaleCreature")
				SetInfoText("$SLAC_Female_Roll_With_Male_Creature_info")
				
			ElseIf option == GetOID("FemalePCRoleWithFemaleCreature") || option == GetOID("FemaleNPCRoleWithFemaleCreature")
				SetInfoText("$SLAC_Female_Roll_With_Female_Creature_info")

			ElseIf option == GetOID("MalePCRoleWithMaleCreature") || option == GetOID("MaleNPCRoleWithMaleCreature")
				SetInfoText("$SLAC_Male_Roll_With_Male_Creature_info")

			ElseIf option == GetOID("MalePCRoleWithFemaleCreature") || option == GetOID("MaleNPCRoleWithFemaleCreature")
				SetInfoText("$SLAC_Male_Roll_With_Female_Creature_info")
			
			ElseIf option == GetOID("NonConsensualIsAlwaysMFPC") || option == GetOID("NonConsensualIsAlwaysMFNPC")
				SetInfoText("$SLAC_Non_Consensual_Is_Always_MF_info")
			
			; Compatibility
			
			ElseIf option == GetOID("submit") || option == GetOID("submit_false")
				SetInfoText("$SLAC_Submit_info")
				
			ElseIf option == GetOID("defeat") || option == GetOID("defeat_false")
				SetInfoText("$SLAC_Defeat_info")
				
			ElseIf option == GetOID("deviouslyHelpless") || option == GetOID("deviouslyHelpless_false")
				SetInfoText("$SLAC_Deviously_Helpless_info")
				
			ElseIf option == GetOID("DisplayModelBlockAuto") || option == GetOID("DisplayModelBlockAuto_false")
				SetInfoText("$SLAC_Disallow_Display_Model_Actors_info")
				
			ElseIf option == GetOID("DeviousDevicesFilter") || option == GetOID("DeviousDevicesFilter_false")
				SetInfoText("$SLAC_Disallow_Devious_Device_Blocked_info")
				
			ElseIf option == GetOID("NakedDefeatFilter") || option == GetOID("NakedDefeatFilter_false")
				SetInfoText("$SLAC_Naked_Defeat_Filter_info")
				
			ElseIf option == GetOID("ToysFilter") || option == GetOID("ToysFilter_false")
				SetInfoText("$SLAC_Disallow_Toys_Blocked_info")
			
			ElseIf option == GetOID("DHLPBlockAuto")
				If DHLPIsSuspended
					SetInfoText("$SLAC_Disallow_DHLP_info_active")
				Else
					SetInfoText("$SLAC_Disallow_DHLP_info")
				EndIf

			ElseIf option == GetOID("DCURBlockAuto")
				If StorageUtil.GetIntValue(slacUtility.PlayerRef, "DCUR_SceneRunning", 0) > 0
					SetInfoText("$SLAC_Disallow_DCUR_info_active")
				Else
					SetInfoText("$SLAC_Disallow_DCUR_info")
				EndIf

			ElseIf option == GetOID("convenientHorses")
				SetInfoText("$SLAC_Convenient_Horses_Fix_info")
				
			ElseIf option == GetOID("softDependanciesTest")
				SetInfoText("$SLAC_Mods_Check_info")
				
			ElseIf option == GetOID("allowInScene")
				SetInfoText("$SLAC_Allow_In_Scene_info")
				
			ElseIf option == GetOID("currentPCSceneQuest")
				SetInfoText("$SLAC_Current_PC_Scene_Quest_info")
				
			ElseIf option == GetOID("claimActiveActors")
				SetInfoText("$SLAC_Claim_Active_Actors_info")
				
			ElseIf option == GetOID("claimQueuedActors")
				SetInfoText("$SLAC_Claim_Queued_Actors_info")
				
			ElseIf option == GetOID("releaseClaimedActors")
				SetInfoText("$SLAC_Release_Claimed_Actors_info")

			ElseIf option == GetOID("disallowMagicInfluenceCharm")
				SetInfoText("$SLAC_Disallow_Magic_Influence_Charm_info")
				
			ElseIf option == GetOID("disallowMagicAllegianceFaction")
				SetInfoText("$SLAC_Disallow_Magic_Allegiance_Faction_info")
				
			ElseIf option == GetOID("disallowMagicCharmFaction")
				SetInfoText("$SLAC_Disallow_Magic_Charm_Faction_info")
				
			ElseIf option == GetOID("combatStateChangeCooldown")
				SetInfoText("$SLAC_Combat_State_Change_Cooldown_info")
				
			ElseIf option == GetOID("FailedPursuitCooldown")
				SetInfoText("$SLAC_Failed_Pursuit_Cooldown_info")
				
			ElseIf option == GetOID("weaponsPreventAutoEngagement")
				SetInfoText("$SLAC_Weapons_Prevent_Auto_Engagement_info")
			
			ElseIf option == GetOID("useVRCompatibility")
				SetInfoText("$SLAC_Use_VR_Compatibility_info")
			
			ElseIf option == GetOID("suppressVersionWarning")
				SetInfoText("$SLAC_Suppress_Version_Warning_info")
			
			ElseIf option == GetOID("initMCMPage")
				SetInfoText("$SLAC_Initial_MCM_Page_info")
			
			ElseIf option == GetOID("disableSLACStripping")
				SetInfoText("$SLAC_Disable_AC_Stripping_info")
				
			ElseIf option == GetOID("AutoToggleKey")
				SetInfoText("$SLAC_Toggle_AutoEngagement_Key_info")

			ElseIf option == GetOID("SexLabPPlusMode")
				SetInfoText("$SLAC_SexLabPPlus_Compatibility_info")

			; Testing

			ElseIf option == GetOID("skipFilteringStartSex")
				SetInfoText("$SLAC_Skip_Animation_Filtering_info")
			
			ElseIf option == GetOID("allowHostileEngagements")
				SetInfoText("$SLAC_Allow_Hostile_Engagements_info")
			
			ElseIf option == GetOID("allowCombatEngagements")
				SetInfoText("$SLAC_Allow_Combat_Engagements_info")
				
			ElseIf option == GetOID("hostileArousalMin")
				SetInfoText("$SLAC_Hostile_Engagement_Arousal_info")
				
			ElseIf option == GetOID("allowDialogueAutoEngage")
				SetInfoText("$SLAC_Allow_Dialogue_Auto_Engagement_info")
				
			ElseIf option == GetOID("allowMenuAutoEngage")
				SetInfoText("$SLAC_Allow_Menu_Auto_Engagement_info")

			ElseIf option == GetOID("PurgeRaceKeyLists")
				SetInfoText("$SLAC_Purge_Race_Key_Lists_info")

			ElseIf option == GetOID("ClearStoredData")
				SetInfoText("$SLAC_Clear_Stored_Data_info")
				
			; Collars
				
			ElseIf option == GetOID("onlyCollared")
				SetInfoText("$SLAC_Only_Collared_Victims_info")
				
			ElseIf option == GetOID("collarAttraction")
				SetInfoText("$SLAC_Creatures_Prefer_Collars_info")
				
			ElseIf option == GetOID("collaredArousalMin")
				SetInfoText("$SLAC_Collared_Arousal_info")
				
			ElseIf option == GetOID("clearAllCollarData")
				SetInfoText("$SLAC_Clear_All_Collar_Data_info")
			
			; Notification Testing

			ElseIf option == GetOID("NTSelectedNPC") || option == GetOID("NTSelectedCreature")
				SetInfoText("$SLAC_Selected_NPC_Creature_info")

			ElseIf option == GetOID("NTDump")
				SetInfoText("$SLAC_Dump_Results_info")
				
			ElseIf option == GetOID("NTReload")
				SetInfoText("$SLAC_Reload_Notifications_JSON_info")

			EndIf
		EndEvent
	EndState
	
	
; ===================================
; =                                 =
; =            Profiles             =
; =                                 =
; ===================================


	State slacProfiles_ST
	
		Event OnOptionSelect(Int option)
			If option == GetOID("slacProfileLoadTags")
				slacProfileLoadTags = !slacProfileLoadTags
				SetToggleOptionValue(option, slacProfileLoadTags)
				
			ElseIf slacProfileLoadOID.Find(option) > -1
				; Load Profile
				Int profileIndex = slacProfileLoadOID.Find(option)
				LoadSettingsConfirm(profileIndex,option)
				
			ElseIf slacProfileSaveOID.Find(option) > -1
				; Save Profile
				Int profileIndex = slacProfileSaveOID.Find(option)
				SaveSettingsConfirm(profileIndex,option)
				
			EndIf
		EndEvent
		
		Event OnOptionInputOpen(Int option)
			If option == GetOID("slacProfileSaveName")
				SetInputDialogStartText(slacProfileSaveName)
			EndIf
		EndEvent
		
		Event OnOptionInputAccept(Int option, String inputString)
			If option == GetOID("slacProfileSaveName")
				slacProfileSaveName = inputString
				SetInputOptionValue(option, slacProfileSaveName)
			EndIf
		EndEvent
		
		Event OnOptionDefault(Int option)
		EndEvent
		
		Event OnOptionHighlight(Int option)
		
			If option == GetOID("slacProfileLoadTags")
				SetInfoText("$SLAC_Settings_Profile_Load_Tags_info")
			ElseIf option == GetOID("slacProfileSaveName")
				SetInfoText("$SLAC_Current_Profile_Name_info")
			ElseIf slacProfileLoadOID.Find(option) > -1
				; Show load profile Info
				Int profileIndex = slacProfileLoadOID.Find(option)
				If profileIndex == 0
					; Show default profile info
					SetInfoText("$SLAC_Settings_Profile_Default_info")
				Else
					; Show normal profile info
					SetInfoText("Load profile " + profileIndex + ":\n" + GetSettingsInfo(profileIndex))
				EndIf
				
			ElseIf slacProfileSaveOID.Find(option) > -1
				; Show save profile info
				Int profileIndex = slacProfileSaveOID.Find(option)
				SetInfoText("Save over profile " + profileIndex + ":\n" + GetSettingsInfo(profileIndex))
				
			EndIf
		EndEvent
		
	EndState
	
	
; ===================================
; =                                 =
; =              Help               =
; =                                 =
; ===================================


	; =================== System Tests ====================
	
	
	; SexLab Install Test
	State slInstall_ST
		Event OnHighlightST()
			SetInfoText("$SLAC_SL_Install_Complete_info")
		EndEvent
	EndState
	
	; SexLab Version Test
	State inMaintenance_ST
		Event OnHighlightST()
			SetInfoText("$SLAC_Aroused_Creatures_Maintenance_info")
		EndEvent
	EndState
	
	; SexLab Version Test
	State slEnabled_ST
		Event OnHighlightST()
			SetInfoText("$SLAC_SL_Enabled_info")
		EndEvent
	EndState
	
	; SexLab Version Test
	State slCreatures_ST
		Event OnHighlightST()
			SetInfoText("$SLAC_SL_Creatures_Enabled_info")
		EndEvent
	EndState
	
	; SexLab Disable Starting Teleport Test
	State slDisableTeleport_ST
		Event OnHighlightST()
			SetInfoText("$SLAC_SL_Disable_Teleport_Disabled_info")
		EndEvent
	EndState
	
	; SexLab Match Creature Genders Test
	State slMatchCreatureGenders_ST
		Event OnHighlightST()
			SetInfoText("$SLAC_SL_Match_Creature_Genders_info")
		EndEvent
	EndState
	
	
	; ===================== Cleaning ======================
	
	
	; Clean PC
	State cleanPC_ST
		Event OnSelectST()
			Actor playerTemp = Game.GetPlayer()
			slacUtility.EndPursuitQuestForActor(playerTemp,False)
			slacUtility.CleanActor(playerTemp, fullClean = True)
			Log("Manually Cleaned " + playerTemp.GetLeveledActorbase().GetName(), forceTrace = True)
			ShowMessage("$SLAC_Effects_Removed_From_Player_msg",False)
		EndEvent
		Event OnHighlightST()
			SetInfoText("$SLAC_Clean_PC_info")
		EndEvent
	EndState
	
	; Clean NPC
	State cleanNPC_ST
		Event OnSelectST()
			If targetActor && targetActor != None
				slacUtility.EndPursuitQuestForActor(targetActor,False)
				slacUtility.CleanActor(targetActor, fullClean = True)
				Log("Manually Cleaned " + targetActor.GetLeveledActorbase().GetName(), forceTrace = True)
				ShowMessage("Aroused Creatures effects removed from " + targetActor.GetLeveledActorbase().GetName(), False)
			EndIf
		EndEvent
		Event OnHighlightST()
			SetInfoText("$SLAC_Clean_NPC_info")
		EndEvent
	EndState
	
	
	; ================ Engagement Failure  ================
	
	
	; Failure Code Info Lists
	State help_ST
	
		Event OnOptionSelect(Int option)
			If option == GetOID("debugTest")
				debugSLAC = False
				SetTextOptionValue(option,"$SLAC_OK_Green")
				
			ElseIf option == GetOID("skipFilteringTest")
				skipFilteringStartSex = False
				SetTextOptionValue(option,"$SLAC_OK_Green")
			
			ElseIf option == GetOID("autoEngageBlocked")
				If targetActor && targetActor != None && targetActor != Game.GetPlayer()
					If targetActor.IsInFaction(slac_AutoEngageBlockedFaction)
						targetActor.RemoveFromFaction(slac_AutoEngageBlockedFaction)
						targetActor.AddToFaction(slac_AutoEngagePermittedFaction)
						SetTextOptionValue(option,"$SLAC_Allowed")
					ElseIf targetActor.IsInFaction(slac_AutoEngagePermittedFaction)
						targetActor.RemoveFromFaction(slac_AutoEngagePermittedFaction)
						targetActor.RemoveFromFaction(slac_AutoEngageBlockedFaction)
						SetTextOptionValue(option,"$SLAC_Default")
					Else
						targetActor.RemoveFromFaction(slac_AutoEngagePermittedFaction)
						targetActor.AddToFaction(slac_AutoEngageBlockedFaction)
						SetTextOptionValue(option,"$SLAC_Blocked")
					EndIf
				EndIf
				
			ElseIf failedActorsNPCsOID.Find(option) > -1
				Int index = failedActorsNPCsOID.Find(option)
				If ShowMessage("$SLAC_Set_Target_Actor_msg", True, "$SLAC_Set_Target")
					targetActor = failedActorsNPCsRef[index]
					ForcePageReset()
				EndIf
				
			ElseIf failedActorsCreaturesOID.Find(option) > -1
				Int index = failedActorsCreaturesOID.Find(option)
				If ShowMessage("$SLAC_Set_Target_Actor_msg", True, "$SLAC_Set_Target")
					targetActor = failedActorsCreaturesRef[index]
					ForcePageReset()
				EndIf

			EndIf
		EndEvent
		
		Event OnOptionHighlight(Int option)
			If option == GetOID("SexLabVersionTest")
				SetInfoText("$SLAC_SL_Version_info")
				
			ElseIf option == GetOID("debugTest")
				SetInfoText("$SLAC_Debug_Disabled_info")
				
			ElseIf option == GetOID("raceKeyTest")
				SetInfoText("$SLAC_SL_Creature_Races_info")
			
			ElseIf option == GetOID("slacStalled")
				SetInfoText("$SLAC_Player_Script_Operation_info")
				
			ElseIf option == GetOID("skipFilteringTest")
				SetInfoText("$SLAC_Animation_Filtering_Enabled_info")
				
			ElseIf option == GetOID("versionTestUtility")
				SetInfoText("$SLAC_Utility_Script_Version_info")
				
			ElseIf option == GetOID("PapyrusUtilVersionTest")
				SetInfoText("$SLAC_PapyrusUtil_Compatibility_info")
				
			ElseIf option == GetOID("versionTestPlayer")
				SetInfoText("$SLAC_Player_Script_Version_info")
				
			ElseIf option == GetOID("autoEngageBlocked")
				SetInfoText("$SLAC_Auto_Engage_Permission_info")
				
			ElseIf failedActorsNPCsOID.Find(option) > -1
				Int index = failedActorsNPCsOID.Find(option)
				SetInfoText("$SLAC_Failure_String" + failedActorsNPCsString[index])
				
			ElseIf failedActorsCreaturesOID.Find(option) > -1
				Int index = failedActorsCreaturesOID.Find(option)
				SetInfoText("$SLAC_Failure_String" + failedActorsCreaturesString[index])
				Log("ACMCM: failedActorsCreaturesString[" + index + "] = " + failedActorsCreaturesString[index])
				
			EndIf
		EndEvent
	EndState
	
	; Clear Failure Code Lists
	State clearFailedLists_ST
		Event OnSelectST()
			ClearFailData()
			ForcePageReset()
		EndEvent
		Event OnHighlightST()
			SetInfoText("$SLAC_Clear_Failed_Lists_info")
		EndEvent
	EndState
	
	; ======================== End ========================

	
; Save Settings Profile with confirmation
Function SaveSettingsConfirm(Int profileID, Int OID)
	; Prevent saving during maintenance 
	If inMaintenance
		ShowMessage("$SLAC_Profile_Maintenance", False)
		Return
	EndIf

	; Normal profile save message
	String confMsg = "This will overwrite Settings Profile " + profileID + "\nAvoid making configuration changes until the operation is complete.\nAre you sure?"
	
	; Overwrite profile message
	If !ProfileAvailable(profileID)
		confMsg = "This will save a new Settings Profile in slot " + profileID + "\nAvoid making configuration changes until the operation is complete.\nAre you sure?"
	EndIf
	
	; Final confirmation
	If ShowMessage(confMsg, True, "$SLAC_Save", "$SLAC_Cancel")
		; Show Working text
		SetOptionFlags(OID, OPTION_FLAG_DISABLED)
		SetTextOptionValue(OID, "$SLAC_Working_Ellipsis")
		
		; Save settings profile
		If SaveSettings(profileID)
			Log("Aroused Creatures Settings Profile " + profileID + " has been saved", forceNote = True)
			; Announce completion
			ShowMessage("The current configuration has been saved to Settings Profile " + profileID, False)
		Else
			Log("WARNING: Aroused Creatures Settings Profile " + profileID + " could not saved", forceNote = True)
			; Announce failure
			ShowMessage("The current configuration could not be saved. This may be due to operating system security or antivirus configuration.", False)
		EndIf
			
		; Reset option
		;SetOptionFlags(OID, OPTION_FLAG_NONE)
		;SetTextOptionValue(OID, "$SLAC_Save")
		
		; Refresh page to update load and profile name fields
		ForcePageReset() 
	EndIf
EndFunction

; Load Settings Profile with confirmation
Function LoadSettingsConfirm(Int profileID, Int OID)
	; Prevent loading during maintenance 
	If inMaintenance
		ShowMessage("$SLAC_Profile_Maintenance", False)
		Return
	EndIf

	; Normal profile load message
	String confMsg = "This will replace the current configuration with the configuration in Settings Profile " + profileID + "\nAvoid making configuration changes until the operation is complete.\nAre you sure?"
	
	; Default profile load message
	If profileID == 0
		confMsg = "This will replace the current configuration with the configuration in the Default Settings Profile\nAvoid making configuration changes until the operation is complete.\nAre you sure?"
	EndIf

	; Final confirmation
	If ShowMessage(confMsg, True, "$SLAC_Load", "$SLAC_Cancel")
		; Show Working text
		SetOptionFlags(OID, OPTION_FLAG_DISABLED)
		SetTextOptionValue(OID, "$SLAC_Working_Ellipsis")
		
		; Load settings profile
		If LoadSettings(profileID)
			; Update profile name
			SetInputOptionValue(GetOID("slacProfileSaveName"), slacProfileSaveName)
			
			Log("Aroused Creatures Settings Profile " + profileID + " has been loaded", forceNote = True)
			
			; Announce completion
			ShowMessage("Settings Profile " + profileID + " has been applied", False)
		Else
			Log("Aroused Creatures Settings Profile " + profileID + " failed to load", forceNote = True)
			
			; Announce failure
			ShowMessage("Settings Profile " + profileID + " failed to load. This may be the result of a missing, blocked, or corrupted profile file.", False)
		EndIf

		; Reset option
		SetOptionFlags(OID, OPTION_FLAG_NONE)
		SetTextOptionValue(OID, "$SLAC_Load")
	EndIf
EndFunction


; Check if a profile exists
Bool Function ProfileAvailable(Int profileID)
	String filename = filePath + filePrefix + profileID + ".json"
	If JsonUtil.GetIntValue(filename, "SLACMCMVersion", 0) > 0
		Return True
	EndIf
	Return False
EndFunction


; Return string identifying the game that the profile was saved on
String Function GetSettingsInfo(Int profileID)
	If profileID == 0
		Return "Return to Default Settings"
	EndIf
	String filename = filePath + filePrefix + profileID + ".json"
	Return "" + JsonUtil.GetStringValue(filename, "slacProfileSaveName", "Unnamed Profile") + "\n" + JsonUtil.GetStringValue(filename, "SLACPCName") + " Lv" + JsonUtil.GetIntValue(filename, "SLACPCLevel", 0) + " " + RoundDownFloat(JsonUtil.GetFloatValue(filename, "SLACPlayTime", 0)) + "hrs " + Utility.GameTimeToString(JsonUtil.GetFloatValue(filename, "SLACGameTime")) + " (M/D/Y H:M)"
EndFunction
String Function GetProfileName(Int profileID)
	If profileID == 0
		Return "Default Settings"
	EndIf
	If ProfileAvailable(profileID)
		String filename = filePath + filePrefix + profileID + ".json"
		Return "" + JsonUtil.GetStringValue(filename, "slacProfileSaveName", "Unnamed")
	EndIf
	Return ""
EndFunction

; Reduce precision of float for display
String Function RoundDownFloat(Float number)
	If number < 10.0
		Return StringUtil.Substring(number, 0, 3)
	ElseIf number < 100.0
		Return StringUtil.Substring(number, 0, 4)
	ElseIf number < 1000.0
		Return StringUtil.Substring(number, 0, 5)
	ElseIf number < 10000.0
		Return StringUtil.Substring(number, 0, 6)
	EndIf
	Return Math.Floor(number)
EndFunction


; Convert hexadecimal digit to decimal
Int Function HexCharToDec(String hexstring)
	; legacy REMOVE for v5
	HexStringToInt(hexstring)
EndFunction
; Converts hexadecimal string to an Int
; Begins searching from the last/rightmost character
; conversion begins with the first valid hex digit then ends with the next non-hex digit.
Int Function HexStringToInt(String hexstring)
	Int outputdec = 0
	Int i = StringUtil.GetLength(hexstring) - 1
	Int pos = 0
	Bool Started = False
	While i >= 0
		String hexchar = StringUtil.GetNthChar(hexstring, i)
		Int decdigit = 0
		If StringUtil.IsDigit(hexchar)
			decdigit = hexchar as Int
			Started = True
		ElseIf hexchar == "A"
			decdigit = 10
		ElseIf hexchar == "B"
			decdigit = 11
		ElseIf hexchar == "C"
			decdigit = 12
		ElseIf hexchar == "D"
			decdigit = 13
		ElseIf hexchar == "E"
			decdigit = 14
		ElseIf hexchar == "F"
			decdigit = 15
		ElseIf Started
			Return outputdec
		EndIf
		If Started || decdigit > 0
			outputdec += Math.LeftShift(decdigit,pos*4)
			pos += 1
			Started = True
		EndIf
		i -= 1
	EndWhile
	Return outputdec
EndFunction

; Convert an integer to a hexadecimal string
; For FormIDs it is faster to grab the hex id from the form cast as a string:
; StringUtil.SubString(FormObject, (StringUtil.GetLength(FormObject) - 11), 8)
String Function IntToHexString(Int value, Int pad = 8)
	String hexstring = ""
	Int i = 0
	While value > 0 || i < pad
		Int nibble = Math.LogicalAnd(value,15)
		If nibble < 10
			hexstring = "" + nibble + hexstring
		ElseIf nibble == 10
			hexstring = "A" + hexstring
		ElseIf nibble == 11
			hexstring = "B" + hexstring
		ElseIf nibble == 12
			hexstring = "C" + hexstring
		ElseIf nibble == 13
			hexstring = "D" + hexstring
		ElseIf nibble == 14
			hexstring = "E" + hexstring
		ElseIf nibble == 15
			hexstring = "F" + hexstring
		Endif
		value = Math.RightShift(value,4)
		i += 1
	EndWhile
	Return hexstring
EndFunction


; Reset all aggressive tagging to default
Function DefaultAggressiveTags(Bool showResultMessage = False)
	; Clear anim caches to ensure any changes take effect immediately
	SexLab.AnimSlots.ClearAnimCache()
	
	; work through 2p to 5p animations (there is no tag filtering without actor count)
	sslBaseAnimation[] aggrAnims
	sslBaseAnimation[] defaultAggrAnims
	Int removeCount = 0
	Int addCount = 0
	Int p = 2
	While p <= 5
		;aggrAnims = SexLab.GetCreatureAnimationsByTags(ActorCount = p, Tags = "Aggressive," + Utility.GetCurrentRealTime(), TagSuppress = "AggressiveDefault", RequireAll = False)
		aggrAnims = SexLab.GetCreatureAnimationsByTags(ActorCount = p, Tags = "Aggressive", TagSuppress = "AggressiveDefault", RequireAll = False)
		defaultAggrAnims = SexLab.GetCreatureAnimationsByTags(ActorCount = p, Tags = "AggressiveDefault", TagSuppress = "Aggressive", RequireAll = False)
		Log("Found " + aggrAnims.Length + " animations tagged Aggressive")
		Log("Found " + defaultAggrAnims.Length + " animations tagged AggressiveDefault")
		
		; Remove Aggressive tag from non-defaults
		String report = ""
		Int i = 0
		While i < aggrAnims.Length
			report = "Aggressive Tagged: " + aggrAnims[i].Name + " Aggressive:" + aggrAnims[i].HasTag("Aggressive") + " AggressiveDefault:" + aggrAnims[i].HasTag("AggressiveDefault")
			If !aggrAnims[i].HasTag("AggressiveDefault") && aggrAnims[i].HasTag("Aggressive")
				aggrAnims[i].RemoveTag("Aggressive")
				removeCount += 1
				report += " Removing: Aggressive"
			EndIf
			Log(report)
			i += 1
		EndWhile
		
		; Add Aggressive tags to defaults
		i = 0
		While i < defaultAggrAnims.Length
			report = "Aggressive Tagged: " + defaultAggrAnims[i].Name + " Aggressive:" + defaultAggrAnims[i].HasTag("Aggressive") + " AggressiveDefault:" + defaultAggrAnims[i].HasTag("AggressiveDefault")
			If !defaultAggrAnims[i].HasTag("Aggressive")
				defaultAggrAnims[i].AddTag("Aggressive")
				addCount += 1
				report += " Adding: Aggressive"
			EndIf
			Log(report)
			i += 1
		EndWhile
		p += 1
	EndWhile
	
	; Report result counts
	If showResultMessage
		ShowMessage((removeCount+addCount) + " animations updated.\n" + removeCount + " Aggressive tags removed\n" + addCount + " Aggressive tags added", false)
	EndIf
EndFunction


; Toggle the Aggressive tag on an animation
Bool Function ToggleAggressiveTag(sslBaseAnimation anim)
	If anim
		If anim.HasTag("Aggressive")
			anim.RemoveTag("Aggressive")
			Return False
		Else
			anim.AddTag("Aggressive")
			Return True
		EndIf
	EndIf
	Log("Missing animation")
	Return False
EndFunction


Bool Function ToggleCollarValue(Form item)
	If !slacData.GetPersistBool(item,"IsVictimCollar")
		Return slacData.SetPersistBool(item,"IsVictimCollar",True)
	EndIf
	slacData.ClearPersist(item,"IsVictimCollar")
	Return False
EndFunction


; Get string of all tags for named animation
String Function GetAllTagsName(String animName)
	If !UsingSLPP()
		sslBaseAnimation anim = SexLab.GetCreatureAnimationByName(animName)
		If anim
			Return PapyrusUtil.StringJoin(anim.GetTags(), ", ")
		EndIf
	EndIf
	Return ""
EndFunction
; Get string of all tags for registered animation
String Function GetAllTagsRegsitry(String reg)
	;Log("mcm anim name " + animName,true,true,true)
	If UsingSLPP()
		; SexLab P+
		If SexLabRegistry.SceneExists(reg)
			Return PapyrusUtil.StringJoin(SexLabRegistry.GetSceneTags(reg), ", ")
		EndIf
	Else
		; OG SexLab
		sslBaseAnimation anim = SexLab.GetCreatureAnimationByRegistry(reg)
		If anim
			Return PapyrusUtil.StringJoin(anim.GetTags(), ", ")
		EndIf
	EndIf
	Return ""
EndFunction

; Return true if the animation is flagged as aggressive or has a submissive position.
; For now, SLP+ does not provide a means to determine if a scene has a submissive position with only the ID.
; The tagging is not generally indicative of the actual status.
Bool Function IsAggressiveScene(String SceneID)
	If UsingSLPP()
		Return SexLabRegistry.SceneExists(SceneID) && \
			SexLabRegistry.IsSceneTag(SceneID,"Aggressive") || \
			SexLabRegistry.IsSceneTag(SceneID,"Forced") || \
			SexLabRegistry.IsSceneTag(SceneID,"Rough")
	Else
		sslBaseAnimation anim = SexLab.GetCreatureAnimationByRegistry(SceneID)
		Return anim && anim.HasTag("Aggressive")
	EndIf
EndFunction


; Add aggressive animation tags
Function SetDefaultTags()
	If UsingSLPP()
		Log("Default aggressive tagging skipped for SLP+")
		Return
	EndIf
	
	; Default
	AddAgTag("(Bear) Doggystyle")
	AddAgTag("(Seeker) Hugging")
	AddAgTag("(Dog) Dominate")
	AddAgTag("(Dragon) Tongue")
	AddAgTag("(Draugr) Doggystyle")
	AddAgTag("(Draugr) Gangbang 3P")
	AddAgTag("(Draugr) Gangbang 4P") 
	AddAgTag("(Draugr) Gangbang 5P")
	AddAgTag("(Draugr) Holding")
	AddAgTag("(Falmer) Doggystyle")
	AddAgTag("(Falmer) Gangbang 3P")
	AddAgTag("(Falmer) Gangbang 4P")
	AddAgTag("(Falmer) Gangbang 5P")
	AddAgTag("(Falmer) Holding")
	AddAgTag("(Gargoyle) Doggystyle")
	AddAgTag("(Gargoyle) Holding")
	AddAgTag("(Giant) Penetration")
	AddAgTag("(Horse) Doggystyle")
	AddAgTag("(Sabre Cat) Doggystyle")
	AddAgTag("(Troll) Holding")
	AddAgTag("(Troll) Missionary")
	AddAgTag("(Troll) Dominate")
	AddAgTag("(Troll) Grabbing")
	AddAgTag("(Vampire Lord) Holding")
	AddAgTag("(Vampire Lord) Missionary")
	AddAgTag("(Werewolf) Rough Doggystyle")
	AddAgTag("(Werewolf) Doggystyle")
	AddAgTag("(Werewolf) Holding")
	AddAgTag("(Werewolf) Missionary")
	AddAgTag("(Wolf) Doggystyle")
	AddAgTag("(Wolf) Dominate")
	AddAgTag("(Giant) Harrassment")
	AddAgTag("(Giant) Holding")
	AddAgTag("(Riekling) Threesome")
	
	; MNC
	AddAgTag("(Riekling) RieklingDouble")
	AddAgTag("(Lurker) Penetration")
	AddAgTag("(Lurker) Harrassment")
	AddAgTag("(Lurker) Holding")
	AddAgTag("(Dog) Panicnew")
	AddAgTag("(Wolf) Panicnew")
	AddAgTag("(Spriggan) CG")
	AddAgTag("(Spriggan) Behind")
	AddAgTag("Flame Atronach Behind")
	AddAgTag("(Spriggan) On Ground")
	AddAgTag("Flame Atronach Missionary")
	AddAgTag("(Werewolf) Panic Redone")
	AddAgTag("(Skeever) Billyy Doggy")
	AddAgTag("(Skeever) Billyy Face-Fuck")
	AddAgTag("(Skeever) Billyy 3p Spitroast Alt") 
	AddAgTag("(Werewolf) Panic BJ")
	AddAgTag("(Falmers) FunnyBizness")
EndFunction

; Add aggressive tags to default aggressive animations if they have not been previously tagged
; The AggressiveDefault tag indicates that the animation was previously tagged as aggressive and
; subsequently changed by the user or another mod.
Function AddAgTag(String animName)
	sslBaseAnimation anim = SexLab.GetCreatureAnimationByName(animName)
	If anim && !anim.HasTag("AggressiveDefault")
		If anim.SetTags("Aggressive,AggressiveDefault")
			Log("Aggressive, AggressiveDefault tags added to " + anim.Name,false,false,true)
		EndIf
	EndIf
EndFunction


; Helper function not currently used. In future this may be used to adjust anal/vaginal tags on creature animations
Bool Function AddNewTags(String animName, String tag)
	sslBaseAnimation anim = SexLab.GetCreatureAnimationByName(animName)

	If anim && anim.SetTags(tag)
		Log(tag + " tag added to " + anim.Name)
		Return True
	EndIf
	
	Return False
EndFunction


; Synchronise the allowed creatures arrays to add new or remove missing races reported by SexLab
Function UpdateRaceKeys(Bool Purge = False)
	; Copy Race Keys to new array so any changes can be tracked
	String[] newRaceKeyList = FrameworkGetAllRaceKeys()
	PapyrusUtil.SortStringArray(newRaceKeyList)
	raceKeyList = newRaceKeyList
	
	; Create new lists with missing creature races purged
	; The default now is to keep disallowed races that do not have animations. This is to support 
	; loading a custom default profile in a new game before any animations are registered.
	If Purge
		String[] newDisallowedRaceKeyFPCList = PapyrusUtil.StringArray(0)
		String[] newDisallowedRaceKeyMPCList = PapyrusUtil.StringArray(0)
		String[] newDisallowedRaceKeyFNPCList = PapyrusUtil.StringArray(0)
		String[] newDisallowedRaceKeyMNPCList = PapyrusUtil.StringArray(0)
		Int i = 0
		While i < newRaceKeyList.length
			If newRaceKeyList[i]
				If disallowedRaceKeyFPCList.Find(newRaceKeyList[i]) > -1
					; previously disallowed race for Female PC
					newDisallowedRaceKeyFPCList = PapyrusUtil.PushString(newDisallowedRaceKeyFPCList, newRaceKeyList[i])
				EndIf
				If disallowedRaceKeyMPCList.Find(newRaceKeyList[i]) > -1
					; previously disallowed race for Male PC
					newDisallowedRaceKeyMPCList = PapyrusUtil.PushString(newDisallowedRaceKeyMPCList, newRaceKeyList[i])
				EndIf
				If disallowedRaceKeyFNPCList.Find(newRaceKeyList[i]) > -1
					; previously disallowed race for Female NPC
					newDisallowedRaceKeyFNPCList = PapyrusUtil.PushString(newDisallowedRaceKeyFNPCList, newRaceKeyList[i])
				EndIf
				If disallowedRaceKeyMNPCList.Find(newRaceKeyList[i]) > -1
					; previously disallowed race for Male PC
					newDisallowedRaceKeyMNPCList = PapyrusUtil.PushString(newDisallowedRaceKeyMNPCList, newRaceKeyList[i])
				EndIf
			EndIf
			i += 1
		EndWhile

		; Replace current lists with purged versions
		disallowedRaceKeyFPCList = newDisallowedRaceKeyFPCList
		disallowedRaceKeyMPCList = newDisallowedRaceKeyMPCList
		disallowedRaceKeyFNPCList = newDisallowedRaceKeyFNPCList
		disallowedRaceKeyMNPCList = newDisallowedRaceKeyMNPCList
	EndIf
	
	disallowedRaceKeyFPCList = PapyrusUtil.ClearEmpty(disallowedRaceKeyFPCList)
	disallowedRaceKeyMPCList = PapyrusUtil.ClearEmpty(disallowedRaceKeyMPCList)
	disallowedRaceKeyFNPCList = PapyrusUtil.ClearEmpty(disallowedRaceKeyFNPCList)
	disallowedRaceKeyMNPCList = PapyrusUtil.ClearEmpty(disallowedRaceKeyMNPCList)

	checkPCCreatureRace = False
	checkNPCCreatureRace = False
	
	; Skip processing if there are no valid raceKeys left
	; Uses PapyrusUtil GetMatchign functions added in version 4.0 (2021) 
	Int puv = PapyrusUtil.GetVersion()
	If disallowedRaceKeyFPCList.Length > 0 || disallowedRaceKeyMPCList.Length > 0
		If puv >= 40
			String[] FPCListTest = PapyrusUtil.GetMatchingString(disallowedRaceKeyFPCList, raceKeyList)
			String[] MPCListTest = PapyrusUtil.GetMatchingString(disallowedRaceKeyMPCList, raceKeyList)
			If FPCListTest.Length > 0 || MPCListTest.Length > 0
				checkPCCreatureRace = True
			EndIf
		Else
			checkPCCreatureRace = True
		EndIf
	EndIf
	If disallowedRaceKeyFNPCList.Length > 0 || disallowedRaceKeyMNPCList.Length > 0
		If puv >= 40
			String[] FNPCListTest = PapyrusUtil.GetMatchingString(disallowedRaceKeyFNPCList, raceKeyList)
			String[] MNPCListTest = PapyrusUtil.GetMatchingString(disallowedRaceKeyMNPCList, raceKeyList)
			If FNPCListTest.Length > 0 || MNPCListTest.Length > 0
				checkNPCCreatureRace = True
			EndIf
		Else
			checkNPCCreatureRace = True
		EndIf
	EndIf
	
	If debugSLAC
		Purge && Log("Disallowed creature race lists purged of missing races.")
		Log("Race disallowed out of " + raceKeyList.Length + ": PC Female " + disallowedRaceKeyFPCList.length + " PC Male:" + disallowedRaceKeyMPCList.length + " NPC Female:" + disallowedRaceKeyFNPCList.length + " NPC Male:" + disallowedRaceKeyMNPCList.length)
		Log("checkPCCreatureRace: " + checkPCCreatureRace)
		Log("checkNPCCreatureRace: " + checkNPCCreatureRace)
		Log("Disallowed races PC Female: " + PapyrusUtil.StringJoin(disallowedRaceKeyFPCList,", "))
		Log("Disallowed races PC Male: " + PapyrusUtil.StringJoin(disallowedRaceKeyMPCList,", "))
		Log("Disallowed races NPC Female: " + PapyrusUtil.StringJoin(disallowedRaceKeyFNPCList,", "))
		Log("Disallowed races NPC Male: " + PapyrusUtil.StringJoin(disallowedRaceKeyMNPCList,", "))
	EndIf
EndFunction


; Check if creature race is permitted
Bool Function AllowedCreatureRace(String raceKey, Bool isPlayer = True, Bool female = True)
	If  (isPlayer && female) || (allowedSync && female)
		Return disallowedRaceKeyFPCList.Find(raceKey) < 0
	ElseIf (isPlayer && !female) || (allowedSync && !female)
		Return disallowedRaceKeyMPCList.Find(raceKey) < 0
	ElseIf !isPlayer && female
		Return disallowedRaceKeyFNPCList.Find(raceKey) < 0
	ElseIf !isPlayer && !female
		Return disallowedRaceKeyMNPCList.Find(raceKey) < 0
	EndIf
	Return True
EndFunction
Bool Function AllowedCreatureActor(Actor Creature, Actor Victim)
	Bool isPlayer = slacUtility.PlayerRef == Victim
	Bool female = slacUtility.TreatAsSex(Victim,Creature) == 1
	String raceKey = FrameworkGetRaceKey(Creature)
	Return AllowedCreatureRace(raceKey,isPlayer,female)
EndFunction
Bool Function AllowedCreatureActorAll(Actor Creature)
	String raceKey = FrameworkGetRaceKey(Creature)
	If allowedSync
		Return disallowedRaceKeyFPCList.Find(raceKey) < 0 && \
			disallowedRaceKeyMPCList.Find(raceKey) < 0
	Else
		Return disallowedRaceKeyFPCList.Find(raceKey) < 0 && \
			disallowedRaceKeyMPCList.Find(raceKey) < 0 && \
			disallowedRaceKeyFNPCList.Find(raceKey) < 0 && \
			disallowedRaceKeyMNPCList.Find(raceKey) < 0
	EndIf
EndFunction
Bool Function AllowedCreatureActorAny(Actor Creature)
	String raceKey = FrameworkGetRaceKey(Creature)
	If allowedSync
		Return disallowedRaceKeyFPCList.Find(raceKey) < 0 || \
			disallowedRaceKeyMPCList.Find(raceKey) < 0
	Else
		Return disallowedRaceKeyFPCList.Find(raceKey) < 0 || \
			disallowedRaceKeyMPCList.Find(raceKey) < 0 || \
			disallowedRaceKeyFNPCList.Find(raceKey) < 0 || \
			disallowedRaceKeyMNPCList.Find(raceKey) < 0
	EndIf
EndFunction

; Add execution time to end of queue
Function UpdateExecutionTimes(Float lastTime)
	Int i = executionTimes.length
	While i > 1
		i -= 1
		executionTimes[i] = executionTimes[i - 1]
	EndWhile
	executionTimes[0] = lastTime
EndFunction


; Add PC animation to end of queue
Function UpdateRecentPCAnims(String animName = "")
	If animName == ""
		Return
	EndIf

	; Remove any value matching the new anim
	togglesRecentPCAnim = PapyrusUtil.RemoveString(togglesRecentPCAnim,animName)

	; Return array to original size
	togglesRecentPCAnim = PapyrusUtil.ResizeStringArray(togglesRecentPCAnim,5,"")

	; Add new animation to the top of the list
	Int i = togglesRecentPCAnim.length
	While i > 1
		i -= 1
		togglesRecentPCAnim[i] = togglesRecentPCAnim[i - 1]
	EndWhile
	togglesRecentPCAnim[0] = animName
EndFunction


; Add NPC animation to end of queue
Function UpdateRecentNPCAnims(String animName = "")
	If animName == ""
		Return
	EndIf
	
	; Remove any value matching the new anim then remove empty values
	togglesRecentNPCAnim = PapyrusUtil.RemoveString(togglesRecentNPCAnim,animName)

	; Return array to original size
	togglesRecentNPCAnim = PapyrusUtil.ResizeStringArray(togglesRecentNPCAnim,5,"")

	; Add new animation to the top of the list
	Int i = togglesRecentNPCAnim.length
	While i > 1
		i -= 1
		togglesRecentNPCAnim[i] = togglesRecentNPCAnim[i - 1]
	EndWhile
	togglesRecentNPCAnim[0] = animName
EndFunction


; Update Failed Actors
Function UpdateFailedNPCs(Actor akActor, String result)
	If akActor != none && slacmcmCurrentPage != "$SLAC_Help"
		; Unshift new failure result
		; This may run asynchronously so we need to work on copies and
		; allow later executions to overwrite previous ones
		
		String refString = "" + akActor
		String id = StringUtil.SubString("" + refString, (StringUtil.GetLength(refString) - 11), 8)
		String actorNameRef = akActor.GetLeveledActorBase().GetName() + " [" + id + "]"
		
		String[] tempNPC = failedActorsNPCs
		String[] tempNPCString = failedActorsNPCsString
		Actor[] tempNPCRef = failedActorsNPCsRef
		Int i = tempNPC.Length
		While i > 1
			i -= 1
			tempNPC[i] = tempNPC[i - 1]
			tempNPCString[i] = tempNPCString[i - 1]
			tempNPCRef[i] = tempNPCRef[i - 1]
		EndWhile
		
		tempNPC[0] = actorNameRef
		tempNPCString[0] = result
		tempNPCRef[0] = akActor
		
		; Page may have been opened while the operation is in progress
		If slacmcmCurrentPage == "$SLAC_Help"
			Return
		EndIf
		failedActorsNPCs = tempNPC
		failedActorsNPCsString = tempNPCString
		failedActorsNPCsRef = tempNPCRef
	EndIf
EndFunction


; Update Failed Creatures
Function UpdateFailedCreatures(Actor akActor, String result)
	If akActor != none && slacmcmCurrentPage != "$SLAC_Help"
		String refString = "" + akActor
		String id = StringUtil.SubString("" + refString, (StringUtil.GetLength(refString) - 11), 8)
		String actorNameRef = akActor.GetLeveledActorBase().GetName() + " [" + id + "]"
		
		; Unshift new failure result
		String[] tempCreatures = failedActorsCreatures
		String[] tempCreaturesString = failedActorsCreaturesString
		Actor[] tempCreaturesRef = failedActorsCreaturesRef
		Int i = tempCreatures.length
		While i > 1
			i -= 1
			tempCreatures[i] = tempCreatures[i - 1]
			tempCreaturesString[i] = tempCreaturesString[i - 1]
			tempCreaturesRef[i] = tempCreaturesRef[i - 1]
		EndWhile
		
		tempCreatures[0] = actorNameRef
		tempCreaturesString[0] = result
		tempCreaturesRef[0] = akActor
		
		; Page may have been opened while the operation is in progress
		If slacmcmCurrentPage == "$SLAC_Help"
			slacUtility.Log("UpdateFailedCreatures halted: discarding result " + actorNameRef + " " + result)
			Return
		EndIf
		failedActorsCreatures = tempCreatures
		failedActorsCreaturesString = tempCreaturesString
		failedActorsCreaturesRef = tempCreaturesRef
	EndIf
EndFunction


; Clear failure lists
Function ClearFailData()
	failedActorsNPCs = New String[10]
	failedActorsNPCsString = New String[10]
	failedActorsNPCsRef = New Actor[10]
	failedActorsCreatures = New String[10]
	failedActorsCreaturesString = New String[10]
	failedActorsCreaturesRef = New Actor[10]
	failedActorsNPCsOID = new Int[10]
	failedActorsCreaturesOID = new Int[10]
EndFunction


; Update all pursuit global variables from config values
Function UpdateGlobals()
	Log("Updating Globals")
	slac_ModActive.SetValue(modActive as Int)
	slac_DebugScanShaders.SetValue(debugScanShaders as Int)
	slac_ScanCloakCreatureSpell.SetNthEffectMagnitude(0, cloakRadius) ; Cloak spell magic items use magnitude as radius in feet
	slac_ScanCloakCreatureSpell.SetNthEffectMagnitude(1, cloakRadius) ; Cloak spell magic items use magnitude as radius in feet
	slac_ScanRadius.SetValue(cloakRadius * UNITFOOTRATIO)
	slac_EngageRadius.SetValue(engageRadius * UNITFOOTRATIO)
	slac_PursuitCaptureRadiusPC.SetValue(pursuitCaptureRadiusPC * UNITFOOTRATIO)
	slac_PursuitCaptureRadiusNPC.SetValue(pursuitCaptureRadiusNPC * UNITFOOTRATIO)
	slac_PursuitCaptureRadiusPCSafe.SetValue((pursuitCaptureRadiusPC * UNITFOOTRATIO) + 50)
	slac_PursuitCaptureRadiusNPCSafe.SetValue((pursuitCaptureRadiusNPC * UNITFOOTRATIO) + 50)
	slac_PursuitEscapeRadiusPC.SetValue(pursuitEscapeRadiusPC * UNITFOOTRATIO)
	slac_PursuitEscapeRadiusNPC.SetValue(pursuitEscapeRadiusNPC * UNITFOOTRATIO)
	slac_nonFollowerDialogueEnabled.SetValue(nonFollowerDialogueEnabled as Int)
	slac_allCreatureDialogueEnabled.SetValue(allCreatureDialogueEnabled as Int)
	slac_FollowerDialogueArousalMin.SetValue(followerCommandThreshold)
	slac_FollowerDialogueArousalEager.SetValue(followerCommandThreshold + (100 - followerCommandThreshold) / 2)
	slac_CreatureDialogueArousalMin.SetValue(creatureCommandThreshold)
	slac_HorseRefusalPCThreshold.SetValue(horseRefusalPCThreshold)
	slac_AllowCombatEngagements.SetValue(allowCombatEngagements as Int)
	slac_AllowMM.Setvalue((allowNPCMM || allowNPCMM) as Int)
	slac_AllowFF.Setvalue((allowPCFF || allowNPCFF) as Int)
	slac_QueueTypePC.Setvalue(queueTypePC)
	slac_QueueTypeNPC.Setvalue(queueTypeNPC)
	
	slac_AllowCreatureDialogueMale.Setvalue(CondInt(creatureDialogueSex != 1, 1, 0))
	slac_AllowCreatureDialogueFemale.Setvalue(CondInt(creatureDialogueSex != 0, 1, 0))
	
	slac_AllowMaleDialogue.Setvalue(CondInt(followerDialogueGenderIndex != 1, 1, 0))
	slac_AllowFemaleDialogue.Setvalue(CondInt(followerDialogueGenderIndex != 0, 1, 0))
	
	UpdateGameTimeModulo()
	debugSLAC && Log("Updating Globals: Utility.GetCurrentGameTime() = " + Utility.GetCurrentGameTime())
	debugSLAC && Log("Updating Globals: CurrentGameTimeModulo = " + slac_CurrentGameTimeModulo.GetValue())
EndFunction


; Calculate game day modulo 100 for dialogue tests
Function UpdateGameTimeModulo()
	slac_CurrentGameTimeModulo.SetValue(Math.Floor(Utility.GetCurrentGameTime()) % 100)
EndFunction


; Invoking Stop()/Start() on quests can cause the MCM to become unresponsive so this needs to be 
; done while the MCM is closed. OnConfigClose() fires when this particular MCM closes but the UI 
; is still open which causes the issue.
Function SyncQuests()
	; Enable / Disable Follower Dialogue
	If modActive && !slac_FollowerDialogue.IsRunning() && followerDialogueEnabled == True
		Log("Starting Follower Dialogue Quest", forceTrace = True)
		slac_FollowerDialogue.Start()
		slacUtility.CreatureDialogueCreatureRef.Clear()
		slacUtility.CreatureDialogueVictimRef.Clear()
		slacUtility.CreatureDialogueTargetRef.Clear()
		slacUtility.CreatureDialogueForcedRef.Clear()
	ElseIf !modActive || (slac_FollowerDialogue.IsRunning() && followerDialogueEnabled == False)
		Log("Stopping Follower Dialogue Quest", forceTrace = True)
		slac_FollowerDialogue.Stop()
		slacUtility.CreatureDialogueCreatureRef.Clear()
		slacUtility.CreatureDialogueVictimRef.Clear()
		slacUtility.CreatureDialogueTargetRef.Clear()
		slacUtility.CreatureDialogueForcedRef.Clear()
	EndIf
	
	; Reset follower dialogue signal for bribe/intimidate/persuade
	; This should never be reset while in dialogue or if the follower scene is running
	; We know the player is not in dialogue as they MCM is open
	If !slac_FollowerDialogueScene.IsPlaying()
		slac_FollowerDialogueSignal.SetValue(0)
	EndIf
	
	; Enable / Disable Creature Dialogue
	If modActive && !slac_CreatureDialogue.IsRunning() && creatureDialogueEnabled == True
		Log("Starting Creature Dialogue Quest", forceTrace = True)
		slac_CreatureDialogue.Start()
	ElseIf !modActive || (slac_CreatureDialogue.IsRunning() && creatureDialogueEnabled == False)
		Log("Stopping Creature Dialogue Quest", forceTrace = True)
		slac_CreatureDialogue.Stop()
	EndIf
	
	; Update Suitors - this allows clearing suitors even if it has been disabled
	slacUtility.UpdateSuitors()
	
	; Hide struggle meter - this can throw errors if the meter is not present so we do it last.
	;!struggleMeterHidden && slacUtility.WidgetManager.StopMeter()
EndFunction


; Save Settings Profile
Bool Function SaveSettings(Int profileID)
	; Save current settings to file
	String filename = filePath + filePrefix + profileID + ".json"
	
	; Cleanup for legacy settings
	JsonUtil.UnsetStringValue(fileName, "allowedracekeypclist")
	JsonUtil.UnsetStringValue(fileName, "disallowedracekeypclist")
	
	; Version
	JsonUtil.SetIntValue(filename, "SLACMCMVersion", GetVersion())
	JsonUtil.SetFloatValue(filename, "SLACGameTime", Utility.GetCurrentGameTime())
	JsonUtil.SetFloatValue(filename, "SLACPlayTime", Game.GetRealHoursPassed())
	JsonUtil.SetStringValue(filename, "SLACPCName", Game.GetPlayer().GetLeveledActorBase().GetName())
	JsonUtil.SetIntValue(filename, "SLACPCLevel", Game.GetPlayer().GetLevel())
	JsonUtil.SetStringValue(filename, "slacProfileSaveName", slacProfileSaveName)
	
	; General Settings - Global
	;JsonUtil.SetIntValue(filename, "nextEngageTime", nextEngageTime)
	JsonUtil.SetIntValue(filename, "requireLos", requireLos as Int)
	JsonUtil.SetIntValue(filename, "engageRadius", engageRadius)
	JsonUtil.SetIntValue(filename, "noSittingActors", noSittingActors as Int)
	JsonUtil.SetIntValue(filename, "noSleepingActors", noSleepingActors as Int)
	JsonUtil.SetIntValue(filename, "onHitInterrupt", onHitInterrupt as Int)
	JsonUtil.SetIntValue(filename, "relationshipRankMin", relationshipRankMin)
	JsonUtil.SetIntValue(filename, "actorPreferenceIndex", actorPreferenceIndex)
	JsonUtil.SetIntValue(filename, "allowEnemies", allowEnemies as Int)
	
	; General Settings - Performance
	JsonUtil.SetIntValue(filename, "modActive", modActive as Int)
	JsonUtil.SetIntValue(filename, "debugSLAC", debugSLAC as Int)
	JsonUtil.SetIntValue(filename, "debugScanShaders", debugScanShaders as Int)
	JsonUtil.SetIntValue(filename, "countMax", countMax)
	JsonUtil.SetIntValue(filename, "creatureCountMax", creatureCountMax)
	JsonUtil.SetIntValue(filename, "checkFrequency", checkFrequency)
	JsonUtil.SetIntValue(filename, "cloakRadius", cloakRadius)
	JsonUtil.SetIntValue(filename, "SLAnimationMax", SLAnimationMax)

	; PC/NPC Settings
	If AutoToggleState
		; Use stored states while auto-engagement 
		JsonUtil.SetIntValue(filename, "pcActive", LastPCActive as Int)
		JsonUtil.SetIntValue(filename, "npcActive", LastNPCActive as Int)
	Else
		JsonUtil.SetIntValue(filename, "pcActive", pcActive as Int)
		JsonUtil.SetIntValue(filename, "npcActive", npcActive as Int)
	EndIf
	JsonUtil.SetIntValue(filename, "showNotifications", showNotifications as Int)
	JsonUtil.SetIntValue(filename, "showNotificationsNPC", showNotificationsNPC as Int)
	JsonUtil.SetIntValue(filename, "allowFamiliarsPC", allowFamiliarsPC as Int)
	JsonUtil.SetIntValue(filename, "allowFamiliarsNPC", allowFamiliarsNPC as Int)
	JsonUtil.SetIntValue(filename, "allowedNPCFollowers", allowedNPCFollowers)
	JsonUtil.SetIntValue(filename, "allowedPCCreatureFollowers", allowedPCCreatureFollowers)
	JsonUtil.SetIntValue(filename, "allowedNPCCreatureFollowers", allowedNPCCreatureFollowers)
	JsonUtil.SetIntValue(filename, "cooldownPC", cooldownPC)
	JsonUtil.SetIntValue(filename, "cooldownNPC", cooldownNPC)
	;JsonUtil.SetIntValue(filename, "cooldownNPCGlobal", cooldownNPCGlobal as Int)
	JsonUtil.SetIntValue(filename, "cooldownNPCType", cooldownNPCType)
	JsonUtil.SetIntValue(filename, "OnlyPermittedCreaturesPC", OnlyPermittedCreaturesPC as Int)
	JsonUtil.SetIntValue(filename, "OnlyPermittedCreaturesNPC", OnlyPermittedCreaturesNPC as Int)
	
	; PC/NPC Settings - Arousal & Consent
	JsonUtil.SetIntValue(filename, "pcCreatureArousalMin", pcCreatureArousalMin)
	JsonUtil.SetIntValue(filename, "npcCreatureArousalMin", npcCreatureArousalMin)
	JsonUtil.SetIntValue(filename, "pcArousalMin", pcArousalMin)
	JsonUtil.SetIntValue(filename, "npcArousalMin", npcArousalMin)
	JsonUtil.SetIntValue(filename, "pcConsensualIndex", pcConsensualIndex)
	JsonUtil.SetIntValue(filename, "npcConsensualIndex", npcConsensualIndex)
	JsonUtil.SetIntValue(filename, "pcRequiredArousalIndex", pcRequiredArousalIndex)
	JsonUtil.SetIntValue(filename, "npcRequiredArousalIndex", npcRequiredArousalIndex)

	; PC/NPC Settings - Gender
	JsonUtil.SetIntValue(filename, "pcCreatureSexValue", pcCreatureSexValue)
	JsonUtil.SetIntValue(filename, "npcCreatureSexValue", npcCreatureSexValue)
	JsonUtil.SetIntValue(filename, "pcVictimSexValue", pcVictimSexValue)
	JsonUtil.SetIntValue(filename, "npcVictimSexValue", npcVictimSexValue)
	JsonUtil.SetIntValue(filename, "allowPCMM", allowPCMM as Int)
	JsonUtil.SetIntValue(filename, "allowPCFF", allowPCFF as Int)
	JsonUtil.SetIntValue(filename, "allowNPCMM", allowNPCMM as Int)
	JsonUtil.SetIntValue(filename, "allowNPCFF", allowNPCFF as Int)
	
	; PC/NPC Settings - Armor & Clothing
	JsonUtil.SetIntValue(filename, "AllowHeavyArmorPC", AllowHeavyArmorPC as Int)
	JsonUtil.SetIntValue(filename, "AllowLightArmorPC", AllowLightArmorPC as Int)
	JsonUtil.SetIntValue(filename, "AllowClothingPC", AllowClothingPC as Int)
	JsonUtil.SetIntValue(filename, "AllowHeavyArmorNPC", AllowHeavyArmorNPC as Int)
	JsonUtil.SetIntValue(filename, "AllowLightArmorNPC", AllowLightArmorNPC as Int)
	JsonUtil.SetIntValue(filename, "AllowClothingNPC", AllowClothingNPC as Int)
	JsonUtil.SetIntValue(filename, "CreatureNakedArousalModPC", CreatureNakedArousalModPC)
	JsonUtil.SetIntValue(filename, "CreatureNakedArousalModNPC", CreatureNakedArousalModNPC)
	
	; PC/NPC Settings - Pursuit
	JsonUtil.SetIntValue(filename, "pursuitQuestPC", pursuitQuestPC as Int)
	JsonUtil.SetIntValue(filename, "pursuitQuestNPC", pursuitQuestNPC as Int)
	JsonUtil.SetIntValue(filename, "slac_Pursuit00Pounce", slac_Pursuit00Pounce.GetValue() as Int)
	JsonUtil.SetIntValue(filename, "slac_Pursuit01Pounce", slac_Pursuit01Pounce.GetValue() as Int)
	JsonUtil.SetIntValue(filename, "slac_Pursuit01Flee", slac_Pursuit01Flee.GetValue() as Int)
	JsonUtil.SetIntValue(filename, "pursuitCaptureRadiusPC", pursuitCaptureRadiusPC)
	JsonUtil.SetIntValue(filename, "pursuitCaptureRadiusNPC", pursuitCaptureRadiusNPC)
	JsonUtil.SetIntValue(filename, "pursuitEscapeRadiusPC", pursuitEscapeRadiusPC)
	JsonUtil.SetIntValue(filename, "pursuitEscapeRadiusNPC", pursuitEscapeRadiusNPC)
	JsonUtil.SetIntValue(filename, "pursuitMaxTimePC", pursuitMaxTimePC)
	JsonUtil.SetIntValue(filename, "pursuitMaxTimeNPC", pursuitMaxTimeNPC)
	JsonUtil.SetIntValue(filename, "pursuitInviteAnimationPC", pursuitInviteAnimationPC)
	
	; PC/NPC Settings - Queueing
	JsonUtil.SetIntValue(filename, "queueLengthMaxPC", queueLengthMaxPC)
	JsonUtil.SetIntValue(filename, "queueLengthMaxNPC", queueLengthMaxNPC)
	JsonUtil.SetIntValue(filename, "allowQueueLeaversPC", allowQueueLeaversPC as Int)
	JsonUtil.SetIntValue(filename, "allowQueueLeaversNPC", allowQueueLeaversNPC as Int)
	JsonUtil.SetIntValue(filename, "consensualQueuePC", consensualQueuePC)
	JsonUtil.SetIntValue(filename, "consensualQueueNPC", consensualQueueNPC)
	JsonUtil.SetIntValue(filename, "queueTypePC", queueTypePC)
	JsonUtil.SetIntValue(filename, "queueTypeNPC", queueTypeNPC)
	
	; PC/NPC Settings - Orgy
	JsonUtil.SetIntValue(filename, "orgyModePC", orgyModePC as Int)
	JsonUtil.SetIntValue(filename, "orgyModeNPC", orgyModeNPC as Int)
	JsonUtil.SetIntValue(filename, "orgyArousalMinPC", orgyArousalMinPC)
	JsonUtil.SetIntValue(filename, "orgyArousalMinNPC", orgyArousalMinNPC)
	JsonUtil.SetIntValue(filename, "orgyArousalMinPCCreature", orgyArousalMinPCCreature)
	JsonUtil.SetIntValue(filename, "orgyArousalMinNPCCreature", orgyArousalMinNPCCreature)
	JsonUtil.SetIntValue(filename, "orgyRequiredArousalPCIndex", orgyRequiredArousalPCIndex)
	JsonUtil.SetIntValue(filename, "orgyRequiredArousalNPCIndex", orgyRequiredArousalNPCIndex)
	JsonUtil.SetIntValue(filename, "orgyConsentPCIndex", orgyConsentPCIndex)
	JsonUtil.SetIntValue(filename, "orgyConsentNPCIndex", orgyConsentNPCIndex)

	; PC/NPC Settings - Creature Grouping
	JsonUtil.SetIntValue(filename, "groupChancePC", groupChancePC)
	JsonUtil.SetIntValue(filename, "groupChanceNPC", groupChanceNPC)
	JsonUtil.SetIntValue(filename, "groupMaxExtrasPC", groupMaxExtrasPC)
	JsonUtil.SetIntValue(filename, "groupMaxExtrasNPC", groupMaxExtrasNPC)
	JsonUtil.SetIntValue(filename, "groupArousalPC", groupArousalPC)
	JsonUtil.SetIntValue(filename, "groupArousalNPC", groupArousalNPC)
	
	; PC/NPC Settings - Locations
	JsonUtil.SetIntValue(filename, "LocationCityAllowPC", LocationCityAllowPC as Int)
	JsonUtil.SetIntValue(filename, "LocationTownAllowPC", LocationTownAllowPC as Int)
	JsonUtil.SetIntValue(filename, "LocationDwellingAllowPC", LocationDwellingAllowPC as Int)
	JsonUtil.SetIntValue(filename, "LocationInnAllowPC", LocationInnAllowPC as Int)
	JsonUtil.SetIntValue(filename, "LocationPlayerHouseAllowPC", LocationPlayerHouseAllowPC as Int)
	JsonUtil.SetIntValue(filename, "LocationDungeonAllowPC", LocationDungeonAllowPC as Int)
	JsonUtil.SetIntValue(filename, "LocationDungeonClearedAllowPC", LocationDungeonClearedAllowPC as Int)
	JsonUtil.SetIntValue(filename, "LocationOtherAllowPC", LocationOtherAllowPC as Int)
	
	JsonUtil.SetIntValue(filename, "LocationCityAllowNPC", LocationCityAllowNPC as Int)
	JsonUtil.SetIntValue(filename, "LocationTownAllowNPC", LocationTownAllowNPC as Int)
	JsonUtil.SetIntValue(filename, "LocationDwellingAllowNPC", LocationDwellingAllowNPC as Int)
	JsonUtil.SetIntValue(filename, "LocationInnAllowNPC", LocationInnAllowNPC as Int)
	JsonUtil.SetIntValue(filename, "LocationPlayerHouseAllowNPC", LocationPlayerHouseAllowNPC as Int)
	JsonUtil.SetIntValue(filename, "LocationDungeonAllowNPC", LocationDungeonAllowNPC as Int)
	JsonUtil.SetIntValue(filename, "LocationDungeonClearedAllowNPC", LocationDungeonClearedAllowNPC as Int)
	JsonUtil.SetIntValue(filename, "LocationOtherAllowNPC", LocationOtherAllowNPC as Int)
	
	; PC/NPC Settings - PC/NPC Only
	JsonUtil.SetIntValue(filename, "OnlyPermittedNPCs", OnlyPermittedNPCs as Int)
	JsonUtil.SetIntValue(filename, "pcAllowWeapons", pcAllowWeapons as Int)
	JsonUtil.SetIntValue(filename, "allowElders", allowElders as Int)
	JsonUtil.SetIntValue(filename, "inviteAnimationNPC", inviteAnimationNPC)
	JsonUtil.SetIntValue(filename, "pcCrouchIndex", pcCrouchIndex)
	
	; PC/NPC Settings - Male NPCs
	JsonUtil.SetIntValue(filename, "NPCMaleArousalMin", NPCMaleArousalMin)
	JsonUtil.SetIntValue(filename, "NPCMaleCreatureArousalMin", NPCMaleCreatureArousalMin)
	JsonUtil.SetIntValue(filename, "NPCMaleRequiredArousalIndex", NPCMaleRequiredArousalIndex)
	JsonUtil.SetIntValue(filename, "NPCMaleConsensualIndex", NPCMaleConsensualIndex)
	JsonUtil.SetIntValue(filename, "NPCMaleQueuing", NPCMaleQueuing as Int)
	JsonUtil.SetIntValue(filename, "NPCMaleAllowVictim", NPCMaleAllowVictim)

	; SLAC Dialogue & Interactions - Invitation
	JsonUtil.SetIntValue(filename, "inviteTargetKey", inviteTargetKey)
	JsonUtil.SetIntValue(filename, "inviteArousalMin", inviteArousalMin)
	JsonUtil.SetIntValue(filename, "inviteConsentPCIndex", inviteConsentPCIndex)
	JsonUtil.SetIntValue(filename, "inviteAnimationPC", inviteAnimationPC)
	JsonUtil.SetIntValue(filename, "inviteStripDelayPC", inviteStripDelayPC)
	JsonUtil.SetIntValue(filename, "inviteOpensHorseDialogue", inviteOpensHorseDialogue as Int)
	JsonUtil.SetIntValue(filename, "inviteOpensCreatureDialogue", inviteOpensCreatureDialogue as Int)
	JsonUtil.SetIntValue(filename, "inviteCreatureSex", inviteCreatureSex)
	
	; SLAC Dialogue & Interactions - Suitors
	JsonUtil.SetIntValue(filename, "suitorsMaxPC", suitorsMaxPC)
	JsonUtil.SetIntValue(filename, "suitorsPCArousalMin", suitorsPCArousalMin)
	JsonUtil.SetIntValue(filename, "suitorsPCAllowWeapons", suitorsPCAllowWeapons as Int)
	JsonUtil.SetIntValue(filename, "suitorsPCAllowLeave", suitorsPCAllowLeave as Int)
	JsonUtil.SetIntValue(filename, "suitorsPCCrouchEffect", suitorsPCCrouchEffect)
	JsonUtil.SetIntValue(filename, "suitorsPCOnlyNaked", suitorsPCOnlyNaked as Int)
	JsonUtil.SetIntValue(filename, "suitorsPCAllowFollowers", suitorsPCAllowFollowers as Int)
	
	; SLAC Dialogue & Interactions - Struggle
	JsonUtil.SetIntValue(filename, "struggleEnabled", struggleEnabled as Int)
	JsonUtil.SetIntValue(filename, "struggleKeyOne", struggleKeyOne)
	JsonUtil.SetIntValue(filename, "struggleKeyTwo", struggleKeyTwo)
	JsonUtil.SetFloatValue(filename, "struggleStaminaDamage", struggleStaminaDamage)
	JsonUtil.SetFloatValue(filename, "struggleStaminaDamageMultiplier", struggleStaminaDamageMultiplier)
	JsonUtil.SetFloatValue(filename, "struggleTimingOne", struggleTimingOne)
	JsonUtil.SetFloatValue(filename, "struggleTimingTwo", struggleTimingTwo)
	JsonUtil.SetIntValue(filename, "struggleMeterHidden", struggleMeterHidden as Int)
	JsonUtil.SetIntValue(filename, "struggleFailureEnabled", struggleFailureEnabled as Int)
	JsonUtil.SetIntValue(filename, "struggleExhaustionMode", struggleExhaustionMode)
	JsonUtil.SetIntValue(filename, "struggleExhaustionDuration", slacUtility.slac_StaminaDrainSpell.GetNthEffectDuration(0) as Int)
	JsonUtil.SetIntValue(filename, "struggleQueueEscape", struggleQueueEscape as Int)
	JsonUtil.SetIntValue(filename, "widgetXPositionNPC", widgetXPositionNPC as Int)
	JsonUtil.SetIntValue(filename, "widgetYPositionNPC", widgetYPositionNPC as Int)
	
	; SLAC Dialogue & Interactions - Actor Selection
	JsonUtil.SetIntValue(filename, "targetKey", targetKey)
	
	; SLAC Dialogue & Interactions - Player Horse
	JsonUtil.SetIntValue(filename, "horseRefusalPCMounting", horseRefusalPCMounting as Int)
	JsonUtil.SetIntValue(filename, "horseRefusalPCRiding", horseRefusalPCRiding as Int)
	JsonUtil.SetIntValue(filename, "horseRefusalPCThreshold", horseRefusalPCThreshold)
	JsonUtil.SetIntValue(filename, "horseRefusalPCSex", horseRefusalPCSex)
	JsonUtil.SetIntValue(filename, "horseRefusalPCEngage", horseRefusalPCEngage as Int)
	
	; SLAC Dialogue & Interactions - Follower Commands
	JsonUtil.SetIntValue(filename, "followerDialogueEnabled", followerDialogueEnabled as Int)
	JsonUtil.SetIntValue(filename, "nonFollowerDialogueEnabled", nonFollowerDialogueEnabled as Int)
	JsonUtil.SetIntValue(filename, "followerCommandThreshold", followerCommandThreshold)
	JsonUtil.SetIntValue(filename, "creatureCommandThreshold", creatureCommandThreshold)
	JsonUtil.SetIntValue(filename, "followerDialogueGenderIndex", followerDialogueGenderIndex)

	; SLAC Dialogue & Interactions - Creature Dialogue
	JsonUtil.SetIntValue(filename, "creatureDialogueEnabled", creatureDialogueEnabled as Int)
	JsonUtil.SetIntValue(filename, "allCreatureDialogueEnabled", allCreatureDialogueEnabled as Int)
	JsonUtil.SetIntValue(filename, "creatureDialogueAllowSilent", creatureDialogueAllowSilent as Int)
	JsonUtil.SetIntValue(filename, "creatureDialogueAllowHorses", creatureDialogueAllowHorses as Int)
	JsonUtil.SetIntValue(filename, "creatureDialogueAllowSteal", creatureDialogueAllowSteal as Int)
	JsonUtil.SetIntValue(filename, "creatureDialogueSex", creatureDialogueSex)

	; Allowed Creatures
	JsonUtil.SetStringValue(filename, "disallowedRaceKeyFPCList", PapyrusUtil.StringJoin(disallowedRaceKeyFPCList,","))
	JsonUtil.SetStringValue(filename, "disallowedRaceKeyMPCList", PapyrusUtil.StringJoin(disallowedRaceKeyMPCList,","))
	JsonUtil.SetStringValue(filename, "disallowedRaceKeyFNPCList", PapyrusUtil.StringJoin(disallowedRaceKeyFNPCList,","))
	JsonUtil.SetStringValue(filename, "disallowedRaceKeyMNPCList", PapyrusUtil.StringJoin(disallowedRaceKeyMNPCList,","))

	; Record Aggressive Toggles
	SexLab.AnimSlots.ClearAnimCache()
	JsonUtil.StringListClear(filename, "AggressiveAnimations")
	JsonUtil.StringListClear(filename, "NonAggressiveAnimations")
	sslBaseAnimation[] aggrAnims
	sslBaseAnimation[] nonAggrAnims
	Int p = 2
	While p <= 5
		aggrAnims = SexLab.GetCreatureAnimationsByTags(ActorCount = p, Tags = "Aggressive", TagSuppress = "AggressiveDefault", RequireAll = False)
		nonAggrAnims = SexLab.GetCreatureAnimationsByTags(ActorCount = p, Tags = "AggressiveDefault", TagSuppress = "Aggressive", RequireAll = False)
		Int i = 0
		While i < aggrAnims.Length
			JsonUtil.StringListAdd(filename, "AggressiveAnimations", aggrAnims[i].Name)
			i += 1
		EndWhile
		i = 0
		While i < nonAggrAnims.Length
			JsonUtil.StringListAdd(filename, "NonAggressiveAnimations", nonAggrAnims[i].Name)
			i += 1
		EndWhile
		p += 1
	EndWhile
	JsonUtil.SetStringValue(filename, "aggressiveTogglesTags", aggressiveTogglesTags)
	JsonUtil.SetStringValue(filename, "aggressiveTogglesRaceKey", aggressiveTogglesRaceKey)
	JsonUtil.SetIntValue(filename, "animationsPerPage", animationsPerPage)
	
	; Other Settings - Trans Options
	JsonUtil.SetIntValue(filename, "TransMFTreatAsPC", TransMFTreatAsPC as Int)
	JsonUtil.SetIntValue(filename, "TransFMTreatAsPC", TransFMTreatAsPC as Int)
	JsonUtil.SetIntValue(filename, "TransMFTreatAsNPC", TransMFTreatAsNPC as Int)
	JsonUtil.SetIntValue(filename, "TransFMTreatAsNPC", TransFMTreatAsNPC as Int)
	
	; Other Settings - Animation Selection
	JsonUtil.SetIntValue(filename, "restrictAggressivePC", restrictAggressivePC as Int)
	JsonUtil.SetIntValue(filename, "restrictAggressiveNPC", restrictAggressiveNPC as Int)
	JsonUtil.SetIntValue(filename, "restrictConsensualPC", restrictConsensualPC as Int)
	JsonUtil.SetIntValue(filename, "restrictConsensualNPC", restrictConsensualNPC as Int)
	;JsonUtil.SetIntValue(filename, "allowMaleReceiverPC", allowMaleReceiverPC as Int)
	;JsonUtil.SetIntValue(filename, "allowMaleReceiverNPC", allowMaleReceiverNPC as Int)
	
	JsonUtil.SetIntValue(filename, "FemalePCRoleWithMaleCreature", FemalePCRoleWithMaleCreature) ; Female
	JsonUtil.SetIntValue(filename, "FemalePCRoleWithFemaleCreature", FemalePCRoleWithFemaleCreature) ; Male
	JsonUtil.SetIntValue(filename, "MalePCRoleWithMaleCreature", MalePCRoleWithMaleCreature) ; Male
	JsonUtil.SetIntValue(filename, "MalePCRoleWithFemaleCreature", MalePCRoleWithFemaleCreature) ; Male
	
	JsonUtil.SetIntValue(filename, "FemaleNPCRoleWithMaleCreature", FemaleNPCRoleWithMaleCreature) ; Female
	JsonUtil.SetIntValue(filename, "FemaleNPCRoleWithFemaleCreature", FemaleNPCRoleWithFemaleCreature) ; Male
	JsonUtil.SetIntValue(filename, "MaleNPCRoleWithMaleCreature", MaleNPCRoleWithMaleCreature) ; Male
	JsonUtil.SetIntValue(filename, "MaleNPCRoleWithFemaleCreature", MaleNPCRoleWithFemaleCreature) ; Male
	
	JsonUtil.SetIntValue(filename, "NonConsensualIsAlwaysMFPC", NonConsensualIsAlwaysMFPC as Int)
	JsonUtil.SetIntValue(filename, "NonConsensualIsAlwaysMFNPC", NonConsensualIsAlwaysMFNPC as Int)

	; Other Settings - Compatibility
	JsonUtil.SetIntValue(filename, "submit", submit as Int)
	JsonUtil.SetIntValue(filename, "defeat", defeat as Int)
	JsonUtil.SetIntValue(filename, "DeviousDevicesFilter", DeviousDevicesFilter as Int)
	JsonUtil.SetIntValue(filename, "NakedDefeatFilter", NakedDefeatFilter as Int)
	JsonUtil.SetIntValue(filename, "deviouslyHelpless", deviouslyHelpless as Int)
	JsonUtil.SetIntValue(filename, "DisplayModelBlockAuto", DisplayModelBlockAuto as Int)
	JsonUtil.SetIntValue(filename, "ToysFilter", ToysFilter as Int)
	JsonUtil.SetIntValue(filename, "DHLPBlockAuto", DHLPBlockAuto as Int)
	JsonUtil.SetIntValue(filename, "DCURBlockAuto", DCURBlockAuto as Int)
	JsonUtil.SetIntValue(filename, "convenientHorses", convenientHorses as Int)
	JsonUtil.SetIntValue(filename, "allowInScene", allowInScene as Int)
	JsonUtil.SetIntValue(filename, "claimActiveActors", claimActiveActors as Int)
	JsonUtil.SetIntValue(filename, "claimQueuedActors", claimQueuedActors as Int)
	JsonUtil.SetIntValue(filename, "disallowMagicInfluenceCharm", disallowMagicInfluenceCharm as Int)
	JsonUtil.SetIntValue(filename, "disallowMagicAllegianceFaction", disallowMagicAllegianceFaction as Int)
	JsonUtil.SetIntValue(filename, "disallowMagicCharmFaction", disallowMagicCharmFaction as Int)
	JsonUtil.SetIntValue(filename, "combatStateChangeCooldown", combatStateChangeCooldown)
	JsonUtil.SetIntValue(filename, "FailedPursuitCooldown", FailedPursuitCooldown)
	JsonUtil.SetIntValue(filename, "weaponsPreventAutoEngagement", weaponsPreventAutoEngagement as Int)
	JsonUtil.SetIntValue(filename, "initMCMPage", initMCMPage)
	JsonUtil.SetIntValue(filename, "useVRCompatibility", useVRCompatibility as Int)
	JsonUtil.SetIntValue(filename, "disableSLACStripping", disableSLACStripping as Int)
	JsonUtil.SetIntValue(filename, "AutoToggleKey", AutoToggleKey)
	JsonUtil.SetIntValue(filename, "SexLabPPlusMode", SexLabPPlusMode as Int)

	; Other Settings - Testing
	JsonUtil.SetIntValue(filename, "skipFilteringStartSex", skipFilteringStartSex as Int)
	JsonUtil.SetIntValue(filename, "allowCombatEngagements", allowCombatEngagements as Int)
	JsonUtil.SetIntValue(filename, "allowHostileEngagements", allowHostileEngagements as Int)
	JsonUtil.SetIntValue(filename, "hostileArousalMin", hostileArousalMin)
	JsonUtil.SetIntValue(filename, "allowDialogueAutoEngage", allowDialogueAutoEngage as Int)
	JsonUtil.SetIntValue(filename, "allowMenuAutoEngage", allowMenuAutoEngage as Int)

	; Other Settings - Collars
	JsonUtil.SetIntValue(filename, "onlyCollared", onlyCollared as Int)
	JsonUtil.SetIntValue(filename, "collarAttraction", collarAttraction as Int)
	JsonUtil.SetIntValue(filename, "collaredArousalMin", collaredArousalMin)
	
	; Save settings file
	; While the file will save when the game is saved this allows the user to load a game, 
	; save the settings and then just quit. Should make transferring settings less bothersome.
	If JsonUtil.Unload(filename)
		Log("SaveSettings for profile " + profileID + " succeeded: " + filename, forceTrace = True)
		Return True
	Else
		Log("WARNING: SaveSettings for profile " + profileID + " failed: " + filename, forceTrace = True)
		Return False
	EndIf
EndFunction

; Load Settings Profile
Bool Function LoadSettings(Int profileID)
	; Apply settings from a saved settings profile
	String filename = filePath + filePrefix + profileID + ".json"
	
	Log("LoadSettings for profile " + profileID + ": " + filename, forceTrace = True)

	JsonUtil.Unload(filename, saveChanges = False)
	If !JsonUtil.Load(filename)
		; Error - Missing file / could not load
		Log("WARNING: LoadSettings error parsing profile " + profileID + ": file could not be loaded or is not found at " + filename, forceTrace = True)
		Return False
	ElseIf !JsonUtil.IsGood(filename)
		; Error - JSON formatting
		Log("WARNING: LoadSettings error parsing profile " + profileID + ": syntax error in " + filename, forceTrace = True)
		Return False
	EndIF

	; Version
	Int settingsVersion = JsonUtil.GetIntValue(filename, "SLACMCMVersion", GetVersion())
	slacProfileSaveName = JsonUtil.GetStringValue(filename, "slacProfileSaveName", slacProfileSaveName)
	
	; General Settings - Global
	requireLos = JsonUtil.GetIntValue(filename, "requireLos") as Bool
	engageRadius = JsonUtil.GetIntValue(filename, "engageRadius")
	onHitInterrupt = JsonUtil.GetIntValue(filename, "onHitInterrupt") as Bool
	relationshipRankMin = JsonUtil.GetIntValue(filename, "relationshipRankMin")
	actorPreferenceIndex = JsonUtil.GetIntValue(filename, "actorPreferenceIndex")
	allowEnemies = JsonUtil.GetIntValue(filename, "allowEnemies") as Bool
	allowPCFF = JsonUtil.GetIntValue(filename, "allowPCFF", 0) as Bool
	allowPCMM = JsonUtil.GetIntValue(filename, "allowPCMM", 0) as Bool
	allowNPCFF = JsonUtil.GetIntValue(filename, "allowNPCFF", 0) as Bool
	allowNPCMM = JsonUtil.GetIntValue(filename, "allowNPCMM", 0) as Bool
	; Replace legacy nextEngageTime
	Int tempNextEngageTime = JsonUtil.GetIntValue(filename, "nextEngageTime", 0)
	If tempNextEngageTime > 0
		cooldownNPCType = 0
		cooldownNPC = tempNextEngageTime
	EndIf
	
	; General Settings - Performance
	modActive = JsonUtil.GetIntValue(filename, "modActive") as Bool
	debugSLAC = JsonUtil.GetIntValue(filename, "debugSLAC") as Bool
	If MiscUtil.FileExists("Data/SKSE/Plugins/ArousedCreatures/debugslac.txt")
		Log("LoadSettings: Debug Override Activated", forceTrace = True)
		debugSLAC = True
	EndIf
	debugScanShaders = JsonUtil.GetIntValue(filename, "debugScanShaders") as Bool
	countMax = JsonUtil.GetIntValue(filename, "countMax")
	creatureCountMax = JsonUtil.GetIntValue(filename, "creatureCountMax")
	checkFrequency = JsonUtil.GetIntValue(filename, "checkFrequency")
	cloakRadius = JsonUtil.GetIntValue(filename, "cloakRadius")
	SLAnimationMax = JsonUtil.GetIntValue(filename, "SLAnimationMax", 15)

	; PC/NPC Settings
	AutoToggleState = False
	pcActive = JsonUtil.GetIntValue(filename, "pcActive") as Bool
	npcActive = JsonUtil.GetIntValue(filename, "npcActive") as Bool
	showNotifications = JsonUtil.GetIntValue(filename, "showNotifications") as Bool
	showNotificationsNPC = JsonUtil.GetIntValue(filename, "showNotificationsNPC") as Bool
	allowFamiliarsPC = JsonUtil.GetIntValue(filename, "allowFamiliarsPC") as Bool
	allowFamiliarsNPC = JsonUtil.GetIntValue(filename, "allowFamiliarsNPC") as Bool
	cooldownPC = JsonUtil.GetIntValue(filename, "cooldownPC", 0)
	cooldownNPC = JsonUtil.GetIntValue(filename, "cooldownNPC", 0)
	If settingsVersion < 40025 ; v4.11
		cooldownPC = Math.Ceiling(cooldownPC / 60) * 60
		cooldownNPC = Math.Ceiling(cooldownNPC / 60) * 60
		Log("LoadSettings: Profile from " + settingsVersion + " updating cooldown values to v4.11+ (secs to multiples of 60)")
	EndIf
	;cooldownNPCGlobal = JsonUtil.GetIntValue(filename, "cooldownNPCGlobal", 0) as Bool
	cooldownNPCType = JsonUtil.GetIntValue(filename, "cooldownNPCType", 0)
	allowedNPCFollowers = JsonUtil.GetIntValue(filename, "allowedNPCFollowers", 0)
	allowedPCCreatureFollowers = JsonUtil.GetIntValue(filename, "allowedPCCreatureFollowers", 0)
	allowedNPCCreatureFollowers = JsonUtil.GetIntValue(filename, "allowedNPCCreatureFollowers", 0)
	OnlyPermittedCreaturesPC = JsonUtil.GetIntValue(filename, "OnlyPermittedCreaturesPC", 0) as Bool
	OnlyPermittedCreaturesNPC = JsonUtil.GetIntValue(filename, "OnlyPermittedCreaturesNPC", 0) as Bool
	
	; PC/NPC Settings - Gender
	pcCreatureSexValue = JsonUtil.GetIntValue(filename, "pcCreatureSexValue", 2)
	npcCreatureSexValue = JsonUtil.GetIntValue(filename, "npcCreatureSexValue", 2)
	pcVictimSexValue = JsonUtil.GetIntValue(filename, "pcVictimSexValue")
	npcVictimSexValue = JsonUtil.GetIntValue(filename, "npcVictimSexValue")
	
	If settingsVersion < 40020 ; v4.10
		; update from previous sex value storage
		If pcVictimSexValue == -1
			pcVictimSexValue = 2 ; Both
		ElseIf pcVictimSexValue == 0
			pcVictimSexValue = 0 ; Male
		Else
			pcVictimSexValue = 1 ; Female
		EndIf
		If npcVictimSexValue == -1
			npcVictimSexValue = 2 ; Both
		ElseIf npcVictimSexValue == 0
			npcVictimSexValue = 0 ; Male
		Else
			npcVictimSexValue = 1 ; Female
		EndIf
		
		Log("LoadSettings: Profile from " + settingsVersion + " updating victim sex values to v4.10+ (value -= 1)")
		
		; - 2 = convert existing value, 0 = male
		pcCreatureSexValue = CondInt(pcCreatureSexValue > 1, pcCreatureSexValue - 2, 0)
		npcCreatureSexValue = CondInt(npcCreatureSexValue > 1, npcCreatureSexValue - 2, 0)
		Log("LoadSettings: Profile from " + settingsVersion + " updating creature sex values to v4.10+ (value -= 2)")

	EndIf
	
	; PC/NPC Settings - Arousal & Consent
	pcCreatureArousalMin = JsonUtil.GetIntValue(filename, "pcCreatureArousalMin")
	npcCreatureArousalMin = JsonUtil.GetIntValue(filename, "npcCreatureArousalMin")
	pcArousalMin = JsonUtil.GetIntValue(filename, "pcArousalMin")
	npcArousalMin = JsonUtil.GetIntValue(filename, "npcArousalMin")
	pcConsensualIndex = JsonUtil.GetIntValue(filename, "pcConsensualIndex")
	npcConsensualIndex = JsonUtil.GetIntValue(filename, "npcConsensualIndex")
	pcRequiredArousalIndex = JsonUtil.GetIntValue(filename, "pcRequiredArousalIndex")
	npcRequiredArousalIndex = JsonUtil.GetIntValue(filename, "npcRequiredArousalIndex")
	
	; PC/NPC Settings - Armor & Clothing
	AllowHeavyArmorPC = JsonUtil.GetIntValue(filename, "AllowHeavyArmorPC") as Bool
	AllowLightArmorPC = JsonUtil.GetIntValue(filename, "AllowLightArmorPC") as Bool
	AllowClothingPC = JsonUtil.GetIntValue(filename, "AllowClothingPC") as Bool
	AllowHeavyArmorNPC = JsonUtil.GetIntValue(filename, "AllowHeavyArmorNPC") as Bool
	AllowLightArmorNPC = JsonUtil.GetIntValue(filename, "AllowLightArmorNPC") as Bool
	AllowClothingNPC = JsonUtil.GetIntValue(filename, "AllowClothingNPC") as Bool
	CreatureNakedArousalModPC = JsonUtil.GetIntValue(filename, "CreatureNakedArousalModPC", 100)
	CreatureNakedArousalModNPC = JsonUtil.GetIntValue(filename, "CreatureNakedArousalModNPC", 100)
	
	; PC/NPC Settings - Pursuit
	pursuitQuestPC = JsonUtil.GetIntValue(filename, "pursuitQuestPC") as Bool
	pursuitQuestNPC = JsonUtil.GetIntValue(filename, "pursuitQuestNPC") as Bool
	slac_Pursuit00Pounce.SetValue(JsonUtil.GetIntValue(filename, "slac_Pursuit00Pounce"))
	slac_Pursuit01Pounce.SetValue(JsonUtil.GetIntValue(filename, "slac_Pursuit01Pounce"))
	slac_Pursuit01Flee.SetValue(JsonUtil.GetIntValue(filename, "slac_Pursuit01Flee"))
	pursuitCaptureRadiusPC = JsonUtil.GetIntValue(filename, "pursuitCaptureRadiusPC")
	pursuitCaptureRadiusNPC = JsonUtil.GetIntValue(filename, "pursuitCaptureRadiusNPC")
	pursuitEscapeRadiusPC = JsonUtil.GetIntValue(filename, "pursuitEscapeRadiusPC")
	pursuitEscapeRadiusNPC = JsonUtil.GetIntValue(filename, "pursuitEscapeRadiusNPC")
	pursuitMaxTimePC = JsonUtil.GetIntValue(filename, "pursuitMaxTimePC")
	pursuitMaxTimeNPC = JsonUtil.GetIntValue(filename, "pursuitMaxTimeNPC")
	pursuitInviteAnimationPC = JsonUtil.GetIntValue(filename, "pursuitInviteAnimationPC")
	
	; PC/NPC Settings - Queueing
	queueLengthMaxPC = JsonUtil.GetIntValue(filename, "queueLengthMaxPC", 2)
	queueLengthMaxNPC = JsonUtil.GetIntValue(filename, "queueLengthMaxNPC", 2)
	allowQueueLeaversPC = JsonUtil.GetIntValue(filename, "allowQueueLeaversPC", 0) as Bool
	allowQueueLeaversNPC = JsonUtil.GetIntValue(filename, "allowQueueLeaversNPC", 0) as Bool
	consensualQueuePC = JsonUtil.GetIntValue(filename, "consensualQueuePC", 2)
	consensualQueueNPC = JsonUtil.GetIntValue(filename, "consensualQueueNPC", 2)
	queueTypePC = JsonUtil.GetIntValue(filename, "queueTypePC", 1)
	queueTypeNPC = JsonUtil.GetIntValue(filename, "queueTypeNPC", 1)
	
	; PC/NPC Settings - Orgy
	orgyModePC = JsonUtil.GetIntValue(filename, "orgyModePC") as Bool
	orgyModeNPC = JsonUtil.GetIntValue(filename, "orgyModeNPC") as Bool
	orgyArousalMinPC = JsonUtil.GetIntValue(filename, "orgyArousalMinPC")
	orgyArousalMinNPC = JsonUtil.GetIntValue(filename, "orgyArousalMinNPC")
	orgyArousalMinPCCreature = JsonUtil.GetIntValue(filename, "orgyArousalMinPCCreature")
	orgyArousalMinNPCCreature = JsonUtil.GetIntValue(filename, "orgyArousalMinNPCCreature")
	orgyRequiredArousalPCIndex = JsonUtil.GetIntValue(filename, "orgyRequiredArousalPCIndex")
	orgyRequiredArousalNPCIndex = JsonUtil.GetIntValue(filename, "orgyRequiredArousalNPCIndex")
	orgyConsentPCIndex = JsonUtil.GetIntValue(filename, "orgyConsentPCIndex")
	orgyConsentNPCIndex = JsonUtil.GetIntValue(filename, "orgyConsentNPCIndex")

	; PC/NPC Settings - Creature Grouping
	groupChancePC = JsonUtil.GetIntValue(filename, "groupChancePC")
	groupChanceNPC = JsonUtil.GetIntValue(filename, "groupChanceNPC")
	groupMaxExtrasPC = JsonUtil.GetIntValue(filename, "groupMaxExtrasPC")
	groupMaxExtrasNPC = JsonUtil.GetIntValue(filename, "groupMaxExtrasNPC")
	groupArousalPC = JsonUtil.GetIntValue(filename, "groupArousalPC")
	groupArousalNPC = JsonUtil.GetIntValue(filename, "groupArousalNPC")
	
	; PC/NPC Settings - Locations
	LocationCityAllowPC = JsonUtil.GetIntValue(filename, "LocationCityAllowPC", 1) as Bool
	LocationTownAllowPC = JsonUtil.GetIntValue(filename, "LocationTownAllowPC", 1) as Bool
	LocationDwellingAllowPC = JsonUtil.GetIntValue(filename, "LocationDwellingAllowPC", 1) as Bool
	LocationInnAllowPC = JsonUtil.GetIntValue(filename, "LocationInnAllowPC", 1) as Bool
	LocationPlayerHouseAllowPC = JsonUtil.GetIntValue(filename, "LocationPlayerHouseAllowPC", 1) as Bool
	LocationDungeonAllowPC = JsonUtil.GetIntValue(filename, "LocationDungeonAllowPC", 0) as Bool
	LocationDungeonClearedAllowPC = JsonUtil.GetIntValue(filename, "LocationDungeonClearedAllowPC", 1) as Bool
	LocationOtherAllowPC = JsonUtil.GetIntValue(filename, "LocationOtherAllowPC", 1) as Bool
	LocationCityAllowNPC = JsonUtil.GetIntValue(filename, "LocationCityAllowNPC", 1) as Bool
	LocationTownAllowNPC = JsonUtil.GetIntValue(filename, "LocationTownAllowNPC", 1) as Bool
	LocationDwellingAllowNPC = JsonUtil.GetIntValue(filename, "LocationDwellingAllowNPC", 1) as Bool
	LocationInnAllowNPC = JsonUtil.GetIntValue(filename, "LocationInnAllowNPC", 1) as Bool
	LocationPlayerHouseAllowNPC = JsonUtil.GetIntValue(filename, "LocationPlayerHouseAllowNPC", 1) as Bool
	LocationDungeonAllowNPC = JsonUtil.GetIntValue(filename, "LocationDungeonAllowNPC", 0) as Bool
	LocationDungeonClearedAllowNPC = JsonUtil.GetIntValue(filename, "LocationDungeonClearedAllowNPC", 1) as Bool
	LocationOtherAllowNPC = JsonUtil.GetIntValue(filename, "LocationOtherAllowNPC", 1) as Bool
	
	; PC/NPC Settings - PC/NPC Only
	OnlyPermittedNPCs = JsonUtil.GetIntValue(filename, "OnlyPermittedNPCs", 0) as Bool
	pcAllowWeapons = JsonUtil.GetIntValue(filename, "pcAllowWeapons") as Bool
	allowElders = JsonUtil.GetIntValue(filename, "allowElders") as Bool
	noSittingActors = JsonUtil.GetIntValue(filename, "noSittingActors") as Bool
	noSleepingActors = JsonUtil.GetIntValue(filename, "noSleepingActors") as Bool
	pcCrouchIndex = JsonUtil.GetIntValue(filename, "pcCrouchIndex")
	
	; PC/NPC Settings - Male NPCs
	NPCMaleArousalMin = JsonUtil.GetIntValue(filename, "NPCMaleArousalMin", 60)
	NPCMaleCreatureArousalMin = JsonUtil.GetIntValue(filename, "NPCMaleCreatureArousalMin", 80)
	NPCMaleRequiredArousalIndex = JsonUtil.GetIntValue(filename, "NPCMaleRequiredArousalIndex", 3)
	NPCMaleConsensualIndex = JsonUtil.GetIntValue(filename, "NPCMaleConsensualIndex", 1)
	NPCMaleQueuing = JsonUtil.GetIntValue(filename, "NPCMaleQueuing", 0) as Bool
	NPCMaleAllowVictim = JsonUtil.GetIntValue(filename, "NPCMaleAllowVictim", 3)

	; Dialogue & Interactions - Invitation
	inviteTargetKey = JsonUtil.GetIntValue(filename, "inviteTargetKey")
	inviteArousalMin = JsonUtil.GetIntValue(filename, "inviteArousalMin", 40)
	inviteConsentPCIndex = JsonUtil.GetIntValue(filename, "inviteConsentPCIndex")
	inviteAnimationPC = JsonUtil.GetIntValue(filename, "inviteAnimationPC", 1)
	inviteAnimationNPC = JsonUtil.GetIntValue(filename, "inviteAnimationNPC", 1)
	inviteStripDelayPC = JsonUtil.GetIntValue(filename, "inviteStripDelayPC", 3)
	inviteOpensHorseDialogue = JsonUtil.GetIntValue(filename, "inviteOpensHorseDialogue", 0) as Bool
	inviteOpensCreatureDialogue = JsonUtil.GetIntValue(filename, "inviteOpensCreatureDialogue", 0) as Bool
	inviteCreatureSex = JsonUtil.GetIntValue(filename, "inviteCreatureSex", 2)
	
	; Dialogue & Interactions - Suitors
	suitorsMaxPC = JsonUtil.GetIntValue(filename, "suitorsMaxPC", 0)
	suitorsPCArousalMin = JsonUtil.GetIntValue(filename, "suitorsPCArousalMin", 60)
	suitorsPCAllowWeapons = JsonUtil.GetIntValue(filename, "suitorsPCAllowWeapons", 0) as Bool
	suitorsPCAllowLeave = JsonUtil.GetIntValue(filename, "suitorsPCAllowLeave", 0) as Bool
	suitorsPCCrouchEffect = JsonUtil.GetIntValue(filename, "suitorsPCCrouchEffect", 0)
	suitorsPCOnlyNaked = JsonUtil.GetIntValue(filename, "suitorsPCOnlyNaked", 0) as Bool
	suitorsPCAllowFollowers = JsonUtil.GetIntValue(filename, "suitorsPCAllowFollowers", 0) as Bool
	
	; Dialogue & Interactions - Struggle
	struggleEnabled = JsonUtil.GetIntValue(filename, "struggleEnabled") as Bool
	struggleKeyOne = JsonUtil.GetIntValue(filename, "struggleKeyOne")
	struggleKeyTwo = JsonUtil.GetIntValue(filename, "struggleKeyTwo")
	struggleStaminaDamage = JsonUtil.GetFloatValue(filename, "struggleStaminaDamage")
	struggleStaminaDamageMultiplier = JsonUtil.GetFloatValue(filename, "struggleStaminaDamageMultiplier")
	struggleTimingOne = JsonUtil.GetFloatValue(filename, "struggleTimingOne")
	struggleTimingTwo = JsonUtil.GetFloatValue(filename, "struggleTimingTwo")
	struggleMeterHidden = JsonUtil.GetIntValue(filename, "struggleMeterHidden", 0) as Bool
	struggleFailureEnabled = JsonUtil.GetIntValue(filename, "struggleFailureEnabled") as Bool
	If settingsVersion < 40035 ; pre v4.15
		struggleExhaustionMode = JsonUtil.GetIntValue(filename, "struggleExhaustionEnabled")
	Else
		struggleExhaustionMode = JsonUtil.GetIntValue(filename, "struggleExhaustionMode")
	EndIf
	slacUtility.slac_StaminaDrainSpell.SetNthEffectDuration(0, JsonUtil.GetIntValue(filename, "struggleExhaustionDuration"))
	struggleQueueEscape = JsonUtil.GetIntValue(filename, "struggleQueueEscape") as Bool
	widgetXPositionNPC = JsonUtil.GetIntValue(filename, "widgetXPositionNPC", 925) as Float
	widgetYPositionNPC = JsonUtil.GetIntValue(filename, "widgetYPositionNPC", 655) as Float
	
	; Dialogue & Interactions - Actor Selection
	targetKey = JsonUtil.GetIntValue(filename, "targetKey")
	
	; Dialogue & Interactions - Player Horse
	horseRefusalPCMounting = JsonUtil.GetIntValue(filename, "horseRefusalPCMounting") as Bool
	horseRefusalPCRiding = JsonUtil.GetIntValue(filename, "horseRefusalPCRiding") as Bool
	horseRefusalPCThreshold = JsonUtil.GetIntValue(filename, "horseRefusalPCThreshold")
	horseRefusalPCSex = JsonUtil.GetIntValue(filename, "horseRefusalPCSex")
	horseRefusalPCEngage = JsonUtil.GetIntValue(filename, "horseRefusalPCEngage", 0) as Bool
	
	; Dialogue & Interactions - Follower Commands
	followerDialogueEnabled = JsonUtil.GetIntValue(filename, "followerDialogueEnabled") as Bool
	nonFollowerDialogueEnabled = JsonUtil.GetIntValue(filename, "nonFollowerDialogueEnabled") as Bool
	followerCommandThreshold = JsonUtil.GetIntValue(filename, "followerCommandThreshold")
	creatureCommandThreshold = JsonUtil.GetIntValue(filename, "creatureCommandThreshold", 40)
	followerDialogueGenderIndex = JsonUtil.GetIntValue(filename, "followerDialogueGenderIndex", 1)

	; Dialogue & Interactions - Creature Dialogue
	creatureDialogueEnabled = JsonUtil.GetIntValue(filename, "creatureDialogueEnabled") as Bool
	allCreatureDialogueEnabled = JsonUtil.GetIntValue(filename, "allCreatureDialogueEnabled") as Bool
	creatureDialogueAllowSilent = JsonUtil.GetIntValue(filename, "creatureDialogueAllowSilent") as Bool
	creatureDialogueAllowHorses = JsonUtil.GetIntValue(filename, "creatureDialogueAllowHorses") as Bool
	creatureDialogueAllowSteal = JsonUtil.GetIntValue(filename, "creatureDialogueAllowSteal") as Bool
	creatureDialogueSex = JsonUtil.GetIntValue(filename, "creatureDialogueSex", 2)

	; Allowed Creatures
	If JsonUtil.HasStringValue(filename, "disallowedRaceKeyPCList")
		; Convert old profile allowed list
		disallowedRaceKeyFPCList = PapyrusUtil.StringSplit(JsonUtil.GetStringValue(filename, "disallowedRaceKeyPCList"), ",")
		disallowedRaceKeyMPCList = disallowedRaceKeyFPCList
		disallowedRaceKeyFNPCList = disallowedRaceKeyFPCList
		disallowedRaceKeyMNPCList = disallowedRaceKeyFPCList
	Else
		disallowedRaceKeyFPCList = PapyrusUtil.StringSplit(JsonUtil.GetStringValue(filename, "disallowedRaceKeyFPCList", ""), ",")
		disallowedRaceKeyMPCList = PapyrusUtil.StringSplit(JsonUtil.GetStringValue(filename, "disallowedRaceKeyMPCList", ""), ",")
		disallowedRaceKeyFNPCList = PapyrusUtil.StringSplit(JsonUtil.GetStringValue(filename, "disallowedRaceKeyFNPCList", ""), ",")
		disallowedRaceKeyMNPCList = PapyrusUtil.StringSplit(JsonUtil.GetStringValue(filename, "disallowedRaceKeyMNPCList", ""), ",")
	EndIf
	UpdateRaceKeys()

	; Other Settings - Trans Options
	TransMFTreatAsPC = JsonUtil.GetIntValue(filename, "TransMFTreatAsPC", 1)
	TransFMTreatAsPC = JsonUtil.GetIntValue(filename, "TransFMTreatAsPC", 0)
	TransMFTreatAsNPC = JsonUtil.GetIntValue(filename, "TransMFTreatAsNPC", 1)
	TransFMTreatAsNPC = JsonUtil.GetIntValue(filename, "TransFMTreatAsNPC", 0)
	
	; Other Settings - Animation Selection
	restrictAggressivePC = JsonUtil.GetIntValue(filename, "restrictAggressivePC") as Bool
	restrictAggressiveNPC = JsonUtil.GetIntValue(filename, "restrictAggressiveNPC") as Bool
	restrictConsensualPC = JsonUtil.GetIntValue(filename, "restrictConsensualPC") as Bool
	restrictConsensualNPC = JsonUtil.GetIntValue(filename, "restrictConsensualNPC") as Bool
	;allowMaleReceiverPC = JsonUtil.GetIntValue(filename, "allowMaleReceiverPC") as Bool
	;allowMaleReceiverNPC = JsonUtil.GetIntValue(filename, "allowMaleReceiverNPC") as Bool

	FemalePCRoleWithMaleCreature = JsonUtil.GetIntValue(filename, "FemalePCRoleWithMaleCreature", 1) ; Female
	FemalePCRoleWithFemaleCreature = JsonUtil.GetIntValue(filename, "FemalePCRoleWithFemaleCreature", 0) ; Male
	MalePCRoleWithMaleCreature = JsonUtil.GetIntValue(filename, "MalePCRoleWithMaleCreature", 0) ; Male
	MalePCRoleWithFemaleCreature = JsonUtil.GetIntValue(filename, "MalePCRoleWithFemaleCreature", 0) ; Male
	
	FemaleNPCRoleWithMaleCreature = JsonUtil.GetIntValue(filename, "FemaleNPCRoleWithMaleCreature", 1) ; Female
	FemaleNPCRoleWithFemaleCreature = JsonUtil.GetIntValue(filename, "FemaleNPCRoleWithFemaleCreature", 0) ; Male
	MaleNPCRoleWithMaleCreature = JsonUtil.GetIntValue(filename, "MaleNPCRoleWithMaleCreature", 0) ; Male
	MaleNPCRoleWithFemaleCreature = JsonUtil.GetIntValue(filename, "MaleNPCRoleWithFemaleCreature", 0) ; Male

	NonConsensualIsAlwaysMFPC = JsonUtil.SetIntValue(filename, "NonConsensualIsAlwaysMFPC", 1) as Bool
	NonConsensualIsAlwaysMFNPC = JsonUtil.SetIntValue(filename, "NonConsensualIsAlwaysMFNPC", 1) as Bool

	; Other Settings - Compatibility
	submit = JsonUtil.GetIntValue(filename, "submit", 1) as Bool
	defeat = JsonUtil.GetIntValue(filename, "defeat", 1) as Bool
	DeviousDevicesFilter = JsonUtil.GetIntValue(filename, "DeviousDevicesFilter", 1) as Bool
	NakedDefeatFilter = JsonUtil.GetIntValue(filename, "NakedDefeatFilter", 1) as Bool
	deviouslyHelpless = JsonUtil.GetIntValue(filename, "deviouslyHelpless", 1) as Bool
	DisplayModelBlockAuto = JsonUtil.GetIntValue(filename, "DisplayModelBlockAuto", 1) as Bool
	ToysFilter = JsonUtil.GetIntValue(filename, "ToysFilter", 1) as Bool
	DHLPBlockAuto = JsonUtil.GetIntValue(filename, "DHLPBlockAuto", 1) as Bool
	DCURBlockAuto = JsonUtil.GetIntValue(filename, "DCURBlockAuto", 1) as Bool
	convenientHorses = JsonUtil.GetIntValue(filename, "convenientHorses", 1) as Bool
	allowInScene = JsonUtil.GetIntValue(filename, "allowInScene", 0) as Bool
	claimActiveActors = JsonUtil.GetIntValue(filename, "claimActiveActors", 1) as Bool
	claimActiveActors = JsonUtil.GetIntValue(filename, "claimQueuedActors", 1) as Bool
	disallowMagicInfluenceCharm = JsonUtil.GetIntValue(filename, "disallowMagicInfluenceCharm", 0) as Bool
	disallowMagicAllegianceFaction = JsonUtil.GetIntValue(filename, "disallowMagicAllegianceFaction", 0) as Bool
	disallowMagicCharmFaction = JsonUtil.GetIntValue(filename, "disallowMagicCharmFaction", 0) as Bool
	combatStateChangeCooldown = JsonUtil.GetIntValue(filename, "combatStateChangeCooldown", 0)
	FailedPursuitCooldown = JsonUtil.GetIntValue(filename, "FailedPursuitCooldown", 0)
	weaponsPreventAutoEngagement = JsonUtil.GetIntValue(filename, "weaponsPreventAutoEngagement", 0) as Bool
	If settingsVersion < 40028 ; < v4.12
		weaponsPreventAutoEngagement = JsonUtil.GetIntValue(filename, "weaponsPreventAutoEnagagment", 0) as Bool
	EndIf
	initMCMPage = JsonUtil.GetIntValue(filename, "initMCMPage", 0)
	useVRCompatibility = JsonUtil.GetIntValue(filename, "useVRCompatibility", 0) as Bool
	disableSLACStripping = JsonUtil.GetIntValue(filename, "disableSLACStripping", 0) as Bool
	AutoToggleKey = JsonUtil.GetIntValue(filename, "AutoToggleKey", -1)
	SexLabPPlusMode = JsonUtil.GetIntValue(filename, "SexLabPPlusMode", 1) as Bool

	; Other Settings - Testing
	skipFilteringStartSex = JsonUtil.GetIntValue(filename, "skipFilteringStartSex", 0) as Bool
	allowCombatEngagements = JsonUtil.GetIntValue(filename, "allowCombatEngagements", 0) as Bool
	allowHostileEngagements = JsonUtil.GetIntValue(filename, "allowHostileEngagements", 0) as Bool
	hostileArousalMin = JsonUtil.GetIntValue(filename, "hostileArousalMin", 0)
	allowDialogueAutoEngage = JsonUtil.GetIntValue(filename, "allowDialogueAutoEngage") as Bool
	allowMenuAutoEngage = JsonUtil.GetIntValue(filename, "allowMenuAutoEngage") as Bool

	; Other Settings - Collars
	onlyCollared = JsonUtil.GetIntValue(filename, "onlyCollared") as Bool
	collarAttraction = JsonUtil.GetIntValue(filename, "collarAttraction") as Bool
	collaredArousalMin = JsonUtil.GetIntValue(filename, "collaredArousalMin")
	
	; Sync
	UpdateGlobals()

	; Aggressive Toggles
	aggressiveTogglesTags = JsonUtil.GetStringValue(filename, "aggressiveTogglesTags", "Rough")
	aggressiveTogglesRaceKey = JsonUtil.GetStringValue(filename, "aggressiveTogglesRaceKey", "")
	animationsPerPage = JsonUtil.GetIntValue(filename, "animationsPerPage", 80)

	; Tagging operations may take a while so we'll do this last and let the user leave the menu with a working config
	If slacProfileLoadTags
		Int aggrAnimTotal = JsonUtil.StringListCount(filename, "AggressiveAnimations")
		Int nonAggrAnimTotal = JsonUtil.StringListCount(filename, "NonAggressiveAnimations")
		sslBaseAnimation anim
		
		; Reset aggressive tagging to default
		DefaultAggressiveTags()
		
		; Apply aggressive tagging from profile
		Int i = 0
		While i < aggrAnimTotal
			String animName = JsonUtil.StringListGet(filename, "AggressiveAnimations", i)
			If animName != ""
				anim = SexLab.GetCreatureAnimationByName(animName)
				If anim != None
					anim.AddTag("Aggressive")
				EndIf
			EndIf
			i += 1
		EndWhile

		; Tag as Non-Aggressive
		i = 0
		While i < nonAggrAnimTotal
			String animName = JsonUtil.StringListGet(filename, "NonAggressiveAnimations", i)
			If animName != ""
				anim = SexLab.GetCreatureAnimationByName(animName)
				If anim != None
					anim.RemoveTag("Aggressive")
				EndIf
			EndIf
			i += 1
		EndWhile
	EndIf
	
	Log("LoadSettings for profile " + profileID + " complete.", forceTrace = True)
	Return True
EndFunction


; Dump raw settings to log
Function DumpSettings()
	Log(" --- General Settings - Global --- ", forceTrace = True)
	;Log("nextEngageTime: " + nextEngageTime, forceTrace = True)
	Log("requireLos: " + requireLos, forceTrace = True)
	Log("engageRadius: " + engageRadius, forceTrace = True)
	Log("onHitInterrupt: " + onHitInterrupt, forceTrace = True)
	Log("relationshipRankMin: " + relationshipRankMin, forceTrace = True)
	Log("actorPreferenceIndex: " + actorPreferenceIndex, forceTrace = True)
	Log("allowEnemies: " + allowEnemies, forceTrace = True)
	
	Log(" --- General Settings - Performance --- ", forceTrace = True)
	Log("modActive: " + modActive, forceTrace = True)
	Log("debugSLAC: " + debugSLAC, forceTrace = True)
	Log("debugScanShaders: " + debugScanShaders, forceTrace = True)
	Log("countMax: " + countMax, forceTrace = True)
	Log("creatureCountMax: " + creatureCountMax, forceTrace = True)
	Log("checkFrequency: " + checkFrequency, forceTrace = True)
	Log("cloakRadius: " + cloakRadius, forceTrace = True)

	Log(" --- PC/NPC Settings --- ", forceTrace = True)
	Log("pcActive: " + pcActive, forceTrace = True)
	Log("npcActive: " + npcActive, forceTrace = True)
	Log("AutoToggleState: " + AutoToggleState + " LastPCActive:" + LastPCActive + " LastNPCActive:" + LastNPCActive, forceTrace = True)
	Log("allowedNPCFollowers: " + allowedNPCFollowers, forceTrace = True)
	Log("allowedPCCreatureFollowers: " + allowedPCCreatureFollowers, forceTrace = True)
	Log("allowedNPCCreatureFollowers: " + allowedNPCCreatureFollowers, forceTrace = True)
	Log("showNotifications: " + showNotifications, forceTrace = True)
	Log("showNotificationsNPC: " + showNotificationsNPC, forceTrace = True)
	Log("allowFamiliarsPC: " + allowFamiliarsPC, forceTrace = True)
	Log("allowFamiliarsNPC: " + allowFamiliarsNPC, forceTrace = True)
	Log("cooldownPC: " + cooldownPC, forceTrace = True)
	Log("cooldownNPC: " + cooldownNPC, forceTrace = True)
	;Log("cooldownNPCGlobal: " + cooldownNPCGlobal, forceTrace = True)
	Log("cooldownNPCType: " + cooldownNPCType, forceTrace = True)
	Log("OnlyPermittedCreaturesPC: " + OnlyPermittedCreaturesPC, forceTrace = True)
	Log("OnlyPermittedCreaturesNPC: " + OnlyPermittedCreaturesNPC, forceTrace = True)
	
	Log(" --- PC/NPC Settings - Gender --- ", forceTrace = True)
	Log("pcCreatureSexValue: " + pcCreatureSexValue, forceTrace = True)
	Log("npcCreatureSexValue: " + npcCreatureSexValue, forceTrace = True)
	Log("pcVictimSexValue: " + pcVictimSexValue, forceTrace = True)
	Log("npcVictimSexValue: " + npcVictimSexValue, forceTrace = True)
	Log("allowPCMM: " + allowPCMM, forceTrace = True)
	Log("allowPCFF: " + allowPCFF, forceTrace = True)
	Log("allowNPCMM: " + allowNPCMM, forceTrace = True)
	Log("allowNPCFF: " + allowNPCFF, forceTrace = True)
	
	Log(" --- PC/NPC Settings - Arousal & Consent --- ", forceTrace = True)
	Log("pcCreatureArousalMin: " + pcCreatureArousalMin, forceTrace = True)
	Log("npcCreatureArousalMin: " + npcCreatureArousalMin, forceTrace = True)
	Log("pcArousalMin: " + pcArousalMin, forceTrace = True)
	Log("npcArousalMin: " + npcArousalMin, forceTrace = True)
	Log("pcConsensualIndex: " + pcConsensualIndex, forceTrace = True)
	Log("npcConsensualIndex: " + npcConsensualIndex, forceTrace = True)
	Log("pcRequiredArousalIndex: " + pcRequiredArousalIndex, forceTrace = True)
	Log("npcRequiredArousalIndex: " + npcRequiredArousalIndex, forceTrace = True)

	Log(" --- PC/NPC Settings - Armor & Clothing --- ", forceTrace = True)
	Log("AllowHeavyArmorPC: " + AllowHeavyArmorPC, forceTrace = True)
	Log("AllowLightArmorPC: " + AllowLightArmorPC, forceTrace = True)
	Log("AllowClothingPC: " + AllowClothingPC, forceTrace = True)
	Log("AllowHeavyArmorNPC: " + AllowHeavyArmorNPC, forceTrace = True)
	Log("AllowLightArmorNPC: " + AllowLightArmorNPC, forceTrace = True)
	Log("AllowClothingNPC: " + AllowClothingNPC, forceTrace = True)
	Log("CreatureNakedArousalModPC: " + CreatureNakedArousalModPC, forceTrace = True)
	Log("CreatureNakedArousalModNPC: " + CreatureNakedArousalModNPC, forceTrace = True)
	
	Log(" --- PC/NPC Settings - Pursuit --- ", forceTrace = True)
	Log("pursuitQuestPC: " + pursuitQuestPC, forceTrace = True)
	Log("pursuitQuestNPC: " + pursuitQuestNPC, forceTrace = True)
	Log("Pursuit00Pounce: " + slac_Pursuit00Pounce.GetValue(), forceTrace = True)
	Log("Pursuit01Pounce: " + slac_Pursuit01Pounce.GetValue(), forceTrace = True)
	Log("Pursuit01Flee: " + slac_Pursuit01Flee.GetValue(), forceTrace = True)
	Log("pursuitCaptureRadiusPC: " + pursuitCaptureRadiusPC, forceTrace = True)
	Log("pursuitCaptureRadiusNPC: " + pursuitCaptureRadiusNPC, forceTrace = True)
	Log("pursuitEscapeRadiusPC: " + pursuitEscapeRadiusPC, forceTrace = True)
	Log("pursuitEscapeRadiusNPC: " + pursuitEscapeRadiusNPC, forceTrace = True)
	Log("pursuitMaxTimePC: " + pursuitMaxTimePC, forceTrace = True)
	Log("pursuitMaxTimeNPC: " + pursuitMaxTimeNPC, forceTrace = True)
	Log("pursuitInviteAnimationPC: " + pursuitInviteAnimationPC, forceTrace = True)
	
	Log(" --- PC/NPC Settings - Queueing --- ", forceTrace = True)
	Log("queueLengthMaxPC: " + queueLengthMaxPC, forceTrace = True)
	Log("queueLengthMaxNPC: " + queueLengthMaxNPC, forceTrace = True)
	Log("allowQueueLeaversPC: " + allowQueueLeaversPC, forceTrace = True)
	Log("allowQueueLeaversNPC: " + allowQueueLeaversNPC, forceTrace = True)
	Log("consensualQueuePC: " + consensualQueuePC, forceTrace = True)
	Log("consensualQueueNPC: " + consensualQueueNPC, forceTrace = True)
	Log("queueTypePC: " + queueTypePC, forceTrace = True)
	Log("queueTypeNPC: " + queueTypeNPC, forceTrace = True)
	
	Log(" --- PC/NPC Settings - Orgy --- ", forceTrace = True)
	Log("orgyModePC: " + orgyModePC, forceTrace = True)
	Log("orgyModeNPC: " + orgyModeNPC, forceTrace = True)
	Log("orgyArousalMinPC: " + orgyArousalMinPC, forceTrace = True)
	Log("orgyArousalMinNPC: " + orgyArousalMinNPC, forceTrace = True)
	Log("orgyArousalMinPCCreature: " + orgyArousalMinPCCreature, forceTrace = True)
	Log("orgyArousalMinNPCCreature: " + orgyArousalMinNPCCreature, forceTrace = True)
	Log("orgyRequiredArousalPCIndex: " + orgyRequiredArousalPCIndex, forceTrace = True)
	Log("orgyRequiredArousalNPCIndex: " + orgyRequiredArousalNPCIndex, forceTrace = True)
	Log("orgyConsentPCIndex: " + orgyConsentPCIndex, forceTrace = True)
	Log("orgyConsentNPCIndex: " + orgyConsentNPCIndex, forceTrace = True)

	Log(" --- PC/NPC Settings - Creature Grouping --- ", forceTrace = True)
	Log("groupChancePC: " + groupChancePC, forceTrace = True)
	Log("groupChanceNPC: " + groupChanceNPC, forceTrace = True)
	Log("groupMaxExtrasPC: " + groupMaxExtrasPC, forceTrace = True)
	Log("groupMaxExtrasNPC: " + groupMaxExtrasNPC, forceTrace = True)
	Log("groupArousalPC: " + groupArousalPC, forceTrace = True)
	Log("groupArousalNPC: " + groupArousalNPC, forceTrace = True)
	
	Log(" --- PC/NPC Settings - Locations --- ", forceTrace = True)
	Log("LocationCityAllowPC: " + LocationCityAllowPC, forceTrace = True)
	Log("LocationTownAllowPC: " + LocationTownAllowPC, forceTrace = True)
	Log("LocationDwellingAllowPC: " + LocationDwellingAllowPC, forceTrace = True)
	Log("LocationInnAllowPC: " + LocationInnAllowPC, forceTrace = True)
	Log("LocationPlayerHouseAllowPC: " + LocationPlayerHouseAllowPC, forceTrace = True)
	Log("LocationDungeonAllowPC: " + LocationDungeonAllowPC, forceTrace = True)
	Log("LocationDungeonClearedAllowPC: " + LocationDungeonClearedAllowPC, forceTrace = True)
	Log("LocationOtherAllowPC: " + LocationOtherAllowPC, forceTrace = True)
	
	Log("LocationCityAllowNPC: " + LocationCityAllowNPC, forceTrace = True)
	Log("LocationTownAllowNPC: " + LocationTownAllowNPC, forceTrace = True)
	Log("LocationDwellingAllowNPC: " + LocationDwellingAllowNPC, forceTrace = True)
	Log("LocationInnAllowNPC: " + LocationInnAllowNPC, forceTrace = True)
	Log("LocationPlayerHouseAllowNPC: " + LocationPlayerHouseAllowNPC, forceTrace = True)
	Log("LocationDungeonAllowNPC: " + LocationDungeonAllowNPC, forceTrace = True)
	Log("LocationDungeonClearedAllowNPC: " + LocationDungeonClearedAllowNPC, forceTrace = True)
	Log("LocationOtherAllowNPC: " + LocationOtherAllowNPC, forceTrace = True)
	
	Log(" --- PC/NPC Settings - PC/NPC Only --- ", forceTrace = True)
	Log("OnlyPermittedNPCs: " + OnlyPermittedNPCs, forceTrace = True)
	Log("pcAllowWeapons: " + pcAllowWeapons, forceTrace = True)
	Log("pcCrouchIndex: " + pcCrouchIndex, forceTrace = True)
	Log("allowEdlers: " + allowElders, forceTrace = True)
	Log("noSittingActors: " + noSittingActors, forceTrace = True)
	Log("noSleepingActors: " + noSleepingActors, forceTrace = True)
	
	Log(" --- PC/NPC Settings - Male NPCs --- ", forceTrace = True)
	Log("NPCMaleArousalMin: " + NPCMaleArousalMin, forceTrace = True)
	Log("NPCMaleCreatureArousalMin: " + NPCMaleCreatureArousalMin, forceTrace = True)
	Log("NPCMaleRequiredArousalIndex: " + NPCMaleRequiredArousalIndex, forceTrace = True)
	Log("NPCMaleConsensualIndex: " + NPCMaleConsensualIndex, forceTrace = True)
	Log("NPCMaleQueuing: " + NPCMaleQueuing, forceTrace = True)
	Log("NPCMaleAllowVictim: " + NPCMaleAllowVictim, forceTrace = True)

	Log(" --- Dialogue & Interactions - Invitation --- ", forceTrace = True)
	Log("inviteTargetKey: " + inviteTargetKey, forceTrace = True)
	Log("inviteArousalMin: " + inviteArousalMin, forceTrace = True)
	Log("inviteConsentPCIndex: " + inviteConsentPCIndex, forceTrace = True)
	Log("inviteAnimationPC: " + inviteAnimationPC, forceTrace = True)
	Log("inviteAnimationNPC: " + inviteAnimationNPC, forceTrace = True)
	Log("inviteStripDelayPC: " + inviteStripDelayPC, forceTrace = True)
	Log("inviteOpensHorseDialogue: " + inviteOpensHorseDialogue, forceTrace = True)
	Log("inviteOpensCreatureDialogue: " + inviteOpensCreatureDialogue, forceTrace = True)
	Log("inviteCreatureSex: " + inviteCreatureSex, forceTrace = True)
	
	Log(" --- Dialogue & Interactions - Suitors --- ", forceTrace = True)
	Log("suitorsMaxPC: " + suitorsMaxPC, forceTrace = True)
	Log("suitorsPCArousalMin: " + suitorsPCArousalMin, forceTrace = True)
	Log("suitorsPCAllowWeapons: " + suitorsPCAllowWeapons, forceTrace = True)
	Log("suitorsPCAllowLeave: " + suitorsPCAllowLeave, forceTrace = True)
	Log("suitorsPCCrouchEffect: " + suitorsPCCrouchEffect, forceTrace = True)
	Log("suitorsPCOnlyNaked: " + suitorsPCOnlyNaked, forceTrace = True)
	Log("suitorsPCAllowFollowers: " + suitorsPCAllowFollowers, forceTrace = True)
	
	Log(" --- Dialogue & Interactions - Struggle --- ", forceTrace = True)
	Log("struggleEnabled: " + struggleEnabled, forceTrace = True)
	Log("struggleKeyOne: " + struggleKeyOne, forceTrace = True)
	Log("struggleKeyTwo: " + struggleKeyTwo, forceTrace = True)
	Log("struggleStaminaDamage: " + struggleStaminaDamage, forceTrace = True)
	Log("struggleStaminaDamageMultiplier: " + struggleStaminaDamageMultiplier, forceTrace = True)
	Log("struggleTimingOne: " + struggleTimingOne, forceTrace = True)
	Log("struggleTimingTwo: " + struggleTimingTwo, forceTrace = True)
	Log("struggleMeterHidden: " + struggleMeterHidden, forceTrace = True)
	Log("struggleFailureEnabled: " + struggleFailureEnabled, forceTrace = True)
	Log("struggleExhaustionMode: " + struggleExhaustionMode, forceTrace = True)
	Log("struggleExhaustionDuration: " + slacUtility.slac_StaminaDrainSpell.GetNthEffectDuration(0), forceTrace = True)
	Log("struggleQueueEscape: " + struggleQueueEscape, forceTrace = True)
	
	Log(" --- Dialogue & Interactions - Actor Selection --- ", forceTrace = True)
	Log("targetKey: " + targetKey, forceTrace = True)
	
	Log(" --- Dialogue & Interactions - Player Horse --- ", forceTrace = True)
	Log("horseRefusalPCMounting: " + horseRefusalPCMounting, forceTrace = True)
	Log("horseRefusalPCRiding: " + horseRefusalPCRiding, forceTrace = True)
	Log("horseRefusalPCThreshold: " + horseRefusalPCThreshold, forceTrace = True)
	Log("horseRefusalPCSex: " + horseRefusalPCSex, forceTrace = True)
	Log("horseRefusalPCEngage: " + horseRefusalPCEngage, forceTrace = True)
	
	Log(" --- Dialogue & Interactions - Follower Commands --- ", forceTrace = True)
	Log("followerDialogueEnabled: " + followerDialogueEnabled, forceTrace = True)
	Log("nonFollowerDialogueEnabled: " + nonFollowerDialogueEnabled, forceTrace = True)
	Log("followerCommandThreshold: " + followerCommandThreshold, forceTrace = True)
	Log("creatureCommandThreshold: " + creatureCommandThreshold, forceTrace = True)
	Log("followerDialogueGenderIndex: " + followerDialogueGenderIndex, forceTrace = True)

	Log(" --- Dialogue & Interactions - Creature Dialogue --- ", forceTrace = True)
	Log("creatureDialogueEnabled: " + creatureDialogueEnabled, forceTrace = True)
	Log("allCreatureDialogueEnabled: " + allCreatureDialogueEnabled, forceTrace = True)
	Log("creatureDialogueAllowSilent: " + creatureDialogueAllowSilent, forceTrace = True)
	Log("creatureDialogueAllowHorses: " + creatureDialogueAllowHorses, forceTrace = True)
	Log("creatureDialogueAllowSteal: " + creatureDialogueAllowSteal, forceTrace = True)
	Log("creatureDialogueSex: " + creatureDialogueSex, forceTrace = True)

	Log(" --- Dialogue & Interactions - Allowed Creatures --- ", forceTrace = True)
	Log("disallowedRaceKeyFPCList: " + PapyrusUtil.StringJoin(disallowedRaceKeyFPCList,","), forceTrace = True)
	Log("disallowedRaceKeyMPCList: " + PapyrusUtil.StringJoin(disallowedRaceKeyMPCList,","), forceTrace = True)
	Log("disallowedRaceKeyFNPCList: " + PapyrusUtil.StringJoin(disallowedRaceKeyFNPCList,","), forceTrace = True)
	Log("disallowedRaceKeyMNPCList: " + PapyrusUtil.StringJoin(disallowedRaceKeyMNPCList,","), forceTrace = True)

	Log(" --- Aggressive Toggles --- ", forceTrace = True)
	Log("aggressiveTogglesTags: " + aggressiveTogglesTags, forceTrace = True)
	Log("aggressiveTogglesRaceKey: " + CondString(aggressiveTogglesRaceKey == "$SLAC_All", "All", aggressiveTogglesRaceKey), forceTrace = True)
	Log("animationsPerPage: " + animationsPerPage, forceTrace = True)
	
	Log(" --- Other Settings - Trans Options --- ", forceTrace = True)
	Log("TransMFTreatAsPC: " + TransMFTreatAsPC, forceTrace = True)
	Log("TransFMTreatAsPC: " + TransFMTreatAsPC, forceTrace = True)
	Log("TransMFTreatAsNPC: " + TransMFTreatAsNPC, forceTrace = True)
	Log("TransFMTreatAsNPC: " + TransFMTreatAsNPC, forceTrace = True)
	
	Log(" --- Other Settings - Animation Selection --- ", forceTrace = True)
	Log("restrictAggressivePC: " + restrictAggressivePC, forceTrace = True)
	Log("restrictAggressiveNPC: " + restrictAggressiveNPC, forceTrace = True)
	Log("restrictConsensualPC: " + restrictConsensualPC, forceTrace = True)
	Log("restrictConsensualNPC: " + restrictConsensualNPC, forceTrace = True)
	;Log("allowMaleReceiverPC: " + allowMaleReceiverPC, forceTrace = True)
	;Log("allowMaleReceiverNPC: " + allowMaleReceiverNPC, forceTrace = True)
	
	Log("FemalePCRoleWithMaleCreature: " + FemalePCRoleWithMaleCreature)
	Log("FemalePCRoleWithFemaleCreature: " + FemalePCRoleWithFemaleCreature)
	Log("MalePCRoleWithMaleCreature: " + MalePCRoleWithMaleCreature)
	Log("MalePCRoleWithFemaleCreature: " + MalePCRoleWithFemaleCreature)
	
	Log("FemaleNPCRoleWithMaleCreature: " + FemaleNPCRoleWithMaleCreature)
	Log("FemaleNPCRoleWithFemaleCreature: " + FemaleNPCRoleWithFemaleCreature)
	Log("MaleNPCRoleWithMaleCreature: " + MaleNPCRoleWithMaleCreature)
	Log("MaleNPCRoleWithFemaleCreature: " + MaleNPCRoleWithFemaleCreature)
	
	Log("NonConsensualIsAlwaysMFPC: " + NonConsensualIsAlwaysMFPC)
	Log("NonConsensualIsAlwaysMFNPC: " + NonConsensualIsAlwaysMFNPC)
	
	Log(" --- Other Settings - Compatibility --- ", forceTrace = True)
	Log("submit: " + submit, forceTrace = True)
	Log("defeat: " + defeat, forceTrace = True)
	Log("DeviousDevicesFilter: " + DeviousDevicesFilter, forceTrace = True)
	Log("NakedDefeatFilter: " + NakedDefeatFilter, forceTrace = True)
	Log("deviouslyHelpless: " + deviouslyHelpless, forceTrace = True)
	Log("DisplayModelBlockAuto: " + DisplayModelBlockAuto, forceTrace = True)
	Log("ToysFilter: " + ToysFilter, forceTrace = True)
	Log("DHLPBlockAuto: " + DHLPBlockAuto, forceTrace = True)
	Log("DCURBlockAuto: " + DCURBlockAuto, forceTrace = True)
	Log("convenientHorses: " + convenientHorses, forceTrace = True)
	Log("allowInScene: " + allowInScene, forceTrace = True)
	Log("claimActiveActors: " + claimActiveActors, forceTrace = True)
	Log("claimQueuedActors: " + claimQueuedActors, forceTrace = True)
	Log("disallowMagicInfluenceCharm: " + disallowMagicInfluenceCharm, forceTrace = True)
	Log("disallowMagicAllegianceFaction: " + disallowMagicAllegianceFaction, forceTrace = True)
	Log("disallowMagicCharmFaction: " + disallowMagicCharmFaction, forceTrace = True)
	Log("combatStateChangeCooldown: " + combatStateChangeCooldown, forceTrace = True)
	Log("FailedPursuitCooldown: " + FailedPursuitCooldown, forceTrace = True)
	Log("weaponsPreventAutoEngagement: " + weaponsPreventAutoEngagement, forceTrace = True)
	Log("initMCMPage: " + initMCMPage, forceTrace = True)
	Log("useVRCompatibility: " + useVRCompatibility, forceTrace = True)
	Log("disableSLACStripping: " + disableSLACStripping, forceTrace = True)
	Log("AutoToggleKey: " + AutoToggleKey, forceTrace = True)
	Log("SexLabPPlusMode: " + SexLabPPlusMode, forceTrace = True)
	Log("SexLab Version: " + SexLab.GetVersion() + " Using SexLab P+: " + UsingSLPP(), forceTrace = True)

	Log(" --- Other Settings - Testing --- ", forceTrace = True)
	Log("skipFilteringStartSex: " + skipFilteringStartSex, forceTrace = True)
	Log("allowCombatEngagements: " + allowCombatEngagements, forceTrace = True)
	Log("allowHostileEngagements: " + allowHostileEngagements, forceTrace = True)
	Log("hostileArousalMin: " + hostileArousalMin, forceTrace = True)
	Log("allowDialogueAutoEngage: " + allowDialogueAutoEngage, forceTrace = True)
	Log("allowMenuAutoEngage: " + allowMenuAutoEngage, forceTrace = True)

	Log(" --- Other Settings - Collars --- ", forceTrace = True)
	Log("onlyCollared: " + onlyCollared, forceTrace = True)
	Log("collarAttraction: " + collarAttraction, forceTrace = True)
	Log("collaredArousalMin: " + collaredArousalMin, forceTrace = True)
EndFunction


; Location strings
String Function LocationString()
	Location currentLocation = Game.GetPlayer().GetCurrentLocation()
	If !currentLocation
		Return "Other Location"
	EndIf
	
	; Minor Types
	
	If currentLocation.HasKeyword(LocTypeInn)
		Return "Inn"
	EndIf
	
	If currentLocation.HasKeyword(LocTypePlayerHouse)
		Return "Player House"
	EndIf
	
	If currentLocation.HasKeyword(LocTypeDungeon) && currentLocation.IsCleared()
		Return "Cleared Dungeon"
	EndIf
	
	; Major Types
	
	If currentLocation.HasKeyword(LocTypeCity)
		Return "City"
	EndIf
	
	If currentLocation.HasKeyword(LocTypeTown)
		Return "Town"
	EndIf
	
	If currentLocation.HasKeyword(LocTypeDwelling)
		Return "Dwelling"
	EndIF
	
	If currentLocation.HasKeyword(LocTypeDungeon)
		Return "Dungeon"
	EndIF
	
	Return "Other Location"
EndFunction


; Returns a human readable name for an item even if it's just a hex ID
String Function GetFormName(Form item, String prefix = "")
	If item == None
		Return prefix + "[None]"
	EndIf
	
	String name = item.GetName()
	If name == "" && item as Actor
		; Actor
		(item as Actor).GetLeveledActorBase().Getname()
	ElseIf name == "" && item as ObjectReference
		; Object Reference
		(item as ObjectReference).GetBaseObject().GetName()
	EndIf
	
	If name == ""
		; Everything else
		name = prefix + slacUtility.GetFormIdHex(item)
	EndIf
	
	Return name
EndFunction


Int Function GetIntPercent(Int percent, Int value)
	Return Math.Floor(value * (percent as Float / 100))
EndFunction


; -----------------;
; Version Matching ;
; -----------------;

; Version Matching - Current for given parts.
; i.e. version = 1.5.97 will return true for match = 1.5 but not the reverse.
Bool Function VersionCurrent(String version, String match)
	String[] verParts = GetVersionParts(version)
	String[] matchParts = GetVersionParts(match)
	
	; If verison is shorter than match then it cannot equal (the reverse is not true)
	If verParts.Length < matchParts.Length
		Return False
	EndIf
	
	; Available match parts must be equal
	Int i = 0
	While i < matchParts.Length && i < verParts.Length
		If matchParts[i] as Int != verParts[i] as Int
			Return False
		EndIf
		i += 1
	EndWhile
	
	Return True
EndFunction

; Compare two version strings 
; Return:
; -1    version is earlier than match
; 0     version is current with match
; 1     version is later than match
; Examples:
; VersionCompare("1.5.97", "1.6") returns -1
; VersionCompare("1.5.97", "1.5") returns 0
; VersionCompare("1.5.97", "1.5.80") returns 1
; Only available parts are matched so:
; VersionCompare("1.5", "1.5.97") returns 0
Int Function VersionCompare(String version, String match)
	String[] verParts = GetVersionParts(version)
	String[] matchParts = GetVersionParts(match)
	
	; Available match parts must be less than version parts
	Int i = 0
	While i < matchParts.Length && i < verParts.Length
		If verParts[i] as Int > matchParts[i] as Int
			Return 1
		ElseIf verParts[i] as Int < matchParts[i] as Int
			Return -1
		EndIf
		i += 1
	EndWhile
	
	Return 0
EndFunction

; Break up version string into period-delimited parts after removing junk parts.
String[] Function GetVersionParts(String version)
	; No RegEx in Papyrus so this needs to be rough and ready.

	; Remove anything to the left of the first digit
	Int i = 0
	Int verLength = StringUtil.GetLength(version)
	While i < verLength
		String char = StringUtil.GetNthChar(version, i)
		If	StringUtil.IsDigit(char)
			version = StringUtil.SubString(version, i, -1)
			i = verLength
		EndIf
		i += 1
	EndWhile
	
	; Remove anything to the right of the last consecutive digit+period
	i = 0
	verLength = StringUtil.GetLength(version)
	While i < verLength
		String char = StringUtil.GetNthChar(version, i)
		If char != "." && !StringUtil.IsDigit(char)
			version = StringUtil.SubString(version, 0, i)
			i = verLength
		EndIf
		i += 1
	EndWhile
	
	; We won't stop to cast here as we need to iterate through the 
	; array later anyway and some parts may not need to be tested
	Return PapyrusUtil.StringSplit(version, ".")
	
	; This will return nonsense for version strings containing spurious digits.
	; e.g. "M0r3B34ns v1.1"
EndFunction


;-----------------------------------------;
; String, Int and Float Return Conditions ;
;-----------------------------------------;

; Select string output using a bool
String Function CondString(Bool condition, String trueString = "", String falseString = "")
	If condition
		Return trueString
	EndIf
	Return falseString
EndFunction

; Select int output using a bool
Int Function CondInt(Bool condition, Int trueInt = 1, Int falseInt = 0)
	If condition
		Return trueInt
	EndIf
	Return falseInt
EndFunction

; Select float output using a bool
Float Function CondFloat(Bool condition, Float trueFloat = 1.0, Float falseFloat = 0.0)
	If condition
		Return trueFloat
	EndIf
	Return falseFloat
EndFunction

; Return truncated string representation of a float with the given number of places after the point
; This is just for sensible display
String Function PrecisionFloatString(Float val, int places = 1)
	String[] parts = new String[2]
	parts = PapyrusUtil.StringSplit(val,".")
	Return Math.Floor(val) + "." + StringUtil.SubString(parts[1],0,places)
EndFunction

; Advance index values for Menu option string array
Int Function AdvIndex(Int index, String[] array, Int default = -1)
	If default > -1 && Input.IsKeyPressed(KeyLCtrl)
		Return default
	EndIf
	Return CondInt(index >= array.Length - 1, 0, index + 1)
EndFunction

; Disable / Restore enabled state for PC/NPC auto-engagement options
Bool function AutoToggleSwitch()
	AutoToggleState = !AutoToggleState

	If AutoToggleState
		; Record current auto enabled status, then turn them off
		LastPCActive = pcActive 
		LastNPCActive = npcActive
		pcActive = False
		npcActive = False
	Else 
		; Restore previous auto enabled status
		pcActive = LastPCActive
		npcActive = LastNPCActive
	EndIf
	
	; Stop any running pursuit quests
	If AutoToggleState
		slacUtility.EndPursuitQuest(slac_Pursuit_00)
		slacUtility.EndPursuitQuest(slac_Pursuit_01)
		slacUtility.EndPursuitQuest(slac_FollowerDialogue)
		slacUtility.EndPursuitQuest(slac_CreatureDialogue)
		slacUtility.ClearSuitors()
		slacUtility.ClearAllQueues()
	EndIf

	; Notify user of change
	If AutoToggleState
		!debugSLAC && slacUtility.Log("SLAC Auto-Engagements Stopped", forceNote = True)
		debugSLAC && slacUtility.Log("SLAC Auto-Engagements Stopped (was PC:" + LastPCActive + " NPC:" + LastNPCActive + ")", forceNote = True)
	Else
		!debugSLAC && slacUtility.Log("SLAC Auto-Engagements Restored", forceNote = True)
		debugSLAC && slacUtility.Log("SLAC Auto-Engagements Restored (now PC:" + pcActive + " NPC:" + npcActive + ")", forceNote = True)
	EndIf

	Return AutoToggleState
EndFunction


;------------------------------------;
;          SL Framework API          ;
;------------------------------------;
; Things like this may be moved to a separate interface script in future.

; Check for SexLab P+
Bool Function UsingSLPP()
	Return SexLabPPlusMode && SexLab.GetVersion() >= 20000
EndFunction

; Get all creature race key strings
String[] Function FrameworkGetAllRaceKeys()
	If UsingSLPP()
		; SexLab P+
		Return SexLabRegistry.GetAllRaceKeys(True)
	Else
		; SexLab
		Return sslCreatureAnimationSlots.GetAllRaceKeys()
	EndIf
EndFunction

; Get race key string for given actor
String Function FrameworkGetRaceKey(Actor Creature)
	If UsingSLPP()
		; SexLab P+
		Return SexLabRegistry.GetRaceKey(Creature)
	Else
		; SexLab
		String raceID = MiscUtil.GetActorRaceEditorID(Creature)
		Return sslCreatureAnimationSlots.GetRaceKeyByID(raceID)
	EndIf
EndFunction


;------------------------------------;
; Config PapyrusUtil Storage (trial) ;
;------------------------------------;

; In testing, calling values via these functions takes twice as long as calling regular script properties.

;Int Function ConfGetInt(String dataKey, Int dataDefault = -1)
;	Return slacData.GetPersistInt(None,"Config." + dataKey, dataDefault)
;EndFunction
;Int Function ConfSetInt(String dataKey, Int dataValue)
;	Return slacData.SetPersistInt(None,"Config." + dataKey, dataValue)
;EndFunction
;Bool Function ConfGetBool(String dataKey, Bool dataDefault = False)
;	Return slacData.GetPersistInt(None,"Config." + dataKey, dataDefault as Int) as Bool
;EndFunction
;Bool Function ConfSetBool(String dataKey, Bool dataValue)
;	Return slacData.SetPersistInt(None,"Config." + dataKey, dataValue as Int) as Bool
;EndFunction

;------------------;
; MCM OID Handling ;
;------------------;

Function SetOID(String keyName, Int OID)
	keyName != "" && StorageUtil.SetIntValue(none,"SLArousedCreatures.MCM.OID." + keyName,OID)
	OIDCount += 1
	If OIDCount > 128
		Log("CAUTION: MCM option limit exceeded! (count:" + OIDCount + " keyName:" + keyName + " OID:" + OID + ")")
	EndIf
EndFunction
Int Function GetOID(String keyName)
	If keyName != ""
		Return StorageUtil.GetIntValue(none,"SLArousedCreatures.MCM.OID." + keyName,-1)
	EndIf
	Return -1
EndFunction
Function ClearAllOID()
	StorageUtil.ClearAllPrefix("SLArousedCreatures.MCM.OID")
	OIDCount = 0
EndFunction

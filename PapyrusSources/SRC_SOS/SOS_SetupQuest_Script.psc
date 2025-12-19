Scriptname SOS_SetupQuest_Script extends Quest

;----------PROPERTIES----------

Int Property SOS_VersionInt Auto Hidden
float Property SOS_Version Auto Hidden ; deprecated

Actor Property PlayerRef Auto
Armor Property SOS_DefaultUnderwear Auto
Keyword Property SOS_Genitals Auto
Keyword Property SOS_Underwear Auto
Keyword Property SOS_Revealing Auto
Keyword Property SOS_Concealing Auto
Keyword Property SOS_Merchant Auto
FormList Property SOS_Addons Auto
Faction Property SOS_SchlongifiedFaction Auto
Faction Property SOS_DialogSetup Auto

Spell Property SOS_SetupSpell Auto
Spell Property SOS_SetupNPCSpell Auto
Spell Property SOS_ErectionSpell Auto
Spell Property SOS_ErectionNPCSpell Auto
Spell Property SOS_ErectionDialogSpell Auto
Spell Property SOS_ErectionExaustionSpell Auto
Spell Property SOS_ActorSpell Auto
Spell Property SOS_RevealingArmorPlayerSpell Auto
Spell Property SOS_RevealingArmorNPCSpell Auto
Spell Property SOS_DebugSpell Auto
Spell Property SOS_DebugNPCSpell Auto

MagicEffect Property SOS_ErectionMagicEffect Auto
MagicEffect Property SOS_ActorMagicEffect Auto

SOS_Config Property config Auto
GlobalVariable Property SOS_Initialized Auto

Faction Property SexLabGenderFaction Auto Hidden

String[] sNiNodes
bool SOSRaceMenu = false
FormList Property SOS_tmp Auto
int updateCounter = 0
Keyword Property RidingInCarriage Auto
Faction Property CarriageSystemFaction Auto
Quest Property MQ101 Auto
Bool checkOpeningScene = True
Bool Property openingSceneChecked Auto Hidden
int oldSex
Race oldRace
Bool Property AddonsRegistered Auto Hidden
Bool Property useDLL Auto Hidden


Event OnInit()
	sNiNodes = new String[8]
	sNiNodes[0] = "NPC GenitalsBase [GenBase]"
	sNiNodes[1] = "NPC GenitalsScrotum [GenScrot]"
	sNiNodes[2] = "NPC Genitals01 [Gen01]"
	sNiNodes[3] = "NPC Genitals02 [Gen02]"
	sNiNodes[4] = "NPC Genitals03 [Gen03]"
	sNiNodes[5] = "NPC Genitals04 [Gen04]"
	sNiNodes[6] = "NPC Genitals05 [Gen05]"
	sNiNodes[7] = "NPC Genitals06 [Gen06]"
	
	If !SexLabGenderFaction && Game.GetModByName("SexLab.esm") != 255
		SexLabGenderFaction = Game.GetFormFromFile(0x43A43, "SexLab.esm") as Faction ; SexLabGenderFaction "SexLab Gender Faction" [FACT:08043A43]
	EndIf
EndEvent

Bool Function Initialize(bool firstTime)

	CheckSOSRacemenuPlugin()
	
	If !SexLabGenderFaction && Game.GetModByName("SexLab.esm") != 255
		SexLabGenderFaction = Game.GetFormFromFile(0x43A43, "SexLab.esm") as Faction ; SexLabGenderFaction "SexLab Gender Faction" [FACT:08043A43]
	EndIf

	If firstTime
		Debug.Trace("SOS: first time initialization...")
		PlayerRef.SetFactionRank(SOS_DialogSetup, 0)
		GiveOrRemoveInteractionSpells(true)
		Debug.Trace("SOS: first time initialization complete.")
		Notify("$SOS first time")
		; give the addons some time to initialize before we start spreading the schlongs
		RegisterForSingleUpdate(5.0)
	Else
		SendModEvent("ReSchlongify")
		CheckPlayerSpells() ; Just in case the spells are lost for whatever reason
		RegisterForMenu("RaceSex Menu")
	EndIf
	
	Return true
EndFunction

;----------EVENTS----------

Event OnUpdate()
	; not initialized yet ?
	If SOS_Data.CountAddons() > 0
		Debug.Trace("SOS: starting to spread schlongs.")
		CheckActorSpell(PlayerRef, false, false) ; give actor spell
		StartSpreading() ; give setup spell
		; the Alternate Start - LAL mod was triggering the race-switch code
		; before SOS already was initializing
		RegisterForMenu("RaceSex Menu")
	Else
		If updateCounter < 10 ; loop stops after a while
			updateCounter += 1
			RegisterForSingleUpdate(5.0)
		EndIf
	EndIf
EndEvent

Event OnMenuOpen(String MenuName)
	If MenuName == "RaceSex Menu"
		oldSex = PlayerRef.GetLeveledActorBase().GetSex()
		oldRace = PlayerRef.GetRace()
	EndIf
EndEvent

Event OnMenuClose(String MenuName)

	If MenuName != "RaceSex Menu" || SOS_Data.CountAddons() == 0
		Return
	EndIf
	ActorBase PLAB = PlayerRef.GetLeveledActorBase()
	If PLAB.GetSex() == oldSex && PlayerRef.GetRace() == oldRace
		Return
	EndIf
	
	Debug.Trace("SOS RaceSwitchComplete: " + PLAB.GetName() + " switched to race " + PlayerRef.GetRace().GetName())

	int size = 1
	Faction addonFaction = None
	Form oldAddon = None
	Form addon = GetActiveAddon(PlayerRef)
	
	If addon
		; actor was already schlonged, retrieve SOS data
		addonFaction = SOS_Data.GetFaction(addon)
		size = PlayerRef.GetFactionRank(addonFaction)
		oldAddon = addon
		
		int currentSex = PLAB.GetSex()
		If oldSex != currentSex && !IsSchlongGenderAllowed(addon, currentSex)
			addon = None ; invalidate schlong due gender change
			Debug.Trace("SOS RaceSwitchComplete: " + PLAB.GetName() + " lost schlong due to gender change")
		EndIf
	EndIf
	
	If !addon
		; switched race and had no schlong, or switched gender, lets see if we can find a new schlong
		addon = DetermineSchlongType(PlayerRef)
		If addon
			Debug.Trace("SOS RaceSwitchComplete: new schlong for " + PLAB.GetName() + ", schlong index " + SOS_Data.FindAddon(addon))
			SetSchlongType(addon, PlayerRef) ; factions and genitals
			RegisterNewSchlongifiedActor(PlayerRef, addon) ; addon formlist
		EndIf
	EndIf
	
	If !addon
		; no schlong available, clean
		RemoveSchlongFromActor(oldAddon, PlayerRef)
	Else
		ScaleSchlongBones(addon, PlayerRef, size) ; bone scales
		UpdateNiNodes(PlayerRef)
		CheckActorSpell(PlayerRef, true, false)
	EndIf

EndEvent

;----------FUNCTIONS----------

Function CheckSOSRacemenuPlugin()
    SOSRaceMenu = Game.GetModByName("SOSRaceMenu.esp") != 255
EndFunction

bool Function IsSkeletonSOSCompatible(Actor akActor)
	return akActor && sNiNodes && sNiNodes.Length > 0 && sNiNodes[0] != "" && NetImmerse.HasNode(akActor, sNiNodes[0], 0)
EndFunction

SOS_AddonQuest_Script Function GetActiveAddon(Actor akActor)
	if akActor
		int i = SOS_Data.CountAddons()
		While i > 0
			i -= 1
			SOS_AddonQuest_Script addon = SOS_Data.GetAddon(i)
			If akActor.IsInFaction(SOS_Data.GetFaction(addon))
				Return addon
			EndIf
		EndWhile
	EndIf
	Return None
EndFunction

Int Function SetSchlongType(Form newAddon, Actor akActor)
	{remove old addon, add new factions and genitals}
	If !akActor || !newAddon
		Return  -1
	EndIf

	Int iRank = 1
	Form oldAddon = GetActiveAddon(akActor)
	
	If oldAddon
		Faction kOldFaction = SOS_Data.GetFaction(oldAddon)
		If kOldFaction
			iRank = akActor.GetFactionRank(kOldFaction)
			akActor.RemoveFromFaction(kOldFaction)
			SOS_Data.RemoveSchlonged(oldAddon, akActor)
		EndIf
	EndIf
	
	Faction kNewFaction = SOS_Data.GetFaction(newAddon)
	
	If kNewFaction
		Debug.Trace("SOS SetSchlongType: Changing " + akActor.GetLeveledActorBase().GetName() + "'s schlong to "+ kNewFaction.GetName())

		akActor.SetFactionRank(kNewFaction, iRank)
		akActor.SetFactionRank(SOS_SchlongifiedFaction, iRank)

		if akActor.WornHasKeyword(SOS_Genitals) || !akActor.WornHasKeyword(SOS_Underwear)
			Armor bodyArmor = akActor.GetWornForm(0x00000004) as Armor
			If !bodyArmor || IsRevealing(bodyArmor)
				Armor kNewArmor = SOS_Data.GetGenitalArmor(newAddon)
				akActor.EquipItem(kNewArmor, false, true)
				If akActor.HasMagicEffect(SOS_ErectionMagicEffect)
					Debug.SendAnimationEvent(akActor, "SOSFastErect")
				Else
					CheckArousalOverride(akActor)
				EndIf
			EndIf
			If oldAddon
				Armor kOldArmor = SOS_Data.GetGenitalArmor(oldAddon)
				akActor.RemoveItem(kOldArmor, 999, true)
			EndIf
		endIf
		
		Return iRank
	endIf
	
	Return -1
EndFunction

Function CheckArousalOverride(Actor akActor)
	Int bend = StorageUtil.GetIntValue(akActor, "SOS_ArousalOverride", missing = -1000)
	If bend != -1000
		If bend < -9
			Debug.SendAnimationEvent(akActor, "SOSFlaccid")
		ElseIf bend > 9
			Debug.SendAnimationEvent(akActor, "SOSBend9")
		Else
			Debug.SendAnimationEvent(akActor, "SOSBend" + bend)
		EndIf
	EndIf
EndFunction

Function SetSchlongSize(Form addon, Actor akActor, int size)
	{update factions and bone scales}
	If !akActor
		Return
	EndIf
	
	Faction addonFaction = SOS_Data.GetFaction(addon)
	If addonFaction
		akActor.SetFactionRank(SOS_SchlongifiedFaction, size)
		akActor.SetFactionRank(addonFaction, size)
		ScaleSchlongBones(addon, akActor, size)
	Else
		Debug.Trace("SOS SetSchlongSize: ERROR - could not find SOS_Factions data on " + addon + ". Schlong not scaled.")
	EndIf
	
EndFunction

Function ScaleSchlongBones(Form addon, Actor akActor, int aiFactionRank)
	If !akActor
		Return
	EndIf
	If SOSRaceMenu && akActor == PlayerRef
		Debug.Trace("SOS ScaleSchlongBones: RaceMenu plugin found. Skip scaling for player.")
		Return
	EndIf
	
;	If useDLL
;		SOS_SKSE.ScaleSchlongBones(addon, akActor, aiFactionRank, config.fGlobalSchlongSizeBoostFactor)
;	Else
		Bool isFemale = akActor.GetLeveledActorBase().GetSex() == 1
		Float scale
		If aiFactionRank == 0
			scale = 0.0
		Else
			scale = Math.pow(1.08, aiFactionRank - 1) * (1.0 + config.fGlobalSchlongSizeBoostFactor / 100.0)
		EndIf
		If sNiNodes && sNiNodes.Length > 0 && sNiNodes[0] !=  ""
	;		NiOverride.AddNodeTransformScale(akActor, False, isFemale, sNiNodes[0], "Schlongs of Skyrim.esp", scale)  ; alternatively -- uncomment the preferred method
	;		NiOverride.UpdateNodeTransform(akActor, False, isFemale, sNiNodes[0])
			NetImmerse.SetNodeScale(akActor, sNiNodes[0], scale, False)  ; alternatively -- comment out
			If akActor == PlayerRef  ; scale the first person skeleton as well
	;			NiOverride.AddNodeTransformScale(akActor, True, isFemale, sNiNodes[0], "Schlongs of Skyrim.esp", scale)  ; alternatively -- uncomment the preferred method
	;			NiOverride.UpdateNodeTransform(akActor, True, isFemale, sNiNodes[0])
				NetImmerse.SetNodeScale(akActor, sNiNodes[0], scale, True)  ; alternatively -- comment out
			EndIf
		EndIf
;	EndIf
EndFunction

Float Function Rescale(Float scale, Float factor)
	Return 1 + (scale - 1) * factor
EndFunction

Function SetSexlabGender(SOS_AddonQuest_Script addon, Actor akActor)
	If !akActor || !SexLabGenderFaction || !addon
		Return
	EndIf
	
	if addon.bForceMale
		if akActor.GetFactionRank(SexLabGenderFaction) != 0
			akActor.SetFactionRank(SexLabGenderFaction, 0)
			if config.bDisplayActionInConsole
				MiscUtil.PrintConsole("Adding " + addon.GetName() + " to " + akActor.GetLeveledActorBase().GetName() + " and setting SexLab Gender to male")
			endif
		endif
	elseif addon.bForceFemale
		if akActor.GetFactionRank(SexLabGenderFaction) != 1
			akActor.SetFactionRank(SexLabGenderFaction, 1)
			if config.bDisplayActionInConsole
				MiscUtil.PrintConsole("Adding " + addon.GetName() + " to " + akActor.GetLeveledActorBase().GetName() + " and setting SexLab Gender to female")
			endif
		endif
	elseif akActor.IsInFaction(SexLabGenderFaction)
		akActor.RemoveFromFaction(SexLabGenderFaction)
		if config.bDisplayActionInConsole
			MiscUtil.PrintConsole("Adding " + addon.GetName() + " to " + akActor.GetLeveledActorBase().GetName() + " and removing SexLab Gender")
		endif
;	else
	;	if config.bDisplayActionInConsole
	;		MiscUtil.PrintConsole("Adding " + addon.GetName() + " to " + akActor.GetLeveledActorBase().GetName() + " but not setting SexLab Gender")
	;	endif
	endif
EndFunction

;----------SCHLONGIFICATION----------

Function RegisterNewSchlongifiedActor(Actor akActor, Form addon = None)
	{Maintains knowledge about all actors that ever got a schlong}
	If !akActor
		Return
	EndIf
	
	If !addon
		addon = GetActiveAddon(akActor)
	Endif
	
	; only register non-temporary actors permanently
	If akActor.GetActorBase() == akActor.GetLeveledActorBase()
		SOS_Data.AddSchlonged(addon, akActor)
	Endif
EndFunction

int Function DetermineSchlongSize(Form addon, Actor akActor)
	{Determines a random schlong size for the given actor, considering the configured distribution for that race}
	If !akActor
		Return 1
	EndIf
	
	int min = config.iMinSchlongSize
	int max = config.iMaxSchlongSize

	If min > max
		max = min + 1
	Endif

	; size is fixed for player and merchants
	If akActor == PlayerRef
		Return min
	ElseIf akActor.GetLeveledActorBase().HasKeyword(SOS_Merchant)
		Return 20
	EndIf
	
	Race actorRace = akActor.GetRace()
	int raceIndex = SOS_Data.FindCompatibleRace(addon, actorRace)
	If raceIndex == -1
		Return 1
	EndIf

	int sizeDistribution = SOS_Data.GetRaceSize(addon, raceIndex)
	;Debug.Trace("SOS DetermineSchlongSize: deciding schlong size for " + akActor.GetLeveledActorBase().GetName() + " [" + actorRace.GetName() + "] -> size distribution=" + sizeDistribution)
	
	If sizeDistribution != 0 && Utility.RandomInt(0, 100) < Math.Abs(sizeDistribution)
		int sizeOffset = sizeDistribution * max / 100
		;Debug.Trace("SOS DetermineSchlongSize sizeOffset " + sizeOffset)
		if sizeOffset < 0
			max = Math.Floor(max + sizeOffset) + 1
		Else
			min = sizeOffset
		Endif
	Endif

	int size = Utility.RandomInt(min, max)
	;Debug.Trace("SOS DetermineSchlongSize: generated value between " + min + " | " + max + ": " + size + " for " + akActor.GetLeveledActorBase().GetName() + " [" + actorRace.GetName() + "]")
	return size
EndFunction

Form Function DetermineSchlongType(actor akActor)
	{Determines a random schlong type for the given actor, respecting the gender, enabled and probability settings for that race}
;	If useDLL
;		Return SOS_SKSE.DetermineSchlongType(akActor)
;	Else
		If AddonsRegistered
			InvalidateAllRacesCache()
			AddonsRegistered = False
		EndIf

		Race aRace = akActor.GetRace()
		Int numAddons = SOS_Addons.GetSize()
		Int i = 0

		If StorageUtil.GetIntValue(aRace, "SOS_RaceCacheValid") == 0
			; Build a cache of added up probabilities for both genders
			Float sumM = 0.0
			Float sumF = 0.0
			Float probability
			Form addon
			While i < numAddons
				addon = SOS_Addons.GetAt(i)
				Int enabledGender = StorageUtil.GetIntValue(addon, "SOS_Genders") % 10  ; 0=Male, 1=Female, 2=Both, 10=Both but disabled for females, 11=Both but disabled for males
				probability = GetRaceProbability(addon, aRace)
				If enabledGender == 0
					sumM += probability
				ElseIf enabledGender == 1
					sumF += probability
				ElseIf enabledGender == 2
					sumM += probability
					sumF += probability
				EndIf
				;Debug.Trace("---->" + i + ": " + addon + " - - sumM = " + sumM + ", sumF = " + sumF)
				StorageUtil.FloatListAdd(aRace, "SOS_RaceCacheProbsM", sumM, allowDuplicate = true)
				StorageUtil.FloatListAdd(aRace, "SOS_RaceCacheProbsF", sumF, allowDuplicate = true)
				i += 1
			EndWhile
			StorageUtil.SetIntValue(aRace, "SOS_RaceCacheValid", 1)
			Debug.Trace("SOS DetermineSchlongType: Built cache for race " + aRace + " from " + numAddons + " addons.")
		EndIf

		Float[] probs  ; working with a local array is faster
		If akActor.GetLeveledActorBase().GetSex() == 0  ; male
			probs = StorageUtil.FloatListToArray(aRace, "SOS_RaceCacheProbsM")
		Else
			probs = StorageUtil.FloatListToArray(aRace, "SOS_RaceCacheProbsF")
		EndIf

		If probs[probs.Length - 1] == 0.0  ; final sum is zero <- all addon probabilities for this race are zero
			Return None
		EndIf

		Float probRoll = Utility.RandomFloat(0.0, probs[probs.Length - 1] - 0.01)
		i = 0
		While probs[i] < probRoll
			i += 1
		EndWhile

		Return SOS_Addons.GetAt(i)
;	EndIf
	
EndFunction

Float Function GetRaceProbability(Form addon, Race actorRace)
	; check MCM race configuration
	If SOS_Data.FindEnabledRace(addon, actorRace) != -1
		; return MCM % configuration
		int raceIndex = SOS_Data.FindCompatibleRace(addon, actorRace)
		If raceIndex != -1
			Return SOS_Data.GetRaceProbability(addon, raceIndex)
		EndIf
	EndIf
	Return 0.0
EndFunction

bool Function IsSchlongRaceCompatible(Form addon, Actor akActor)
	return akActor && SOS_Data.FindCompatibleRace(addon, akActor.GetRace()) != -1
EndFunction

bool Function IsSchlongGenderAllowed(Form addon, int gender)
	int enabledGender = SOS_Data.GetGender(addon) ; 0=Male, 1=Female, 2=Both, 10=Both but disabled for females, 11=Both but disabled for males
	return enabledGender == 2 || enabledGender == gender || enabledGender == gender + 10
EndFunction

Function InvalidateRaceCache(Race akRace)
;	If !useDLL
		StorageUtil.UnsetIntValue(akRace, "SOS_RaceCacheValid")
		StorageUtil.FloatListClear(akRace, "SOS_RaceCacheProbsM")
		StorageUtil.FloatListClear(akRace, "SOS_RaceCacheProbsF")
;	EndIf
EndFunction

Function InvalidateAllRacesCache(Bool newDLL = False)
;	If !useDLL || newDLL
		Form raceToClear
		Int numRaces = StorageUtil.FormListCount(None, "SOS_KnownCompatibleRaces")
		While numRaces > 0
			numRaces -= 1
			raceToClear = StorageUtil.FormListGet(None, "SOS_KnownCompatibleRaces", numRaces)
			StorageUtil.UnsetIntValue(raceToClear, "SOS_RaceCacheValid")
			StorageUtil.FloatListClear(raceToClear, "SOS_RaceCacheProbsM")
			StorageUtil.FloatListClear(raceToClear, "SOS_RaceCacheProbsF")
		EndWhile
;	EndIf
EndFunction

Function UpdateNiNodes(Actor akActor)
	{Only updates the NiNodes if the actor is not riding a horse, to avoid flying bug of QueueNiNodeUpdate function}
	If !akActor
		Return
	EndIf
	
	If akActor.IsOnMount()
		Debug.Trace("SOS UpdateNiNodes: " + akActor.GetLeveledActorBase().GetName() + " is on mount.")
		Return
	EndIf
	
	If IsOnCart(akActor)
		Debug.Trace("SOS UpdateNiNodes: " + akActor.GetLeveledActorBase().GetName() + " is on cart.")
		Return
	endif
	
	akActor.QueueNiNodeUpdate()
EndFunction

Bool Function IsOnCart(Actor akActor)
	{Function to check if the Actor is attached to a cart}
	If !akActor
		Return false
	EndIf

	If akActor.HasKeyword(RidingInCarriage) || akActor.IsInFaction(CarriageSystemFaction)
		Return true
	EndIf
	
	If checkOpeningScene
		; Opening quest, cart scene. It will break if armor of people on cart is made revealing
		; or non-vanilla armor is equipped on them (Immersive Armors mod)
		; or SchlongsOfSkyrim.dll is not installed
		int stageID = MQ101.GetCurrentStageID()
		If stageID > 14 && stageID < 65
			Return True
		Else
			If stageID >= 65
				checkOpeningScene = False
				openingSceneChecked = True  ; flag can be read from SOS_ActorMagicEffect_Script
			EndIf
			Return False
		EndIf
	EndIf
	
	Return False

EndFunction

int Function CleanSchlongifiedActors(Form addon, Bool removingSOS)
	{unschlongifies actors of the faction of the given schlong addon, making them available for a new schlong}

	Faction cleanFaction = SOS_Data.GetFaction(addon)
	If !cleanFaction
		Debug.Trace("SOS CleanSchlongifiedActors: Addon " + addon + " has no faction data, cannot proceed.")
		Return 0
	EndIf
	
	Debug.Trace("SOS CleanSchlongifiedActors: attempting unschlongification for schlong addon " + cleanFaction.GetName())
	
	Armor genitals = SOS_Data.GetGenitalArmor(addon)
	If !SOS_SetupNPCSpell
		SOS_SetupNPCSpell = Game.GetFormFromFile(0x12e7, "Schlongs of Skyrim.esp") as Spell
	EndIf
	int iCleanedActors = 0
	Int i = SOS_Data.CountSchlongeds(addon)
	Actor schlActor
	While i > 0
		i -= 1
		schlActor = SOS_Data.GetSchlonged(addon, i)
		If schlActor && schlActor.IsInFaction(cleanFaction)
			;Debug.Trace("SOS CleanSchlongifiedActors: Cleaning " + schlActor.GetName())
			schlActor.RemoveFromFaction(SOS_SchlongifiedFaction)
			schlActor.RemoveFromFaction(cleanFaction)
			If removingSOS
				schlActor.RemoveSpell(SOS_SetupNPCSpell)
				schlActor.RemoveSpell(SOS_ActorSpell)
			EndIf
			schlActor.RemoveItem(genitals, 999, true)
			iCleanedActors += 1
		EndIf
	endwhile
	SOS_Data.ClearSchlongeds(addon)
	Debug.Trace("SOS CleanSchlongifiedActors: unschlongified " + iCleanedActors + " actors.")
	
	Return iCleanedActors
EndFunction

Function RemoveSchlongAddon(Form addon, Bool removingSOS)
	{Tries to eliminate every trace from a specific schlong addon while keeping the indices for all formlists consistent and intact}

	SOS_addonQuest_Script addonScript = addon as SOS_addonQuest_Script

	CleanSchlongifiedActors(addonScript, removingSOS)
	addonScript.UnregisterAddon()

EndFunction

Function RemoveSchlongFromActor(Form addon, Actor akActor)
	If !akActor
		Return
	EndIf
	
	akActor.RemoveFromFaction(SOS_SchlongifiedFaction)
	If addon
		akActor.RemoveFromFaction(SOS_Data.GetFaction(addon))
		akActor.RemoveItem(SOS_Data.GetGenitalArmor(addon), 999, true)
		SOS_Data.removeSchlonged(addon, akActor)
	EndIf
	SendModEvent("ReSchlongify", "GoToSchlongless", akActor.GetFormID())
EndFunction


Function Restart()
	Debug.Notification("Restarting SOS...")
	
	PlayerRef.RemoveSpell(SOS_ActorSpell)
	Utility.Wait(0.1) ; needed to make sure actor magic effect stops
	
	DisableAddons(false)
	
	Stop() ; stop quest
	
	; discard all stored data added by scripts
	SOS_Data.ClearAddons()
	SOS_Addons.Revert()
	SOS_Data.ClearBlackList()
	CleanSchlongifiedArmors()
		
	; start quest
	SOS_Initialized.SetValue(0)
	Start()
	
	EnableAddons()

	Debug.Notification("Restart complete!")
EndFunction

Function Remove()
	Debug.Notification("Removing SOS...")
	
	PlayerRef.RemoveSpell(SOS_ActorSpell)
	PlayerRef.RemoveSpell(SOS_SetupSpell)
	GiveOrRemoveSpells(false, false, SOS_ErectionSpell, SOS_ErectionNPCSpell)
	GiveOrRemoveSpells(false, false, SOS_RevealingArmorPlayerSpell, SOS_RevealingArmorNPCSpell)
	GiveOrRemoveSpells(false, false, SOS_DebugSpell, SOS_DebugNPCSpell)
	
	; Needed to make sure actor magic effect stops
	; Actually I'm not sure because in this case the spell is not added back
	; WaitMenuMode because this function is called from MCM
	; TODO: test if really needed
	Utility.WaitMenuMode(0.1) 
	
	; remove addons, stop their quests
	DisableAddons(true)
	
	; stop quests
	config.Stop()
	Stop()
	
	; discard all stored data added by scripts
	SOS_Data.ClearAddons()
	SOS_Addons.Revert()
	CleanSchlongifiedArmors()
	SOS_Data.ClearKnownRaces()
	SOS_Data.ClearBlackList()
	
	Debug.MessageBox("SOS has been removed. Please save and exit the game, and disable the mod.")
EndFunction

Function EnableAddons()
	int count = SOS_tmp.GetSize()
	Int i = 0
	While i < count
		SOS_addonQuest_Script addonScript = SOS_tmp.GetAt(i) as SOS_addonQuest_Script
		addonScript.RegisterAddon()
		i += 1
	EndWhile
	SOS_tmp.Revert()
EndFunction

Function DisableAddons(Bool removingSOS)
	Int i = SOS_Data.CountAddons()
	While i > 0
		i -= 1
		Debug.Trace("SOS DisableAddons: removing addon #" + i)
		SOS_AddonQuest_Script addon = SOS_Data.GetAddon(i)
		If addon
			SOS_tmp.addForm(addon)
			RemoveSchlongAddon(addon, removingSOS)
			If removingSOS
				SOS_Data.ClearGender(addon)
				SOS_Data.ClearBones(addon)
				addon.Stop()
			EndIf
		EndIf
	EndWhile
	InvalidateAllRacesCache()
EndFunction

Function Notify(String msg)
	If config.bNotificationsEnabled
		Debug.Notification(msg)
	EndIf
EndFunction

Int Function CleanSchlongifiedArmors()
	int count = SOS_Data.CountConcealingArmors()
	int i = 0
	
	While i < count
		Armor arm = SOS_Data.GetConcealingArmor(i)
		if arm
			arm.RemoveSlotFromMask(0x00400000)
		endif
		i += 1
	endWhile
	
	i = 0
	count = SOS_Data.CountRevealingArmors()
	While i < count
		Armor arm = SOS_Data.GetRevealingArmor(i)
		if arm && !HasRevealingKeyword(arm)
			if Math.LogicalAnd(arm.GetSlotMask(), 0x00000004) == 0x00000004
				ArmorAddon akAddon
				int a = arm.GetNumArmorAddons()
				bool IsRevealing = True
				while a
					a -= 1
					akAddon = arm.GetNthArmorAddon(a)
					If akAddon && Math.LogicalAnd(akAddon.GetSlotMask(), 0x00400000) == 0x00400000
						arm.RemoveSlotFromMask(0x00400000)
						IsRevealing = False
						a = 0
					EndIf
				endwhile
				If IsRevealing
					arm.AddSlotToMask(0x00400000)
				EndIf
			EndIf
		endif
		i += 1
	endWhile
	
	count = SOS_Data.ClearConcealingArmors()
	count += SOS_Data.ClearRevealingArmors()
	
	Return count
EndFunction

Bool Function IsRevealing(Armor akArmor)
;	If useDLL
;		Return SOS_SKSE.IsRevealing(akArmor)
;	Else
		If akArmor
			If SOS_Data.FindRevealingArmor(akArmor) != -1
				Return True
			ElseIf HasRevealingKeyword(akArmor)
				Return True
			EndIf
		EndIf
		Return False
;	EndIf
EndFunction

Bool Function HasRevealingKeyword(Armor akArmor)
	If !SOS_Revealing
		SOS_Revealing = Keyword.GetKeyword("SOS_Revealing")
	EndIf
	If !akArmor || !SOS_Revealing
		Return False
	EndIf
	If akArmor.HasKeyword(SOS_Revealing)
		Return True
		Return akArmor.HasKeywordString(SOS_Revealing.GetString())
	EndIf
	String KeywordString = SOS_Revealing.GetString()
	keyword[] Keywords = akArmor.GetKeywords()
	int i = Keywords.Length
	While i > 0
		i -= 1
		If Keywords[i] && Keywords[i].GetString() == KeywordString
			Return True
		EndIf
	endWhile
	Return False
EndFunction

Function ToggleRevealingArmor(Actor akActor)
	PlayerRef.DoCombatSpellApply(SOS_RevealingArmorPlayerSpell, akActor)
EndFunction

Function CastDebugSpell(Actor akActor)
	PlayerRef.DoCombatSpellApply(SOS_DebugSpell, akActor)
EndFunction

; =========== SPELL MANAGEMENT ===============================================================================================

Function StartSpreading()
	{ Starts the cloak effect on player }
	PlayerRef.AddSpell(SOS_SetupSpell, false)
EndFunction

Function StopSpreading()
	{ Stops the cloak effect on player }
	PlayerRef.RemoveSpell(SOS_SetupSpell)
EndFunction

Function CheckActorSpell(Actor akActor, Bool activeState, Bool inMenu)
	If !akActor
		Return
	EndIf
	
	If !akActor.HasSpell(SOS_ActorSpell)
		akActor.AddSpell(SOS_ActorSpell, false)
	ElseIf !akActor.HasMagicEffect(SOS_ActorMagicEffect)
		; got spell and no magic effect? a possible cause is the resurrect console command on player
	    RestartActorSpell(akActor, inMenu)
	ElseIf activeState
		; Had the spell, ensure active state
		SendModEvent("ReSchlongify", "GoToActive", akActor.GetFormID())
	EndIf
EndFunction

Function CheckPlayerSpells()

	CheckActorSpell(PlayerRef, false, false)
	
	If !PlayerRef.HasSpell(SOS_SetupSpell)
		Debug.Trace("SOS CheckPlayerSpells: SOS_SetupSpell is lost?")
		StartSpreading()
	EndIf
	
EndFunction

Function GiveOrRemoveInteractionSpells(bool give, bool wait = true)
	{adds or removes the SOS interactive spells to/from the player as they are currently configured in the menu}
	; TODO: we probably do not need the waiting around in here
	GiveOrRemoveSpells(give, wait, SOS_ErectionSpell, SOS_ErectionNPCSpell)
EndFunction

Function GiveOrRemoveSpells(bool give, bool wait, Spell s1, Spell s2)
	If give
		PlayerRef.AddSpell(s1, false)
		If wait
			Utility.Wait(0.1)
		EndIf
		PlayerRef.AddSpell(s2, false)
	Else
		PlayerRef.RemoveSpell(s1)
		If wait
			Utility.Wait(0.1)
		EndIf
		PlayerRef.RemoveSpell(s2)
	EndIf
EndFunction

Function RestartActorSpell(Actor akActor, Bool inMenu)
	{ forces the OnEffectStart event on target actor }
	If !akActor
		Return
	EndIf
	
	akActor.RemoveSpell(SOS_ActorSpell)
	
	If inMenu
		Utility.WaitMenuMode(0.1)
	Else
		Utility.Wait(0.1) ; sometimes the actor doesn't get the spell back
	EndIf
	
	akActor.AddSpell(SOS_ActorSpell, false)
EndFunction

Bool Function SOSRaceMenuInstalled()
	Return SOSRaceMenu
EndFunction

Function SetSchlong(Actor akActor, Form addon, bool inMenu)
	If !akActor
		Return
	EndIf
	
	RegisterNewSchlongifiedActor(akActor, addon) ; addon formlist
	int size = SetSchlongType(addon, akActor) ; remove old addon, add new factions and genitals
	if size
		ScaleSchlongBones(addon, akActor, size)
		CheckActorSpell(akActor, true, inMenu)
		SOS_Data.RemoveBlacklisted(akActor)
		SOS_AddonQuest_Script realFreakingAddon = SOS_Data.GetAddon(SOS_Data.FindAddon(addon));
		SetSexlabGender(realFreakingAddon, akActor)
	EndIf
	; TODO: schlongify the armor. Is needed when forcing a schlong to a custom race and he's using a custom armor
EndFunction

FormList Property SOS_AddonLock Auto
FormList Property SOS_CompatibleRaces Auto
FormList Property SOS_EnabledRaces Auto
FormList Property SOS_RaceSizes Auto
FormList Property SOS_RaceProbabilities Auto
FormList Property SOS_Factions Auto
FormList Property SOS_Genders Auto
FormList Property SOS_SchlongifiedActors Auto
FormList Property SOS_Schlonged Auto
FormList Property SOS_ConcealingArmors Auto
FormList Property SOS_Bones Auto
FormList Property SOS_GenitalArmors Auto
FormList Property SOS_KnownRaces Auto
bool restartOptionEnabled

Scriptname SOS_PlayerAliasScript extends ReferenceAlias  

ReferenceAlias Property PlayerRef  Auto
SOS_SetupQuest_Script Property SOS_Quest Auto
SOS_Config Property config Auto
GlobalVariable Property SOS_Initialized Auto
Message Property SOS_ShapePotionCustomRace Auto

Int[] flex
Actor Property selectedActor Auto Hidden 
Actor lastNPC

int iBendUpKey = 201
int iBendDownKey = 209
int iBendPlayerModifierKey = 42

int addonsCount = 0
Bool addonsCheckInProgress
Bool armorsCheckInProgress

Event OnInit()
	RegisterKeys()
	RegisterForSingleUpdate(20.0)
EndEvent

Event OnUpdate()
	; this is to track a possible bug, store how many addons
	addonsCount = SOS_Data.CountAddons()
EndEvent

Event OnPlayerLoadGame()
	CheckAddons()
	CheckArmors()
endEvent

Int Function RemoveMissingArmors()
	int Output = -1
	Output = SOS_Data.Remove(none, "SOS_ConcealingArmors", none)
	Output += SOS_Data.Remove(none, "SOS_RevealingArmors", none)
	return Output
EndFunction

Function CheckArmors()
	; prevent double check/restore: one from self.OnPlayerLoadGame(), and one from SOS_Maintenance.Init() via SOS_Maintenance_Alias.OnPlayerLoadGame()
	If armorsCheckInProgress
		Return
	Else
		armorsCheckInProgress = True
	EndIf

	Debug.Trace("SOS CheckArmors: " + RemoveMissingArmors() + " armors are being removed") 
	armor knowArmor
	int i = SOS_Data.CountConcealingArmors()
	While i
		i -= 1
		knowArmor = SOS_Data.GetConcealingArmor(i)
		If knowArmor && Math.LogicalAnd(knowArmor.GetSlotMask(), 0x00400000) != 0x00400000
			If SOS_Quest.useDLL
				SOS_SKSE.FormListRemove(None, "SOS_RevealingArmors", knowArmor, True)
				SOS_SKSE.FormListAdd(None, "SOS_ConcealingArmors", knowArmor, False)
			EndIf
			knowArmor.AddSlotToMask(0x00400000)  ; slot 52
		EndIf
	EndWhile
	
	i = SOS_Data.CountRevealingArmors()
	While i
		i -= 1
		knowArmor = SOS_Data.GetRevealingArmor(i)
		If knowArmor && Math.LogicalAnd(knowArmor.GetSlotMask(), 0x00400000) == 0x00400000
			If SOS_Quest.useDLL
				SOS_SKSE.FormListRemove(None, "SOS_ConcealingArmors", knowArmor, True)
				SOS_SKSE.FormListAdd(None, "SOS_RevealingArmors", knowArmor, False)
			EndIf
			knowArmor.RemoveSlotFromMask(0x00400000)  ; slot 52
		EndIf
	EndWhile
	
	If PlayerRef
		SOS_Quest.UpdateNiNodes(PlayerRef.GetActorReference())
	EndIf
	Debug.Trace("SOS CheckArmors: done...") 
	armorsCheckInProgress = False
EndFunction

Function CheckAddons()
	; prevent double check/restore: one from self.OnPlayerLoadGame(), and one from SOS_Maintenance.Init() via SOS_Maintenance_Alias.OnPlayerLoadGame()
	If addonsCheckInProgress
		Return
	Else
		addonsCheckInProgress = True
	EndIf
	
	int skseCount = SOS_Data.CountAddons() ; addons stored in the SKSE save
	SOS_Data.Remove(none, "SOS_Addons", none) ; remove the invalid entries due to addon uninstall
	int actualCount = SOS_Data.CountAddons() ; valid addons
	int uninstalledAddons = skseCount - actualCount
	
	If uninstalledAddons == 0
		
		; check the installed addons against the stored addons in the regular save
		int lostCount = addonsCount - actualCount
		
		If lostCount > 0
			Debug.Trace("SOS CheckAddons: " + skseCount + " in SKSE save, " + actualCount + " valid entries, " + uninstalledAddons + " uninstalled, " + addonsCount + " before.")
			; The SKSE data is lost? Possible causes so far:
			; - Missing SKSE co-save. Most likely. The file has been deleted, or its name does not match the .ess file
			; - Conflict with another SKSE plugin (It happened with JContainers 0.67)
			; - PapyrusUtil has been uninstalled
			SOS_ShapePotionCustomRace.Show(lostCount) ; Warn user (recycled msg, don't mind its name)
			
			; reactivate the lost addons
			RestoreLostAddons()			
		EndIf
	EndIf
	
	If SOS_Quest.SOS_Addons.GetSize() > 0 && SOS_Data.CountAddons() == 0
		; Got schlongs in the formlist (regular save) but none in the skse storage
		; The mod was probably installed with no right SKSE installation. Now the SKSE is fine.
		; Schlong data was not properly stored when the mod installed for the first time and should be recovered
		RestoreLostAddons()
	EndIf
	
	; store the addon count in the regular save for next time
	addonsCount = SOS_Data.CountAddons()

	addonsCheckInProgress = False
EndFunction

Function RestoreLostAddons()
	{For when the SKSE data is lost, this reinstalls the installed addons }
	
	; re-add the spell to register the reschlongify mod event on player
	Game.GetPlayer().RemoveSpell(SOS_Quest.SOS_ActorSpell)
	Utility.Wait(0.1) ; needed to make sure actor magic effect stops
	
	; Recover the schlongs from the regular save
	int backupCount = SOS_Quest.SOS_Addons.GetSize()
	int i = 0
	int restored = 0
	
	While i < backupCount	
		SOS_addonQuest_Script addon = SOS_Quest.SOS_Addons.GetAt(i) as SOS_addonQuest_Script
		
		; is this schlong lost?
		If addon && SOS_Data.FindAddon(addon) == -1
			Debug.Trace("SOS RestoreLostAddons: Recovering " + addon)
			addon.RegisterAddon()
			restored += 1
		EndIf
		i += 1
	EndWhile

	SOS_Quest.InvalidateAllRacesCache()
	
	SOS_Quest.CheckActorSpell(Game.GetPlayer(), false, false)
	
	SOS_Quest.Notify("SOS has restored " + restored + " schlong addon(s).") ; todo translate
	
EndFunction

Event OnCrosshairRefChange(ObjectReference ref)
	If ref as Actor
		selectedActor = ref as Actor
	EndIf
EndEvent

Function RegisterKeys()
	If config.iBendUpKey
		iBendUpKey = config.iBendUpKey
	EndIf
	If config.iBendDownKey
		iBendDownKey = config.iBendDownKey
	EndIf
	If config.iBendPlayerModifierKey
		iBendPlayerModifierKey = config.iBendPlayerModifierKey
	EndIf
	
	Debug.Trace("SOS - RegisterForKey " + iBendUpKey + " and " + iBendDownKey)
	RegisterForKey(iBendUpKey)
	RegisterForKey(iBendDownKey)
	
	RegisterForCrosshairRef()
	
	If !flex
		flex = new Int[2]
	EndIf
EndFunction

Function ReRegisterKeys()
	UnRegisterForKey(iBendUpKey)
	UnRegisterForKey(iBendDownKey)
	RegisterKeys()
EndFunction

Event OnKeyDown(int aiKeyCode)
	Actor akActor
	Int pos = 0
	
	Int idx = Input.IsKeyPressed(iBendPlayerModifierKey) as Int
	If idx
		akActor = Game.GetPlayer()
		pos = flex[idx]
	ElseIf selectedActor
		If selectedActor == lastNPC
			pos = flex[idx]
		EndIf
		akActor = selectedActor
		lastNPC = selectedActor
	EndIf
	
	If akActor
		Int direction = 1
		If aiKeyCode == iBendDownKey
			direction = -1
		EndIf
		if (pos + direction) > -11 && (pos + direction) < 10
			pos += direction
		endif
		flex[idx] = pos
		If pos == -10
			Debug.SendAnimationEvent(akActor, "SOSFlaccid")
		Else
			Debug.SendAnimationEvent(akActor, "SOSBend" + pos)
		EndIf
	EndIf
EndEvent

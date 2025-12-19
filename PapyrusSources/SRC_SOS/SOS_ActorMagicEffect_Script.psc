Scriptname SOS_ActorMagicEffect_Script extends ActiveMagicEffect
{The effect that ensures that nude people have their schlongs visible, and dressed ones don't, unless they wear something revealing}

;----------PROPERTIES----------

SOS_SetupQuest_Script Property SOS_Quest Auto
SOS_Config Property config Auto

Spell Property SOS_ActorSpell Auto
Spell Property SOS_SetupSpell  Auto
MagicEffect Property SOS_ErectionMagicEffect Auto
FormList Property SOS_RevealingArmors Auto
Keyword Property SOS_Underwear Auto
Keyword Property SOS_Genitals Auto
Keyword Property SOS_Revealing Auto
Keyword Property SOS_Concealing Auto
Keyword Property SOS_Potion Auto
Keyword Property SOS_Merchant Auto
Faction Property SOS_SchlongifiedFaction Auto
Faction Property SOS_DialogSetup Auto
Race Property WereWolfBeastRace Auto

;----------ACTOR PROPERTIES----------

Actor Property ActorRef Auto Hidden
Actor Property PlayerRef Auto
int iFlexFactor = 0
bool schlongedBeforeWW = false

;----------EVENTS----------

Auto State Active

	Event OnEffectStart(Actor akTarget, Actor akCaster)
		If !ScriptIsBroken("OnEffectStart")
			
			ActorRef = akTarget
			RegisterForModEvent("ReSchlongify", "OnReSchlongify")
			
			Form addon = SOS_Quest.GetActiveAddon(ActorRef)
			If addon
				addon = ReSchlongify(addon)
			Else
				addon = Schlongify()
			EndIf
		EndIf
	EndEvent
	
	Event OnReSchlongify(string eventName, string strArg, float numArg, Form sender)
		If strArg == ""
			
			; main ReSchlongification process
			ReSchlongify()
			
		ElseIf strArg == "ScaleSchlongs"
		
			Form addon = SOS_Quest.GetActiveAddon(ActorRef)
			If addon
				int size = ActorRef.GetFactionRank(SOS_Data.GetFaction(addon))
				SOS_Quest.ScaleSchlongBones(addon, ActorRef, size)
			EndIf
		
		ElseIf strArg == "GoToSchlongless" && ActorRef && ActorRef.GetFormID() == numArg
			; character schlong has been removed through MCM
			GoToState("SchlongLess")
			
		;Else
		;	int handle = ModEvent.Create(strArg)
		;	if handle
		;		ModEvent.PushForm(handle, ActorRef)
		;		ModEvent.Send(handle)
		;	endIf
		EndIf
	EndEvent

	Event OnObjectUnequipped(Form akBaseObject, ObjectReference akReference)
		Armor unequipped = akBaseObject as Armor
		If !ActorRef || !unequipped || ScriptIsBroken("OnObjectUnequipped")
			Return
		EndIf
		;Debug.trace("SOS - U: " + akBaseObject.GetName() + " (" + akBaseObject.GetFormId() + ")")

		Utility.Wait(0.05)
		Armor PelvisEquipped =  ActorRef.GetWornForm(0x00400000) as Armor
		
		If !PelvisEquipped
			; check if we need to equip the genitals
			
			Armor BodyEquipped = ActorRef.GetWornForm(0x00000004) as Armor
			; Equip genitals if actor is nude, or is wearing revealing armor and the item removed is a panty/underwear
			If !BodyEquipped || (HasPelvisSlot(unequipped) && SOS_Quest.IsRevealing(BodyEquipped))
				EquipGenitals()
				
				; update needed if the camera is in TFC mode
				If Game.GetCameraState() == 3
					SOS_Quest.UpdateNiNodes(ActorRef)
				EndIf
				
				; this fixes the permaunderwear bug during SL animations when SL's Auto TFC mode setting is on
				; where SOS equips the schlong and doesn't show up until the camera mode changes back
				Utility.wait(0.1)
			EndIf
		EndIf

	EndEvent

	Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)
		;Debug.trace("SOS - E: " + akBaseObject.GetName() + " (" + akBaseObject.GetFormId() + ")")
		If ActorRef && ActorRef.GetLeveledActorBase().GetRace() != WerewolfBeastRace ; prevents unequipping genitals when an outfit is autoequipped during WW transform
			Armor akArmor = akBaseObject as Armor
			If akArmor && HasBodySlot(akArmor)
			;	int concealingMask = 0x00400004
				Bool isRevealingArmor = SOS_Quest.IsRevealing(akArmor)
				Bool isInConcealingList = SOS_Data.FindConcealingArmor(akArmor) != -1
				Bool hasBodyAndSOSSlot = Math.LogicalAnd(akArmor.GetSlotMask(), 0x00400004) == 0x00400004

				If !isRevealingArmor && !isInConcealingList  ; armor has been equipped for the first time
					if !hasBodyAndSOSSlot
						ArmorAddon akAddon
						int i = akArmor.GetNumArmorAddons()
						while i
							i -= 1
							akAddon = akArmor.GetNthArmorAddon(i)
							If akAddon && Math.LogicalAnd(akAddon.GetSlotMask(), 0x00400000) == 0x00400000
								SOS_Data.AddRevealingArmor(akArmor)
								i = 0
							EndIf
						endwhile
					EndIf
					IF SOS_Data.FindRevealingArmor(akArmor) < 0
						MarkArmorAsConcealing(akArmor)
					EndIf
					SOS_Quest.UpdateNiNodes(ActorRef)
				ElseIf isInConcealingList
					If !hasBodyAndSOSSlot  ; Armor slot 52 didn't stick. This usually happens after loading a game.
						akArmor.AddSlotToMask(0x00400000)  ; slot 52
						SOS_Quest.UpdateNiNodes(ActorRef)
					EndIf
				EndIf

				If HasPelvisSlot(akArmor)
					; concealing armor, the slot 52 hides the schlong, remove it from inventory
					UnequipGenitals()
				ElseIf !ActorRef.GetWornForm(0x00400000) as Armor
					; revealing armor, equip schlong if not already equipped
					EquipGenitals()
				EndIf
			EndIf
		EndIf

	EndEvent
	
	Event OnRaceSwitchComplete()
		;Debug.trace("SOS Actor ME Active - OnRaceSwitchComplete")
		If !ActorRef
			Return
		EndIf
		
		Form addon = SOS_Quest.GetActiveAddon(ActorRef)
		
		If ActorRef.GetLeveledActorBase().GetRace() != WerewolfBeastRace
			ScaleSchlongToCurrentSize(addon)
		Else
		
			schlongedBeforeWW = true

			; check MCM for schlong availability
			Float raceProbability = SOS_Quest.GetRaceProbability(addon, WerewolfBeastRace)
			If raceProbability <= 0.0
				GoToState("SchlongLess")
				If ActorRef.WornHasKeyword(SOS_Genitals)
					Debug.trace("SOS OnRaceSwitchComplete: No schlong for Werewolf. Werewolf race is disabled in MCM for the equipped schlong")
					UnequipGenitals()
				EndIf
			Else
				If !ActorRef.WornHasKeyword(SOS_Genitals)
					Debug.trace("SOS OnRaceSwitchComplete: equipping schlong after Werewolf transition")
					EquipGenitals(addon)
				EndIf
				ScaleSchlongToCurrentSize(addon, 1.5) ; + 50% bigger to compensate WW body
			EndIf
		EndIf
		
	EndEvent

EndState



State SchlongLess
	
	Event OnBeginState()
		;Debug.Trace("SOS SchlongLess: " + ActorRef.GetLeveledActorBase().GetName() + " entered schlongless state")
	EndEvent
	
	Event OnRaceSwitchComplete()
		
		; reequip schlong if reverting from WW
		If schlongedBeforeWW && ActorRef.GetLeveledActorBase().GetRace() != WerewolfBeastRace
			Debug.trace("SOS Werewolf: reequipping schlong after beast form")
			schlongedBeforeWW = false
			Form addon = SOS_Quest.GetActiveAddon(ActorRef)
			ScaleSchlongToCurrentSize(addon)
			EquipGenitals(addon, false)
			GoToState("Active")
		EndIf
		
	EndEvent
	
	Event OnObjectUnequipped(Form akBaseObject, ObjectReference akReference)
	EndEvent

EndState

; event handling for any state

Event OnReSchlongify(string eventName, string strArg, float numArg, Form sender)
	; force active state on previously SchlongLess actors
	If strArg == "GoToActive" && ActorRef && ActorRef.GetFormID() == numArg
		GoToState("Active")
	;ElseIf strArg && strArg != "ScaleSchlongs" && strArg != "GoToSchlongless"
	;	int handle = ModEvent.Create(strArg)
	;	if handle
	;		ModEvent.PushForm(handle, ActorRef)
	;		ModEvent.Send(handle)
	;	endIf
	EndIf
EndEvent

Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
	{Check for SOS Potions that an NPC gets in its inventory, and use them}
	If !ScriptIsBroken("OnItemAdded")
		Potion addedPotion = akBaseItem as Potion
		If addedPotion && ActorRef != PlayerRef ; Only NPCs should automatically use potions
			If addedPotion.HasKeyword(SOS_Potion) ;Is it a Normal Potion? Only Schlongified NPCs can use it then
				If SOS_Quest.GetActiveAddon(ActorRef)
					Debug.Trace("SOS OnItemAdded: NPC " + ActorRef.GetLeveledActorBase().GetName() + " got a normal potion " + akBaseItem.GetName() + " and should use it")
					ActorRef.EquipItem(akBaseItem)
				EndIf
			EndIf
		EndIf
	EndIf
EndEvent

Function MarkArmorAsConcealing(Armor akArmor)
	Debug.Trace("SOS MarkArmorAsConcealing: registering armor as concealing " + akArmor.GetName())
	akArmor.AddSlotToMask(0x00400000)
	SOS_Data.AddConcealingArmor(akArmor)
EndFunction

Bool Function IsConcealing(Armor akArmor)
	; armor has both slots 32 and 52, or is flagged as concealing
	Return Math.LogicalAnd(akArmor.GetSlotMask(), 0x00400004) == 0x00400004 \
		|| SOS_Data.FindConcealingArmor(akArmor) != -1
EndFunction

Function EquipGenitals(Form addon = None, Bool checkErection = true)
	If !ActorRef
		Return
	EndIf
	
	If !addon
		addon = SOS_Quest.GetActiveAddon(ActorRef)
		If !addon
			; most likely this is caused by and OnObjectEquipped or OnObjectUnequipped
			; before the scripts are finished assigning a schlong
			Return
		EndIf
	EndIf
	
	Armor genitals = SOS_Data.GetGenitalArmor(addon)
	
	;If ActorRef.GetWornForm(0x00400000)
		; make sure there is nothing on the slot 52 item
		; this could happen if swapping a body armor (32+52) via scripting
		; 1. unequipping the armor triggers sos to put the schlong
		; 2. then a second armor is equipped before the schlong has been equipped
		; 3. finally sos equips the schlong, which unequips the body armor
		;Return
	;EndIf
	ActorRef.EquipItem(genitals, false, true)
	If checkErection && ActorRef.HasMagicEffect(SOS_ErectionMagicEffect)
		Debug.SendAnimationEvent(ActorRef, "SOSFastErect")
	Else
		SOS_Quest.CheckArousalOverride(ActorRef)
	EndIf
EndFunction

Function UnequipGenitals()
	If !ActorRef
		Return
	EndIf
	
	Form addon = SOS_Quest.GetActiveAddon(ActorRef)
	Armor genitals = SOS_Data.GetGenitalArmor(addon)
	;Debug.trace("SOS Unequip Genitals from " + ActorRef.GetLeveledActorBase().GetName())
	If genitals
		ActorRef.RemoveItem(genitals, 999, true)
	EndIf
EndFunction

Function ScaleSchlongToCurrentSize(Form addon, float factor = 1.0)
	If !ActorRef
		Return
	EndIf
	
	int size = ActorRef.GetFactionRank(SOS_Data.GetFaction(addon)) as int
	size = Math.Floor(size * factor)
	If size > 40
		size = 40
	EndIf
	SOS_Quest.ScaleSchlongBones(addon, ActorRef, size)
EndFunction

Bool Function ScriptIsBroken(String func)

	Bool isBroken = (!Self || StringUtil.Find(Self as string, "<None>") >= 0)

	If !isBroken
		isBroken = (!SOS_Quest || SOS_Quest == none || !SOS_SchlongifiedFaction || !SOS_SchlongifiedFaction || SOS_SchlongifiedFaction == None || StringUtil.Find(SOS_SchlongifiedFaction as String, "<None>") >= 0)
		If isBroken
			; Probably this script is a remainder of a previous SOS installation, baked in the savegame.
			; It points to None references, dispel
			Debug.Trace("SOS " + func + ": leftover script on " + ActorRef)
			Dispel()
		Else
			isBroken = true
			isBroken = GetTargetActor() == none
		EndIf
	EndIf

	Return isBroken
EndFunction

Form Function Schlongify()

	; the actor has no schlong yet, so we select one for him/her if available
	Form addon = SOS_Quest.DetermineSchlongType(ActorRef)
	If !addon
		GoToState("SchlongLess")
		Return None
	EndIf
	
	int size = SOS_Quest.DetermineSchlongSize(addon, ActorRef)
	SOS_Quest.SetSchlongSize(addon, ActorRef, size)
	SOS_Quest.RegisterNewSchlongifiedActor(ActorRef, addon)
	
	SOS_AddonQuest_Script realFreakingAddon = SOS_Data.GetAddon(SOS_Data.FindAddon(addon));
	SOS_Quest.SetSexlabGender(realFreakingAddon, ActorRef)
	
	Debug.Trace("SOS Actor Schlongify: new schlong for " + ActorRef.GetLeveledActorBase().GetName() + " got schlong index " + SOS_Data.FindAddon(addon) + " size " + size)
	
	CheckArmor(addon)
	
	int handle = ModEvent.Create("Schlongify")
	if handle
		ModEvent.PushForm(handle, ActorRef)
		ModEvent.PushForm(handle, addon)
		ModEvent.Send(handle)
	endIf
	
	Return addon
	
EndFunction

Form Function ReSchlongify(Form addon = None)
	{Fixes bones scales}
	ActorRef = ActorRef as Actor
	If !ActorRef || ActorRef == None || StringUtil.Find(ActorRef as string,"<NULL ") >= 0 || ActorRef.IsDisabled() ||  ActorRef.IsDeleted()
		Return None
	ElseIf !ActorRef.Is3DLoaded()
		; when loading an autosave after zone change, actors may have not been fully loaded
		Utility.wait(1)
		If !ActorRef.Is3DLoaded()
			; actor is not in player's location, no need to fix
			Return None
		Else
			Return ReSchlongify(addon)
		EndIf
	EndIf
	
	If !addon
		addon = SOS_Quest.GetActiveAddon(ActorRef)
	EndIf
	
	If addon
		int size = ActorRef.GetFactionRank(SOS_Data.GetFaction(addon))
		ActorRef.SetFactionRank(SOS_SchlongifiedFaction, size) ; sinchronize factions
		SOS_Quest.ScaleSchlongBones(addon, ActorRef, size) ; scales
		;Debug.Trace("SOS ReSchlongify: fixing " + SOS_Data.GetFaction(addon).GetName() + "[" + size +"] for actor " + ActorRef.GetLeveledActorBase().getName())
		CheckArmor(addon)
	ElseIf SOS_Data.FindBlacklisted(actorRef) == -1
		Debug.Trace("SOS ReSchlongify: " + ActorRef.GetLeveledActorBase().getName() + " somehow lost his schlong!?!")
		addon = Schlongify()
	Endif
	
	Return addon
	
EndFunction

Function CheckArmor(Form addon)
	If !addon || !ActorRef
		Return
	EndIf

	Armor bodyArmor = ActorRef.GetWornForm(0x00000004) as Armor
	If !bodyArmor
		If !ActorRef.GetWornForm(0x00400000) as Armor  ; nothing in pelvis slot 52
			EquipGenitals(addon, false)
		EndIf
		Return
	EndIf
	Bool isRevealingArmor = SOS_Quest.IsRevealing(bodyArmor)
	Bool isInConcealingList = StorageUtil.FormListHas(None, "SOS_ConcealingArmors", bodyArmor)
	Bool hasBodyAndSOSSlot = Math.LogicalAnd(bodyArmor.GetSlotMask(), 0x00400004) == 0x00400004
	
	If !isRevealingArmor && !isInConcealingList
		; a custom armor has been equipped for the 1st time
		
		; Now that the armor has the slot 52, update actor
		; this hides the underwear AA from the SkinNaked
		if !hasBodyAndSOSSlot
			ArmorAddon akAddon
			int i = bodyArmor.GetNumArmorAddons()
			while i
				i -= 1
				akAddon = bodyArmor.GetNthArmorAddon(i)
				If akAddon && Math.LogicalAnd(akAddon.GetSlotMask(), 0x00400000) == 0x00400000
					SOS_Data.AddRevealingArmor(bodyArmor)
					i = 0
				EndIf
			endwhile
		EndIf
		IF SOS_Data.FindRevealingArmor(bodyArmor) < 0
			MarkArmorAsConcealing(bodyArmor)
		EndIf
		SOS_Quest.UpdateNiNodes(ActorRef)

	ElseIf isInConcealingList
		If !hasBodyAndSOSSlot  ; Armor slot 52 didn't stick. This usually happens after loading a game.
			bodyArmor.AddSlotToMask(0x00400000)  ; slot 52
			SOS_Quest.UpdateNiNodes(ActorRef)
		EndIf
		
	ElseIf isRevealingArmor
		; Nude or revealing armor. Equip genitals if the pelvis slot is free
		If !ActorRef.GetWornForm(0x00400000) as Armor  ; nothing in pelvis slot 52
			EquipGenitals(addon, false)
		Else  ; before: SOS_Data.FindRevealingArmor(bodyArmor) != -1
			; armor has been set up as revealing, make the schlong poke out
			SOS_Quest.UpdateNiNodes(ActorRef)
		EndIf
		
	EndIf
EndFunction

Bool Function HasBodySlot(Armor akArmor)
	Return Math.LogicalAnd(akArmor.GetSlotMask(), 0x00000004)
EndFunction

Bool Function HasPelvisSlot(Armor akArmor)
	Return Math.LogicalAnd(akArmor.GetSlotMask(), 0x00400000)
EndFunction

; =========== DEPRECATED =======================================================================

FormList Property SOS_ConcealingArmors Auto
Keyword Property SOS_ShapePotion Auto
Message Property SOS_ShapePotionCustomRace Auto
FormList Property SOS_EnabledRaces Auto
FormList Property SOS_Factions Auto
FormList Property SOS_GenitalArmors Auto
FormList Property SOS_Bones Auto
FormList Property SOS_ShapePotions Auto

Scriptname SOS_RevealingArmorMagicEffect_Script extends activemagiceffect  

;----------PROPERTIES----------

SOS_SetupQuest_Script Property SOS_Quest Auto

FormList Property SOS_Factions Auto             ; DEPRECATED
FormList Property SOS_GenitalArmors Auto        ; DEPRECATED
FormList Property SOS_RevealingArmors Auto      ; DEPRECATED
FormList Property SOS_ConcealingArmors Auto     ; DEPRECATED
Keyword Property SOS_Concealing Auto
Keyword Property SOS_Revealing Auto

;----------EVENTS----------

Event OnEffectFinish(Actor akTarget, Actor akCaster)

	Armor bodyArmor = akTarget.GetWornForm(0x00000004) as Armor
	If !bodyArmor
		Return
	EndIf
	
	Armor genitals = SOS_Data.GetGenitalArmor(SOS_Quest.GetActiveAddon(akTarget))
	
	Debug.trace("SOS_RevealingArmorMagicEffect: " + akTarget + ", arm = " + bodyArmor + ", gen = " + genitals)
	
	If !SOS_Quest.HasRevealingKeyword(bodyArmor) && SOS_Data.FindRevealingArmor(bodyArmor) != -1
		SOS_Data.RemoveRevealingArmor(bodyArmor)
		SOS_Data.AddConcealingArmor(bodyArmor)
		if Math.LogicalAnd(bodyArmor.GetSlotMask(), 0x00400000) != 0x00400000
			bodyArmor.AddSlotToMask(0x00400000)
		endIf
		akTarget.RemoveItem(genitals, 999, true)
		Debug.Trace("SOS_RevealingArmorMagicEffect: Armor set to concealing.")
		SOS_Quest.Notify(bodyArmor.GetName() + " set to be a Concealing Armor") ; todo translate
	Elseif SOS_Data.FindConcealingArmor(bodyArmor) != -1
		SOS_Data.RemoveConcealingArmor(bodyArmor)
		SOS_Data.AddRevealingArmor(bodyArmor)
		if Math.LogicalAnd(bodyArmor.GetSlotMask(), 0x00400004) == 0x00400004
			bodyArmor.RemoveSlotFromMask(0x00400000)
		EndIf
		akTarget.EquipItem(genitals, false, true)
		SOS_Quest.UpdateNiNodes(akTarget)
		Debug.Trace("SOS_RevealingArmorMagicEffect: Armor set to revealing.")
		SOS_Quest.Notify(bodyArmor.GetName() + " set to be a Revealing Armor") ; todo translate
	ElseIf Math.LogicalAnd(bodyArmor.GetSlotMask(), 0x00000004)
		SOS_Data.AddRevealingArmor(bodyArmor)
		if Math.LogicalAnd(bodyArmor.GetSlotMask(), 0x00400004) == 0x00400004
			bodyArmor.RemoveSlotFromMask(0x00400000)
		EndIf
		akTarget.EquipItem(genitals, false, true)
		SOS_Quest.UpdateNiNodes(akTarget)
		Debug.Trace("SOS_RevealingArmorMagicEffect: Armor set to revealing.")
		SOS_Quest.Notify(bodyArmor.GetName() + " set to be a Revealing Armor") ; todo translate
	EndIf

EndEvent

ScriptName SOS_SKSE

; ---------------------------------------------------------------------------------------
; NOTE: This version of Schlongs of Skyrim is no longer dependent on SchlongsOfSkyrim.dll
;       which is currently not compatible with Skyrim AE versions 1.6.x.
;       None of the functions in here are actually used anymore,
;       but keeping this script in case some other mod calls its functions.
; ---------------------------------------------------------------------------------------

; The dynamic use of the slot 52 has been moved from the Armors to their ArmorAddons

; Checks the slots on the armor, and also on all AAs that uses the body slot
;Bool Function HasSlot(Armor akArmor, int slotMask) Global Native

; Checks if the armor is a custom armor and adds the slot 52 to it
; For that, the armor must be a non-revealing body armor with no slot 52
; Returns true if the slot was added, false if these conditions were not met
; NOTE: not used by any other SOS script
Bool Function FixCustomArmor(Armor akArmor) Global Native
;/ 	If akArmor.GetFormID() / 0x1000000 > 4  ; not defined in Skyrim.esm, Update.esm, Dawnguard.esm, HearthFires.esm, or Dragonborn.esm
		Int slotMask = akArmor.GetSlotMask()
		If slotMask == 0x00000004  ; slot 32 only
			If !IsRevealing(akArmor) || IsInConcealingList(akArmor)
				akArmor.AddSlotToMask(0x00400000)  ; slot 52
				Return True
			EndIf
		EndIf
	EndIf
	Return False
EndFunction
 /;
; Returns true if either
; A) the passed Armor has the SOS_Revealing keyword, or
; B) its first ArmorAddon using the body biped slot is stored in the list SOS_RevealingArmors
Bool Function IsRevealing(Armor akArmor) Global Native
;/	; Replaced with Papyrus emulation in SOS_SetupQuest_Script
	Return (Game.GetFormFromFile(0xD62, "Schlongs of Skyrim.esp") as SOS_SetupQuest_Script).IsRevealing(akArmor)
EndFunction
/;
; Returns true if the armor is a body armor and its first ArmorAddon using the body biped slot also uses the slot 52
;Bool Function IsConcealing(Armor akArmor) Global
;	Return akArmor && HasSlot(akArmor, akArmor.kSlotMask52)
;EndFunction

;Bool Function SetConcealing(Armor akArmor) Global Native

;Bool Function SetRevealing(Armor akArmor) Global Native

; Returns true if the armor is stored in the list SOS_ConcealingArmors
; NOTE: only used in the SOS debug spell
Bool Function IsInConcealingList(Armor akArmor) Global Native
;/ 	Return StorageUtil.FormListHas(None, "SOS_ConcealingArmors", akArmor)
EndFunction
 /;
; This does fixes to the data stored in SOS SKSE plugin, if needed for the passed version
;Function Maintenance(int version) Global Native

; NOTE: Only used once in SOS_SetupQuest_Script. To be inlined there because of faster data access.
Form Function DetermineSchlongType (Actor akActor) Global Native
;/	; Replaced with Papyrus emulation in SOS_SetupQuest_Script
	(Game.GetFormFromFile(0xD62, "Schlongs of Skyrim.esp") as SOS_SetupQuest_Script).DetermineSchlongType(akActor)
EndFunction
/;
; NOTE: used once in SOS_SetupQuest_Script
Function ScaleSchlongBones(Form addon, Actor akActor, int rank, float factor) Global Native
;/	(Game.GetFormFromFile(0xD62, "Schlongs of Skyrim.esp") as SOS_SetupQuest_Script).ScaleSchlongBones(addon, akActor, rank)
EndFunction
/;
int function FormListAdd(Form obj, string key, Form value, bool allowDuplicate = true) global native
;/ 	StorageUtil.FormListAdd(obj, keyName, value, allowDuplicate = true)
EndFunction
/;
int function IntListAdd(Form obj, string key, Int value, bool allowDuplicate = true) global native
;/ 	StorageUtil.IntListAdd(obj, keyName, value, allowDuplicate = true)
EndFunction
 /;
int function FloatListAdd(Form obj, string key, Float value, bool allowDuplicate = true) global native
;/ 	StorageUtil.FloatListAdd(obj, keyName, value, allowDuplicate = true)
EndFunction
 /;
int function FormListClear(Form obj, string key) global native
;/ 	StorageUtil.FormListClear(obj, keyName)
EndFunction
 /;
int function IntListClear(Form obj, string key) global native
;/ 	StorageUtil.IntListClear(obj, keyName)
EndFunction
 /;
int function FloatListClear(Form obj, string key) global native
;/ 	StorageUtil.FloatListClear(obj, keyName)
EndFunction
 /;
int function FormListCount(Form obj, string key) global native
;/ 	StorageUtil.FormListCount(obj, keyName)
EndFunction
 /;
int function IntListCount(Form obj, string key) global native
;/ 	StorageUtil.IntListCount(obj, keyName)
EndFunction
 /;
int function FloatListCount(Form obj, string key) global native
;/ 	StorageUtil.FloatListCount(obj, keyName)
EndFunction
 /;
int function FormListFind(Form obj, string key, Form value) global native
;/ 	StorageUtil.FormListFind(obj, keyName, value)
EndFunction
 /;
int function IntListFind(Form obj, string key, Int value) global native
;/ 	StorageUtil.IntListFind(obj, keyName, value)
EndFunction
 /;
int function FloatListFind(Form obj, string key, Float value) global native
;/ 	StorageUtil.FloatListFind(obj, keyName, value)
EndFunction
 /;
Form function FormListGet(Form obj, string key, int index) global native
;/ 	StorageUtil.FormListGet(obj, keyName, index)
EndFunction
 /;
Int function IntListGet(Form obj, string key, int index) global native
;/ 	StorageUtil.IntListGet(obj, keyName, index)
EndFunction
 /;
Float function FloatListGet(Form obj, string key, int index) global native
;/ 	StorageUtil.FloatListGet(obj, keyName, index)
EndFunction
 /;
int function FormListRemove(Form obj, string key, Form value, bool allInstances = false) global native
;/ 	StorageUtil.FormListRemove(obj, keyName, value, allInstances = false)
EndFunction
 /;
int function IntListRemove(Form obj, string key, Int value, bool allInstances = false) global native
;/ 	StorageUtil.IntListRemove(obj, keyName, value, allInstances = false)
EndFunction
 /;
int function FloatListRemove(Form obj, string key, Float value, bool allInstances = false) global native
;/ 	StorageUtil.FloatListRemove(obj, keyName, value, allInstances = false)
EndFunction
 /;
Form function FormListSet(Form obj, string key, int index, Form value) global native
;/ 	StorageUtil.FormListSet(obj, keyName, index, value)
EndFunction
 /;
int function IntListSet(Form obj, string key, int index, int value) global native
;/ 	StorageUtil.IntListSet(obj, keyName, index, value)
EndFunction
 /;
float function FloatListSet(Form obj, string key, int index, float value) global native
;/ 	StorageUtil.FloatListSet(obj, keyName, index, value)
EndFunction
 /;
int function GetIntValue(Form obj, string key, int missing = 0) global native
;/ 	StorageUtil.GetIntValue(obj, keyName, missing = 0)
EndFunction
 /;
int function SetIntValue(Form obj, string key, int value) global native
;/ 	StorageUtil.SetIntValue(obj, keyName, value)
EndFunction
 /;
bool function UnsetIntValue(Form obj, string key) global native;
;/ 	StorageUtil.UnsetIntValue(obj, keyName)
EndFunction
 /;
Scriptname SOS_IO Extends Quest

int RESULT_OK = 0
int INVALID_FILE = -1
int INVALID_CONTENT = -2

Bool Function ExportSettings()
	ExportGeneralSettings()
	ExportAddons()
	ExportArmors()
	Bool result = Save(getFileName())
	Return result
EndFunction

String Function getFileName() Global
	Return "../SOS.json"
EndFunction

Int Function ImportSettings()
	bool ok = Load(getFileName())
	If ok
		int result = ImportGeneralSettings()
		If result == RESULT_OK
			ImportAddons()
			SOS.SendModEvent("ReSchlongify", "ScaleSchlongs")
			ImportArmors()
		EndIf
		Return result
	EndIf
	Return INVALID_FILE
EndFunction

Function ExportGeneralSettings()
	setInt(MIN_SCHLONG_SIZE, SOS.iMinSchlongSize)
	setInt(MAX_SCHLONG_SIZE, SOS.iMaxSchlongSize)
	setFloat(GLOBAL_SCHLONG_SIZE_BOOST_FACTOR, SOS.fGlobalSchlongSizeBoostFactor)
	setInt(DIALOG_SETTINGS, SOS.iDialogSettings)
	setInt(ERECTION_SPELLS_ENABLED, SOS.bErectionSpellsEnabled as int)
	setInt(POTIONS_ENABLED, SOS.bPotionsEnabled as int)
	setInt(DISTRIBUTE_ADDONS, SOS.bDistributeAddons as int)
	setInt(BEND_UP_KEY, SOS.iBendUpKey)
	setInt(BEND_DOWN_KEY, SOS.iBendDownKey)
	setInt(BEND_PLAYER_MODIFIER_KEY, SOS.iBendPlayerModifierKey)
EndFunction

Function ExportArmors()
	int i = 0
	int count = SOS_Data.CountRevealingArmors()
	form[] kArmors = Utility.CreateFormArray(count)
	While i < count
		kArmors[i] = SOS_Data.GetRevealingArmor(i)
		i += 1
	EndWhile
	kArmors = PapyrusUtil.RemoveForm(kArmors, none)
	setFormList(REVEALING_ARMORS, kArmors)
	i = 0
	count = SOS_Data.CountConcealingArmors()
	kArmors = Utility.CreateFormArray(count)
	While i < count
		kArmors[i] = SOS_Data.GetConcealingArmor(i)
		i += 1
	EndWhile
	kArmors = PapyrusUtil.RemoveForm(kArmors, none)
	setFormList(CONCEALING_ARMORS, kArmors)
EndFunction

Function ExportAddons()
	int i = 0
	int count = SOS_Data.CountAddons()
	String[] sAddons = Utility.CreateStringArray(count)
	Int[] iGenders = Utility.CreateIntArray(count)
	While i < count
		SOS_AddonQuest_Script addon = SOS_Data.GetAddon(i)
		sAddons[i] = addon.getAddonName()
		iGenders[i] = SOS_Data.GetGender(addon)
		ExportRaces(addon, i)
		i += 1
	EndWhile
	setIntList(GENDERS, iGenders)
	setStringList(ADDONS, sAddons)
EndFunction

Function ExportRaces(Form addon, int index)
	int i = 0
	int count = SOS_Data.CountCompatibleRaces(addon)
	Int[] enabledRaces = Utility.CreateIntArray(count)
	Int[] sizes = Utility.CreateIntArray(count)
	Float[] probabilities = Utility.CreateFloatArray(count)
	While i < count
		enabledRaces[i] = (SOS_Data.FindEnabledRace(addon, SOS_Data.GetCompatibleRace(addon, i)) != -1) as Int
		sizes[i] = SOS_Data.GetRaceSize(addon, i)
		probabilities[i] = SOS_Data.GetRaceProbability(addon, i)
		i += 1
	EndWhile
	setIntList(ENABLED_RACES_ADDON + index, enabledRaces)
	setIntList(SIZES_ADDON + index, sizes)
	setFloatList(PROBABILITIES_ADDON + index, probabilities)
EndFunction

Int Function ImportGeneralSettings()
	int iMinSchlongSize = getInt(MIN_SCHLONG_SIZE)
	int iMaxSchlongSize = getInt(MAX_SCHLONG_SIZE)
	If !(iMinSchlongSize > 0 && iMinSchlongSize < 8)
		; Missing entry or invalid value. Something went wrong with this file
		Return INVALID_CONTENT
	EndIf
	SOS.iMinSchlongSize = iMinSchlongSize
	If !(iMaxSchlongSize > 0 && iMaxSchlongSize < 21)
		; Missing entry or invalid value. Something went wrong with this file
		Return INVALID_CONTENT
	EndIf
	SOS.iMaxSchlongSize = iMaxSchlongSize
	SOS.fGlobalSchlongSizeBoostFactor = getFloat(GLOBAL_SCHLONG_SIZE_BOOST_FACTOR)
	SOS.SetDialogSettings(getInt(DIALOG_SETTINGS))
	SOS.SetErectionSpellsEnabled(getInt(ERECTION_SPELLS_ENABLED) as Bool)
	SOS.SetPotionsEnabled(getInt(POTIONS_ENABLED) as Bool)
	SOS.bDistributeAddons = getInt(DISTRIBUTE_ADDONS) as Bool
	SOS.iBendUpKey = getInt(BEND_UP_KEY)
	SOS.iBendDownKey = getInt(BEND_DOWN_KEY)
	SOS.iBendPlayerModifierKey = getInt(BEND_PLAYER_MODIFIER_KEY)
	SOS.PlayerAliasScript.ReRegisterKeys()
	Return RESULT_OK
EndFunction

Function ImportArmors()
	int i = 0
	form[] kArmors = getFormList(REVEALING_ARMORS)
	armor kArmor
	While i < kArmors.Length
		If (kArmor)
			; is this armor installed?
			SOS_Data.RemoveConcealingArmor(kArmor)
			If SOS_Data.FindRevealingArmor(kArmor) < 0
				SOS_Data.AddRevealingArmor(kArmor)
				if Math.LogicalAnd(kArmor.GetSlotMask(), 0x00400004) == 0x00400004
					kArmor.RemoveSlotFromMask(0x00400000)
				EndIf
			EndIf
		EndIf
		i += 1
	EndWhile
	i = 0
	kArmors = getFormList(CONCEALING_ARMORS)
	While i < kArmors.Length
		kArmor = kArmors[i] as armor
		If (kArmor)
			; is this armor installed?
			SOS_Data.RemoveRevealingArmor(kArmor)
			If SOS_Data.FindConcealingArmor(kArmor) < 0
				SOS_Data.AddConcealingArmor(kArmor)
				If Math.LogicalAnd(kArmor.GetSlotMask(), 0x00400000) != 0x00400000
					kArmor.AddSlotToMask(0x00400000)  ; slot 52
				EndIf
			EndIf
		EndIf
		i += 1
	EndWhile
EndFunction

Function ImportAddons()
	int i = 0
	String[] sAddons = getStringList(ADDONS)
	Int[] iGenders = getIntList(GENDERS)
	int count = sAddons.Length
	While i < count
		; is this addon installed?
		int installedIdx = SOS.GetAddonIndexForName(sAddons[i])
		If installedIdx != -1
			SOS_AddonQuest_Script addon = SOS_Data.GetAddon(installedIdx)
			SOS_Data.SetGender(addon, iGenders[i])
			ImportRaces(addon, i)
		EndIf
		i += 1
	EndWhile
EndFunction

Function ImportRaces(Form addon, int index)
	Int[] enabledRaces = getIntList(ENABLED_RACES_ADDON + index)
	Int[] sizes = getIntList(SIZES_ADDON + index)
	Float[] probabilities = getFloatList(PROBABILITIES_ADDON + index)
	int i = 0
	int count = enabledRaces.Length
	While i < count
		bool enabledRace = enabledRaces[i] as Bool
		Race aRace = SOS_Data.GetCompatibleRace(addon, i)
		bool alreadyEnabled = SOS_Data.FindEnabledRace(addon, aRace) != -1
		If enabledRace && !alreadyEnabled
			SOS_Data.AddEnabledRace(addon, aRace)
		ElseIf !enabledRace && alreadyEnabled
			SOS_Data.RemoveEnabledRace(addon, aRace)
		EndIf
		SOS_Data.SetRaceSize(addon, i, sizes[i])
		SOS_Data.SetRaceProbability(addon, i, probabilities[i])
		i += 1
	EndWhile
EndFunction

SOS_Config Property SOS Auto

String MIN_SCHLONG_SIZE = "iMinSchlongSize"
String MAX_SCHLONG_SIZE = "iMaxSchlongSize"
String GLOBAL_SCHLONG_SIZE_BOOST_FACTOR = "fGlobalSchlongSizeBoostFactor"
String DIALOG_SETTINGS = "iDialogSettings"
String ERECTION_SPELLS_ENABLED = "bErectionSpellsEnabled"
String POTIONS_ENABLED = "bPotionsEnabled"
String DISTRIBUTE_ADDONS = "bDistributeAddons"
String BEND_UP_KEY = "iBendUpKey"
String BEND_DOWN_KEY = "iBendDownKey"
String BEND_PLAYER_MODIFIER_KEY = "iBendPlayerModifierKey"
String GENDERS = "iGenders"
String ADDONS = "sAddons"
String REVEALING_ARMORS = "kRevealingArmors"
String CONCEALING_ARMORS = "kConcealingArmors"
String ENABLED_RACES_ADDON = "iEnabledRacesAddon"
String SIZES_ADDON = "iSizesAddon"
String PROBABILITIES_ADDON = "fProbabilitiesAddon"

; native functions in SchlongsOfSkyrim.dll are replaced with their respective JsonUtil functions
;
Function setInt(String KeyName, Int value)
	JsonUtil.SetIntValue("../SOS.json", KeyName, value)
EndFunction
Function setFloat(String KeyName, Float value)
	JsonUtil.SetFloatValue("../SOS.json", KeyName, value)
EndFunction
Function setIntList(String KeyName, Int[] value)
	JsonUtil.IntListCopy("../SOS.json", KeyName, value)
EndFunction
Function setFloatList(String KeyName, Float[] value)
	JsonUtil.FloatListCopy("../SOS.json", KeyName, value)
EndFunction
Function setStringList(String KeyName, String[] value)
	JsonUtil.StringListCopy("../SOS.json", KeyName, value)
EndFunction
Function setFormList(String KeyName, form[] value)
	JsonUtil.FormListCopy("../SOS.json", KeyName, value)
EndFunction
;
Int Function getInt(String KeyName)
	Return JsonUtil.GetIntValue("../SOS.json", KeyName)
EndFunction
Float Function getFloat(String KeyName)
	Return JsonUtil.GetFloatValue("../SOS.json", KeyName)
EndFunction
Int[] Function getIntList(String KeyName)
	Return JsonUtil.IntListToArray("../SOS.json", KeyName)
EndFunction
Float[] Function getFloatList(String KeyName)
	Return JsonUtil.FloatListToArray("../SOS.json", KeyName)
EndFunction
String[] Function getStringList(String KeyName)
	Return JsonUtil.StringListToArray("../SOS.json", KeyName)
EndFunction
Form[] Function getFormList(String KeyName)
	Return JsonUtil.FormListToArray("../SOS.json", KeyName)
EndFunction
;
Bool Function Save(String file)
	Return JsonUtil.Save("../SOS.json", minify = False)
EndFunction
Bool Function Load(String file)
	Return JsonUtil.Load("../SOS.json")
EndFunction

Scriptname slac_Data Extends Quest
{SexLab Aroused Creatures data storage and handling functions}

Import StorageUtil

; ===================================
; =                                 =
; =              Data               =
; =                                 =
; ===================================


; Get / Set SLAC Signal Data
; This is data used to send additional info between pending operations such as signalling the 
; disposition of a pursuit trigger to a capture event. This data is not intended to be persistent 
; and should not persist between saves or even beyond the end of an engagement. This data is not 
;intended to be transferable between saves and will only be stored on local references.
Int Function SetSignalInt(Form akForm = None, String dataKey, Int dataValue)
	Return SetIntValue(akForm, "SLArousedCreatures.Signal." + dataKey, dataValue)
EndFunction
Int Function GetSignalInt(Form akForm = None, String dataKey, Int dataValueDefault = 0)
	Return GetIntValue(akForm, "SLArousedCreatures.Signal." + dataKey, dataValueDefault)
EndFunction
Bool Function SetSignalBool(Form akForm = None, String dataKey, Bool dataValue)
	Return SetIntValue(akForm, "SLArousedCreatures.Signal." + dataKey, dataValue as Int)
EndFunction
Bool Function GetSignalBool(Form akForm = None, String dataKey, Bool dataValueDefault = False)
	Return GetIntValue(akForm, "SLArousedCreatures.Signal." + dataKey, dataValueDefault as Int) as Bool
EndFunction
Float Function SetSignalFloat(Form akForm = None, String dataKey, Float dataValue)
	Return SetFloatValue(akForm, "SLArousedCreatures.Signal." + dataKey, dataValue)
EndFunction
Float Function GetSignalFloat(Form akForm = None, String dataKey, Float dataValueDefault = 0.0)
	Return GetFloatValue(akForm, "SLArousedCreatures.Signal." + dataKey, dataValueDefault)
EndFunction
String Function SetSignalString(Form akForm = None, String dataKey, String dataValue)
	Return SetStringValue(akForm, "SLArousedCreatures.Signal." + dataKey, dataValue)
EndFunction
String Function GetSignalString(Form akForm = None, String dataKey, String dataValueDefault = "")
	Return GetStringValue(akForm, "SLArousedCreatures.Signal." + dataKey, dataValueDefault)
EndFunction
Form Function SetSignalForm(Form akForm = None, String dataKey, Form dataValue)
	Return SetFormValue(akForm, "SLArousedCreatures.Signal." + dataKey, dataValue)
EndFunction
Form Function GetSignalForm(Form akForm = None, String dataKey, Form dataValueDefault = None)
	Return GetFormValue(akForm, "SLArousedCreatures.Signal." + dataKey, dataValueDefault)
EndFunction
Int Function ClearSignal(Form akForm = None, String dataKey = "")
	; Clear signals from form - for use at the end of an engagement or end of failed pursuit
	Return ClearDataCommon(akForm,dataKey,"Signal")
EndFunction
Int Function ClearSignalAll(String dataKey = "")
	If dataKey == ""
		Return ClearAllPrefix("SLArousedCreatures.Signal")
	EndIf
	Return ClearAllPrefix("SLArousedCreatures.Signal." + dataKey)
EndFunction

; Get / Set SLAC Session Data
; This is data that needs to persist between engagements but not between sessions
; Eg queuing and suitor informations as both of these are cleared when loading a save.
Int Function SetSessionInt(Form akForm = None, String dataKey, Int dataValue)
	Return SetIntValue(akForm, "SLArousedCreatures.Session." + dataKey, dataValue)
EndFunction
Int Function GetSessionInt(Form akForm = None, String dataKey, Int dataValueDefault = 0)
	Return GetIntValue(akForm, "SLArousedCreatures.Session." + dataKey, dataValueDefault)
EndFunction
Bool Function SetSessionBool(Form akForm = None, String dataKey, Bool dataValue)
	Return SetIntValue(akForm, "SLArousedCreatures.Session." + dataKey, dataValue as Int)
EndFunction
Bool Function GetSessionBool(Form akForm = None, String dataKey, Bool dataValueDefault = False)
	Return GetIntValue(akForm, "SLArousedCreatures.Session." + dataKey, dataValueDefault as Int) as Bool
EndFunction
Float Function SetSessionFloat(Form akForm = None, String dataKey, Float dataValue)
	Return SetFloatValue(akForm, "SLArousedCreatures.Session." + dataKey, dataValue)
EndFunction
Float Function GetSessionFloat(Form akForm = None, String dataKey, Float dataValueDefault = 0.0)
	Return GetFloatValue(akForm, "SLArousedCreatures.Session." + dataKey, dataValueDefault)
EndFunction
String Function SetSessionString(Form akForm = None, String dataKey, String dataValue)
	Return SetStringValue(akForm, "SLArousedCreatures.Session." + dataKey, dataValue)
EndFunction
String Function GetSessionString(Form akForm = None, String dataKey, String dataValueDefault = "")
	Return GetStringValue(akForm, "SLArousedCreatures.Session." + dataKey, dataValueDefault)
EndFunction
Form Function SetSessionForm(Form akForm = None, String dataKey, Form dataValue)
	Return SetFormValue(akForm, "SLArousedCreatures.Session." + dataKey, dataValue)
EndFunction
Form Function GetSessionForm(Form akForm = None, String dataKey, Form dataValueDefault = None)
	Return GetFormValue(akForm, "SLArousedCreatures.Session." + dataKey, dataValueDefault)
EndFunction
Int Function SetSessionFormList(Form akForm = None, String dataKey, Form dataValue)
	Return FormListAdd(akForm, "SLArousedCreatures.Session." + dataKey, dataValue)
EndFunction
Form Function GetSessionFormList(Form akForm = None, String dataKey, Int formIndex)
	Return FormListGet(akForm, "SLArousedCreatures.Session." + dataKey, formIndex)
EndFunction
Int Function GetSessionFormListCount(Form akForm = None, String dataKey)
	Return FormListCount(akForm, "SLArousedCreatures.Session." + dataKey)
EndFunction
Form[] Function GetSessionFormListArray(Form akForm = None, String dataKey)
	Return FormListToArray(akForm, "SLArousedCreatures.Session." + dataKey)
EndFunction
Int Function ClearSession(Form akForm = None, String dataKey = "")
	Return ClearDataCommon(akForm,dataKey,"Session")
EndFunction
Int Function ClearSessionAll(String dataKey = "")
	If dataKey == ""
		Return ClearAllPrefix("SLArousedCreatures.Session")
	EndIf
	Return ClearAllPrefix("SLArousedCreatures.Session." + dataKey)
EndFunction

; Get / Set SLAC Permanent Data
; This is data that needs to persist between sessions. Eg indicating that a piece of heavy armor should be treated as clothing.
Int Function SetPersistInt(Form akForm = None, String dataKey, Int dataValue)
	Return SetIntValue(akForm, "SLArousedCreatures.Persist." + dataKey, dataValue)
EndFunction
Int Function GetPersistInt(Form akForm = None, String dataKey, Int dataValueDefault = 0)
	Return GetIntValue(akForm, "SLArousedCreatures.Persist." + dataKey, dataValueDefault)
EndFunction
Bool Function SetPersistBool(Form akForm = None, String dataKey, Bool dataValue)
	Return SetIntValue(akForm, "SLArousedCreatures.Persist." + dataKey, dataValue as Int)
EndFunction
Bool Function GetPersistBool(Form akForm = None, String dataKey, Bool dataValueDefault = False)
	Return GetIntValue(akForm, "SLArousedCreatures.Persist." + dataKey, dataValueDefault as Int) as Bool
EndFunction
Float Function SetPersistFloat(Form akForm = None, String dataKey, Float dataValue)
	Return SetFloatValue(akForm, "SLArousedCreatures.Persist." + dataKey, dataValue)
EndFunction
Float Function GetPersistFloat(Form akForm = None, String dataKey, Float dataValueDefault = 0.0)
	Return GetFloatValue(akForm, "SLArousedCreatures.Persist." + dataKey, dataValueDefault)
EndFunction
String Function SetPersistString(Form akForm = None, String dataKey, String dataValue)
	Return SetStringValue(akForm, "SLArousedCreatures.Persist." + dataKey, dataValue)
EndFunction
String Function GetPersistString(Form akForm = None, String dataKey, String dataValueDefault = "")
	Return GetStringValue(akForm, "SLArousedCreatures.Persist." + dataKey, dataValueDefault)
EndFunction
Form Function SetPersistForm(Form akForm = None, String dataKey, Form dataValue)
	Return SetFormValue(akForm, "SLArousedCreatures.Persist." + dataKey, dataValue)
EndFunction
Form Function GetPersistForm(Form akForm = None, String dataKey, Form dataValueDefault = None)
	Return GetFormValue(akForm, "SLArousedCreatures.Persist." + dataKey, dataValueDefault)
EndFunction
Int Function SetPersistFormList(Form akForm = None, String dataKey, Form dataValue)
	Return FormListAdd(akForm, "SLArousedCreatures.Persist." + dataKey, dataValue)
EndFunction
Form Function GetPersistFormList(Form akForm = None, String dataKey, Int formIndex)
	Return FormListGet(akForm, "SLArousedCreatures.Persist." + dataKey, formIndex)
EndFunction
Int Function GetPersistFormListCount(Form akForm = None, String dataKey)
	Return FormListCount(akForm, "SLArousedCreatures.Persist." + dataKey)
EndFunction
Form[] Function GetPersistFormListArray(Form akForm = None, String dataKey)
	Return FormListToArray(akForm, "SLArousedCreatures.Persist." + dataKey)
EndFunction
Int Function ClearPersist(Form akForm = None, String dataKey = "")
	Return ClearDataCommon(akForm,dataKey,"Persist")
EndFunction
Int Function ClearPersistAll(String dataKey = "")
	If dataKey == ""
		Return ClearAllPrefix("SLArousedCreatures.Persist")
	EndIf
	Return ClearAllPrefix("SLArousedCreatures.Persist." + dataKey)
EndFunction

; Shortcut getter for Bool OR on matching keys across all storage namespaces.
Bool Function GetAllBool(Form akForm = None, String dataKey, Bool dataValueDefault = False)
	Return GetIntValue(akForm, "SLArousedCreatures.Signal." + dataKey, dataValueDefault as Int) as Bool || \
		GetIntValue(akForm, "SLArousedCreatures.Session." + dataKey, dataValueDefault as Int) as Bool || \
		GetIntValue(akForm, "SLArousedCreatures.Persist." + dataKey, dataValueDefault as Int) as Bool
EndFunction

; Unifying data key clearance procedure per-scope
Int Function ClearDataCommon(Form akForm = None, String dataKey = "", String Scope)
	If dataKey == ""
		; Clear all
		Return ClearAllObjPrefix(akForm, "SLArousedCreatures." + Scope)
	EndIf

	; Clear multiple 
	String[] keylist = PapyrusUtil.StringSplit(dataKey,",")
	If keylist.Length > 1
		Int i = 0
		Int returnInt = 0
		While i < keylist.Length
			returnInt += ClearAllObjPrefix(akForm, "SLArousedCreatures." + Scope + "." + keylist[i])
			i += 1
		EndWhile
		Return returnInt
	EndIf

	; Clear specific
	Return ClearAllObjPrefix(akForm, "SLArousedCreatures." + Scope + "." + dataKey)
EndFunction
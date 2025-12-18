Scriptname slaFrameworkScr extends Quest
{SLSO version - Uses OSLAroused API with SLSO-specific functionality (SeparateOrgasms, SOS control)}

; vanilla
Actor Property PlayerRef Auto

; sla properties
slaMainScr Property slaMain Auto
slaConfigScr Property slaConfig Auto

FormList Property slaArousedVoiceList Auto
FormList Property slaUnArousedVoiceList Auto

Faction Property slaArousal Auto
Faction Property slaArousalBlocked Auto
Faction Property slaArousalLocked Auto
Faction Property slaExposure Auto
Faction Property slaExhibitionist Auto
Faction Property slaGenderPreference Auto
Faction Property slaTimeRate Auto
Faction Property slaExposureRate Auto

Faction slaArousalFaction
Faction slaExposureFaction
Faction slaNakedFaction
Faction slaExposureRateFaction
Faction slaTimeRateFaction

GlobalVariable Property sla_NextMaintenance Auto  

Int Property slaArousalCap = 100 AutoReadOnly

bool Property IsOSLArousedStub = true Auto

; SexLab
SexLabFramework property SexLab auto


function OnGameLoaded()
    slaMain = Game.GetFormFromFile(0x42D62, "SexLabAroused.esm") as slaMainScr
    slaConfig = Game.GetFormFromFile(0x1C6E0, "SexLabAroused.esm") as slaConfigScr

    slaArousalFaction = Game.GetFormFromFile(0x3FC36, "SexLabAroused.esm") as Faction
    slaArousal = slaArousalFaction
    slaExposureFaction = Game.GetFormFromFile(0x25837, "SexLabAroused.esm") as Faction
    slaExposure = slaExposureFaction
    slaNakedFaction = Game.GetFormFromFile(0x77F87, "SexLabAroused.esm") as Faction

    slaGenderPreference = Game.GetFormFromFile(0x79A72, "SexLabAroused.esm") as Faction

    slaExposureRateFaction = Game.GetFormFromFile(0x7649B, "SexLabAroused.esm") as Faction
    slaTimeRateFaction = Game.GetFormFromFile(0x7C025, "SexLabAroused.esm") as Faction
    
    slaMain.OnGameLoaded()
    slaMain.setUpdateFrequency(OSLArousedNativeConfig.GetUpdateIntervalRealTimeSeconds())

    RegisterForModEvent("slaUpdateExposure", "ModifyExposure")

    UnregisterForUpdate()
endfunction

Int Function GetVersion()
	Return 20140124
EndFunction

; 0 - Male
; 1 - Female
; 2 - Both
; 3 - SexLab
Int Function GetGenderPreference(Actor akRef, Bool forConfig = False)
	If (akRef == None)
		return -2
	EndIf
			
	int res = akRef.GetFactionRank(slaGenderPreference)
		
	If (res < 0 || res == 3)
		If (forConfig == True)
			Return 3
		EndIf
	
        if (Game.GetModByName("SexLab.esm") == 255)
            return -1
        endif

		float rawRatio = sslActorStats._GetSkill(akRef, 14) ;;14 is the sexuality skill ID
        float ratio = 100
        if rawRatio > 0.0
            ratio = rawRatio as int
        endif
		if ratio > 65
			res =  (-(akRef.GetLeveledActorBase().GetSex() - 1))
		ElseIf ratio < 35
			res =  akRef.GetLeveledActorBase().GetSex()
		Else
			res =  2
		EndIf
	EndIf
	Return res
EndFunction


Function SetGenderPreference(Actor akRef, Int gender)
	If (akRef == None)
		return
	EndIf
	
	akRef.SetFactionRank(slaGenderPreference, gender)
EndFunction


bool Function IsActorExhibitionist(Actor akRef)
    return OSLAroused_ModInterface.IsActorExhibitionist(akRef)
EndFunction


Function SetActorExhibitionist(Actor akRef, bool val = false)
    OSLAroused_ModInterface.SetActorExhibitionist(akRef, val)
EndFunction


; returned values range 0.0 - 100.0
Float Function GetActorTimeRate(Actor akRef)
    if(akRef == none)
        return -2.0
    endif

    return OSLArousedNative.GetActorTimeRate(akRef)
EndFunction


; val values are 0.0-100.0
; returned values range 0.0 - 100.0
Float Function SetActorTimeRate(Actor akRef, Float val)
    if(akRef == none)
        return -2.0
    endif
    return OSLArousedNative.SetActorTimeRate(akRef, val)
EndFunction


; use to change time rate incrementally
Float Function UpdateActorTimeRate(Actor akRef, Float val)
    if(akRef == none)
        return -2.0
    endif
    return OSLArousedNative.ModifyActorTimeRate(akRef, val)
EndFunction


Float Function GetActorExposureRate(Actor akRef)
    if(akRef == None)
        return -2
    endif

    return OSLAroused_ModInterface.GetArousalMultiplier(akRef)
EndFunction


Float Function SetActorExposureRate(Actor akRef, Float val)
    if(akRef == none)
        return -2.0
    endif
    return OSLAroused_ModInterface.SetArousalMultiplier(akRef, val, "slaframework SetActorExposureRate")
EndFunction


Float Function UpdateActorExposureRate(Actor akRef, Float val)
    If (akRef == none)
        return -2
    EndIf

    return OSLAroused_ModInterface.ModifyArousalMultiplier(akRef, val, "slaframework UpdateActorExposureRate")
EndFunction


Int Function GetActorExposure(Actor akRef)
    if(akRef == none)
        return -2
    endif

    return OSLAroused_ModInterface.GetExposure(akRef) as int
EndFunction


Int Function SetActorExposure(Actor akRef, Int val)
    if(akRef == none)
        return -2
    endif
    return OSLAroused_ModInterface.SetArousal(akRef, val) as int
EndFunction


;Additive exposure - uses OSLAroused API
Int Function UpdateActorExposure(Actor act, Int modVal, String debugMsg = "")
    return OSLAroused_ModInterface.ModifyArousal(act, modVal, "slaframework UpdateActorExposure") as Int
EndFunction


Float Function GetActorDaysSinceLastOrgasm(Actor akRef)
    If (akRef == None)
        return -2.0
    EndIf
    
    ; SLSO-specific: Check SeparateOrgasms setting
    If (SexLab != None && SexLab.config != None && SexLab.config.SeparateOrgasms)
        return OSLAroused_ModInterface.GetActorDaysSinceLastOrgasm(akRef)
    Else
        ; Fallback to SexLab stats when SeparateOrgasms is disabled
        float daysSince = OSLAroused_ModInterface.GetActorDaysSinceLastOrgasm(akRef)
        if daysSince < 0
            return SexLab.Stats.DaysSinceLastSex(akRef)
        endif
        return daysSince
    EndIf
EndFunction


Function UpdateActorOrgasmDate(Actor akRef)
    if(akRef == none)
        return
    endif
    OSLAroused_ModInterface.RegisterOrgasm(akRef)
EndFunction


bool Function IsActorArousalLocked(Actor akRef)
    return OSLAroused_ModInterface.IsActorArousalLocked(akRef)
EndFunction


Function SetActorArousalLocked(Actor akRef, bool val)
    OSLAroused_ModInterface.SetActorArousalLocked(akRef, val)
EndFunction


bool Function IsActorArousalBlocked(Actor akRef)
    return false
EndFunction


Function SetActorArousalBlocked(Actor akRef, bool val)
    ; Not implemented in OSLAroused
EndFunction


int Function GetActorArousal(Actor akRef)
    if(akRef == none || akRef.IsChild())
        return -2
    endif

    int arousal = OSLAroused_ModInterface.GetArousal(akRef) as int
    
    ; SLSO-specific: Update SOS position and track most aroused actor
    UpdateSOSPosition(akRef, arousal)
    
    If (akRef == PlayerRef)
        slaMain.OnPlayerArousalUpdate(arousal)
    Else        
        If (slaConfig.slaMostArousedActorInLocation != None && slaConfig.slaMostArousedActorInLocation != akRef)
            If (slaConfig.slaMostArousedActorInLocation.GetCurrentLocation() == PlayerRef.GetCurrentLocation())
                If (slaConfig.slaArousalOfMostArousedActorInLoc <= arousal)
                    slaConfig.slaMostArousedActorInLocation = akRef
                    slaConfig.slaArousalOfMostArousedActorInLoc = arousal
                EndIf
            Else
                slaConfig.slaMostArousedActorInLocation = akRef
                slaConfig.slaArousalOfMostArousedActorInLoc = arousal
            EndIf
        Else
            slaConfig.slaMostArousedActorInLocation = akRef
            slaConfig.slaArousalOfMostArousedActorInLoc = arousal
        EndIf
    EndIf

    return arousal
EndFunction


Actor Function GetMostArousedActorInLocation()
    Return OSLArousedNative.GetMostArousedActorInLocation()
EndFunction


function OnActorNakedUpdated(Actor act, bool newNaked)
    if(slaNakedFaction)
        if(newNaked)
            act.SetFactionRank(slaNakedFaction, 0)
        else
            act.SetFactionRank(slaNakedFaction, -2)
        endif
    endif
endfunction


Event ModifyExposure(Form actForm, float val)
    Actor akRef = actForm as Actor
    if(akRef)
        OSLAroused_ModInterface.ModifyArousal(akRef, val, "slaframework ModifyExposure")
    endif
EndEvent


; SLSO-specific: SOS erection control based on arousal
Function UpdateSOSPosition(Actor akRef, int akArousal)
    If (akRef == None || !slaConfig.IsUseSOS)
        return
    ElseIf akRef.IsInFaction(SexLab.AnimatingFaction)
        return
    EndIf
    
    int res = (akArousal / 4) - 14;
    HandleErection(akRef, res)
EndFunction


Function HandleErection(Actor akRef, int position)
    If position < -9
        Debug.sendAnimationEvent(akRef, "SOSFlaccid")
    ElseIf position > 9
        Debug.sendAnimationEvent(akRef, "SOSBend9")
    Else
        Debug.sendAnimationEvent(akRef, "SOSBend" + position)
    EndIf
EndFunction


; ************************
; Depreciated functions
; ************************
Int Function GetActorHoursSinceLastSex(Actor akRef)
    If (akRef == None)
        return -2
    EndIf
    
    return (OSLAroused_ModInterface.GetActorDaysSinceLastOrgasm(akRef) * 24) as Int
EndFunction


Float Function GetActorDaysSinceLastSex(Actor akRef)
    If (akRef == None)
        return -2.0
    EndIf
    
    Return SexLab.Stats.DaysSinceLastSex(akRef)
EndFunction


function Log(string msg) global
    Debug.Trace("----OSLAroused---- [slaFrameworkScr SLSO] - " + msg)
endfunction

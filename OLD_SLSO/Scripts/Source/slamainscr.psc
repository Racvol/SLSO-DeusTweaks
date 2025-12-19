Scriptname slaMainScr extends Quest  
{SLSO version - Adapted for OSL Aroused by DeusForge AI}

; sla properties
slaConfigScr Property slaConfig Auto
Spell Property slaCloakSpell Auto
Spell Property slaDesireSpell Auto
GlobalVariable Property slaNextTimePlayerNaked Auto
Quest Property slaScanAll Auto
Quest Property slaNakedNPC Auto
Keyword Property ArmorCuirass Auto
Keyword Property ClothingBody Auto
Faction Property slaNaked Auto
GlobalVariable Property sla_NextMaintenance  Auto  
GlobalVariable Property sla_AnimateFemales Auto
GlobalVariable Property sla_AnimateMales Auto
GlobalVariable Property sla_AnimationThreshhold Auto
GlobalVariable Property sla_UseLineOfSight Auto

Formlist Property sla_NakedArmorList Auto

Float Property updateFrequency = 120.00 Auto hidden

bool bWasInitialized = false

; SexLab
SexLabFramework Property SexLab Auto

; vanilla
Actor Property PlayerRef Auto
GlobalVariable Property GameDaysPassed Auto

; callback functions
String slaStageStartStr = "OnStageStart"
String slaAnimationEndStr = "OnAnimationEnd"

; constants
float arousalSearchRadius = 2048.0

; variables
Int modVersion = 0;
Int previousPlayerArousal = 0;
Float lastNotificationTime = 0.0;
Actor crosshairRef = None
Bool wasPlayerRaped = False;
Keyword zadDeviousBelt = None

bool bIsLocked = false
bool bUseLOS = false
int [] lockingInts
bool bNakedOnly = true
bool bDisabled = false

int[] property ActorTypes auto hidden

function OnGameLoaded()
    slaConfig = Game.GetFormFromFile(0x1C6E0, "SexLabAroused.esm") as slaConfigScr
    
    ActorTypes = new Int[3]
    ActorTypes[0] = 43
    ActorTypes[1] = 44
    ActorTypes[2] = 62

    SetVersion(20140124)
    
    slaNextTimePlayerNaked.SetValue(0.0)    
        
    UnregisterForAllModEvents()
    RegisterForModEvent("StageStart", slaStageStartStr)
    RegisterForModEvent("OrgasmEnd", slaAnimationEndStr)
    RegisterForModEvent("SexLabOrgasmSeparate", "OnSexLabOrgasmSeparate")
    RegisterForModEvent("slaUpdateExposure", "ModifyExposure")
    
    ; Hook into OSL Native events to restore notifications
    RegisterForModEvent("OSLA_ActorArousalUpdated", "OnOSLArousalUpdated")
    
    RegisterForCrosshairRef()
    
    int xflmainId = Game.GetModByName("Devious Devices - Assets.esm")
    if(xflmainId != 255)
            zadDeviousBelt = Game.GetFormFromFile(0x02003330, "Devious Devices - Assets.esm") As Keyword
            Debug.Trace(Self + ": found Devious Devices - Assets.esm")
    else
        zadDeviousBelt = None
    EndIf

    if(PlayerRef.HasSpell(slaCloakSpell))
        PlayerRef.RemoveSpell(slaCloakSpell)    
    endif
    
    UpdateDesireSpell()

    Debug.Trace(Self + ": finished maintenance")
    bWasInitialized = true
EndFunction

int function IsAnimatingFemales()
    return sla_AnimateFemales.getValue() as Int
endFunction

function SetIsAnimatingFemales(int newValue)
    sla_AnimateFemales.setValue(newValue)
endFunction

int function IsAnimatingMales()
    return sla_AnimateMales.getValue() as Int
endFunction

function SetIsAnimatingMales(int newValue)
    sla_AnimateMales.setValue(newValue)
endFunction

int function getAnimationThreshold()
    return sla_AnimationThreshhold.getValue() as Int
endFunction

function setAnimationThreshold(int newValue)
    sla_AnimationThreshhold.setValue(newValue)
endFunction

int function getUseLOS()
    return sla_UseLineOfSight.getValue() as Int
endFunction

int function getNakedOnly()
    return bNakedOnly as Int
endFunction

function setNakedOnly(int newValue)
    bNakedOnly = newValue as bool
endFunction

int function getDisabled()
    return bDisabled as Int
endFunction

function setDisabled(int newValue)
    bDisabled = newValue as bool
endFunction

function setUseLOS(int newValue)
    sla_UseLineOfSight.setValue(newValue)
    bUseLOS = newValue as bool
endFunction

function setUpdateFrequency(Float newFreq)
    updateFrequency = newFreq
endFunction 

Event OnInit()
    OnGameLoaded()
EndEvent

function setCleaningTime()
    float nextTime = GameDaysPassed.GetValue() + 10.0 
    sla_NextMaintenance.SetValue(nextTime)
endFunction

Function Maintenance()
    ; Stub - OSL handles maintenance
EndFunction

function startCleaning()
    ; Stub - OSL handles cleaning
endFunction

bool function IsSexLabActive()
    int i = SexLab.Threads.Length
    while i
        i -= 1
        if SexLab.Threads[i].IsLocked
            return true
        endIf
    endwhile
    return false
endfunction

Event OnUpdate()
    ; DISABLED: Legacy scanning loop. OSL Aroused handles scanning natively.
EndEvent

Event ModifyExposure(Form act, float val)
    Actor akRef = act as Actor
    if(akRef != none)
        OSLAroused_ModInterface.ModifyArousal(akRef, val, " External Modify Exposure Event")
    endif
EndEvent

; Legacy function - Stubbed as OSL handles naked detection natively
Function UpdateNakedArousal(Actor akRef, Actor akNaked)
EndFunction

bool Function IsActorNaked(Actor akRef)
    return OSLArousedNative.IsActorNaked(akRef)
EndFunction

function UpdateCloakEffect()
endFunction

Int Function GetVersion()   
    return modVersion
EndFunction

Function SetVersion(Int  newVersion)
    if (modVersion < newVersion)
        modVersion = newVersion
    EndIf
EndFunction

Function UpdateDesireSpell()
    OSLAroused_Main.Get().SetArousalEffectsEnabled(slaConfig.IsDesireSpell)
EndFunction

Event OnCrosshairRefChange(ObjectReference ref)
    crosshairRef = none
    if ref != none
            crosshairRef = ref as Actor
    endIf
EndEvent

; Adapter event to restore notifications
Event OnOSLArousalUpdated(string eventName, string strArg, float newArousal, Form sender)
    If (sender == PlayerRef)
        OnPlayerArousalUpdate(newArousal as Int)
    EndIf
EndEvent

Event OnStageStart(string eventName, string argString, float argNum, form sender)
    String File = "/SLSO/Config.json"
    If JsonUtil.GetIntValue("/SLSO/Config", "sl_sla_stage_arousal") == 1
        sslThreadController controller = SexLab.GetController(argString as int)
        Actor[] actorList = SexLab.HookActors(argString)
        Actor[] targetactorList = actorList
        Int howmuch
        
        If (actorList.length < 1)
            return
        EndIf
        
        sslThreadController thisThread = SexLab.HookController(argString)
        
        If (actorList.length == 2)
            targetactorList =  new Actor [2]
            targetactorList[0] = actorList[1]
            targetactorList[1] = actorList[0]
        endif   
        
        bool nomore = false
        int i = 0
        if (actorList.length <= 2)
            While i < actorList.length 
                int pos = controller.GetPosition(actorList[i])
                If (((controller.ActorAlias(actorList[i]) as sslActorAlias).GetOrgasmCount() >= controller.Get_minimum_aggressor_orgasm_Count()) && ((controller.ActorAlias(actorList[i]) as sslActorAlias).GetGender() != 1) && controller.Animation.MalePosition(pos))
                    nomore = true
                EndIf
                i += 1
            EndWhile
        endif   
        
        i = 0
        While i < actorList.length
            If (controller.ActorAlias(targetactorList[i]) as sslActorAlias).GetOrgasmCount() == 0 && !nomore
                Actor victim = SexLab.HookVictim(argString)
                int exposuremult = 1

                If (victim != None && victim == targetactorList[i] && JsonUtil.GetIntValue("/SLSO/Config", "condition_victim_arousal") != 1)
                    int j = controller.ActorCount
                    int aggressorBroken = 0
                    while j > 0 && JsonUtil.GetIntValue(File, "condition_victim_orgasm_aggressor_broken")
                        if controller.ActorAlias[j].GetRef() as Actor != victim && controller.ActorAlias[j].GetMentallyBrokenState()
                            aggressorBroken += 1
                        endif
                        j -= 1
                    endwhile

                    If (JsonUtil.GetIntValue("/SLSO/Config", "condition_victim_arousal") == 0)
                        exposuremult = 0
                    ElseIf (JsonUtil.GetIntValue("/SLSO/Config", "condition_victim_arousal") == 2) || JsonUtil.GetIntValue(File, "condition_victim_arousal") == 4
                        exposuremult = PapyrusUtil.ClampInt((SexLab.Stats.GetSkillLevel(victim, "Lewd", 0.3) - 3), -3, 3)
                    ElseIf (JsonUtil.GetIntValue("/SLSO/Config", "condition_victim_arousal") == 3 || JsonUtil.GetIntValue(File, "condition_victim_arousal") == 4)
                        if targetactorList[i] == victim && (controller.ActorAlias(targetactorList[i]) as sslActorAlias).GetMentallyBrokenState()
                            exposuremult = 1
                        elseif JsonUtil.GetIntValue(File, "condition_victim_arousal") == 4
                            exposuremult = PapyrusUtil.ClampInt((SexLab.Stats.GetSkillLevel(victim, "Lewd", 0.3) - 3), -3, 3)
                        else
                            exposuremult = 0
                        endif
                    ElseIf JsonUtil.GetIntValue(File, "condition_victim_orgasm_aggressor_broken") && aggressorBroken == controller.ActorCount - 1
                        exposuremult = 1
                    ElseIf (exposuremult == 0)
                        exposuremult = 1
                    EndIf
                EndIf
                
                If (exposuremult != 0)
                    float ExposureRateBackup = OSLAroused_ModInterface.GetArousalMultiplier(targetactorList[i])
                    OSLAroused_ModInterface.SetArousalMultiplier(targetactorList[i], 1.0)
                    
                    If ((thisThread.animation.HasTag("Foreplay") && thisThread.LeadIn) || thisThread.animation.HasTag("Masturbation"))
                        howmuch = 1 + SexLab.Stats.GetSkillLevel(actorList[i], "Foreplay")
                        OSLAroused_ModInterface.ModifyArousal(targetactorList[i], (howmuch*exposuremult) as float, "Foreplay")
                    EndIf
                    
                    If (!(thisThread.LeadIn || thisThread.animation.HasTag("Masturbation")))
                        If (thisThread.animation.HasTag("Vaginal"))
                            howmuch = 1 + SexLab.Stats.GetSkillLevel(actorList[i], "Vaginal")
                            OSLAroused_ModInterface.ModifyArousal(targetactorList[i], (howmuch*exposuremult) as float, "Vaginal")
                        ElseIf (thisThread.animation.HasTag("Oral"))
                            howmuch = 1 + SexLab.Stats.GetSkillLevel(actorList[i], "Oral")
                            OSLAroused_ModInterface.ModifyArousal(targetactorList[i], (howmuch*exposuremult) as float, "Oral")
                        ElseIf (thisThread.animation.HasTag("Anal"))
                            howmuch = 1 + SexLab.Stats.GetSkillLevel(actorList[i], "Anal")
                            OSLAroused_ModInterface.ModifyArousal(targetactorList[i], (howmuch*exposuremult) as float, "Anal")
                        ElseIf (thisThread.animation.HasTag("Bestiality"))
                            howmuch = 1 + SexLab.Stats.GetSkillLevel(actorList[i], "Lewd", 0.3)
                            OSLAroused_ModInterface.ModifyArousal(targetactorList[i], (howmuch*exposuremult) as float, "Bestiality")
                        EndIf
                    EndIf
                    ;restore actor ExposureRate
                    OSLAroused_ModInterface.SetArousalMultiplier(targetactorList[i], ExposureRateBackup)
                EndIf
            EndIf
            i += 1
        EndWhile
        
        ; Legacy "Arouse NPCs within Radius" removed as OSL Aroused handles scene viewing arousal natively
    EndIf
EndEvent

Event OnSexLabOrgasmSeparate(Form ActorRef, Int Thread)
    actor akActor = ActorRef as actor
    string argString = Thread as string
    
    ; lastSexFinished = Utility.GetCurrentRealTime() ; Removed unused var
    
    sslThreadController thisThread = SexLab.HookController(argString)
    Actor victim = SexLab.HookVictim(argString)
    
    If (victim != None)
        If (victim == PlayerRef)
            wasPlayerRaped = True
        EndIf
        
        OSLAroused_ModInterface.ModifyArousal(victim, (JsonUtil.GetIntValue("/SLSO/Config", "sl_sla_orgasmexposureloss")/2 + JsonUtil.GetIntValue("/SLSO/Config", "sl_sla_orgasmexposuremodifier") * SexLab.Stats.GetSkillLevel(victim, "Lewd", 0.3)) as float, "being rape victim")
    EndIf
    
    Int exposureValue = ((thisThread.TotalTime / GetAnimationDuration(thisThread)) * (JsonUtil.GetIntValue("/SLSO/Config", "sl_sla_orgasmexposureloss") + JsonUtil.GetIntValue("/SLSO/Config", "sl_sla_orgasmexposuremodifier") * SexLab.Stats.GetSkillLevel(akActor, "Lewd", 0.3))) as Int
    OSLAroused_ModInterface.RegisterOrgasm(akActor)
    OSLAroused_ModInterface.ModifyArousal(akActor, exposureValue as float, "having orgasm")
EndEvent

Event OnAnimationEnd(string eventName, string argString, float argNum, form sender)
        Actor[] actorList = SexLab.HookActors(argString)
        
        If (actorList.length < 1)
            return
        EndIf

        sslThreadController thisThread = SexLab.HookController(argString)
        
    If !SexLab.config.SeparateOrgasms || JsonUtil.GetIntValue("/SLSO/Config", "sl_default_always_orgasm") == 1 || (!thisThread.HasPlayer && JsonUtil.GetIntValue("/SLSO/Config", "sl_npcscene_always_orgasm") == 1)
        Actor victim = SexLab.HookVictim(argString)
        sslBaseAnimation animation = SexLab.HookAnimation(argString)
        
        Bool canMalePosOrgasm = (animation.HasTag("Anal") || animation.HasTag("Vaginal") || animation.HasTag("Masturbation") || animation.HasTag("Blowjob") || animation.HasTag("Boobjob") || animation.HasTag("Handjob") || animation.HasTag("Footjob") || animation.HasTag("69"))
        Bool canFemalePosOrgasm = (animation.HasTag("Anal") || animation.HasTag("Vaginal") || animation.HasTag("Masturbation") || animation.HasTag("Fisting") || animation.HasTag("Cunnilingus") || animation.HasTag("69") || animation.HasTag("Lesbian"))
        Bool creatureOverride = (animation.HasTag("Oral"))
        
        If (victim != None)
            wasPlayerRaped = (victim == PlayerRef)
            OSLAroused_ModInterface.ModifyArousal(victim, (JsonUtil.GetIntValue("/SLSO/Config", "sl_sla_orgasmexposureloss")/2 + JsonUtil.GetIntValue("/SLSO/Config", "sl_sla_orgasmexposuremodifier") * SexLab.Stats.GetSkillLevel(victim, "Lewd", 0.3)) as float, "being rape victim")
        EndIf
        
        int i = 0   
        While i < actorList.length
            bool doesOrgasm = false
            Bool actorHasDeviousBelt = False
            
            If (animation.getGender(i) % 3 == 0)
                If (zadDeviousBelt != None)
                    actorHasDeviousBelt = actorList[i].WornHasKeyword(zadDeviousBelt)
                EndIf
                doesOrgasm = (canMalePosOrgasm && !actorHasDeviousBelt)
            
            ElseIf (animation.getGender(i) % 3 == 1)
                If (zadDeviousBelt != None)
                    actorHasDeviousBelt = actorList[i].WornHasKeyword(zadDeviousBelt)
                EndIf
                doesOrgasm = (canFemalePosOrgasm && !actorHasDeviousBelt)
                
            ElseIf (animation.getGender(i) % 3 == 2)
                If (zadDeviousBelt != None)
                    actorHasDeviousBelt = actorList[i].WornHasKeyword(zadDeviousBelt)
                EndIf
                doesOrgasm = ((canMalePosOrgasm || canFemalePosOrgasm) && !actorHasDeviousBelt)
            EndIf
            
            If (animation.getGender(i) >= 2 && creatureOverride)
                doesOrgasm = true
            EndIf
            
            If doesOrgasm
                Int exposureValue = ((thisThread.TotalTime / GetAnimationDuration(thisThread)) * (JsonUtil.GetIntValue("/SLSO/Config", "sl_sla_orgasmexposureloss") + JsonUtil.GetIntValue("/SLSO/Config", "sl_sla_orgasmexposuremodifier") * SexLab.Stats.GetSkillLevel(actorList[i], "Lewd", 0.3))) as Int
                OSLAroused_ModInterface.RegisterOrgasm(actorList[i])
                OSLAroused_ModInterface.ModifyArousal(actorList[i], exposureValue as float, "having orgasm")
            EndIf
            
            i += 1
        EndWhile
    EndIf
EndEvent

Float Function GetAnimationDuration(sslThreadController bThread)
    If (bThread == None)
        return -1.0
    EndIf
    
    Float[] timeList =  bThread.Timers
    Float res = 0.0
    Float stageTimer = 0.0
    int i = 0
    int stageCount = bThread.animation.StageCount()
    
    While (i < timeList.length && i < stageCount)
        if i == stageCount - 1
            stageTimer = timeList[4]
        elseif i < 3
            stageTimer = timeList[i]
        else
            stageTimer = timeList[3]
        endIf
        res = res + stageTimer
        i += 1
    EndWhile
    return res
EndFunction

Function OnPlayerArousalUpdate(Int arousal) 
    If (arousal <= 20 && (previousPlayerArousal > 20 || lastNotificationTime + 0.5 <= GameDaysPassed.GetValue()))
        If (wasPlayerRaped == True)
            Debug.Notification("$SLA_NotificationArousal20Rape")
            wasPlayerRaped = False
        Else
            Debug.Notification("$SLA_NotificationArousal20")
        EndIf
        lastNotificationTime = GameDaysPassed.GetValue()
    ElseIf (arousal >= 90 && (previousPlayerArousal < 90 || lastNotificationTime + 0.2 <= GameDaysPassed.GetValue()))
        Debug.Notification("$SLA_NotificationArousal90")
        lastNotificationTime = GameDaysPassed.GetValue()
    ElseIf (arousal >= 70 && (previousPlayerArousal < 70 || lastNotificationTime + 0.3 <= GameDaysPassed.GetValue()))
        Debug.Notification("$SLA_NotificationArousal70")
        lastNotificationTime = GameDaysPassed.GetValue()
    ElseIf (arousal >= 50 && (previousPlayerArousal < 50 || lastNotificationTime + 0.4 <= GameDaysPassed.GetValue()))
        Debug.Notification("$SLA_NotificationArousal50")
        lastNotificationTime = GameDaysPassed.GetValue()
    EndIf

    previousPlayerArousal = arousal
EndFunction

function CleanActorStorage()
endFunction

bool function IsActor(Form FormRef)
    return FormRef && ActorTypes.Find(FormRef.GetType()) != -1
endFunction

bool function IsImportant(Actor ActorRef)
    if !ActorRef || ActorRef.IsDead() || ActorRef.IsDeleted() || ActorRef.IsChild()
        return false
    elseIf ActorRef == PlayerRef
        return true
    endIf
    ActorBase BaseRef = ActorRef.GetLeveledActorBase()
    return BaseRef.IsUnique() || BaseRef.IsEssential() || BaseRef.IsInvulnerable() || BaseRef.IsProtected() || ActorRef.IsGuard() || ActorRef.IsPlayerTeammate()
endFunction

function ClearFromActorStorage(Form FormRef)
endFunction
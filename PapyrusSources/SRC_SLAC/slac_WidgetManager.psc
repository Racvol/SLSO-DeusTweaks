Scriptname slac_WidgetManager extends Quest
{Players Script for SexLab Aroused Creatures controlling widget updates and maintenance}

slac_StaminaWidget Property StaminaMeter Auto
slac_StaminaWidgetPC Property StaminaMeterPC Auto
slac_StaminaWidgetNPC Property StaminaMeterNPC Auto
Actor Property PlayerRef Auto

Actor MonitoredActor = None
Float MaxStaminaPC = 0.0
Float MaxStaminaNPC = 0.0
Float CurrentStaminaPC = 0.0
Float CurrentStaminaNPC = 0.0
Float PosX = 925.0
Float PosY = 670.0
Bool ObscuredNPC = False


Function StartMeter(Actor akSubject)
	UnregisterForUpdate()
	If akSubject
		MonitoredActor = akSubject
		MaxStaminaPC = GetMaximumStamina(PlayerRef)
		MaxStaminaNPC = GetMaximumStamina(MonitoredActor)
		CurrentStaminaPC = PlayerRef.GetActorValue("Stamina")
		CurrentStaminaNPC = MonitoredActor.GetActorValue("Stamina")
		
		StaminaMeterNPC.Color = 0xFF9E9E ; Pink
		StaminaMeterPC.Color = 0x00FF00 ; Green
		SetHAnchor("left")
		SetVAnchor("top")
		SetXPosition(PosX)
		SetYPosition(PosY)
		StaminaMeterNPC.Alpha = 100.0
		StaminaMeterPC.Alpha = 100.0
		ObscuredNPC = False
		
		RegisterForSingleUpdate(0.01)
	EndIf
EndFunction


Function StopMeter()
	UnregisterForUpdate()
	MonitoredActor = None
	ObscuredNPC = False
	StaminaMeterPC.Alpha = 0.0
	StaminaMeterNPC.Alpha = 0.0
EndFunction


Function ObscureNPCMeter()
	ObscuredNPC = True
	StaminaMeternPC.Color = 0xFCFBE7 ; off-white
	StaminaMeterNPC.Value = 1.0
EndFunction

Function SetHAnchor(String h)
	StaminaMeterNPC.HAnchor = h
	StaminaMeterPC.HAnchor = h
	StaminaMeterNPC.UpdateWidgetHAnchor()
	StaminaMeterPC.UpdateWidgetHAnchor()
EndFunction

Function SetVAnchor(String v)
	StaminaMeterNPC.VAnchor = v
	StaminaMeterPC.VAnchor = v
	StaminaMeterNPC.UpdateWidgetVAnchor()
	StaminaMeterPC.UpdateWidgetVAnchor()
EndFunction

Function SetXPosition(Float x)
	PosX = x
	StaminaMeterNPC.X = PosX
	StaminaMeterPC.X = PosX
	StaminaMeterNPC.UpdateWidgetPositionX()
	StaminaMeterPC.UpdateWidgetPositionX()
EndFunction
Float Function GetXPosition()
	Return StaminaMeterNPC.X
EndFunction

Function SetYPosition(Float y)
	PosY = y
	StaminaMeterNPC.Y = PosY
	StaminaMeterPC.Y = PosY + 25
	StaminaMeterNPC.UpdateWidgetPositionY()
	StaminaMeterPC.UpdateWidgetPositionY()
EndFunction
Float Function GetYPosition()
	Return StaminaMeterNPC.Y
EndFunction

Event OnUpdate()
	Actor TempMonitoredActor = MonitoredActor
	If TempMonitoredActor
		If !ObscuredNPC
			StaminaMeterNPC.Value = TempMonitoredActor.GetActorValue("Stamina") / MaxStaminaNPC
		ElseIf StaminaMeterNPC.Value < 1.0
			StaminaMeterNPC.Value = 1.0
		EndIf
		StaminaMeterPC.Value = PlayerRef.GetActorValue("Stamina") / MaxStaminaPC
		RegisterForSingleUpdate(0.01)
		Return
	EndIf
	
	StaminaMeterPC.Alpha = 0.0
	StaminaMeterNPC.Alpha = 0.0
	UnregisterForUpdate()
	Return
EndEvent


; returns the maximum value for this actor value, buffs are accounted for.
; https://www.creationkit.com/index.php?title=GetActorValuePercentage_-_Actor
Float Function GetMaximumStamina(Actor akActor)
    Float BaseValue = akActor.GetBaseActorValue("Stamina")
    Float CurrentMaxValue = Math.Ceiling(akActor.GetActorValue("Stamina") / akActor.GetActorValuePercentage("Stamina"))
 
    if BaseValue < CurrentMaxValue
        return BaseValue
    else
        return CurrentMaxValue
    endif
EndFunction

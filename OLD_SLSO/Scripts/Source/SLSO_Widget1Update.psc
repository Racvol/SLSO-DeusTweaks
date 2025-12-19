Scriptname SLSO_Widget1Update Extends ReferenceAlias

SLSO_WidgetCoreScript1 Property Widget Auto

SexLabFramework SexLab
sslThreadController controller

String File
String widgetid
String ActorName
String EnjoymentValue
String Temper
String EdgeStack
Float LastTimeFlash

; Cached Configuration
Int BaseColor = 0xFFFFFF
Int MagickaColor = 0x0000FF
Int MagickaFadeColor = 0x69C0FF
Int DisplayMode = 0
Int Gender = 0
Bool Display_widget = true

; Cached Arrays for Colors (Optimization)
Int[] CachedWidgetColors

; Cached Flags
Bool bWidgetEnabled = false
Bool bWidgetOn = false
Bool bPassiveEnjoymentReduction = false
Int iSelectedActorColor
Int iLabelColor

;----------------------------------------------------------------------------
;Widget Setup
;----------------------------------------------------------------------------

Event OnInit()
	HideWidget()
	File = "/SLSO/Config.json"
	widgetid = "widget" + self.GetID()
	DisplayMode = 0
EndEvent

Event Start_widget(Int Widget_Id, Int Thread_Id)
	if Widget_Id == self.GetID()
		UnregisterForModEvent("SLSO_Start_widget")

		SexLab = Quest.GetQuest("SexLabQuestFramework") as SexLabFramework
		controller = SexLab.GetController(Thread_Id)
		if controller.HasPlayer
			StartWidget()
		else
			StopWidget()
		endif
		self.RegisterForModEvent("SLSO_Change_Partner", "Change_Partner")
		self.RegisterForModEvent("SLSO_Change_Display", "Change_Display")
	endif
EndEvent

Event Change_Partner(Form ActorRef)
	if ActorRef as Actor == self.GetActorRef()
		Widget.LabelTextColor = iSelectedActorColor
	else
		Widget.LabelTextColor = iLabelColor
	endif
EndEvent

Event Change_Display(Form ActorRef)
	if ActorRef == self.GetActorRef() || (JsonUtil.GetIntValue(File, "condition_display_mode_global") && self.GetActorRef() != Game.Getplayer())
		if DisplayMode == 0
			DisplayMode = 1
		else
			DisplayMode = 0
		endif
	endif
EndEvent

Event Stop_widget(Int Widget_Id)
	if Widget_Id == self.GetID()
		StopWidget()
	endif
EndEvent

Function StartWidget()
	; Init Array
	CachedWidgetColors = new Int[6]
	UpdateWidgetPosition()
EndFunction

Function StopWidget()
	UnRegisterForUpdate()
	UnregisterForAllModEvents()
	UnregisterForAllKeys()
	HideWidget()
	(self as ReferenceAlias).Clear()
EndFunction

Function ShowWidget()
	Widget.Alpha = 100.0
EndFunction

Function HideWidget()
	Widget.Alpha = 0.0
EndFunction

Function UpdateWidgetPosition()
	Actor ActorRef = self.GetActorRef() 
	
	; --- CACHE JSON VALUES HERE (ONCE PER SCENE) ---
	bWidgetEnabled = (JsonUtil.GetIntValue(File, "widget_enabled") == 1)
	bWidgetOn = (JsonUtil.StringListGet(File, widgetid, 0) == "on")
	bPassiveEnjoymentReduction = (JsonUtil.GetIntValue(File, "game_passive_enjoyment_reduction") == 1)
	
	; Cache Colors
	CachedWidgetColors[1] = JsonUtil.StringListGet(File, "widgetcolors", 1) as int
	CachedWidgetColors[2] = JsonUtil.StringListGet(File, "widgetcolors", 2) as int
	CachedWidgetColors[3] = JsonUtil.StringListGet(File, "widgetcolors", 3) as int
	CachedWidgetColors[4] = JsonUtil.StringListGet(File, "widgetcolors", 4) as int
	CachedWidgetColors[5] = JsonUtil.StringListGet(File, "widgetcolors", 5) as int
	
	iSelectedActorColor = JsonUtil.GetFloatValue(File, "widget_selectedactorcolor", 16768768) as int
	iLabelColor = JsonUtil.GetFloatValue(File, "widget_labelcolor", 16777215) as int
	; ----------------------------------------------

	If ActorRef != none
		;female
		If controller.ActorAlias(ActorRef).GetGender() == 1
			BaseColor = CachedWidgetColors[5]
			Gender = 1
		;male
		Else
			BaseColor = CachedWidgetColors[4]
			Gender = 0
		EndIf
	Else
		BaseColor = 0xFFFFFF
	EndIf
	
	Widget.BorderColor = JsonUtil.GetFloatValue(File, "widget_bordercolor", 0) as int
	Widget.BorderWidth = 0
	
	if ((JsonUtil.GetIntValue(File, "widget_player_only") == 1 && self.GetActorRef() == Game.Getplayer()) || JsonUtil.GetIntValue(File, "widget_player_only") != 1)
		Display_widget = true
	else
		Display_widget = false
	endif
	
	Widget.X = JsonUtil.StringListGet(File, widgetid, 1) as Float
	Widget.Y = JsonUtil.StringListGet(File, widgetid, 2) as Float
	Widget.MeterFillMode = JsonUtil.StringListGet(File, widgetid, 3)
	Widget.SetMeterPercent(0.0)
	Widget.BorderAlpha = JsonUtil.GetFloatValue(File, "widget_borderalpha")
	Widget.BackgroundAlpha = JsonUtil.GetFloatValue(File, "widget_backgroundalpha")
	Widget.MeterAlpha = JsonUtil.GetFloatValue(File, "widget_meteralpha")
	Widget.MeterScale = JsonUtil.GetFloatValue(File, "widget_meterscale")
	Widget.LabelTextSize = JsonUtil.GetFloatValue(File, "widget_labeltextsize")
	Widget.ValueTextSize = JsonUtil.GetFloatValue(File, "widget_valuetextsize")
	Widget.LabelTextColor = iLabelColor
	
	ActorName = self.GetActorRef().GetDisplayName()
	if JsonUtil.GetIntValue(File, "widget_show_enjoymentmodifier") == 1
		EnjoymentValue = "0.00%"
	else
		EnjoymentValue = ""
	endif
	EdgeStack = ""
	Temper = ""
	Widget.SetTexts(ActorName, EnjoymentValue)
	LastTimeFlash = game.GetRealHoursPassed()
	RegisterForSingleUpdate(1)
EndFunction

;----------------------------------------------------------------------------
;Widget update Loop
;----------------------------------------------------------------------------

Event OnUpdate()
	; Use cached bools instead of JsonUtil
	If bWidgetOn && bWidgetEnabled && Display_widget
		ShowWidget()
	Else
		HideWidget()
	EndIf
	
	Actor ActorRef = self.GetActorRef() 
	If ActorRef != none
		if controller.ActorAlias(ActorRef).GetActorRef() != none
			if controller.ActorAlias(ActorRef).GetState() == "Animating"
				If bWidgetEnabled
					UpdateWidget(ActorRef, controller.ActorAlias(ActorRef).GetFullEnjoyment() as float)
				EndIf
				If bPassiveEnjoymentReduction
					controller.ActorAlias(ActorRef).BonusEnjoyment(self.GetActorRef(), -1)
				EndIf
				RegisterForSingleUpdate(1)
			else
				StopWidget()
			endif
		else
			StopWidget()
		endif
	endif
EndEvent

Function UpdateWidget(Actor akActor, Float Enjoyment)
	If akActor == none
		return
	EndIf
	If Display_widget == true && akActor == Game.Getplayer()
		Game.EnablePlayerControls()
	EndIf
	if DisplayMode == 0
		if EnjoymentValue != ""
			EnjoymentValue = "E:" + StringUtil.Substring(controller.ActorAlias(self.GetActorRef()).GetFullEnjoymentMod(), 0, 5) + "%"
		endif
		Widget.SetTexts(ActorName, EnjoymentValue)
		Enjoyment /= 100
		
		; Use cached colors array
		If Enjoyment >= 0.75
			Widget.SetMeterColors(BaseColor, CachedWidgetColors[1])
		ElseIf Enjoyment >= 0.50
			Widget.SetMeterColors(BaseColor, CachedWidgetColors[2])
		ElseIf Enjoyment >= 0.25
			Widget.SetMeterColors(BaseColor, CachedWidgetColors[3])
		Else
			Widget.SetMeterColors(BaseColor, BaseColor)
		EndIf
		
		If Enjoyment > 1
			Enjoyment = 1
		EndIf
		Widget.SetMeterPercent(Enjoyment*100)
		If Enjoyment >= 0.90
			GetCurrentHourOfDay()		;flash
		EndIf
	elseif DisplayMode == 1
		if controller.IsAggressor(self.GetActorRef() as Actor)
			Temper = "Temper: " + StringUtil.Substring(controller.ActorAlias(self.GetActorRef()).GetTemperMult()*100, 0, 4) + "%"
		endif
		EdgeStack = "Edge: " + controller.ActorAlias(self.GetActorRef() as Actor).GetEdgeStack()
		Widget.SetTexts(Temper, EdgeStack)
		if controller.ActorAlias(self.GetActorRef() as Actor).GetMentallyBrokenState()
			Widget.SetMeterColors(MagickaFadeColor, BaseColor)
		else
			Widget.SetMeterColors(MagickaColor, MagickaFadeColor)
		endif
		Widget.SetMeterPercent(self.GetActorRef().GetActorValuePercentage("Magicka")*100)
	endif
EndFunction

Function GetCurrentHourOfDay()
	float Time = game.GetRealHoursPassed() 		; days spend in game
	Time *= 60 									; seconds spend in game (simplified calc logic from original)

	if Math.Floor(Time*86400) >= Math.Floor(LastTimeFlash*86410)
		Widget.StartMeterFlash()
		LastTimeFlash = Time
	endif
EndFunction
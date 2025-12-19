Scriptname slac_StaminaMeter extends SKI_WidgetBase

slac_Config Property slacConfig Auto

Float _meterWidth
Float _meterHeight
Int _meterColor
String _meterDirection
Float _meterValue

Event OnWidgetReset()
	Parent.OnWidgetReset()
	WidgetName  = "slac_StaminaMeterWidget"
	
	; Initial Value
	Value       = 0.0       ; 0.0 Empty, 1.0 Full
	
	; Position & Size
	HAnchor     = "left"   ; "left", "center", "right"
	VAnchor     = "top"  ; "top", "center", "bottom"
	X        = 925.0    ; Horizontal pos in pixels (0.0 to 1280.0 for all displays).
	Y        = 670.0     ; Vertical pos in pixels (0.0 to 720.0 for all displays).
	Width    = 295.0     ; approx vanilla 298.0
	Height   = 25.0      ; approx vanilla 25.0
	
	; Color
	Alpha  = 0.0       ; Ensure meter is invisible on game load
	Color       = 0xFF9E9E 	; 0xFF9E9E Pink
	
	; Animation
	Direction   = "left"    ; "left", "center", "right"
	
	; Mode Visibility 
	string[] hudModes = new string[14]
	hudModes[0] = "All"
	hudModes[1] = "StealthMode"
	hudModes[2] = "Favor"
	hudModes[3] = "Swimming"
	hudModes[4] = "HorseMode"
	hudModes[5] = "WarHorseMode"
	hudModes[6] = "MovementDisabled"
	hudModes[7] = "InventoryMode"
	hudModes[8] = "BookMode"
	hudModes[9] = "DialogueMode"
	hudModes[10] = "BarterMode"
	hudModes[11] = "TweenMode"
	hudModes[12] = "WorldMapMode"
	hudModes[13] = "CartMode"
	;hudModes[14] = "SleepWaitMode"
	;hudModes[15] = "JournalMode"
	;hudModes[16] = "VATSPlayback"
	Modes = hudModes
	
	UI.Invoke(HUD_MENU, WidgetRoot + ".initCommit")
EndEvent

; SKI_WidgetBase Overrides
String Function GetWidgetSource()
	Return "Skyui/meter.swf" ; Not sure what this does
EndFunction

String Function GetWidgetType()
	Return "slac_StaminaMeter" ; scriptname
EndFunction


; Meter display value
Float Property Value
	Function Set(Float newValue)
		_meterValue = newValue
		If (Ready)
			UI.InvokeFloat(HUD_MENU, WidgetRoot + ".setPercent", _meterValue)
		Endif
	EndFunction
	float Function Get()
		Return _meterValue
	EndFunction
EndProperty

; Meter width
Float Property Width
	Function Set(Float newWidth)
		_meterWidth = newWidth
		If (Ready)
			UI.InvokeFloat(HUD_MENU, WidgetRoot + ".setWidth", _meterWidth)
		Endif
	EndFunction
	Float Function Get()
		Return _meterWidth
	EndFunction
EndProperty

; Meter height
Float Property Height
	Function Set(Float newHeight)
		_meterHeight = newHeight
		If (Ready)
			UI.InvokeFloat(HUD_MENU, WidgetRoot + ".setHeight", _meterHeight)
		Endif
	EndFunction
	Float Function Get()
		Return _meterHeight
	EndFunction
EndProperty

; Meter color
Int Property Color
	Function Set(Int newColor)
		_meterColor = newColor
		If (Ready)
			UI.InvokeInt(HUD_MENU, WidgetRoot + ".setColor", _meterColor)
		Endif
	EndFunction
	Int Function Get()
		Return _meterColor
	EndFunction
EndProperty

; Meter fill direction
String Property Direction
	Function Set(String newDirection)
		_meterDirection = newDirection
		If (Ready)
			UI.InvokeString(HUD_MENU, WidgetRoot + ".setFillDirection", _meterDirection)
		Endif
	EndFunction
	String Function Get()
		Return _meterDirection
	EndFunction
EndProperty

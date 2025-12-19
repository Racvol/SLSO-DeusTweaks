Scriptname slac_StaminaWidgetNPC Extends slac_StaminaMeter

string function GetWidgetSource()
	return "defeat/meter.swf"
endFunction

String Function GetWidgetType()
	Return "slac_StaminaMeterNPC" ; scriptname
EndFunction

Event OnWidgetReset()
	parent.OnWidgetReset()
	WidgetName	= "slac_StaminaMeterWidgetNPC"
EndEvent

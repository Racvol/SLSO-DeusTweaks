Scriptname slac_StaminaWidgetPC Extends slac_StaminaMeter

string function GetWidgetSource()
	Return "defeat/meter.swf"
endFunction

String Function GetWidgetType()
	Return "slac_StaminaMeterPC" ; scriptname
EndFunction

Event OnWidgetReset()
	Parent.OnWidgetReset()
	WidgetName	= "slac_StaminaMeterWidgetPC"
EndEvent

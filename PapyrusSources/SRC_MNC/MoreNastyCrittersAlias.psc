ScriptName MoreNastyCrittersAlias Extends ReferenceAlias

MoreNastyCrittersRaces Property Races Auto
MoreNastyCrittersVoices Property Voices Auto

Event OnInit()
	Races.RegisterForModEvent("SexLabSlotCreatureAnimations", "RegisterAnimations")
	Voices.RegisterForModEvent("SexLabSlotVoices", "RegisterVoices")
EndEvent

Event OnPlayerLoadGame()
	Races.RegisterForModEvent("SexLabSlotCreatureAnimations", "RegisterAnimations")
	Voices.RegisterForModEvent("SexLabSlotVoices", "RegisterVoices")
EndEvent
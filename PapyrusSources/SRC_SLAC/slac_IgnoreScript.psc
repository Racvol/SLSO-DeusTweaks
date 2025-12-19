Scriptname slac_IgnoreScript extends ActiveMagicEffect

slac_Config Property slacConfig Auto
slac_Utility Property slacUtility Auto
Spell property slac_IgnoreSpell auto

Actor carrier

Event OnEffectStart(Actor akTarget, Actor akCaster)
	carrier = akTarget
	RegisterForSingleUpdateGameTime(slacConfig.ignoreDuration)
	If (slacConfig.debugSLAC)
		String attackerName = carrier.GetLeveledActorBase().GetName()
		slacUtility.Log(attackerName + " ignored for " + (slacConfig.ignoreDuration as int) + " game hours")
	EndIf
EndEvent

Event OnUpdateGameTime()
	If carrier != none
		carrier.DispelSpell(slac_IgnoreSpell)
		If (slacConfig.debugSLAC)
			String attackerName = carrier.GetLeveledActorBase().GetName()
			slacUtility.Log(attackerName + " no longer ignored")
		EndIf
	EndIf
EndEvent

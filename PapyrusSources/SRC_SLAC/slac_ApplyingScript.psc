Scriptname slac_ApplyingScript extends ActiveMagicEffect

slac_Utility Property slacUtility Auto
Spell property slac_ActiveCreatureSpell auto
 
Event OnEffectStart(Actor akTarget, Actor akCaster)
	
	If !akTarget.AddSpell(slac_ActiveCreatureSpell)
		slacUtility.Log("failed to apply ACE to " + akTarget.GetLeveledActorBase().GetName())
	EndIf
	
EndEvent

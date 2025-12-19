Scriptname slac_ApplyingCreatureScript extends ActiveMagicEffect

slac_Utility Property slacUtility Auto
Spell property slac_ActiveCreatureSpell auto
 
Event OnEffectStart(Actor akTarget, Actor akCaster)
	
	If !slac_ActiveCreatureSpell.Cast(akTarget)
		slacUtility.Log("failed to apply ACE to " + akTarget.GetLeveledActorBase().GetName())
	EndIf
	
EndEvent

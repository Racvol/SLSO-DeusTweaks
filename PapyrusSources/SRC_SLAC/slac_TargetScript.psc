Scriptname slac_TargetScript extends ActiveMagicEffect

slac_Config Property slacConfig Auto
slac_Utility Property slacUtility Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
	; Collect target actor
	slacUtility.UpdateTargetActor(akTarget)
EndEvent


Scriptname slac_ActiveCreatureScript extends ActiveMagicEffect

slac_Config Property slacConfig Auto
slac_Utility Property slacUtility Auto
Spell property slac_ActiveCreatureSpell auto
Actor Property PlayerRef Auto

Actor carrier
Float health
Bool endingNow = false

Event OnEffectStart(Actor akTarget, Actor akCaster)
	carrier = akTarget
	health = carrier.GetActorValue("Health")
EndEvent


; Stop animation on creature hit
Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
	If slacConfig.onHitInterrupt
		If (health - carrier.GetActorValue("Health")) > 2.0 || (akAggressor == PlayerRef && !(akSource as Spell))
		
			String actorName = carrier.GetLeveledActorBase().GetName()
			slacUtility.Log(actorName + " interrupted by hit (-" + (health - carrier.GetActorValue("Health")) + "hp)")
			
			slacUtility.EndPursuitQuestForActor(carrier)
			slacUtility.EndCreatureSexPrematurely(carrier)
		EndIf
	EndIf
EndEvent


; Stop Animation or Pursuit when entering combat
Event OnCombatStateChanged(Actor akTarget, int combatState)
	;slacUtility.Log("combat state change " + (endingNow) + " " + combatState)
	If combatState > 0 && !slacConfig.allowCombatEngagements
		String attackerName = carrier.GetLeveledActorBase().GetName()
		slacUtility.Log(attackerName + " interrupted by combat")
		slacUtility.EndPursuitQuestForActor(carrier)
		slacUtility.EndCreatureSexPrematurely(carrier)
	EndIf
EndEvent

; Recast if still needed
Event OnEffectFinish(Actor akTarget, Actor akCaster)
	If carrier && carrier != None
		String creatureName = carrier.GetLeveledActorBase().GetName()
		If !carrier.Is3DLoaded() || !carrier.GetParentCell().IsAttached() || carrier.GetDistance(PlayerRef) > 10000.0
			slacUtility.Log("AAE removed for " + creatureName + " - unloaded or too far")
		ElseIf carrier.IsInFaction(slacUtility.slac_engagedActor)
			slac_ActiveCreatureSpell.Cast(PlayerRef,carrier)
			slacUtility.Log("AAE resetting for " + creatureName + " - still engaged")
		ElseIf slacUtility.IsSLACPursuitActive(carrier) 
			slac_ActiveCreatureSpell.Cast(PlayerRef,carrier)
			slacUtility.Log("AAE resetting for " + creatureName + " - pursuit active")
		Else
			slacUtility.Log("AAE removed from " + creatureName + " - no longer active")
		EndIf
	EndIf
EndEvent

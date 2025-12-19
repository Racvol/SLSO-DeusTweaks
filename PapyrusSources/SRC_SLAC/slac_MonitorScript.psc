Scriptname slac_MonitorScript extends ReferenceAlias

slac_Config Property slacConfig Auto
slac_Utility Property slacUtility Auto
Actor Property PlayerRef Auto

Float health
Actor monitoredActor
String actorName

Event PrepMonitor()
	monitoredActor = GetActorReference()
	actorName = slacUtility.GetActorNameRef(monitoredActor)
	health = monitoredActor.GetActorValue("Health")
	slacUtility.Log("Monitor: now monitoring " + actorName)
EndEvent


; Stop Animation/Pursuit on actor hit
Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
	If !monitoredActor
		slacUtility.Log("Monitor: OnHit fired before PrepMonitor")
		Return
	EndIf
	; We don't check for combat engagement override here as On Hit Interrupt is a
	; distinct option in the config so we expect both to work at the same time.
	If slacConfig.onHitInterrupt
		; Monitored actor has taken more the 2 point of damage from 
		; a source other than a physical attack from the player
		If (health - monitoredActor.GetActorValue("Health")) > 2.0 || (akAggressor == PlayerRef && !(akSource as Spell))
			slacUtility.Log("Monitor: " + actorName + " interrupted by hit (-" + (health - monitoredActor.GetActorValue("Health")) + "hp)")
			slacUtility.EndPursuitQuestForActor(monitoredActor)
			slacUtility.EndCreatureSexPrematurely(monitoredActor)
		EndIf
	EndIf
EndEvent


; Stop Animation/Pursuit when entering combat
Event OnCombatStateChanged(Actor akTarget, int combatState)
	If slacConfig.onHitInterrupt && combatState > 0 && !slacConfig.allowCombatEngagements
		slacUtility.Log("Monitor: " + actorName + " interrupted by combat")
		slacUtility.EndPursuitQuestForActor(monitoredActor)
		slacUtility.EndCreatureSexPrematurely(monitoredActor)
	EndIf
EndEvent

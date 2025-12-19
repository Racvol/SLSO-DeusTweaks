Scriptname MNC_RabbitReScale extends activemagiceffect  

Event OnEffectStart(Actor Target, Actor Caster)
Caster.SetScale(1.3)
;RegisterForSingleUpdate(5.0)
EndEvent

Event OnEffectFinish(Actor target, Actor caster)
Caster.SetScale(1)
EndEvent

;note, i can't get the onupdate script to do it's fucking job, so "even actor heights" is not getting bypassed like it should be.

;Actor Target
;Actor caster
;Event OnUpdate()
;Target.SetScale(1.3)
;Caster.SetScale(1.3)
;RegisterForSingleUpdate(10.0)
;EndEvent
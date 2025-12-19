Scriptname SLSO_SpellAnimSyncScript extends activemagiceffect
{Optimized AnimSync - Cached JSON config}

SexLabFramework Property SexLab auto
sslThreadController Property controller auto

Actor ActorSync	; for animation speed control
String Property File auto

; Script-level variables (No Property needed for internal logic)
Float Base_speed
Float Min_speed
Float Max_speed

; Cached Configuration (Read once at start)
Int Property iConfigAnimSpeedMode Auto Hidden
Int Property iConfigActorSyncMode Auto Hidden
Bool Property bConfigSpeedControlEnabled Auto Hidden

Event OnEffectStart( Actor akTarget, Actor akCaster )
	File = "/SLSO/Config.json"
	
	; Check plugin version first
	if (SKSE.GetPluginVersion("animspeed plugin") > 0)
		; Cache main toggle
		int speedControl = JsonUtil.GetIntValue(File, "game_animation_speed_control", 0)
		
		if speedControl != 0
			SexLab = Quest.GetQuest("SexLabQuestFramework") as SexLabFramework
			
			; Cache configuration values immediately
			iConfigAnimSpeedMode = speedControl
			iConfigActorSyncMode = JsonUtil.GetIntValue(File, "game_animation_speed_control_actorsync")
			
			; Cache speed limits
			Base_speed = (JsonUtil.GetIntValue(File, "game_animation_speed_control_base", 50) as float)/100
			Min_speed = (JsonUtil.GetIntValue(File, "game_animation_speed_control_min" , 50) as float)/100
			Max_speed = (JsonUtil.GetIntValue(File, "game_animation_speed_control_max", 100) as float)/100
			
			RegisterForModEvent("SLSO_Start_widget", "Start_widget")
			RegisterForModEvent("AnimationEnd", "OnSexLabEnd")
		else
			Remove()
		endif
	else
		Remove()
	endif
EndEvent

Event Start_widget(Int Widget_Id, Int Thread_Id)
	UnregisterForModEvent("SLSO_Start_widget")

	controller = SexLab.GetController(Thread_Id)
	
	; Use cached mode
	if iConfigActorSyncMode == 1 && controller.HasPlayer
		;sync to player
		ActorSync = Game.GetPlayer()
		SexLab.Log(" SLSO Setup() actor: " + GetTargetActor().GetDisplayName() + " ActorSync to player")
	elseif iConfigActorSyncMode == 2
		;sync to last actor in animation(probably male\aggressor)
		int i = controller.ActorCount
		while i > 0 && ActorSync == none
			i -= 1
			if controller.ActorAlias[i].GetActorRef() != none
				if !controller.ActorAlias[i].IsVictim()
					ActorSync = controller.ActorAlias[i].GetActorRef()
				endIf
			endIf
		endWhile
		SexLab.Log(" SLSO Setup() actor: " + GetTargetActor().GetDisplayName() + " ActorSync to " + controller.ActorAlias[i].GetActorRef().GetDisplayName())
	endif
	
	if ActorSync == none
		ActorSync = GetTargetActor()
		SexLab.Log(" SLSO Setup() actor: " + GetTargetActor().GetDisplayName() + " ActorSync to self")
	endif
	
	RegisterForSingleUpdate(1)
EndEvent

Event OnSexLabEnd(string EventName, string argString, Float argNum, form sender)
	if controller == SexLab.GetController(argString as int)
		Remove()
	endif
EndEvent

Event OnUpdate()
	; Safety check
	if !GetTargetActor() || !controller || controller.GetState() != "Animating"
		Remove()
		Return
	endif

	if controller.ActorAlias(GetTargetActor()).GetActorRef() != none
		Float FullEnjoymentMOD
		
		; Use cached mode variable iConfigAnimSpeedMode instead of JsonUtil
		if iConfigAnimSpeedMode == 1 ; stamina based animation speed
			FullEnjoymentMOD = PapyrusUtil.ClampFloat(ActorSync.GetActorValuePercentage("Stamina")*100/30/3, Min_speed, Max_speed)
			AnimSpeedHelper.SetAnimationSpeed(GetTargetActor(), FullEnjoymentMOD+Base_speed, 0.5, false)
			
		elseif iConfigAnimSpeedMode == 2 ; enjoyment based animation speed
			FullEnjoymentMOD = PapyrusUtil.ClampFloat((controller.ActorAlias(ActorSync).GetFullEnjoyment() as float)/30/3, Min_speed, Max_speed)
			AnimSpeedHelper.SetAnimationSpeed(GetTargetActor(), FullEnjoymentMOD+Base_speed, 0.5, false)
		endif
		
		RegisterForSingleUpdate(1)
		return
	endif
	Remove()
EndEvent

Event OnPlayerLoadGame()
	Remove()
EndEvent

Event OnEffectFinish( Actor akTarget, Actor akCaster )
	If akTarget != none
		if (SKSE.GetPluginVersion("animspeed plugin") > 0)
			AnimSpeedHelper.SetAnimationSpeed(akTarget, 1, 0, false)
		endif
	EndIf
EndEvent

function Remove()
	If GetTargetActor() != none
		UnRegisterForUpdate()
		UnregisterForAllModEvents()
		UnregisterForAllKeys()
		SLSO_MCM SLSO = Quest.GetQuest("SLSO") as SLSO_MCM
		If GetTargetActor().HasSpell(SLSO.SLSO_SpellAnimSync)
			GetTargetActor().RemoveSpell(SLSO.SLSO_SpellAnimSync)
		EndIf
	EndIf
endFunction
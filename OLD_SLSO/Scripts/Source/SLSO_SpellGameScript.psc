Scriptname SLSO_SpellGameScript Extends activemagiceffect
{Optimized SLSO Game Script - DeltaTime, cached JSON, memory leak protection}

SexLabFramework Property SexLab auto
sslThreadController Property controller auto

String Property File auto
Bool Property IsAggressor auto
Bool Property IsVictim auto
Bool Property IsFemale auto
Bool Property IsCreature auto
Bool Property MentallyBroken auto
Bool Property Forced auto
Bool Property PauseGame auto
Actor Property PartnerReference auto
Float Property ActualMagicka auto
Float Property Vibrate auto
float Property GetModSelfSta auto
float Property GetModSelfMag auto
float Property GetModPartSta auto
float Property GetModPartMag auto
int Property Position auto
int Property RelationshipRank auto
int Property OrgasmCounted auto

Float Property fLastUpdateTime auto hidden

; Cached JSON config
Int Property iConfigGameEnabled auto hidden
Int Property iConfigGameNpcEnabled auto hidden
Int Property iConfigGamePlayerAutoplay auto hidden
Int Property iConfigGameVictimAutoplay auto hidden
Int Property iConfigGameEdging auto hidden
Int Property iConfigGameNoStaEndanim auto hidden
Int Property iConfigGameMaleOrgasmEndanim auto hidden
Int Property iConfigGameEnjoymentReduction auto hidden
Int Property iConfigGamePleasurePriority auto hidden
Int Property iConfigConditionAggressorOrgasm auto hidden
Int Property iConfigConditionConsensualOrgasm auto hidden
Int Property iConfigConditionVictimArousal auto hidden
Int Property iConfigConditionVictimOrgasmAggressorBroken auto hidden
Int Property iConfigMinimumStageTime auto hidden
Int Property iConfigSchlongSizeMindBreak auto hidden
Float Property fConfigMentalDamageTweak auto hidden
Float Property fConfigMentalDamageTweakPlayer auto hidden

; КЭШИРОВАННЫЕ КЛАВИШИ (Чтобы не читать файл при каждом нажатии)
Int Property iKey_PauseGame Auto Hidden
Int Property iKey_BonusEnjoyment Auto Hidden
Int Property iKey_Edge Auto Hidden
Int Property iKey_Resist Auto Hidden
Int Property iKey_DisplayMode Auto Hidden
Int Property iKey_Utility Auto Hidden
Int Property iKey_Select1 Auto Hidden
Int Property iKey_Select2 Auto Hidden
Int Property iKey_Select3 Auto Hidden
Int Property iKey_Select4 Auto Hidden
Int Property iKey_Select5 Auto Hidden

Event OnEffectStart( Actor akTarget, Actor akCaster )
	File = "/SLSO/Config.json"
	SexLab = Quest.GetQuest("SexLabQuestFramework") as SexLabFramework
	
	; Кэшируем настройки
	iConfigGameEnabled = JsonUtil.GetIntValue(File, "game_enabled")
	iConfigGameNpcEnabled = JsonUtil.GetIntValue(File, "game_npc_enabled", 0)
	iConfigGamePlayerAutoplay = JsonUtil.GetIntValue(File, "game_player_autoplay")
	iConfigGameVictimAutoplay = JsonUtil.GetIntValue(File, "game_victim_autoplay")
	iConfigGameEdging = JsonUtil.GetIntValue(File, "game_edging")
	iConfigGameNoStaEndanim = JsonUtil.GetIntValue(File, "game_no_sta_endanim")
	iConfigGameMaleOrgasmEndanim = JsonUtil.GetIntValue(File, "game_male_orgasm_endanim")
	iConfigGameEnjoymentReduction = JsonUtil.GetIntValue(File, "game_enjoyment_reduction_chance")
	iConfigGamePleasurePriority = JsonUtil.GetIntValue(File, "game_pleasure_priority")
	iConfigConditionAggressorOrgasm = JsonUtil.GetIntValue(File, "condition_aggressor_orgasm")
	iConfigConditionConsensualOrgasm = JsonUtil.GetIntValue(File, "condition_consensual_orgasm")
	iConfigConditionVictimArousal = JsonUtil.GetIntValue(File, "condition_victim_arousal")
	iConfigConditionVictimOrgasmAggressorBroken = JsonUtil.GetIntValue(File, "condition_victim_orgasm_aggressor_broken")
	iConfigMinimumStageTime = JsonUtil.GetIntValue(File, "minimum_stage_time")
	iConfigSchlongSizeMindBreak = JsonUtil.GetIntValue(File, "slso_schlong_size_mind_break")
	fConfigMentalDamageTweak = JsonUtil.GetFloatValue(File, "mental_damage_tweak")
	fConfigMentalDamageTweakPlayer = JsonUtil.GetFloatValue(File, "mental_damage_tweak_player")

	; Кэшируем клавиши
	iKey_PauseGame = JsonUtil.GetIntValue(File, "hotkey_pausegame")
	iKey_BonusEnjoyment = JsonUtil.GetIntValue(File, "hotkey_bonusenjoyment")
	iKey_Edge = JsonUtil.GetIntValue(File, "hotkey_edge")
	iKey_Resist = JsonUtil.GetIntValue(File, "hotkey_resist")
	iKey_DisplayMode = JsonUtil.GetIntValue(File, "hotkey_display_mode")
	iKey_Utility = JsonUtil.GetIntValue(File, "hotkey_utility")
	iKey_Select1 = JsonUtil.GetIntValue(File, "hotkey_select_actor_1")
	iKey_Select2 = JsonUtil.GetIntValue(File, "hotkey_select_actor_2")
	iKey_Select3 = JsonUtil.GetIntValue(File, "hotkey_select_actor_3")
	iKey_Select4 = JsonUtil.GetIntValue(File, "hotkey_select_actor_4")
	iKey_Select5 = JsonUtil.GetIntValue(File, "hotkey_select_actor_5")
	
	RegisterForModEvent("SLSO_Start_widget", "Start_widget")
	RegisterForModEvent("AnimationEnd", "OnSexLabEnd")
	
	RegisterKey(iKey_PauseGame)
	
	OrgasmCounted = 0
	fLastUpdateTime = Utility.GetCurrentRealTime()
EndEvent

Event Start_widget(Int Widget_Id, Int Thread_Id)
	UnregisterForModEvent("SLSO_Start_widget")

	controller = SexLab.GetController(Thread_Id)
	
	if iConfigGameEnabled == 1 && (controller.HasPlayer || iConfigGameNpcEnabled == 1)
		PauseGame = false
		IsAggressor = controller.IsAggressor(GetTargetActor())
		IsVictim = controller.IsVictim(GetTargetActor())
		IsFemale = controller.ActorAlias(GetTargetActor()).GetGender() == 1
		IsCreature = controller.ActorAlias(GetTargetActor()).IsCreature()
		if IsCreature
			ActualMagicka = GetTargetActor().GetBaseActorValue("Magicka")
			GetTargetActor().SetActorValue("Magicka",(ActualMagicka + 100))
		endif
		GetModSelfSta = GetMod("Stamina", GetTargetActor())
		GetModSelfMag = GetMod("Magicka", GetTargetActor())
		Position = controller.Positions.Find(GetTargetActor())
		RelationshipRank = controller.GetLowestPresentRelationshipRank(GetTargetActor())
		
		Change_Partner()
		
		if controller.ActorAlias(GetTargetActor()).GetActorRef() == Game.GetPlayer()
			RegisterKey(iKey_Edge)
			; RegisterKey(JsonUtil.GetIntValue(File, "hotkey_orgasm")) ; Оставлено, если нужно для совместимости
			RegisterKey(iKey_BonusEnjoyment)
			RegisterKey(iKey_Resist)
			RegisterKey(iKey_DisplayMode)
			RegisterKey(iKey_Select1)
			RegisterKey(iKey_Select2)
			RegisterKey(iKey_Select3)
			RegisterKey(iKey_Select4)
			RegisterKey(iKey_Select5)
		endif
		
		if controller.Animation.HasTag("Estrus") || controller.Animation.HasTag("Machine") || controller.Animation.HasTag("Slime") || controller.Animation.HasTag("Ooze")
			Forced = true
		endif
		self.RegisterForModEvent("DeviceVibrateEffectStart", "OnVibrateStart")
		self.RegisterForModEvent("DeviceVibrateEffectStop", "OnVibrateStop")
		RegisterForSingleUpdate(1)
	else
		Remove()
	endif
EndEvent

Event OnSexLabEnd(string EventName, string argString, Float argNum, form sender)
	if controller == SexLab.GetController(argString as int)
		Remove()
	endif
	if IsCreature
		GetTargetActor().SetActorValue("Magicka",ActualMagicka)
	endif
EndEvent

Event OnUpdate()
	Actor Target = GetTargetActor()
	
	If !Target || !Target.Is3DLoaded() || !controller || controller.GetState() != "Animating"
		Remove()
		Return
	EndIf
	
	Float CurrentTime = Utility.GetCurrentRealTime()
	fLastUpdateTime = CurrentTime
	
	if controller.ActorAlias(Target).GetActorRef() != none
		if controller.ActorAlias(Target).GetState() == "Animating"
			If iConfigGameEnabled == 1 && !PauseGame
				Game()
			EndIf
			
			RegisterForSingleUpdate(1)
			return
		endif
	endif
	Remove()
EndEvent

float Function GetMod(string var = "", actor PartnerRef = none)
	if PartnerRef == none
		PartnerRef = GetTargetActor()
	endif
	float mod = 0
	if var == "Stamina"
		if (controller.Animation.HasTag("Vaginal"))
			mod = SexLab.Stats.GetSkillLevel(PartnerRef, "Vaginal")
		elseif(controller.Animation.HasTag("Anal"))
			mod = SexLab.Stats.GetSkillLevel(PartnerRef, "Anal")
		elseif(controller.Animation.HasTag("Oral"))
			mod = SexLab.Stats.GetSkillLevel(PartnerRef, "Oral")
		elseif(controller.Animation.HasTag("Foreplay") || controller.Animation.HasTag("Masturbation"))
			mod = SexLab.Stats.GetSkillLevel(PartnerRef, "Foreplay")
		endIf
	elseif var == "Magicka"
		mod = SexLab.Stats.GetSkillLevel(PartnerRef, "Lewd", 0.3) - SexLab.Stats.GetSkillLevel(PartnerRef, "Pure", 0.3)
	else
		Debug.Notification("error, SLSO widget GetMod has no var")
	endif
	return PapyrusUtil.ClampFloat(mod, -6, 6)
EndFunction

Function Game(string var = "")
	Actor PartnerRef = none
	float FullEnjoymentMOD = PapyrusUtil.ClampFloat((controller.ActorAlias(GetTargetActor()).GetFullEnjoyment() as float)/30, 1.0, 3.0)
	float mod
	
	if (IsVictim && GetTargetActor() == Game.GetPlayer() && iConfigGameVictimAutoplay == 1)
		MentallyBroken = true
	ElseIf GetTargetActor().GetActorValuePercentage("Magicka") <= 0.10 && !MentallyBroken
		MentallyBroken = true
		if IsAggressor && GetTargetActor() != Game.GetPlayer() && controller.HasPlayer
			String msg = ("Aggressor " + GetTargetActor().GetDisplayName() + " are loosing it and try to pleasure their victim.")
			Debug.Notification(msg)
			SexLabUtil.PrintConsole(msg)
		endif
	ElseIf GetTargetActor().GetActorValuePercentage("Magicka") > 0.30 && MentallyBroken == true
		MentallyBroken = false
		if IsAggressor && GetTargetActor() != Game.GetPlayer() && controller.HasPlayer
			String msg = ("Aggressor " + GetTargetActor().GetDisplayName() + " are comming back to their sense.")
			Debug.Notification(msg)
			SexLabUtil.PrintConsole(msg)
		endif
	EndIf
	controller.ActorAlias(GetTargetActor()).SetMentallyBroken(MentallyBroken)

	controller.ActorAlias(GetTargetActor()).LoseEdgeStack(1)
	
	if IsAggressor && controller.IsVictim(Game.GetPlayer()) && !MentallyBroken && !controller.ActorAlias(PartnerReference).GetMentallyBrokenState()
		controller.ActorAlias(GetTargetActor()).AddTemperMult(0.05)
	elseif IsAggressor && controller.IsVictim(Game.GetPlayer()) && !MentallyBroken && controller.ActorAlias(PartnerReference).GetMentallyBrokenState()
		controller.ActorAlias(GetTargetActor()).LoseTemperMult(0.05)
	elseif IsAggressor && controller.IsVictim(Game.GetPlayer()) && MentallyBroken
		controller.ActorAlias(GetTargetActor()).ResetTemperMult()
	endif

	if IsAggressor && controller.ActorAlias(GetTargetActor()).GetTemperMult() > 1 && !controller.ActorAlias(PartnerReference).GetMentallyBrokenState() && !controller.ActorAlias(GetTargetActor()).GetMentallyBrokenState() && Utility.RandomInt(0, Math.Floor(35 - (5 * controller.ActorAlias(GetTargetActor()).GetTemperMult()))) <= 1
		AggressiveMentalBreak(PartnerReference)
	endif

	If var == "Stamina"
		If MentallyBroken == false
			mod = GetModSelfSta
			If GetTargetActor().GetActorValuePercentage("Stamina") > 0.10
				if (controller.ActorCount == 1 || Input.IsKeyPressed(iKey_Utility))
					ModEnjoyment(GetTargetActor(), mod, FullEnjoymentMOD)
					MentalBreak(GetTargetActor())
				elseif controller.ActorCount > 1
					ModEnjoyment(PartnerReference, mod, FullEnjoymentMOD)
					MentalBreak(PartnerReference)
					if controller.IsAggressor(PartnerReference)
						controller.ActorAlias(PartnerReference).LoseTemperMult(0.1)
					endif
				endif
			EndIf
		EndIf
	
	ElseIf var == "Magicka"
		if MentallyBroken == false
			if controller.ActorCount == 1 || Input.IsKeyPressed(iKey_Utility)
				mod = GetModSelfMag
				if GetTargetActor().GetActorValuePercentage("Magicka") > 0.10
					GetTargetActor().DamageActorValue("Magicka", GetTargetActor().GetBaseActorValue("Magicka")/(10-mod)*0.5)
					controller.ActorAlias(GetTargetActor()).HoldOut()
					EdgeStack(GetTargetActor())
				endif
			elseif controller.ActorCount > 1
				mod = GetModSelfSta
				if GetTargetActor().GetActorValuePercentage("Stamina") > 0.10
					GetTargetActor().DamageActorValue("Stamina", GetTargetActor().GetBaseActorValue("Stamina")/(10+mod)*0.5)
					controller.ActorAlias(PartnerReference).HoldOut()
					if controller.IsAggressor(PartnerReference) && !controller.ActorAlias(PartnerReference).GetMentallyBrokenState()
						controller.ActorAlias(PartnerReference).AddTemperMult(0.1)
						Sexlab.log(" TemperMult: " + controller.ActorAlias(PartnerReference).GetTemperMult())
					endif
					EdgeStack(PartnerReference)
				endif
			endif
		EndIf

	ElseIf var == "Resolve" && controller.ActorCount > 1
		if MentallyBroken == false
			if Input.IsKeyPressed(iKey_Utility)
				mod = GetModSelfMag
				GetTargetActor().DamageActorValue("Magicka", GetTargetActor().GetBaseActorValue("Magicka")*(0.60 + (mod*5)*0.01))
				GetTargetActor().RestoreActorValue("Stamina", GetTargetActor().GetBaseActorValue("Stamina"))
				Sexlab.log(" letting go ")
			else
				mod = GetModSelfMag
				if GetTargetActor().GetActorValuePercentage("Stamina") > 0.10
					if Utility.GetCurrentRealTime() < (controller.ActorAlias(GetTargetActor()).GetLastMentalDamageTime())
						GetTargetActor().DamageActorValue("Stamina",GetTargetActor().GetBaseActorValue("Stamina")/20)
						GetTargetActor().RestoreActorValue("Magicka", controller.ActorAlias(GetTargetActor()).GetLastMentalDamage())
						Sexlab.Log(" Perfect resist ! recovered " + controller.ActorAlias(GetTargetActor()).GetLastMentalDamage())
						controller.ActorAlias(GetTargetActor()).SetLastMentalDamage(0)
					else
						GetTargetActor().DamageActorValue("Stamina",GetTargetActor().GetBaseActorValue("Stamina")/10)
						GetTargetActor().RestoreActorValue("Magicka", controller.ActorAlias(GetTargetActor()).GetLastMentalDamage() * (0.60 -((mod*5)*0.01)))
						Sexlab.Log(" resisting, recovered " + controller.ActorAlias(GetTargetActor()).GetLastMentalDamage() * (0.60 -((mod*5)*0.01)))
						controller.ActorAlias(GetTargetActor()).SetLastMentalDamage(0)
					endif
					if controller.IsAggressor(PartnerReference) && !controller.ActorAlias(PartnerReference).GetMentallyBrokenState()
						controller.ActorAlias(PartnerReference).AddTemperMult(0.05)
					endif
				endif
			endif
		EndIf

	Elseif GetTargetActor() != Game.GetPlayer() || iConfigGamePlayerAutoplay == 1 || MentallyBroken == true
		mod = GetModSelfSta
		
		If GetTargetActor().GetActorValuePercentage("Stamina") > 0.10
			if controller.IsAggressor(GetTargetActor())
				if RelationshipRank < 0
					mod = math.abs(RelationshipRank)
					ModEnjoyment(GetTargetActor(), mod, FullEnjoymentMOD)
					MentalBreak(GetTargetActor())
					MentalBreak(PartnerReference)
				
				else
					if MentallyBroken == false || controller.ActorCount > 2
						ModEnjoyment(GetTargetActor(), mod, FullEnjoymentMOD)
						MentalBreak(PartnerReference)
						MentalBreak(GetTargetActor())
					else
						ModEnjoyment(PartnerReference, mod, FullEnjoymentMOD)
						MentalBreak(PartnerReference)
					EndIf
				EndIf
			Else
				if MentallyBroken == false || controller.ActorCount > 2
					if (Utility.RandomInt(0, 100) < SexLab.Stats.GetSkillLevel(GetTargetActor(), "Lewd", 0.3)*10*1.5) && iConfigGamePleasurePriority == 1
						ModEnjoyment(GetTargetActor(), mod, FullEnjoymentMOD)
						MentalBreak(GetTargetActor())
				
					elseif (Utility.RandomInt(0, 100) < (25+controller.GetHighestPresentRelationshipRank(GetTargetActor())*10*2)) && controller.ActorCount == 2
						ModEnjoyment(PartnerReference, mod, FullEnjoymentMOD)
						MentalBreak(PartnerReference)
						MentalBreak(GetTargetActor())

					elseif (Utility.RandomInt(0, 100) < SexLab.Stats.GetSkillLevel(GetTargetActor(), "Lewd", 0.3)*10*1.5) && iConfigGamePleasurePriority == 0
						ModEnjoyment(GetTargetActor(), mod, FullEnjoymentMOD)
						MentalBreak(GetTargetActor())

					EndIf
					
				else
					ModEnjoyment(PartnerReference, mod, FullEnjoymentMOD)
					MentalBreak(PartnerReference)
				EndIf
			EndIf
		EndIf
		
		mod = GetModSelfMag
		
		If iConfigGameEdging == 1
			If GetTargetActor().GetActorValuePercentage("Magicka") > 0.10 && (Utility.RandomInt(0, 100) < (25+controller.GetHighestPresentRelationshipRank(GetTargetActor())*10*2) && controller.ActorCount == 2)
				If controller.ActorAlias(GetTargetActor()).GetFullEnjoyment() as float > 95
					GetTargetActor().DamageActorValue("Magicka", GetTargetActor().GetBaseActorValue("Magicka")/(10-mod))
					controller.ActorAlias(GetTargetActor()).HoldOut(3)
					MentalBreak(GetTargetActor())
					MentalBreak(PartnerReference)
				EndIf
			EndIf
		EndIf
	endif
	

	If Vibrate > 0
		GetTargetActor().DamageActorValue("Stamina", GetTargetActor().GetBaseActorValue("Stamina")/(10-GetModSelfMag+FullEnjoymentMOD))
		controller.ActorAlias(GetTargetActor()).BonusEnjoyment(GetTargetActor(), Vibrate as Int)
		MentalBreak(GetTargetActor())
	EndIf
	
	If Forced
		GetTargetActor().DamageActorValue("Stamina", GetTargetActor().GetBaseActorValue("Stamina")/(10-GetModSelfMag+FullEnjoymentMOD))
		controller.ActorAlias(GetTargetActor()).BonusEnjoyment(GetTargetActor(), 1)
		MentalBreak(GetTargetActor())
	EndIf

	If (iConfigGameNoStaEndanim == 1 && GetTargetActor().GetActorValuePercentage("Stamina") < 0.10) && (Position != 0 || controller.ActorCount == 1) && (controller.Stage < controller.Animation.StageCount || (((controller.ActorAlias(GetTargetActor()) as sslActorAlias).GetOrgasmCount()) >= controller.Get_minimum_aggressor_orgasm_Count())) && Utility.GetCurrentRealTime() > controller.GetLastStageSkip()
		if ((IsAggressor && iConfigConditionAggressorOrgasm == 1) || iConfigConditionConsensualOrgasm) && ((controller.ActorAlias(GetTargetActor()) as sslActorAlias).GetOrgasmCount()) >= controller.Get_minimum_aggressor_orgasm_Count()
			controller.AdvanceStage()
		elseif controller.ActorCount == 1
			GetTargetActor().RestoreActorValue("Stamina", (GetTargetActor().GetBaseActorValue("Stamina")/3))
			sexlab.Log("regenerated: " + (GetTargetActor().GetBaseActorValue("Stamina")/3)+ " stamina")
			MentalBreak(GetTargetActor())
			controller.AdvanceStage()
		elseif (controller.ActorAlias(GetTargetActor()) as sslActorAlias).GetOrgasmCount() <= 0 && ((!IsAggressor && iConfigConditionConsensualOrgasm == false) || (IsAggressor && iConfigConditionAggressorOrgasm == false))
			GetTargetActor().RestoreActorValue("Stamina", (GetTargetActor().GetBaseActorValue("Stamina")/2)*(controller.ActorCount - 1))
			sexlab.Log("regenerated: " + (GetTargetActor().GetBaseActorValue("Stamina")/2)*(controller.ActorCount - 1) + " stamina")
			MentalBreak(GetTargetActor())
			controller.AdvanceStage()
		elseif (controller.ActorAlias(GetTargetActor()) as sslActorAlias).GetOrgasmCount() > 0 && ((!IsAggressor && iConfigConditionConsensualOrgasm == false) || (IsAggressor && iConfigConditionAggressorOrgasm == false))
			controller.AdvanceStage()
		else
			GetTargetActor().RestoreActorValue("Stamina", ((GetTargetActor().GetBaseActorValue("Stamina")/4)*controller.Get_minimum_aggressor_orgasm_Count())*(controller.ActorCount - 1))
			if IsAggressor && controller.ActorAlias(GetTargetActor()).GetTemperMult() > 1 && !controller.ActorAlias(PartnerReference).GetMentallyBrokenState() && !controller.ActorAlias(GetTargetActor()).GetMentallyBrokenState()
				AggressiveMentalBreak(PartnerReference)
			endif
			sexlab.Log("regenerated: " + (GetTargetActor().GetBaseActorValue("Stamina")/4)*controller.Get_minimum_aggressor_orgasm_Count()*(controller.ActorCount - 1) + " stamina")
			MentalBreak(GetTargetActor())
			controller.AdvanceStage()
		Endif
		sexlab.Log(((controller.ActorAlias(GetTargetActor()) as sslActorAlias).GetOrgasmCount()) + " out of " + controller.Get_minimum_aggressor_orgasm_Count() + " orgasm required ")
		; ИСПРАВЛЕНО: Использование закэшированного значения вместо JsonUtil
		controller.SetLastStageSkip(Utility.GetCurrentRealTime() + iConfigMinimumStageTime)
	EndIf

	If (iConfigGameMaleOrgasmEndanim == 1 && !IsFemale && (controller.ActorAlias(GetTargetActor()) as sslActorAlias).GetOrgasmCount() > 0) && ((Position != 0 && controller.ActorCount <= 2) || controller.ActorCount == 1) && (controller.Stage < controller.Animation.StageCount || (((controller.ActorAlias(GetTargetActor()) as sslActorAlias).GetOrgasmCount()) >= controller.Get_minimum_aggressor_orgasm_Count())) && Utility.GetCurrentRealTime() > controller.GetLastStageSkip()
		if (IsAggressor || iConfigConditionConsensualOrgasm) && ((controller.ActorAlias(GetTargetActor()) as sslActorAlias).GetOrgasmCount()) >= controller.Get_minimum_aggressor_orgasm_Count() && controller.ActorCount == 2
			controller.AdvanceStage()
			; ИСПРАВЛЕНО
			controller.SetLastStageSkip(Utility.GetCurrentRealTime() + iConfigMinimumStageTime)
		elseif (!IsAggressor && iConfigConditionConsensualOrgasm == false) || (IsAggressor && iConfigConditionAggressorOrgasm == false) && controller.ActorCount == 2
			controller.AdvanceStage()
			; ИСПРАВЛЕНО
			controller.SetLastStageSkip(Utility.GetCurrentRealTime() + iConfigMinimumStageTime)
		elseif ((controller.ActorAlias(GetTargetActor()) as sslActorAlias).GetOrgasmCount()) > OrgasmCounted && controller.ActorCount <= 2 || controller.ActorCount > 2 && ((controller.ActorAlias(GetTargetActor()) as sslActorAlias).GetOrgasmCount()) > OrgasmCounted /( controller.ActorCount - 1)
			OrgasmCounted += 1
			controller.AdvanceStage(controller.Animation.StageCount)
			if IsAggressor && controller.ActorAlias(GetTargetActor()).GetTemperMult() > 1 && !controller.ActorAlias(PartnerReference).GetMentallyBrokenState() && !controller.ActorAlias(GetTargetActor()).GetMentallyBrokenState()
				AggressiveMentalBreak(PartnerReference)
			endif
			MentalBreak(GetTargetActor())
			sexlab.Log(((controller.ActorAlias(GetTargetActor()) as sslActorAlias).GetOrgasmCount()) + " out of " + controller.Get_minimum_aggressor_orgasm_Count() + " orgasm required ")
			; ИСПРАВЛЕНО
			controller.SetLastStageSkip(Utility.GetCurrentRealTime() + iConfigMinimumStageTime)
		EndIf
	EndIf
	
EndFunction

Function ModEnjoyment(Actor PartnerRef, float mod, float FullEnjoymentMOD)
    GetTargetActor().DamageActorValue("Stamina", GetTargetActor().GetBaseActorValue("Stamina")/(10+mod+FullEnjoymentMOD))
    if PartnerRef != none
        if mod < 3 && Utility.RandomInt(0, 100) < (3 - mod) * 10 && iConfigGameEnjoymentReduction == 1
            controller.ActorAlias(GetTargetActor()).BonusEnjoyment(PartnerRef, -1 + Math.Floor(controller.ActorAlias(PartnerRef).GetEdgeStack()*0.25))
        elseif PartnerRef == GetTargetActor() && controller.ActorAlias(PartnerReference).GetMentallyBrokenState()
            controller.ActorAlias(GetTargetActor()).BonusEnjoyment(PartnerRef, 2 + Math.Floor(controller.ActorAlias(PartnerRef).GetEdgeStack()*0.5))
        else
            controller.ActorAlias(GetTargetActor()).BonusEnjoyment(PartnerRef, Math.Floor(controller.ActorAlias(PartnerRef).GetEdgeStack()*0.25))
        endif
    else    
        SexLab.Log(" SLSO GAME():ModEnjoyment: something wrong, PartnerRef is none")
    endif
EndFunction

Function EdgeStack(Actor PartnerRef)
    if PartnerRef != none
        if controller.ActorAlias(PartnerRef).GetFullEnjoyment() >= 85
            controller.ActorAlias(PartnerRef).AddEdgeStack(3)
        elseif controller.ActorAlias(PartnerRef).GetFullEnjoyment() >= 75
            controller.ActorAlias(PartnerRef).AddEdgeStack(2)
        elseif controller.ActorAlias(PartnerRef).GetFullEnjoyment() >= 65
            controller.ActorAlias(PartnerRef).AddEdgeStack(1)
        endif
    endif
endfunction

Function MentalBreak(Actor PartnerRef)
    if PartnerRef != none
        int damageValue = 0
        if controller.Positions.Find(partnerRef) == 0 && iConfigSchlongSizeMindBreak
            if partnerRef != GetTargetActor()
                damageValue = math.Ceiling(PartnerRef.GetBaseActorValue("Magicka")*0.01*(10+(10*controller.ActorAlias(GetTargetActor()).GetSchlongPercentEfficiency())-GetModSelfSta+GetMod("Magicka",PartnerRef)*0.01)*(((controller.ActorAlias(PartnerRef) as sslActorAlias).GetFullEnjoyment() as float)*0.01)*((1+(controller.ActorAlias(PartnerRef) as sslActorAlias).GetOrgasmCount())*0.5) * controller.ActorAlias(GetTargetActor()).GetTemperMult())
            else
                int schlongDamage = 0
                int i = controller.ActorCount
                While i > 0
                    i -= 1
                    if controller.ActorAlias[i].GetRef() as Actor != GetTargetActor() as Actor
                        schlongDamage += math.Ceiling(10*controller.ActorAlias[i].GetSchlongPercentEfficiency())
                    endif
                endWhile
                damageValue = math.Ceiling( PartnerRef.GetBaseActorValue("Magicka")*0.01*(10+(schlongDamage)-GetModSelfSta+GetMod("Magicka",PartnerRef)*0.01)*(((controller.ActorAlias(PartnerRef) as sslActorAlias).GetFullEnjoyment() as float)*0.01)*((1+(controller.ActorAlias(PartnerRef) as sslActorAlias).GetOrgasmCount())*0.5))
            endif
        elseif partnerRef != GetTargetActor()
            damageValue = math.Ceiling( PartnerRef.GetBaseActorValue("Magicka")*0.01*(10-GetModSelfSta+GetMod("Magicka",PartnerRef)*0.01)*(((controller.ActorAlias(PartnerRef) as sslActorAlias).GetFullEnjoyment() as float)*0.01)*((1+(controller.ActorAlias(PartnerRef) as sslActorAlias).GetOrgasmCount())*0.5) * controller.ActorAlias(GetTargetActor()).GetTemperMult())
        else
            damageValue = math.Ceiling( PartnerRef.GetBaseActorValue("Magicka")*0.01*(10-GetModSelfSta+GetMod("Magicka",PartnerRef)*0.01)*(((controller.ActorAlias(PartnerRef) as sslActorAlias).GetFullEnjoyment() as float)*0.01)*((1+(controller.ActorAlias(PartnerRef) as sslActorAlias).GetOrgasmCount())*0.5))
        endif
        if partnerRef != GetTargetActor() && controller.ActorAlias(partnerRef).GetResisting()
            damageValue = math.Ceiling(damageValue * (0.60 + (GetMod("Magicka",PartnerRef)*5)*0.01))
            controller.ActorAlias(partnerRef).SetResisting(false)
        endif
        if partnerRef == GetTargetActor() && IsAggressor && controller.ActorAlias(PartnerReference).GetMentallyBrokenState()
            damageValue = math.Floor(damageValue * 0.5)
        endif
        if PartnerRef != Game.GetPlayer()
            damageValue = math.Ceiling(damageValue * fConfigMentalDamageTweak)
        else
            damageValue = math.Ceiling(damageValue * fConfigMentalDamageTweakPlayer)
        endif
        PartnerRef.DamageActorValue("Magicka",damageValue)
        if partnerRef != GetTargetActor() && damageValue > 0
            controller.ActorAlias(PartnerRef).SetLastMentalDamage(damageValue)
            controller.ActorAlias(PartnerRef).SetLastMentalDamageTime(Utility.GetCurrentRealTime() + 0.5)
        endif
        
    endif
EndFunction

Function AggressiveMentalBreak(Actor PartnerRef)
    if PartnerRef != none
        int damageValue = 0
        if Utility.RandomInt(30, Math.Floor(115 - (15 * controller.ActorAlias(GetTargetActor()).GetTemperMult()))) < PartnerRef.GetActorValuePercentage("Health")*100
            PartnerRef.DamageActorValue("Health", PartnerRef.GetActorValue("Health")/(Utility.RandomInt(10, 25)))
            (controller.ActorAlias(partnerRef) as sslActorAlias).SLSO_Animating_Moan()
        endif
        damageValue = math.Ceiling(PartnerRef.GetBaseActorValue("Magicka")* (1 - PartnerRef.GetActorValuePercentage("Health") ) *(((controller.ActorAlias(PartnerRef) as sslActorAlias).GetFullEnjoyment() as float)*0.01)*((1+(controller.ActorAlias(PartnerRef) as sslActorAlias).GetOrgasmCount())*0.5))
        if partnerRef != GetTargetActor() && controller.ActorAlias(partnerRef).GetResisting()
            damageValue = math.Ceiling(damageValue * (0.60 + (GetMod("Magicka",PartnerRef)*5)*0.01))
            controller.ActorAlias(partnerRef).SetResisting(false)
        endif
        if PartnerRef != Game.GetPlayer()
            damageValue = math.Ceiling(damageValue * fConfigMentalDamageTweak)
        else
            damageValue = math.Ceiling(damageValue * fConfigMentalDamageTweakPlayer)
        endif
        PartnerRef.DamageActorValue("Magicka",damageValue)
        if partnerRef != GetTargetActor() && damageValue > 0
            controller.ActorAlias(PartnerRef).SetLastMentalDamage(damageValue)
            controller.ActorAlias(PartnerRef).SetLastMentalDamageTime(Utility.GetCurrentRealTime() + 0.5)
        endif
    endif
EndFunction

Event OnPlayerLoadGame()
    Remove()
EndEvent

Event OnEffectFinish( Actor akTarget, Actor akCaster )
EndEvent

Function Remove()
    If GetTargetActor() != none
        UnRegisterForUpdate()
        UnregisterForAllModEvents()
        UnregisterForAllKeys()
        SLSO_MCM SLSO = Quest.GetQuest("SLSO") as SLSO_MCM
        If GetTargetActor().HasSpell(SLSO.SLSO_SpellGame)
            GetTargetActor().RemoveSpell(SLSO.SLSO_SpellGame)
        EndIf
    EndIf
EndFunction

Function Change_Partner(int partnerid = 0)
    partnerid = partnerid - 1
    Actor PartnerReference1
    if controller.ActorCount > 1
        if partnerid < 0
            PartnerReference = controller.ActorAlias(controller.Positions[sslUtility.IndexTravel(controller.Positions.Find(GetTargetActor()), controller.ActorCount)]).GetActorRef()
            if controller.ActorAlias(GetTargetActor()).GetActorRef() == Game.GetPlayer()
                SexLab.Log("SLSO " + GetTargetActor().GetDisplayName() + "'s current partner is " + PartnerReference.GetDisplayName())
            endif
        else
            if !IsFemale && controller.ActorCount > 2
                PartnerReference = controller.Positions[0]
                return
            endif
            PartnerReference1 = controller.ActorAlias[partnerid].GetActorRef()
            if PartnerReference1 == none || PartnerReference1 == PartnerReference || PartnerReference1 == GetTargetActor() || PartnerReference1 == Game.GetPlayer()
                return
            endif
            PartnerReference = PartnerReference1
            if controller.ActorAlias(GetTargetActor()).GetActorRef() == Game.GetPlayer()
                SexLab.Log("SLSO " + GetTargetActor().GetDisplayName() + " changed focus to " + PartnerReference.GetDisplayName())
                Debug.Notification(GetTargetActor().GetDisplayName() + " changed partner to " + PartnerReference.GetDisplayName())
            endif
        endif
        GetModPartSta = GetMod("Stamina", PartnerReference)
        GetModPartMag = GetMod("Magicka", PartnerReference)
        int handle = ModEvent.Create("SLSO_Change_Partner")
        if (handle)
            ModEvent.PushForm(handle, PartnerReference)
            ModEvent.Send(handle)
        endif
    endif
EndFunction

Function Change_Display()
    if controller.ActorCount > 1 && PartnerReference != none && controller.ActorAlias(GetTargetActor()).GetActorRef() == Game.GetPlayer()
        SexLab.Log("Changing SLSO display of " + PartnerReference.GetDisplayName())
        int handle = ModEvent.Create("SLSO_Change_Display")
        if (handle)
            ModEvent.PushForm(handle, PartnerReference)
            ModEvent.Send(handle)
        endif
    endif
endfunction

Event OnVibrateStart(string eventName, string argString, float argNum, form sender)
    If argString == GetTargetActor().GetDisplayName()
        Vibrate = argNum
    EndIf
EndEvent

Event OnVibrateStop(string eventName, string argString, float argNum, form sender)
    If argString == GetTargetActor().GetDisplayName()
        Vibrate = 0
    EndIf
EndEvent

;----------------------------------------------------------------------------
;Hotkeys
;----------------------------------------------------------------------------
Function RegisterKey(int RKey = 0)
    If (RKey != 0)
        self.RegisterForKey(RKey)
    EndIf
EndFunction

Event OnKeyDown(int keyCode)
    if !Utility.IsInMenuMode()
        if controller.ActorAlias(GetTargetActor()).GetActorRef() != none
            ; ИСПОЛЬЗУЕМ КЭШИРОВАННЫЕ КЛАВИШИ ВМЕСТО JsonUtil
            If keyCode == iKey_PauseGame && Input.IsKeyPressed(iKey_Utility)
                if PauseGame
                    PauseGame = false
                    Debug.Notification("SLSO game paused: " + PauseGame)
                else
                    PauseGame = true
                    Debug.Notification("SLSO game paused: " + PauseGame)
                endif
            ElseIf iConfigGameEnabled == 1
                If keyCode == iKey_BonusEnjoyment
                    Game("Stamina")
                ElseIf keyCode == iKey_Edge
                    Game("Magicka")
                ElseIf keyCode == iKey_Resist
                    Game("Resolve")
                ElseIf keyCode == iKey_DisplayMode
                    Change_Display()
                ElseIf Input.IsKeyPressed(iKey_Utility)
                    If keyCode == iKey_Select1
                        Change_Partner(1)
                    ElseIf keyCode == iKey_Select2
                        Change_Partner(2)
                    ElseIf keyCode == iKey_Select3
                        Change_Partner(3)
                    ElseIf keyCode == iKey_Select4
                        Change_Partner(4)
                    ElseIf keyCode == iKey_Select5
                        Change_Partner(5)
                    EndIf
                EndIf
            EndIf
        EndIf
    EndIf
EndEvent
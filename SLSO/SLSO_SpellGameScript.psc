Scriptname SLSO_SpellGameScript Extends activemagiceffect

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

Event OnEffectStart( Actor akTarget, Actor akCaster )
	File = "/SLSO/Config.json"
	SexLab = Quest.GetQuest("SexLabQuestFramework") as SexLabFramework
	RegisterForModEvent("SLSO_Start_widget", "Start_widget")
	RegisterForModEvent("AnimationEnd", "OnSexLabEnd")
	RegisterKey(JsonUtil.GetIntValue(File, "hotkey_pausegame"))
	OrgasmCounted = 0
EndEvent

Event Start_widget(Int Widget_Id, Int Thread_Id)
	UnregisterForModEvent("SLSO_Start_widget")

	controller = SexLab.GetController(Thread_Id)
	
	;check if game enabled
	if JsonUtil.GetIntValue(File, "game_enabled") == 1 && (controller.HasPlayer || JsonUtil.GetIntValue(File, "game_npc_enabled", 0) == 1)
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
		Position  = controller.Positions.Find(GetTargetActor())
		RelationshipRank = controller.GetLowestPresentRelationshipRank(GetTargetActor())

		;SexLab.Log("SLSO partner OLD pre: " + PartnerReference.GetDisplayName())
		;if controller.ActorCount > 1
		;	PartnerReference = controller.ActorAlias(controller.Positions[sslUtility.IndexTravel(controller.Positions.Find(GetTargetActor()), controller.ActorCount)]).GetActorRef()
		;	;GetModPartSta = GetMod("Stamina", PartnerReference)
		;	;GetModPartMag = GetMod("Magicka", PartnerReference) 
		;endif
		;SexLab.Log("SLSO partner OLD post: " + PartnerReference.GetDisplayName())
		
		Change_Partner()
		
		if controller.ActorAlias(GetTargetActor()).GetActorRef() == Game.GetPlayer()
;			SexLab.Log(" SLSO Setup() Player, enabling hotkeys")
			RegisterKey(JsonUtil.GetIntValue(File, "hotkey_edge"))
			RegisterKey(JsonUtil.GetIntValue(File, "hotkey_orgasm"))
			RegisterKey(JsonUtil.GetIntValue(File, "hotkey_bonusenjoyment"))
			RegisterKey(JsonUtil.GetIntValue(File, "hotkey_resist"))
			RegisterKey(JsonUtil.GetIntValue(File, "hotkey_display_mode"))
			RegisterKey(JsonUtil.GetIntValue(File, "hotkey_select_actor_1"))
			RegisterKey(JsonUtil.GetIntValue(File, "hotkey_select_actor_2"))
			RegisterKey(JsonUtil.GetIntValue(File, "hotkey_select_actor_3"))
			RegisterKey(JsonUtil.GetIntValue(File, "hotkey_select_actor_4"))
			RegisterKey(JsonUtil.GetIntValue(File, "hotkey_select_actor_5"))
		endif
		;Estrus, increase enjoyment
		if controller.Animation.HasTag("Estrus")\
		|| controller.Animation.HasTag("Machine")\
		|| controller.Animation.HasTag("Slime")\
		|| controller.Animation.HasTag("Ooze")
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
	;SexLab.Log(self.GetID() - 6  + " SLSO_Game OnUpdate() is running on " + GetTargetActor().GetDisplayName())
	;float bench = game.GetRealHoursPassed()
	if controller.ActorAlias(GetTargetActor()).GetActorRef() != none
		if controller.ActorAlias(GetTargetActor()).GetState() == "Animating"
			If JsonUtil.GetIntValue(File, "game_enabled") == 1 && !PauseGame
				Game()
			EndIf
			
			;SexLab.Log(" SLSO OnUpdate()Game: " + (game.GetRealHoursPassed()-bench)*60*60 )
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
	;return Stamina 0..6 							increases enjoyment, increases magicka damage(mentalbreak)
	;return Magicka -6..+6							-6= pure, reduce own magicka action cost/mentalbreak damage; +6 lewd, increase own magicka action cost/mentalbreak damage
	return PapyrusUtil.ClampFloat(mod, -6, 6)
EndFunction

Function Game(string var = "")
	;float bench = game.GetRealHoursPassed()
	Actor PartnerRef = none
	float FullEnjoymentMOD = PapyrusUtil.ClampFloat((controller.ActorAlias(GetTargetActor()).GetFullEnjoyment() as float)/30, 1.0, 3.0)
	float mod
	
	if (IsVictim && GetTargetActor() == Game.GetPlayer() && JsonUtil.GetIntValue(File, "game_victim_autoplay") == 1)
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

	;passively lose edgestack
	controller.ActorAlias(GetTargetActor()).LoseEdgeStack(1)
	;aggressor passively augment damage to magicka if neither him or victim are mentally broken
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

	;PC only (hotkey)
	;raise enjoyment
	If var == "Stamina"
		If MentallyBroken == false
			mod = GetModSelfSta
			If GetTargetActor().GetActorValuePercentage("Stamina") > 0.10
				;self
				if (controller.ActorCount == 1 || Input.IsKeyPressed(JsonUtil.GetIntValue(File, "hotkey_utility")))
					;SexLab.Log("raise enjoyment self: " + GetTargetActor().GetDisplayName())
					ModEnjoyment(GetTargetActor(), mod, FullEnjoymentMOD)
					MentalBreak(GetTargetActor())
				;partner
				elseif controller.ActorCount > 1
					;SexLab.Log("raise enjoyment partner: " + PartnerReference.GetDisplayName())
					ModEnjoyment(PartnerReference, mod, FullEnjoymentMOD)
					MentalBreak(PartnerReference)
					if controller.IsAggressor(PartnerReference)
						controller.ActorAlias(PartnerReference).LoseTemperMult(0.1)
					endif
				endif
			EndIf
		EndIf
	
	;PC only (hotkey)
	;edge
	ElseIf var == "Magicka"
		;Edge
		;self
		if MentallyBroken == false
			if controller.ActorCount == 1 || Input.IsKeyPressed(JsonUtil.GetIntValue(File, "hotkey_utility"))
				mod = GetModSelfMag
				if GetTargetActor().GetActorValuePercentage("Magicka") > 0.10
					GetTargetActor().DamageActorValue("Magicka", GetTargetActor().GetBaseActorValue("Magicka")/(10-mod)*0.5)
					controller.ActorAlias(GetTargetActor()).HoldOut()
					EdgeStack(GetTargetActor())
				endif
			;partner
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
	;PC only (hotkey)
	;Resolve
	ElseIf var == "Resolve" && controller.ActorCount > 1
			;Embrace
		if MentallyBroken == false
			if Input.IsKeyPressed(JsonUtil.GetIntValue(File, "hotkey_utility"))
				mod = GetModSelfMag
				GetTargetActor().DamageActorValue("Magicka", GetTargetActor().GetBaseActorValue("Magicka")*(0.60 + (mod*5)*0.01))
				GetTargetActor().RestoreActorValue("Stamina", GetTargetActor().GetBaseActorValue("Stamina"))
				Sexlab.log(" letting go ")
			;Resist
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

	;PC(auto/mentalbreak)/NPC
	Elseif GetTargetActor() != Game.GetPlayer()\
	|| JsonUtil.GetIntValue(File, "game_player_autoplay") == 1\
	|| MentallyBroken == true
		mod = GetModSelfSta
		
		If GetTargetActor().GetActorValuePercentage("Stamina") > 0.10
			;aggressor
			if controller.IsAggressor(GetTargetActor())
				;hate sex, enemies
				if RelationshipRank < 0
					mod = math.abs(RelationshipRank)
					ModEnjoyment(GetTargetActor(), mod, FullEnjoymentMOD)
					MentalBreak(GetTargetActor())
					MentalBreak(PartnerReference)
				
				;rough sex, neutrals-lovers
				else
				;not broken, pleasure self
					if MentallyBroken == false || controller.ActorCount > 2
						ModEnjoyment(GetTargetActor(), mod, FullEnjoymentMOD)
						MentalBreak(PartnerReference)
						MentalBreak(GetTargetActor())
				;mental broken, pleasure partner
					else
						ModEnjoyment(PartnerReference, mod, FullEnjoymentMOD)
						MentalBreak(PartnerReference)
					EndIf
				EndIf
			Else
				;not aggressor
				
				;mentally not broken, pleasure self
				if MentallyBroken == false || controller.ActorCount > 2
					;pleasure self if self priority
					;lewdness based check
					if (Utility.RandomInt(0, 100) < SexLab.Stats.GetSkillLevel(GetTargetActor(), "Lewd", 0.3)*10*1.5) && JsonUtil.GetIntValue(File, "game_pleasure_priority") == 1
						ModEnjoyment(GetTargetActor(), mod, FullEnjoymentMOD)
						MentalBreak(GetTargetActor())
				
					;relationship based check
					;try to pleasure other actor
					elseif (Utility.RandomInt(0, 100) < (25+controller.GetHighestPresentRelationshipRank(GetTargetActor())*10*2)) && controller.ActorCount == 2
						ModEnjoyment(PartnerReference, mod, FullEnjoymentMOD)
						MentalBreak(PartnerReference)
						MentalBreak(GetTargetActor())

					;pleasure self if partner priority
					;lewdness based check
					elseif (Utility.RandomInt(0, 100) < SexLab.Stats.GetSkillLevel(GetTargetActor(), "Lewd", 0.3)*10*1.5) && JsonUtil.GetIntValue(File, "game_pleasure_priority") == 0
						ModEnjoyment(GetTargetActor(), mod, FullEnjoymentMOD)
						MentalBreak(GetTargetActor())

					EndIf
					
				;mentally broken, pleasure partner
				else
					ModEnjoyment(PartnerReference, mod, FullEnjoymentMOD)
					MentalBreak(PartnerReference)
				EndIf
			EndIf
		EndIf
		
		mod = GetModSelfMag
		
		;try to hold out orgasm especially if high relation with partner
		If JsonUtil.GetIntValue(File, "game_edging") == 1
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
	

	;DD vibrations
	If Vibrate > 0
		GetTargetActor().DamageActorValue("Stamina", GetTargetActor().GetBaseActorValue("Stamina")/(10-GetModSelfMag+FullEnjoymentMOD))
		controller.ActorAlias(GetTargetActor()).BonusEnjoyment(GetTargetActor(), Vibrate as Int)
		MentalBreak(GetTargetActor())
	EndIf
	
	;EC forced masturbation
	If Forced
		GetTargetActor().DamageActorValue("Stamina", GetTargetActor().GetBaseActorValue("Stamina")/(10-GetModSelfMag+FullEnjoymentMOD))
		controller.ActorAlias(GetTargetActor()).BonusEnjoyment(GetTargetActor(), 1)
		MentalBreak(GetTargetActor())
	EndIf

	;skip to last animation stage if male actor:
	;out of stamina
	;orgasmed enough times (else restore some stamina and advance animation, and harm victim magicka if agressor)
	If (JsonUtil.GetIntValue(File, "game_no_sta_endanim") == 1 && GetTargetActor().GetActorValuePercentage("Stamina") < 0.10)\
	&& (Position != 0 || controller.ActorCount == 1)\
	&& (controller.Stage < controller.Animation.StageCount || (((controller.ActorAlias(GetTargetActor()) as sslActorAlias).GetOrgasmCount()) >= controller.Get_minimum_aggressor_orgasm_Count()))\
	&& Utility.GetCurrentRealTime() > controller.GetLastStageSkip()
		if ((IsAggressor && JsonUtil.GetIntValue(File, "condition_aggressor_orgasm") == 1) || JsonUtil.GetIntValue(File, "condition_consensual_orgasm")) && ((controller.ActorAlias(GetTargetActor()) as sslActorAlias).GetOrgasmCount()) >= controller.Get_minimum_aggressor_orgasm_Count()
			controller.AdvanceStage()
		elseif controller.ActorCount == 1
			GetTargetActor().RestoreActorValue("Stamina", (GetTargetActor().GetBaseActorValue("Stamina")/3))
			sexlab.Log("regenerated: " + (GetTargetActor().GetBaseActorValue("Stamina")/3)+ " stamina")
			MentalBreak(GetTargetActor())
			controller.AdvanceStage()
		elseif (controller.ActorAlias(GetTargetActor()) as sslActorAlias).GetOrgasmCount() <= 0 && ((!IsAggressor && JsonUtil.GetIntValue(File, "condition_consensual_orgasm") == false) || (IsAggressor && JsonUtil.GetIntValue(File, "condition_aggressor_orgasm") == false))
			GetTargetActor().RestoreActorValue("Stamina", (GetTargetActor().GetBaseActorValue("Stamina")/2)*(controller.ActorCount - 1))
			sexlab.Log("regenerated: " + (GetTargetActor().GetBaseActorValue("Stamina")/2)*(controller.ActorCount - 1) + " stamina")
			MentalBreak(GetTargetActor())
			controller.AdvanceStage()
		elseif (controller.ActorAlias(GetTargetActor()) as sslActorAlias).GetOrgasmCount() > 0 && ((!IsAggressor && JsonUtil.GetIntValue(File, "condition_consensual_orgasm") == false) || (IsAggressor && JsonUtil.GetIntValue(File, "condition_aggressor_orgasm") == false))
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
		controller.SetLastStageSkip(Utility.GetCurrentRealTime() + JsonUtil.GetIntValue(File, "minimum_stage_time")) 
	EndIf

	;skip to last animation stage each time male actor orgasmed
	If (JsonUtil.GetIntValue(File, "game_male_orgasm_endanim") == 1 && !IsFemale && (controller.ActorAlias(GetTargetActor()) as sslActorAlias).GetOrgasmCount() > 0)\
	&& ((Position != 0 && controller.ActorCount <= 2) || controller.ActorCount == 1)\
	&& (controller.Stage < controller.Animation.StageCount || (((controller.ActorAlias(GetTargetActor()) as sslActorAlias).GetOrgasmCount()) >= controller.Get_minimum_aggressor_orgasm_Count()))\
	&& Utility.GetCurrentRealTime() > controller.GetLastStageSkip()
		if (IsAggressor || JsonUtil.GetIntValue(File, "condition_consensual_orgasm")) && ((controller.ActorAlias(GetTargetActor()) as sslActorAlias).GetOrgasmCount()) >= controller.Get_minimum_aggressor_orgasm_Count() && controller.ActorCount == 2
			controller.AdvanceStage()
			controller.SetLastStageSkip(Utility.GetCurrentRealTime() + JsonUtil.GetIntValue(File, "minimum_stage_time")) 
		elseif (!IsAggressor && JsonUtil.GetIntValue(File, "condition_consensual_orgasm") == false) || (IsAggressor && JsonUtil.GetIntValue(File, "condition_aggressor_orgasm") == false) && controller.ActorCount == 2
			controller.AdvanceStage()
			controller.SetLastStageSkip(Utility.GetCurrentRealTime() + JsonUtil.GetIntValue(File, "minimum_stage_time")) 
		elseif ((controller.ActorAlias(GetTargetActor()) as sslActorAlias).GetOrgasmCount()) > OrgasmCounted && controller.ActorCount <= 2 || controller.ActorCount > 2 && ((controller.ActorAlias(GetTargetActor()) as sslActorAlias).GetOrgasmCount()) > OrgasmCounted /( controller.ActorCount - 1)
			OrgasmCounted += 1
			controller.AdvanceStage(controller.Animation.StageCount)
			if IsAggressor && controller.ActorAlias(GetTargetActor()).GetTemperMult() > 1 && !controller.ActorAlias(PartnerReference).GetMentallyBrokenState() && !controller.ActorAlias(GetTargetActor()).GetMentallyBrokenState()
				AggressiveMentalBreak(PartnerReference)
			endif
			MentalBreak(GetTargetActor())
			sexlab.Log(((controller.ActorAlias(GetTargetActor()) as sslActorAlias).GetOrgasmCount()) + " out of " + controller.Get_minimum_aggressor_orgasm_Count() + " orgasm required ")
			controller.SetLastStageSkip(Utility.GetCurrentRealTime() + JsonUtil.GetIntValue(File, "minimum_stage_time")) 
		EndIf
	EndIf
	
	;SexLab.Log(" SLSO GAME(): " + (game.GetRealHoursPassed()-bench)*60*60 )
EndFunction

Function ModEnjoyment(Actor PartnerRef, float mod, float FullEnjoymentMOD)
;with skills 3+ always raise enjoyment
;with skills 3- upto 30 chance to decrease enjoyment
	GetTargetActor().DamageActorValue("Stamina", GetTargetActor().GetBaseActorValue("Stamina")/(10+mod+FullEnjoymentMOD))
	if PartnerRef != none
		if mod < 3 && Utility.RandomInt(0, 100) < (3 - mod) * 10 && JsonUtil.GetIntValue(File, "game_enjoyment_reduction_chance") == 1
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
	;damage actor magicka/mental break
	if PartnerRef != none
		int damageValue = 0
		if controller.Positions.Find(partnerRef) == 0 && JsonUtil.GetIntValue(File, "slso_schlong_size_mind_break")
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
			;1% * (base dmg(10) + own skill(0-6) + partner lewdness(-6+6)) * partner enjoyment% * orgasms(1+)
			;PartnerRef.DamageActorValue("Magicka", \
			;	PartnerRef.GetBaseActorValue("Magicka")*0.01\
			;		*(10-GetModSelfSta+GetMod("Magicka",PartnerRef)*0.01)\
			;		*(controller.ActorAlias(PartnerRef) as sslActorAlias).GetFullEnjoyment()*0.01\
			;		*(1+(controller.ActorAlias(PartnerRef) as sslActorAlias).GetOrgasmCount()))
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
			damageValue = math.Ceiling(damageValue * (JsonUtil.GetFloatValue(File, "mental_damage_tweak") as float))
		else
			damageValue = math.Ceiling(damageValue * (JsonUtil.GetFloatValue(File, "mental_damage_tweak_player") as float))
		endif
		PartnerRef.DamageActorValue("Magicka",damageValue)
		if partnerRef != GetTargetActor() && damageValue > 0
			controller.ActorAlias(PartnerRef).SetLastMentalDamage(damageValue)
			controller.ActorAlias(PartnerRef).SetLastMentalDamageTime(Utility.GetCurrentRealTime() + 0.5)
		endif
		
	endif
EndFunction

Function AggressiveMentalBreak(Actor PartnerRef)
	;damage actor magicka/mental break based on health
	;may damage health 
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
			damageValue = math.Ceiling(damageValue * (JsonUtil.GetFloatValue(File, "mental_damage_tweak") as float))
		else
			damageValue = math.Ceiling(damageValue * (JsonUtil.GetFloatValue(File, "mental_damage_tweak_player") as float))
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
	;SexLab.Log("SLSO is victim: " + GetTargetActor().GetDisplayName() +" " + IsVictim)
	;SexLab.Log("SLSO partner pre: " + PartnerReference.GetDisplayName())
	if controller.ActorCount > 1
		if partnerid < 0
			;SexLab.Log("Change_Partner initial setup " + partnerid)
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
			;SexLab.Log("Change_Partner change partner " + PartnerReference1.GetDisplayName())
			if PartnerReference1 == none || PartnerReference1 == PartnerReference || PartnerReference1 == GetTargetActor() || PartnerReference1 == Game.GetPlayer()
				return
			endif
			PartnerReference = PartnerReference1
			;SexLab.Log("Change_Partner partner changed to: " + PartnerReference.GetDisplayName() + " pos (" + partnerid + ")")
			if controller.ActorAlias(GetTargetActor()).GetActorRef() == Game.GetPlayer()
				SexLab.Log("SLSO " + GetTargetActor().GetDisplayName() + " changed focus to " + PartnerReference.GetDisplayName())
				Debug.Notification(GetTargetActor().GetDisplayName() + " changed partner to " + PartnerReference.GetDisplayName())
			endif
		endif
		;SexLab.Log("Change_Partner partner set to: " + PartnerReference.GetDisplayName() + " pos (" + partnerid + ")")
		GetModPartSta = GetMod("Stamina", PartnerReference)
		GetModPartMag = GetMod("Magicka", PartnerReference) 
		int handle = ModEvent.Create("SLSO_Change_Partner")
		if (handle)
			ModEvent.PushForm(handle, PartnerReference)
			ModEvent.Send(handle)
		endif
	endif
	;SexLab.Log("SLSO partner post: " + PartnerReference.GetDisplayName())
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

;----------------------------------------------------------------------------
;DD events
;----------------------------------------------------------------------------
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
			If JsonUtil.GetIntValue(File, "hotkey_pausegame") == keyCode && Input.IsKeyPressed(JsonUtil.GetIntValue(File, "hotkey_utility"))
				if PauseGame
					PauseGame = false
					Debug.Notification("SLSO game paused: " + PauseGame)
				else
					PauseGame = true
					Debug.Notification("SLSO game paused: " + PauseGame)
				endif
			ElseIf JsonUtil.GetIntValue(File, "game_enabled") == 1
				;Debug.Notification("SLSO OnKeyDown : " + keyCode)
				If JsonUtil.GetIntValue(File, "hotkey_bonusenjoyment") == keyCode
					Game("Stamina")
;				ElseIf JsonUtil.GetIntValue(File, "hotkey_orgasm") == keyCode
;					if Input.IsKeyPressed(JsonUtil.GetIntValue(File, "hotkey_utility"))
;						controller.ActorAlias(GetTargetActor()).Orgasm(0)		;normal orgasm, >90 enjoyment
;					endif
;				ElseIf JsonUtil.GetIntValue(File, "hotkey_orgasm") == keyCode
;					if Input.IsKeyPressed(JsonUtil.GetIntValue(File, "hotkey_utility"))
;						controller.ActorAlias(GetTargetActor()).Orgasm(-2)		;forced orgasm, skip slso checks
;					endif
				ElseIf JsonUtil.GetIntValue(File, "hotkey_edge") == keyCode
					Game("Magicka")
				ElseIf JsonUtil.GetIntValue(File, "hotkey_resist") == keyCode
					Game("Resolve")
				ElseIf JsonUtil.GetIntValue(File, "hotkey_display_mode") == keyCode
					Change_Display()
				ElseIf Input.IsKeyPressed(JsonUtil.GetIntValue(File, "hotkey_utility"))
					;If !IsVictim
						If JsonUtil.GetIntValue(File, "hotkey_select_actor_1") == keyCode
							Change_Partner(1)
						ElseIf JsonUtil.GetIntValue(File, "hotkey_select_actor_2") == keyCode
							Change_Partner(2)
						ElseIf JsonUtil.GetIntValue(File, "hotkey_select_actor_3") == keyCode
							Change_Partner(3)
						ElseIf JsonUtil.GetIntValue(File, "hotkey_select_actor_4") == keyCode
							Change_Partner(4)
						ElseIf JsonUtil.GetIntValue(File, "hotkey_select_actor_5") == keyCode
							Change_Partner(5)
						EndIf
					;EndIf
				EndIf
			EndIf
		EndIf
	EndIf
EndEvent

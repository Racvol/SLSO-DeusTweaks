Scriptname SLSO_SpellVoiceScript extends activemagiceffect
{Optimized SLSO Voice Script - DeltaTime, cached JSON, no PlayAndWait (safely)}

SexLabFramework Property SexLab auto
sslThreadController Property controller auto

String Property File auto
Bool Property IsVictim auto
Bool Property IsPlayer auto
Bool Property IsSilent auto
Bool Property IsFemale auto
Int Property Voice auto
FormList Property SoundContainer auto

; DeltaTime tracking
Float Property fLastUpdateTime auto hidden

; Cached JSON config
Int Property iConfigPainSwitch auto hidden
Int Property iConfigEnjoymentBased auto hidden
Bool Property bConfigPlayAndWait auto hidden
Bool Property bConfigUseLipSync auto hidden

Event OnEffectStart( Actor akTarget, Actor akCaster )
	IsPlayer = akTarget == Game.GetPlayer()
	File = "/SLSO/Config.json"
	
	; Cache JSON config once
	iConfigPainSwitch = JsonUtil.GetIntValue(File, "sl_voice_painswitch")
	iConfigEnjoymentBased = JsonUtil.GetIntValue(File, "sl_voice_enjoymentbased")
	bConfigPlayAndWait = JsonUtil.GetIntValue(File, "sl_voice_playandwait") as Bool
	
	if ((JsonUtil.GetIntValue(File, "sl_voice_player") != 0 && IsPlayer) || (JsonUtil.GetIntValue(File, "sl_voice_npc") != 0 && !IsPlayer))
		SexLab = Quest.GetQuest("SexLabQuestFramework") as SexLabFramework
		bConfigUseLipSync = SexLab.Config.UseLipSync
		RegisterForModEvent("SLSO_Start_widget", "Start_widget")
		RegisterForModEvent("AnimationEnd", "OnSexLabEnd")
	else
		Remove()
	endif
EndEvent

Event Start_widget(Int Widget_Id, Int Thread_Id)
	UnregisterForModEvent("SLSO_Start_widget")

	controller = SexLab.GetController(Thread_Id)
	
	IsVictim = controller.IsVictim(GetTargetActor())
	IsSilent = controller.ActorAlias(GetTargetActor()).IsSilent()
	IsFemale = controller.ActorAlias(GetTargetActor()).GetGender() == 1

	if IsFemale
		Voice = 0
		; Fix for uninitialized properties: fall back to direct file lookup safely
		FormList masterList = Game.GetFormFromFile(0x535D, "SLSO.esp") as FormList
		if masterList
			SoundContainer = masterList.GetAt(1) as formlist
		endif
		
		if SoundContainer && SoundContainer.GetSize() > 0
			if IsPlayer
				Voice = JsonUtil.GetIntValue(File, "sl_voice_player")
			elseif JsonUtil.GetIntValue(File, "sl_voice_npc") == -2 && SoundContainer.GetSize() > 0
				Voice = Utility.RandomInt(1, (SoundContainer.GetSize()))
			elseif JsonUtil.GetIntValue(File, "sl_voice_npc") == -1 && SoundContainer.GetSize() > 1
				while Voice < 1 || Voice == JsonUtil.GetIntValue(File, "sl_voice_player")
					Voice = Utility.RandomInt(1, (SoundContainer.GetSize()))
				endwhile
			elseif JsonUtil.GetIntValue(File, "sl_voice_npc") > 0
				Voice = JsonUtil.GetIntValue(File, "sl_voice_npc")
			endif
		else
			JsonUtil.SetIntValue(File, "sl_voice_player", 0)
			JsonUtil.SetIntValue(File, "sl_voice_npc", 0)
			Voice = 0
		endif
		
		if Voice > 0
			SoundContainer = SoundContainer.GetAt(Voice - 1) as formlist
		else
			SoundContainer = none
		endif
	else
		Voice = 0
		SoundContainer = none
	endif

	fLastUpdateTime = Utility.GetCurrentRealTime()
	RegisterForSingleUpdate(0.5)
EndEvent

Event OnSexLabEnd(string EventName, string argString, Float argNum, form sender)
	if controller == SexLab.GetController(argString as int)
		Remove()
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
			if !IsSilent && IsFemale
				if Voice > 0 && SoundContainer != none
					
					sound mySFX
					Int RawFullEnjoyment = controller.ActorAlias(Target).GetFullEnjoyment()
					Int FullEnjoyment = PapyrusUtil.ClampInt(RawFullEnjoyment/10, 0, 10) + 1
						
					if FullEnjoyment > 9
						mySFX = (SoundContainer.GetAt(1) As formlist).GetAt(0) As Sound
					elseif IsVictim && FullEnjoyment < iConfigPainSwitch
						mySFX = (SoundContainer.GetAt(2) As formlist).GetAt(0) As Sound
					else
						if (SoundContainer.GetAt(0) As formlist).GetSize() != 10 || iConfigEnjoymentBased != 1
							FullEnjoyment = 0
						endif
						mySFX = (SoundContainer.GetAt(0) As formlist).GetAt(FullEnjoyment) As Sound
					endif
					
					if mySFX
						; 1. Открываем рот
						if bConfigUseLipSync
							sslBaseVoice.TransitUp(Target, 0, 50)
						endif

						; 2. Играем звук (асинхронно)
						mySFX.Play(Target)
						
						; 3. Ждем и закрываем рот
						if bConfigUseLipSync
							Utility.Wait(Utility.RandomFloat(1.5, 3.0))
							; ВАЖНО: Проверка валидности после паузы
							if Target && Target.Is3DLoaded()
								sslBaseVoice.TransitDown(Target, 0, 50)
							endif
						endif
					endif
					
					controller.ActorAlias(Target).RefreshExpression()
					
					; 4. Случайная пауза перед следующим стоном
					RegisterForSingleUpdate(Utility.RandomFloat(2.0, 5.0))
					return
				endif
			endif
		endif
	endif
	Remove()
EndEvent

Event OnPlayerLoadGame()
	Remove()
EndEvent

Event OnEffectFinish( Actor akTarget, Actor akCaster )
EndEvent

function Remove()
	If GetTargetActor() != none
		UnRegisterForUpdate()
		UnregisterForAllModEvents()
		UnregisterForAllKeys()
		SLSO_MCM SLSO = Quest.GetQuest("SLSO") as SLSO_MCM
		If GetTargetActor().HasSpell(SLSO.SLSO_SpellVoice)
			GetTargetActor().RemoveSpell(SLSO.SLSO_SpellVoice)
		EndIf
	EndIf
endFunction
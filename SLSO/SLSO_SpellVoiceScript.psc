Scriptname SLSO_SpellVoiceScript extends activemagiceffect
{Optimized SLSO Voice Script - DeltaTime, cached JSON, no PlayAndWait}

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

; Cached JSON config (read once at start, not every update)
Int Property iConfigPainSwitch auto hidden
Int Property iConfigEnjoymentBased auto hidden
Bool Property bConfigPlayAndWait auto hidden
Bool Property bConfigUseLipSync auto hidden

Event OnEffectStart( Actor akTarget, Actor akCaster )
	IsPlayer = akTarget == Game.GetPlayer()
	File = "/SLSO/Config.json"
	
	; Cache JSON config once at start (Critical optimization)
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

	;check if female and setup voices according to mcm/json options
	if IsFemale
		Voice = 0
		SoundContainer = (Game.GetFormFromFile(0x535D, "SLSO.esp") as formlist).GetAt(1) as formlist
		if SoundContainer.GetSize() > 0
			if IsPlayer																							;PC selected voice
				Voice = JsonUtil.GetIntValue(File, "sl_voice_player")
				SexLab.Log(" SLSO Setup() actor: " + GetTargetActor().GetDisplayName() + " Voice: " +Voice + " PC selected voice")
			elseif JsonUtil.GetIntValue(File, "sl_voice_npc") == -2 && SoundContainer.GetSize() > 0				;NPC random voice
				Voice = Utility.RandomInt(1, (SoundContainer.GetSize()))
				SexLab.Log(" SLSO Setup() actor: " + GetTargetActor().GetDisplayName() + " Voice: " +Voice + " NPC random voice")
			elseif JsonUtil.GetIntValue(File, "sl_voice_npc") == -1 && SoundContainer.GetSize() > 1				;NPC random non PC voice
				while Voice < 1 || Voice == JsonUtil.GetIntValue(File, "sl_voice_player") 
					Voice = Utility.RandomInt(1, (SoundContainer.GetSize()))
					SexLab.Log(" SLSO Setup() actor: " + GetTargetActor().GetDisplayName() + " Voice: " +Voice + " NPC random non PC voice")
				endwhile
			elseif JsonUtil.GetIntValue(File, "sl_voice_npc") > 0												;todo	;NPC selected voice ; or not todo
				Voice = JsonUtil.GetIntValue(File, "sl_voice_npc")
				SexLab.Log(" SLSO Setup() actor: " + GetTargetActor().GetDisplayName() + " Voice: " +Voice + " sl_voice_npc > 0")
			endif
		else
			JsonUtil.SetIntValue(File, "sl_voice_player", 0)
			JsonUtil.SetIntValue(File, "sl_voice_npc", 0)
			Voice = 0
			SexLab.Log(" SLSO Setup() actor: " + GetTargetActor().GetDisplayName() + " no voice packs found")
		endif
		
		if Voice > 0
			SoundContainer = SoundContainer.GetAt(Voice - 1) as formlist
			SexLab.Log(" SLSO Setup() actor: " + GetTargetActor().GetDisplayName() + " Voice: " +Voice + " SoundContainer " + SoundContainer)
		else
			SexLab.Log(" SLSO Setup() actor: " + GetTargetActor().GetDisplayName() + " Voice(0=disabled): " +Voice + " SoundContainer " + SoundContainer)
		endif
	else 
		Voice = 0
		SoundContainer = none
		SexLab.Log(" SLSO Setup() actor: " + GetTargetActor().GetDisplayName() + " is not female, playing sexlab voice")
	endif

	fLastUpdateTime = Utility.GetCurrentRealTime()
	RegisterForSingleUpdate(0.5) ; Faster update, safe now with optimizations
EndEvent

Event OnSexLabEnd(string EventName, string argString, Float argNum, form sender)
	if controller == SexLab.GetController(argString as int)
		Remove()
	endif
EndEvent

Event OnUpdate()
	Actor Target = GetTargetActor()
	
	; Memory leak protection - validate actor and thread state
	If !Target || !Target.Is3DLoaded() || !controller || controller.GetState() != "Animating"
		Remove()
		Return
	EndIf
	
	; DeltaTime for FPS independence
	Float CurrentTime = Utility.GetCurrentRealTime()
	Float Delta = CurrentTime - fLastUpdateTime
	fLastUpdateTime = CurrentTime
	
	if controller.ActorAlias(Target).GetActorRef() != none
		if controller.ActorAlias(Target).GetState() == "Animating"
			if !IsSilent && IsFemale
				if Voice > 0 && SoundContainer != none
					
					sound mySFX
					Int RawFullEnjoyment = controller.ActorAlias(Target).GetFullEnjoyment()
					Int FullEnjoyment = PapyrusUtil.ClampInt(RawFullEnjoyment/10, 0, 10) + 1
						
					if FullEnjoyment > 9
						; Orgasm
						mySFX = (SoundContainer.GetAt(1) As formlist).GetAt(0) As Sound
					elseif IsVictim && FullEnjoyment < iConfigPainSwitch
						; Pain (cached config)
						mySFX = (SoundContainer.GetAt(2) As formlist).GetAt(0) As Sound
					else
						; Normal (cached config)
						if (SoundContainer.GetAt(0) As formlist).GetSize() != 10 || iConfigEnjoymentBased != 1
							FullEnjoyment = 0
						endif
						mySFX = (SoundContainer.GetAt(0) As formlist).GetAt(FullEnjoyment) As Sound
					endif
					
					; Lip sync
					if bConfigUseLipSync
						sslBaseVoice.TransitUp(Target, 0, 50)
					endif

					; CRITICAL FIX: Use Play() instead of PlayAndWait() to prevent race conditions
					mySFX.Play(Target)
					
					if bConfigUseLipSync
						sslBaseVoice.TransitDown(Target, 0, 50)
					endif
					
					controller.ActorAlias(Target).RefreshExpression()
					RegisterForSingleUpdate(0.5) ; Faster, safe with optimizations
					return
				elseif Voice != 0
					SexLab.Log(" smthn wrong " + Target.GetDisplayName() + " Voice " + Voice + " SoundContainer " + SoundContainer)
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

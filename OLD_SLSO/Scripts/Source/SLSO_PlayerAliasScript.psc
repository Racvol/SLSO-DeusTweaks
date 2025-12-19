scriptname SLSO_PlayerAliasScript extends ReferenceAlias
{SLSO_PlayerAliasScript script - Optimized with cached FormLists and Hotkeys}

int Player_orgasms_count
int Player_bonusenjoyment
String File

; Cached FormLists
FormList SLSO_VoicePacksContainer
FormList SLSO_VoicePacksNamesContainer
FormList SLSO_VictimVoicePacksContainer
FormList SLSO_VictimVoicePacksNamesContainer

FormList _normalVoices
FormList _normalVoiceNames
FormList _victimVoices
FormList _victimVoiceNames

; КЭШИРОВАНИЕ КЛАВИШ (Критично для OnKeyDown)
Int iKey_Widget = -1
Int iKey_Utility = -1

;=============================================================
;INIT
;=============================================================

Event OnInit()
	Maintenance()
EndEvent

Event OnPlayerLoadGame()
	Maintenance()
EndEvent

function Maintenance()
	File = "/SLSO/Config.json"
	if JsonUtil.GetErrors(File) != ""
		Debug.Messagebox("SLSO Json has errors, mod wont work")
		return
	endif
	
	; 1. Безопасная инициализация (Fallback)
	if !SLSO_VoicePacksContainer
		SLSO_VoicePacksContainer = Game.GetFormFromFile(0x535D, "SLSO.esp") as FormList
	endif
	if !SLSO_VoicePacksNamesContainer
		SLSO_VoicePacksNamesContainer = Game.GetFormFromFile(0x63A3, "SLSO.esp") as FormList
	endif
	if !SLSO_VictimVoicePacksContainer
		SLSO_VictimVoicePacksContainer = Game.GetFormFromFile(0x7935, "SLSO.esp") as FormList
	endif
	if !SLSO_VictimVoicePacksNamesContainer
		SLSO_VictimVoicePacksNamesContainer = Game.GetFormFromFile(0x7938, "SLSO.esp") as FormList
	endif
	
	; 2. Кэширование вложенных списков
	if !_normalVoices && SLSO_VoicePacksContainer
		_normalVoices = SLSO_VoicePacksContainer.GetAt(1) as FormList
	endif
	if !_normalVoiceNames && SLSO_VoicePacksNamesContainer
		_normalVoiceNames = SLSO_VoicePacksNamesContainer.GetAt(1) as FormList
	endif
	if !_victimVoices && SLSO_VictimVoicePacksContainer
		_victimVoices = SLSO_VictimVoicePacksContainer.GetAt(1) as FormList
	endif
	if !_victimVoiceNames && SLSO_VictimVoicePacksNamesContainer
		_victimVoiceNames = SLSO_VictimVoicePacksNamesContainer.GetAt(1) as FormList
	endif
	
	; register events
	self.RegisterForModEvent("SexLabOrgasmSeparate", "Orgasm")
	self.RegisterForModEvent("AnimationStart", "OnSexLabStart")
	self.RegisterForModEvent("AnimationEnd", "OnSexLabEnd")
	self.RegisterForSingleUpdateGameTime(1)
	
	; 3. Загружаем коды клавиш в переменные (Оптимизация)
	iKey_Widget = JsonUtil.GetIntValue(File, "hotkey_widget")
	iKey_Utility = JsonUtil.GetIntValue(File, "hotkey_utility")
	RegisterKey(iKey_Widget)
	
	Clear()
	
	; Проверка и сброс голосов
	if _normalVoices && _normalVoices.GetSize() > 0
		int i = 0
		while i < _normalVoices.GetSize()
			if _normalVoices.GetAt(i) == none
				_normalVoices.Revert()
				if _normalVoiceNames
					_normalVoiceNames.Revert()
				endif
				JsonUtil.SetIntValue(File, "sl_voice_player", 0)
				JsonUtil.SetIntValue(File, "sl_voice_npc", 0)
				return
			endif
		i = i + 1
		endwhile
	endif
	
	if _victimVoices && _victimVoices.GetSize() > 0
		int i = 0
		while i < _victimVoices.GetSize()
			if _victimVoices.GetAt(i) == none
				_victimVoices.Revert()
				if _victimVoiceNames
					_victimVoiceNames.Revert()
				endif
				return
			endif
		i = i + 1
		endwhile
	endif
	
endFunction

function Clear()
	int i = 1
	SLSO_MCM SLSO = self.GetOwningQuest() as SLSO_MCM
	while i <= 5
		(self.GetOwningQuest().GetAlias(i)).RegisterForModEvent("SLSO_Stop_widget", "Stop_widget")
		int handle = ModEvent.Create("SLSO_Stop_widget")
		if (handle)
			ModEvent.PushInt(handle, i)
			ModEvent.Send(handle)
		endif
		i += 1
	endwhile
endFunction

Event Orgasm(Form ActorRef, Int Thread)
	if (ActorRef as actor) == Game.GetPlayer()
		Player_orgasms_count = (self.GetOwningQuest() as SLSO_MCM).SexLab.GetController(Thread).ActorAlias(ActorRef as actor).GetOrgasmCount()
		self.RegisterForSingleUpdateGameTime(1)
	endif
EndEvent

Event OnUpdateGameTime()
	Player_orgasms_count = 0
	Player_bonusenjoyment = 0
EndEvent

;----------------------------------------------------------------------------
;SexLab hooks
;----------------------------------------------------------------------------

Event OnSexLabStart(string EventName, string argString, Float argNum, form sender)
	sslThreadController controller = (self.GetOwningQuest() as SLSO_MCM).SexLab.GetController(argString as int)

	int i = 0
	if controller.HasPlayer
		while i < controller.ActorAlias.Length
			if controller.ActorAlias[i].GetActorRef() != none
				if controller.ActorAlias[i].GetActorRef() == Game.GetPlayer()
					(controller.ActorAlias(Game.GetPlayer()) as sslActorAlias).SetOrgasmCount(Player_orgasms_count)
				endif
				
				(self.GetOwningQuest().GetAlias(i+1) as ReferenceAlias).ForceRefTo(controller.ActorAlias[i].GetActorRef())
				(self.GetOwningQuest().GetAlias(i+1)).RegisterForModEvent("SLSO_Start_widget", "Start_widget")
			endif
			i += 1
		endwhile
		i = 0
	endif
	
	while i < controller.ActorAlias.Length
		if controller.ActorAlias[i].GetActorRef() != none
			controller.ActorAlias[i].GetActorRef().RemoveSpell((self.GetOwningQuest() as SLSO_MCM).SLSO_SpellAnimSync)
			controller.ActorAlias[i].GetActorRef().RemoveSpell((self.GetOwningQuest() as SLSO_MCM).SLSO_SpellVoice)
			controller.ActorAlias[i].GetActorRef().RemoveSpell((self.GetOwningQuest() as SLSO_MCM).SLSO_SpellGame)
			
			controller.ActorAlias[i].GetActorRef().AddSpell((self.GetOwningQuest() as SLSO_MCM).SLSO_SpellAnimSync, false)
			controller.ActorAlias[i].GetActorRef().AddSpell((self.GetOwningQuest() as SLSO_MCM).SLSO_SpellVoice, false)
			controller.ActorAlias[i].GetActorRef().AddSpell((self.GetOwningQuest() as SLSO_MCM).SLSO_SpellGame, false)
			
			utility.wait(1)
			
			int handle = ModEvent.Create("SLSO_start_widget")
			if (handle)
				ModEvent.PushInt(handle, i+1)
				ModEvent.PushInt(handle, argString as int)
				ModEvent.Send(handle)
			endif
		endif
		i += 1
	endwhile
EndEvent

Event OnSexLabEnd(string EventName, string argString, Float argNum, form sender)
	sslThreadController controller = (self.GetOwningQuest() as SLSO_MCM).SexLab.GetController(argString as int)

	if controller.HasPlayer
		self.RegisterForSingleUpdateGameTime(1)
		Clear()
	endif
EndEvent


Function RegisterKey(int RKey = 0)
	If (RKey != 0)
		self.RegisterForKey(RKey)
	EndIf
EndFunction

Event OnKeyDown(int keyCode)
	If !Utility.IsInMenuMode()
		; ИСПОЛЬЗУЕМ КЭШИРОВАННЫЕ ПЕРЕМЕННЫЕ (вместо JsonUtil)
		If iKey_Widget == keyCode && Input.IsKeyPressed(iKey_Utility)
			If JsonUtil.GetIntValue(File, "widget_enabled") == 1
				JsonUtil.SetIntValue(File, "widget_enabled", 0)
				(self.GetOwningQuest().GetAlias(1) as SLSO_Widget1Update).HideWidget()
				(self.GetOwningQuest().GetAlias(2) as SLSO_Widget2Update).HideWidget()
				(self.GetOwningQuest().GetAlias(3) as SLSO_Widget3Update).HideWidget()
				(self.GetOwningQuest().GetAlias(4) as SLSO_Widget4Update).HideWidget()
				(self.GetOwningQuest().GetAlias(5) as SLSO_Widget5Update).HideWidget()
			Else
				JsonUtil.SetIntValue(File, "widget_enabled", 1)
			EndIf
		EndIf
	EndIf
EndEvent
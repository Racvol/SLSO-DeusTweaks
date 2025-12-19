Scriptname SLSO_MCM extends SKI_ConfigBase

SLSO_Config Property Config Auto
String File = "/SLSO/Config.json"

; =============================================================
; Вспомогательные функции (Helpers)
; =============================================================

Function ToggleJsonInt(string sKey)
    int val = JsonUtil.GetIntValue(File, sKey, 0)
    if val == 1
        val = 0
    else
        val = 1
    endif
    JsonUtil.SetIntValue(File, sKey, val)
    SetToggleOptionValueST(val)
EndFunction

String Function GetVictimStateStr(string sKey)
    int val = JsonUtil.GetIntValue(File, sKey, 0)
    if val == 0
        return "$condition_victim_orgasm_s0"
    elseif val == 1
        return "$condition_victim_orgasm_s1"
    elseif val == 2
        return "$condition_victim_orgasm_s2"
    elseif val == 3
        return "$condition_victim_orgasm_s3"
    endif
    return "$condition_victim_orgasm_s4"
EndFunction

String Function GetAnimSpeedState()
    int val = JsonUtil.GetIntValue(File, "game_anim_speed_mode", 0)
    if val == 1
        return "$game_animation_speed_control_s1"
    elseif val == 2
        return "$game_animation_speed_control_s2"
    endif
    return "$game_animation_speed_control_s0"
EndFunction

String Function GetAnimSyncState()
    int val = JsonUtil.GetIntValue(File, "game_anim_sync", 0)
    if val == 1
        return "$game_animation_speed_control_actorsync_s1"
    elseif val == 2
        return "$game_animation_speed_control_actorsync_s2"
    endif
    return "$game_animation_speed_control_actorsync_s0"
EndFunction

String Function GetExhibitionistState()
    int val = JsonUtil.GetIntValue(File, "sl_exhibitionist", 0)
    if val == 1
        return "$sl_exhibitionist_s1"
    elseif val == 2
        return "$sl_exhibitionist_s2"
    endif
    return "$sl_exhibitionist_s0"
EndFunction

Function MapKey(string sKey, int keyCode, string conflictControl, string conflictName)
    if conflictControl != ""
        string msg = "Клавиша уже занята:\n'" + conflictControl + "'\n\nПродолжить?"
        if !ShowMessage(msg, true, "Да", "Нет")
            return
        endif
    endif
    JsonUtil.SetIntValue(File, sKey, keyCode)
    SetKeyMapOptionValueST(keyCode)
EndFunction

; =============================================================
; Управление страницами
; =============================================================

Event OnConfigInit()
    ModName = "SL Separate Orgasms"
    Pages = new string[4]
    Pages[0] = "$page1"
    Pages[1] = "$page2"
    Pages[2] = "$page3"
    Pages[3] = "$page4"
EndEvent

Event OnConfigClose()
    Config.LoadSettings()
EndEvent

Event OnPageReset(string page)
    SetCursorFillMode(TOP_TO_BOTTOM)
    if page == "" || page == "$page1"
        DrawLogicPage()
    elseif page == "$page2"
        DrawGamePage()
    elseif page == "$page3"
        DrawUIPage()
    elseif page == "$page4"
        DrawSoundPage()
    endif
EndEvent

; =============================================================
; PAGE 1: LOGIC
; =============================================================

Function DrawLogicPage()
    AddHeaderOption("$Config_Orgasm_event_configuration_Header_1")
    AddToggleOptionST("cond_leadin", "$condition_leadin_orgasm", JsonUtil.GetIntValue(File, "cond_leadin"))
    AddToggleOptionST("cond_female", "$condition_female_orgasm", JsonUtil.GetIntValue(File, "cond_female"))
    AddToggleOptionST("cond_male", "$condition_male_orgasm", JsonUtil.GetIntValue(File, "cond_male"))
    AddToggleOptionST("cond_futa", "$condition_futa_orgasm", JsonUtil.GetIntValue(File, "cond_futa"))
    
    AddHeaderOption("$header_victim_rules")
    AddTextOptionST("cond_victim_mode", "$condition_victim_orgasm", GetVictimStateStr("cond_victim_mode"))
    AddTextOptionST("cond_victim_arousal", "$condition_victim_arousal", GetVictimStateStr("cond_victim_arousal"))
EndFunction

; =============================================================
; PAGE 2: GAMEPLAY
; =============================================================

Function DrawGamePage()
    AddHeaderOption("$Config_Game_Header_3")
    AddToggleOptionST("game_pc", "$slso_game", JsonUtil.GetIntValue(File, "game_pc"))
    AddToggleOptionST("game_npc", "$slso_game_npc", JsonUtil.GetIntValue(File, "game_npc"))
    AddToggleOptionST("game_autopilot_pc", "$game_player_autoplay", JsonUtil.GetIntValue(File, "game_autopilot_pc"))
    
    AddHeaderOption("$game_animation_speed_control")
    AddTextOptionST("game_anim_speed_mode", "$game_animation_speed_control", GetAnimSpeedState())
    AddTextOptionST("game_anim_sync", "$game_animation_speed_control_actorsync", GetAnimSyncState())
EndFunction

; =============================================================
; PAGE 3: UI (TrueHUD & SkyUI)
; =============================================================

Function DrawUIPage()
    AddHeaderOption("TrueHUD (Динамические полоски)")
    AddToggleOptionST("ui_truehud", "$ui_truehud_enabled", JsonUtil.GetIntValue(File, "ui_truehud", 1))
    AddTextOption("$ui_truehud_desc", "", OPTION_FLAG_DISABLED)

    AddEmptyOption()
    
    AddHeaderOption("SkyUI Widget (Для игрока)")
    AddToggleOptionST("ui_skyui_enabled", "$widget_skyui_player_enabled", JsonUtil.GetIntValue(File, "ui_skyui_enabled", 1))
    AddSliderOptionST("ui_skyui_x", "$Position_X", JsonUtil.GetFloatValue(File, "ui_skyui_x", 495.0))
    AddSliderOptionST("ui_skyui_y", "$Position_Y", JsonUtil.GetFloatValue(File, "ui_skyui_y", 680.0))

    SetCursorPosition(1)
    AddHeaderOption("$Enjoyment_Colours_Header")
    int i = 0
    while i < 6
        AddColorOptionST("color_" + i, "$color_" + i, JsonUtil.GetIntValue(File, "color_" + i))
        i += 1
    endwhile
EndFunction

Function DrawSoundPage()
    AddHeaderOption("$Sound_System_VoicePacks_Selection_Header")
    AddToggleOptionST("sl_voice_joy", "$sl_voice_enjoymentbased", JsonUtil.GetIntValue(File, "sl_voice_joy"))
EndFunction

; =============================================================
; STATES (ОБРАБОТКА КЛИКОВ)
; =============================================================

State ui_truehud
    Event OnSelectST()
        ToggleJsonInt("ui_truehud")
    EndEvent
EndState

State ui_skyui_enabled
    Event OnSelectST()
        ToggleJsonInt("ui_skyui_enabled")
    EndEvent
EndState

State ui_skyui_x
    Event OnSliderOpenST()
        SetSliderDialogStartValue(JsonUtil.GetFloatValue(File, "ui_skyui_x"))
        SetSliderDialogRange(0, 1280)
        SetSliderDialogInterval(1)
    EndEvent
    Event OnSliderAcceptST(float value)
        JsonUtil.SetFloatValue(File, "ui_skyui_x", value)
        SetSliderOptionValueST(value)
    EndEvent
EndState

State cond_victim_mode
    Event OnSelectST()
        int val = JsonUtil.GetIntValue(File, "cond_victim_mode") + 1
        if val > 4
            val = 0
        endif
        JsonUtil.SetIntValue(File, "cond_victim_mode", val)
        SetTextOptionValueST(GetVictimStateStr("cond_victim_mode"))
    EndEvent
EndState

; ... States для цветов (color_0...color_5) ...
State color_0
    Event OnColorOpenST()
        SetColorDialogStartColor(JsonUtil.GetIntValue(File, "color_0"))
    EndEvent
    Event OnColorAcceptST(int color)
        JsonUtil.SetIntValue(File, "color_0", color)
        SetColorOptionValueST(color)
    EndEvent
EndState

State color_1
    Event OnColorOpenST()
        SetColorDialogStartColor(JsonUtil.GetIntValue(File, "color_1"))
    EndEvent
    Event OnColorAcceptST(int color)
        JsonUtil.SetIntValue(File, "color_1", color)
        SetColorOptionValueST(color)
    EndEvent
EndState

State color_2
    Event OnColorOpenST()
        SetColorDialogStartColor(JsonUtil.GetIntValue(File, "color_2"))
    EndEvent
    Event OnColorAcceptST(int color)
        JsonUtil.SetIntValue(File, "color_2", color)
        SetColorOptionValueST(color)
    EndEvent
EndState

State color_3
    Event OnColorOpenST()
        SetColorDialogStartColor(JsonUtil.GetIntValue(File, "color_3"))
    EndEvent
    Event OnColorAcceptST(int color)
        JsonUtil.SetIntValue(File, "color_3", color)
        SetColorOptionValueST(color)
    EndEvent
EndState

State color_4
    Event OnColorOpenST()
        SetColorDialogStartColor(JsonUtil.GetIntValue(File, "color_4"))
    EndEvent
    Event OnColorAcceptST(int color)
        JsonUtil.SetIntValue(File, "color_4", color)
        SetColorOptionValueST(color)
    EndEvent
EndState

State color_5
    Event OnColorOpenST()
        SetColorDialogStartColor(JsonUtil.GetIntValue(File, "color_5"))
    EndEvent
    Event OnColorAcceptST(int color)
        JsonUtil.SetIntValue(File, "color_5", color)
        SetColorOptionValueST(color)
    EndEvent
EndState
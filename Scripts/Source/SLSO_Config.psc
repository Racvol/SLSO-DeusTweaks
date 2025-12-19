Scriptname SLSO_Config extends Quest

String Property File = "/SLSO/Config.json" AutoReadOnly

; === КЭШ НАСТРОЕК ===

; 1. Логика оргазма
Int Property CondLeadIn Auto Hidden
Int Property CondDDBelt Auto Hidden
Int Property CondFemale Auto Hidden
Int Property CondMale Auto Hidden
Int Property CondFuta Auto Hidden
Int Property CondFemaleBonus Auto Hidden
Int Property CondMalePenalty Auto Hidden
Int Property CondConsensual Auto Hidden
Int Property CondAggressorNeed Auto Hidden
Int Property CondAggressorChange Auto Hidden
Int Property CondPCNeed Auto Hidden
Int Property CondMinAggressorOrgasms Auto Hidden
Int Property CondMaxAggressorOrgasms Auto Hidden
Int Property CondArousalConsensual Auto Hidden
Int Property CondArousalAggressor Auto Hidden
Int Property CondVictimMode Auto Hidden
Int Property CondVictimArousal Auto Hidden
Int Property CondPCAllowed Auto Hidden

; 2. Процесс (Мини-игра)
Bool Property GamePC Auto Hidden
Bool Property GameNPC Auto Hidden
Bool Property GameEdging Auto Hidden
Bool Property GameUpdateBoost Auto Hidden
Bool Property GameAutopilotPC Auto Hidden
Bool Property GameAutopilotVictim Auto Hidden
Bool Property GamePassiveJoyLoss Auto Hidden
Bool Property GameJoyLossChance Auto Hidden
Int Property GameAnimSpeedMode Auto Hidden
Int Property GameAnimSyncMode Auto Hidden
Float Property GameAnimSpeedBase Auto Hidden
Float Property GameAnimSpeedMin Auto Hidden
Float Property GameAnimSpeedMax Auto Hidden
Int Property GameJoyPriority Auto Hidden
Bool Property GameNoStaEnd Auto Hidden
Bool Property GameMaleEnd Auto Hidden
Int Property GameMinStageTime Auto Hidden
Bool Property GameHybridProgression Auto Hidden
Int Property GameHybridDelay Auto Hidden

; 3. Модификаторы
Float Property MultMentalNPC Auto Hidden
Float Property MultMentalPC Auto Hidden
Int Property MultAggressorBonus Auto Hidden
Int Property SchlongJoyBonus Auto Hidden
Int Property SchlongMediumSize Auto Hidden
Int Property SchlongOralBonus Auto Hidden
Float Property SchlongCurve Auto Hidden
Int Property SchlongMindBreak Auto Hidden
Int Property CreatureSizeBonus Auto Hidden

; 4. Интерфейс (UI)
Bool Property UI_TrueHUD Auto Hidden
Bool Property UI_SkyUI_Enabled Auto Hidden
Bool Property UI_ShowModifier Auto Hidden
Float Property UI_LabelSize Auto Hidden
Float Property UI_ValueSize Auto Hidden
Float Property UI_SkyUI_X Auto Hidden
Float Property UI_SkyUI_Y Auto Hidden
String Property UI_SkyUI_Fill Auto Hidden
Int[] Property Colors Auto Hidden

; 5. Горячие клавиши
Int Property KeyJoy Auto Hidden
Int Property KeyEdge Auto Hidden
Int Property KeyOrgasm Auto Hidden
Int Property KeyUtil Auto Hidden
Int Property KeyPause Auto Hidden
Int Property KeyWidget Auto Hidden
Int Property KeyResist Auto Hidden
Int Property KeyDisplayMode Auto Hidden
Bool Property KeyDisplayModeGlobal Auto Hidden

Event OnInit()
    Colors = new Int[6]
    LoadSettings()
EndEvent

Function LoadSettings()
    ; Логика
    CondLeadIn = JsonUtil.GetIntValue(File, "cond_leadin", 1)
    CondDDBelt = JsonUtil.GetIntValue(File, "cond_ddbelt", 0)
    CondFemale = JsonUtil.GetIntValue(File, "cond_female", 1)
    CondMale = JsonUtil.GetIntValue(File, "cond_male", 1)
    CondFuta = JsonUtil.GetIntValue(File, "cond_futa", 1)
    CondFemaleBonus = JsonUtil.GetIntValue(File, "cond_female_bonus", 1)
    CondMalePenalty = JsonUtil.GetIntValue(File, "cond_male_penalty", 1)
    CondConsensual = JsonUtil.GetIntValue(File, "cond_consensual", 1)
    CondAggressorNeed = JsonUtil.GetIntValue(File, "cond_aggressor_need", 1)
    CondPCNeed = JsonUtil.GetIntValue(File, "cond_pc_need", 0)
    CondVictimMode = JsonUtil.GetIntValue(File, "cond_victim_mode", 2)
    CondVictimArousal = JsonUtil.GetIntValue(File, "cond_victim_arousal", 2)
    CondMinAggressorOrgasms = JsonUtil.GetIntValue(File, "cond_min_agg_org", 1)
    CondMaxAggressorOrgasms = JsonUtil.GetIntValue(File, "cond_max_agg_org", 3)

    ; Процесс
    GamePC = JsonUtil.GetIntValue(File, "game_pc", 1) == 1
    GameNPC = JsonUtil.GetIntValue(File, "game_npc", 0) == 1
    GameEdging = JsonUtil.GetIntValue(File, "game_edging", 1) == 1
    GameUpdateBoost = JsonUtil.GetIntValue(File, "game_update_boost", 1) == 1
    GameAutopilotPC = JsonUtil.GetIntValue(File, "game_autopilot_pc", 0) == 1
    GameAnimSpeedMode = JsonUtil.GetIntValue(File, "game_anim_speed_mode", 1)
    GameAnimSpeedBase = JsonUtil.GetFloatValue(File, "game_anim_speed_base", 1.0)
    GameHybridProgression = JsonUtil.GetIntValue(File, "game_hybrid", 0) == 1

    ; Модификаторы
    MultMentalNPC = JsonUtil.GetFloatValue(File, "mult_mental_npc", 1.0)
    MultMentalPC = JsonUtil.GetFloatValue(File, "mult_mental_pc", 1.0)
    SchlongCurve = JsonUtil.GetFloatValue(File, "schlong_curve", 1.0)

    ; UI
    UI_TrueHUD = JsonUtil.GetIntValue(File, "ui_truehud", 1) == 1
    UI_SkyUI_Enabled = JsonUtil.GetIntValue(File, "ui_skyui_enabled", 1) == 1
    UI_SkyUI_X = JsonUtil.GetFloatValue(File, "ui_skyui_x", 495.0)
    UI_SkyUI_Y = JsonUtil.GetFloatValue(File, "ui_skyui_y", 680.0)
    UI_SkyUI_Fill = JsonUtil.GetPathStringValue(File, "ui_skyui_fill", "left")

    int i = 0
    while i < 6
        Colors[i] = JsonUtil.GetIntValue(File, "color_" + i, 0xFFFFFF)
        i += 1
    endwhile

    ; Клавиши
    KeyJoy = JsonUtil.GetIntValue(File, "key_joy", 0)
    KeyEdge = JsonUtil.GetIntValue(File, "key_edge", 0)
    KeyOrgasm = JsonUtil.GetIntValue(File, "key_orgasm", 0)
    KeyUtil = JsonUtil.GetIntValue(File, "key_util", 0)
EndFunction
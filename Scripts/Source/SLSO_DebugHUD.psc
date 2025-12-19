Scriptname SLSO_DebugHUD extends Quest

; Ссылка на нашего игрока
Actor Property PlayerRef Auto

Event OnInit()
    Debug.Notification("SLSO: HUD Debug Init")
    RegisterForSingleUpdate(3.0) ; Ждем 3 секунды после запуска, чтобы все системы подгрузились
EndEvent

Event OnPlayerLoadGame()
    RegisterForSingleUpdate(2.0)
EndEvent

Event OnUpdate()
    ; 1. Включаем бары на самом игроке (чтобы проверить вид от 3-го лица)
    EnableBarsOnActor(PlayerRef)
    
    ; 2. Пытаемся найти того, на кого смотрит игрок
    ObjectReference target = Game.GetCurrentCrosshairRef()
    if target && target as Actor
        EnableBarsOnActor(target as Actor)
        Debug.Notification("SLSO: HUD enabled on " + target.GetBaseObject().GetName())
    else
        Debug.Notification("SLSO: Look at an NPC and reload to see bars on them")
    endif
    
    ; Повторяем обновление, чтобы полоски не пропадали (TrueHUD иногда требует обновления данных)
    RegisterForSingleUpdate(5.0)
EndEvent

Function EnableBarsOnActor(Actor akActor)
    if akActor
        ; Включаем наши цветные бары через DLL
        SLSO_TrueHUD.EnableSexBars(akActor)
        
        ; Устанавливаем 3-ю полоску (Оргазм) на 70% для наглядности
        ; Параметры: Актер, Текущее значение, Максимум
        SLSO_TrueHUD.UpdateOrgasmBar(akActor, 70.0, 100.0)
    endif
EndFunction
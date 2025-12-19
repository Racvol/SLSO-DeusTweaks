Scriptname SLSO_TrueHUD Hidden

; Включает цветные бары и отображение
Function EnableSexBars(Actor akActor) Global Native

; Обновляет значение 3-й полоски (Оргазм)
; current: текущее значение (0..100)
; max: максимальное (обычно 100.0)
; Если не вызывать эту функцию, 3-я полоска не появится (вернет -1).
Function UpdateOrgasmBar(Actor akActor, float current, float max = 100.0) Global Native

; Выключает всё и сбрасывает цвета
Function DisableSexBars(Actor akActor) Global Native

; Освободить управление TrueHUD (target и special resource bars)
Function ReleaseTrueHUDControls() Global Native
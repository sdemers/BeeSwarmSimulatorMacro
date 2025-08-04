#Requires AutoHotkey v1.1.33+
#NoEnv
SendMode Input
#SingleInstance Force
SetWorkingDir %A_ScriptDir%

WinActivate Roblox
Sleep 1000

toggle := false

F7:: toggle := !toggle
Esc:: ExitApp

SetTimer, AutoLoop, 700  ; ⚡️ Ultra-fast: 0.7s per cycle
return

AutoLoop:
    if (!toggle)
        return

    ; === BUY SEED ===
    Send, {F1}
    Sleep, 1000
    Click, 115, 195  ; Adjust for seed button
    Sleep, 1000

    ; === PLANT ===
    Click, 315, 415  ; Adjust for plot
    Sleep, 1000

    ; === CRAFT ===
    Send, {F2}
    Sleep, 1000
    Click, 365, 465  ; Adjust for craft button
    Sleep, 1000

    ; === SELL ===
    Send, {F3}
    Sleep, 1000
    Click, 415, 515  ; Adjust for sell button
    Sleep, 1000
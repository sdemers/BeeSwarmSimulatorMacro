#Requires AutoHotkey v1.1.33+
#NoEnv
SendMode Input
#SingleInstance Force
SetWorkingDir %A_ScriptDir%

WinActivate Roblox
Sleep 1000

training_time := 60000

Hotkey, Esc, StopScript

StopScript() {
    ExitApp
}

KeyPress(key, duration := 10)
{
    Send, {%key% down}
    Sleep, duration
    Send, {%key% up}
}

Jump() {
    Send, {Space down}
    Sleep, 500
    Send, {Space up}
}

ToolTip, Click, 1200, 400, 1

Click, 2, 100

Loop {
    ToolTip, Running..., 1200, 400, 1
    KeyPress("e")
    Sleep, training_time
    Jump()

    Sleep, 1000
    ToolTip, Moving down, 1200, 400, 1
    KeyPress("s", 5000)

    ToolTip, Pulling..., 1200, 400, 1
    KeyPress("e")
    Sleep, training_time
    Jump()

    Sleep, 1000
    ToolTip, Moving up, 1200, 400, 1
    KeyPress("w", 5000)
    KeyPress("s", 100)
}

#Requires AutoHotkey v1.1.33+

CoordMode, Pixel, Screen

ToolTip F2 to down // F3 to up // F5 to quit // F6 SwitchAutoTool, 50, 100, 1

Hotkey, F2, StartFetching
Hotkey, F3, StopFetching
Hotkey, F5, Xit

global g_tool_active := False

WinActivate Roblox
Sleep 200

StartFetching() {
    g_tool_active := True
    Click, Down

    Loop, {
        if (g_tool_active) {
            Sleep, 5000
            Click, Up
            Sleep, 500
            Click, Down
        } else {
            break
        }
    }
}

StopFetching() {
    g_tool_active := False
    Click, Up
}

Xit() {
    ExitApp
}
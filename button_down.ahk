#Requires AutoHotkey v1.1.33+

CoordMode, Pixel, Screen

ToolTip F2 to down // F3 to up // F5 to quit // F6 Start/Stop Stinger, 50, 1950, 1

Hotkey, F2, StartFetching
Hotkey, F3, StopFetching
Hotkey, F5, Xit
Hotkey, F6, SwitchAutoTool

global g_tool_active := False

WinActivate Roblox
Sleep 200

StartFetching() {
    Click, Down
}

StopFetching() {
    Click, Up
}

Xit() {
    ExitApp
}

SwitchAutoTool() {
    g_tool_active := !g_tool_active
}

StartAutoTool() {
    if (g_tool_active) {
        Send, 3
    }
    While (g_tool_active) {
        Loop, 31 {
            Sleep, 1000
            if (!g_tool_active) {
                break
            }
        }

        if (g_tool_active) {
            Send, 3
        }
    }
}

StartAutoTool()
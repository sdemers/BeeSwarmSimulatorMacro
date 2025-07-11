#Requires AutoHotkey v1.1.33+
#Persistent

#Include, config.ahk
#Include, common.ahk

SetMouseDelay, 0

Sleep, 3000

; DLL-based left mouse click function
ClickDll() {
    DllCall("mouse_event", "UInt", 0x02, "UInt", 0, "UInt", 0, "UInt", 0, "UPtr", 0) ; Down
    DllCall("mouse_event", "UInt", 0x04, "UInt", 0, "UInt", 0, "UInt", 0, "UPtr", 0) ; Up
}

Click100() {
    Loop, 100 {
        ClickDll()
        HyperSleep(10)
    }
}

Loop {
    ; MouseMove, 1400, 1000, 0
    ; Click100()

    MouseMove, 2600, 1340, 0
    Click100()

    MouseMove, 2600, 560, 0
    Click100()
}
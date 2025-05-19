#Requires AutoHotkey v1.1.33+
#Persistent

#Include, common.ahk

WinActivate Roblox

Sleep 200

WalkHubPattern() {

    loop {
        StartFetching()
        MoveUp(1000)
        MoveLeft(1000)
        MoveDown(1000)
        MoveRight(1000)
    }
}

#Requires AutoHotkey v1.1.33+
#Persistent

#Include, config.ahk
#Include, common.ahk

global lastWeathClock := 0
ReadWealthClock()

global useWealthClock := 1
ReadUseWealthClock()

ShouldGoToWealthClock() {
    nextIn := (A_TickCount / 1000) - lastWeathClock
    Debug("Next wealth clock in " . nextIn . " seconds", 5)

    if (nextIn > 3610) {
        ReadUseWealthClock()
        return useWealthClock
    }

    return False
}

MoveToClock(hive) {
    if (MoveFromHiveToCannon()) {
        JumpToCannonAndFire()
        MoveLeft(1500)
        DeployChute()
        loop, 40 {
            MoveUp(50)
            MoveLeft(50)
        }
        Sleep, 2000
        MoveLeft(1000)
        MoveDown(3000)
        MoveRight(750)
        MoveDown(400)
        return True
    }

    return False

}

ReadUseWealthClock() {
    IniRead, Name, config.ini, Config, UseWealthClock
    useWealthClock := Name
}

ReadWealthClock() {
    IniRead, Name, config.ini, Config, LastWealthClock
    lastWeathClock := Name
    Debug("Last Wealth Clock: " . lastWeathClock)
}

WriteWealthClock(Value) {
    lastWeathClock := Value
    IniWrite, %Value%, config.ini, Config, LastWealthClock
}

ExecuteWealthClockScript() {
    Respawn()

    Debug("Moving to Wealth Clock")
    if (MoveToClock(hivePosition)) {
        KeyPress("e", 15)
        Sleep, 200
        WriteWealthClock(A_TickCount / 1000)
    }
}

; WinActivate Roblox
; Sleep 200
; ExecuteWealthClockScript()
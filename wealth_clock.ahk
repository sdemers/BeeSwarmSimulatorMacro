#Requires AutoHotkey v1.1.33+
#Persistent

#Include, config.ahk
#Include, common.ahk

global lastWeathClock := 0
ReadWealthClock()

global useWealthClock := 1
ReadUseWealthClock()

ShouldGoToWealthClock() {
    nextIn := Round((3610000 - (A_TickCount - lastWeathClock)) / 1000)
    ;Debug("A_TickCount: " . A_TickCount . ", lastWeathClock: " . lastWeathClock . ", Next wealth clock in " . nextIn . " seconds", 5)
    Debug("Next wealth clock in " . nextIn . " seconds", 5)

    if (nextIn < 0 or nextIn > 3700) {
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
        TwoKeyPress("w", "a", 9000)
        MoveLeft(1500)
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
    IniRead, Value, config.ini, Config, LastWealthClock
    if (Value > 735430000) {
        Value := 0
    }
    lastWeathClock := Value
    Debug("Last Wealth Clock: " . lastWeathClock)
}

WriteWealthClock(Value) {
    lastWeathClock := Value
    IniWrite, %Value%, config.ini, Config, LastWealthClock
}

ExecuteWealthClockScript() {
    Respawn()

    Debug("Moving to Wealth Clock")
    if (MoveToClock(g_hivePosition)) {
        KeyPress("e", 15)
        Sleep, 500
        WriteWealthClock(A_TickCount)
    }
}

;WinActivate Roblox
;Sleep 200
;ExecuteWealthClockScript()
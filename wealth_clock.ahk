#Requires AutoHotkey v1.1.33+
#Persistent

#Include, config.ahk
#Include, common.ahk

global lastWeathClock := 0
ReadWealthClock()

global useWealthClock := 1
ReadUseWealthClock()

ShouldGoToWealthClock() {
    ReadUseWealthClock()
    Debug("Last Wealth Clock: " . lastWeathClock, 5)

    if (useWealthClock = 1 and A_NowUTC - lastWeathClock > 3630) {
        return True
    }
}

MoveToClock(hive) {
    if (MoveFromHiveToCannon()) {
        JumpToCannonAndFire()
        MoveLeft(900)
        DeployChute()
        MoveUp(100)
        Sleep, 1000
        MoveUp(100)
        Sleep, 1100
        MoveLeft(1000)
        Sleep, 7000
        MoveLeft(1000)
        MoveUp(1000)
        MoveRight(500)
        MoveDown(500)
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
        WriteWealthClock(A_NowUTC)
    }
}

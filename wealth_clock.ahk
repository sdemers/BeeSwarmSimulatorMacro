#Requires AutoHotkey v1.1.33+
#Persistent

#Include, config.ahk
#Include, common.ahk

CoordMode, Pixel, Screen

WinActivate Roblox

Sleep 200

global lastWeathClock := 0

ShouldGoToWealthClock() {

    if (useWealthClock and A_NowUTC - lastWeathClock > 3630) {
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

ExecuteWealthClockScript() {
    Respawn()

    Debug("Moving to Wealth Clock")
    if (MoveToClock(hivePosition)) {
        KeyPress("e", 15)
        Sleep, 200
        lastWeathClock := A_NowUTC
    }
}

;ExecuteWealthClockScript()
#Requires AutoHotkey v1.1.33+
#Persistent

#Include, config.ahk
#Include, common.ahk

CoordMode, Pixel, Screen

WinActivate Roblox

Sleep 200

MoveToCactus(g_hivePosition) {
    If MoveFromHiveToCannon() {
        JumpToCannonAndFire()

        RotateCamera(4)

        Sleep, 500
        MoveLeft(200)
        DeployChute()
        Sleep 2000
        MoveUp(1000)
        SendSpace()
        Sleep 1000

        MoveRight(3000)
        MoveDown(6000)
        RotateRight()

        ZoomOut(5)
        return True
    }
}

ToHiveFromCactus() {
    global g_hivePosition

    MoveUp(3000)
    MoveRight(2000)
    MoveDown(500)
    MoveRight(500)
    MoveUp(1000)
    RotateRight()

    MoveUp(15000)
    MoveLeft(300)

    StopFetching()

    if (MoveToHiveSlot(g_hivePosition) = False) {
        Debug("Hive not found...")
        return False
    }

    return True
}

ExecuteCactusScript() {
    if (ShouldGoToWealthClock()) {
        ExecuteWealthClockScript()
    }
    Respawn()

    loop {
        Debug("Moving to cactus")
        if (MoveToCactus(g_hivePosition)) {
            Debug("Walk Cactus pattern")
            ZoomOut(5)
            ResetSprinklers()
            WalkCactusPattern(g_patternRepeat, g_subpatternRepeat)
            Debug("Moving to hive")
            if (ToHiveFromCactus()) {
                Debug("Convert honey")
                ConvertHoney()
                if (ShouldGoToWealthClock()) {
                    ExecuteWealthClockScript()
                    Respawn()
                }
            } else {
                Debug("Respawning")
                Respawn()
            }
        }
        else {
            Debug("Respawning")
            Respawn()
        }
    }
}

;ExecuteCactusScript()
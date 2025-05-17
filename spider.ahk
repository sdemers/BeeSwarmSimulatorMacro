#Requires AutoHotkey v1.1.33+
#Persistent

#Include, config.ahk
#Include, common.ahk

CoordMode, Pixel, Screen

WinActivate Roblox

Sleep 200

MoveToSpider() {
    if (MoveFromHiveToCannon()) {
        JumpToCannonAndFire()
        Sleep, 800
        DeployChute()
        MoveDown(1100)
        SendSpace()
        Sleep, 2000
        RotateCamera(4)

        MoveUp(2000)
        MoveLeft(3000)
        return True

    }

    return False
}

ToHiveFromSpider() {
    global g_hivePosition

    StopFetching()

    ; Move next to the straberry field
    MoveUp(5000)
    MoveLeft(5000)

    ; Move towards the hives, turn left then move to the hives
    RotateCamera(4)
    MoveUp(6000)
    MoveRight(500)
    MoveUp(10000)

    if (MoveToHiveSlot(g_hivePosition) = False) {
        Debug("Hive not found...")
        return False
    }

    return True
}

ExecuteSpiderScript() {
    if (ShouldGoToWealthClock()) {
        ExecuteWealthClockScript()
    }
    Respawn()

    loop {
        Debug("Moving to spider")
        if (MoveToSpider()) {
            Debug("Walk spider pattern")
            ResetSprinklers()
            WalkSpiderPattern(g_patternRepeat, g_subpatternRepeat, True, 50)
            Debug("Moving to hive")
            if (ToHiveFromSpider()) {
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

;ExecuteSpiderScript()
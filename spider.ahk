#Requires AutoHotkey v1.1.33+
#Persistent

#Include, config.ahk
#Include, common.ahk

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
    MoveUp(3000)
    MoveLeft(3000)

    KeyDown("a")
    Jump()
    Sleep, 3000
    KeyUp("a")

    return ToHiveFromStrawberry()
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
#Requires AutoHotkey v1.1.33+
#Persistent

#Include, config.ahk
#Include, common.ahk

MoveToPumpkin(g_hivePosition) {
    if (MoveFromHiveToCannon()) {
        JumpToCannonAndFire()

        RotateCamera(4)

        Sleep, 500
        MoveLeft(200)
        DeployChute()
        Sleep 2000
        MoveUp(1000)
        SendSpace()
        Sleep 1000

        MoveUp(5000)
        MoveRight(5000)
        RotateRight()

        ZoomOut(5)
        return True
    }
}

ToHiveFromPumpkin() {
    global g_hivePosition

    StopFetching()

    RotateLeft()
    MoveLeft(5000)
    MoveUp(3000)
    MoveRight(12000)

    RotateCamera(4)
    MoveUp(10000)

    JumpFromPolarBearToHive()

    if (MoveToHiveSlot(g_hivePosition) = False) {
        Debug("Hive not found...")
        return False
    }

    return True
}

ExecutePumpkinScript() {
    if (ShouldGoToWealthClock()) {
        ExecuteWealthClockScript()
    }
    Respawn()

    loop {
        Debug("Moving to Pumpkin")
        if (MoveToPumpkin(g_hivePosition)) {
            Debug("Walk Pumpkin pattern")
            ZoomOut(5)
            ResetSprinklers()
            WalkSpiderPattern(g_patternRepeat, g_subpatternRepeat)
            Debug("Moving to hive")
            if (ToHiveFromPumpkin()) {
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

;ExecutePumpkinScript()
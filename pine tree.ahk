#Requires AutoHotkey v1.1.33+
#Persistent

#Include, config.ahk
#Include, common.ahk

ValidatePineTreeField() {

    day := CompareColorAt(3780, 80, 0x7f6e45)
    If (day) {
        return True
    }

    if CompareColorAt(3780, 80, 0x857559) {
        return True
    }

    return CompareColorAt(3780, 80, 0x000000)
}

MoveToPineTree() {
    if (MoveFromHiveToCannon()) {
        JumpToCannonAndFire()

        Sleep 320
        MoveRight(180)
        Sleep 250
        DeployChute()
        Sleep 4700
        SendSpace()
        Sleep 500
        RotateRight()

        ZoomOut(5)

        MoveRight(5000)
        MoveUp(5000)

        return True
    }

    ; if (ValidateField()) {
    ;     return True
    ; }

    return False
}

ToHiveFromPineTree() {
    MoveRight(2000)
    MoveUp(2000)

    StopFetching()

    ; Move next to polar bear
    MoveDown(11000)
    RotateLeft()
    MoveUp(9000)

    JumpFromPolarBearToHive()

    if (MoveToHiveSlot(g_hivePosition) = False) {
        Debug("Hive not found...")
        return False
    }

    return True
}

ExecutePineTree() {
    Debug("Moving to pine tree")
    if (MoveToPineTree()) {
        Debug("Walk pine tree pattern")
        ZoomOut()
        ResetSprinklers()
        WalkElolPattern()
        ;WalkBlueFlowerPattern(g_patternRepeat, g_subpatternRepeat, 2, 200, 50)
        ;WalkPineSwirl(200, false)
        Debug("Moving to hive")
        if (ToHiveFromPineTree()) {
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

ExecutePineTreeScript() {
    if (ShouldGoToWealthClock()) {
        ExecuteWealthClockScript()
    }
    Respawn()

    loop {
        ExecutePineTree()
    }
}

;JumpToRedCannon()
;ExecutePineTreeScript()
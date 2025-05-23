#Requires AutoHotkey v1.1.33+
#Persistent

#Include, config.ahk
#Include, common.ahk

CoordMode, Pixel, Screen

WinActivate Roblox

Sleep 200

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
        MoveRight(200)
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
    global g_hivePosition

    MoveRight(5000)
    MoveUp(5000)

    StopFetching()

    ; Move next to polar bear
    MoveRight(7000)
    MoveDown(13000)
    RotateLeft()
    MoveUp(10000)

    JumpFromPolarBearToHive()

    if (MoveToHiveSlot(g_hivePosition) = False) {
        Debug("Hive not found...")
        return False
    }

    return True
}

ExecutePineTreeScript() {
    if (ShouldGoToWealthClock()) {
        ExecuteWealthClockScript()
    }
    Respawn()

    loop {
        Debug("Moving to pine tree")
        if (MoveToPineTree()) {
            Debug("Walk pine tree pattern")
            ZoomOut()
            ResetSprinklers()
            RotateCamera(-1)
            WalkRosePattern(g_patternRepeat, g_subpatternRepeat, 1000, 0)
            RotateCamera(1)
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
}

;JumpToRedCannon()
;ExecutePineTreeScript()
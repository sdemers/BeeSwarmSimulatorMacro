#Requires AutoHotkey v1.1.33+
#Persistent

#Include, config.ahk
#Include, common.ahk

ValidateCoconutField() {
    return True

    day := CompareColorAt(3750, 2000, 0x7f7156) && CompareColorAt(1900, 650, 0xd06a42)
    If (day) {
        return True
    }

    night := CompareColorAt(3750, 2000, 0x000000) && CompareColorAt(1900, 650, 0x5d2b0c)
    return night
}

MoveToCoconut() {
    if (MoveFromHiveToCannon()) {
        JumpToCannonAndFire()

        MoveUp(500)
        DeployChute()
        MoveUp(300)
        Sleep, 4000
        MoveUp(3500)
        MoveRight(10000)
        MoveUp(1000)

        return True
    }

    return False
}

ToHiveFromCoconut() {
    StopFetching()

    TwoKeyPress("w", "d", 3000)
    MoveDown(5000)
    KeyDown("s")
    Jump()
    Sleep, 5000
    KeyUp("s")
    RotateLeft()
    MoveRight(5000)
    MoveUp(10000)
    MoveDown(8000)

    if (MoveToHiveUp() = False) {
        Debug("Hive not found...")
        return False
    }

    RotateRight()
    return True
}

ExecuteCoconutScript() {
    if (ShouldGoToWealthClock()) {
        ExecuteWealthClockScript()
    }

    Respawn()

    loop {
        Debug("Moving to coconut")
        if (MoveToCoconut()) {
            Debug("Walk coconut pattern")
            ZoomOut()
            ResetSprinklers()
            WalkRosePattern(g_patternRepeat, g_subpatternRepeat, 1000, 0)
            Debug("Moving to hive")
            if (ToHiveFromCoconut()) {
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

;ExecuteCoconutScript()

#Requires AutoHotkey v1.1.33+
#Persistent

#Include, config.ahk
#Include, common.ahk

MoveToPepperField() {
    if (MoveFromHiveToCannon()) {
        JumpToRedCannon()
        MoveRight(3000)

        KeyDown("d")
        Jump()
        HyperSleep(2000)
        KeyUp("d")

        KeyDown("w")
        HyperSleep(1000)
        Jump()
        HyperSleep(2500)
        Jump()
        HyperSleep(2000)
        Jump()
        HyperSleep(3000)
        Jump()
        HyperSleep(1000)
        KeyUp("w")
        HyperSleep(200)

        KeyDown("w")
        KeyDown("d")
        HyperSleep(1000)
        Jump()
        HyperSleep(2000)
        KeyUp("w")
        HyperSleep(300)
        Jump()
        HyperSleep(2000)
        Jump()
        HyperSleep(1500)
        KeyUp("d")

        RotateRight()
        MoveUp(1000)
        TwoKeyPress("w", "d", 10000)

        return True
    }

    return False
}

ToHiveFromPepperField() {
    global g_hivePosition

    StopFetching()

    MoveUp(5000)
    MoveRight(5000)

    RotateCamera(4)
    MoveUp(10000)
    MoveLeft(5000)

    TwoKeyPress("w", "d", 2000)
    MoveLeft(500)
    MoveUp(500)
    MoveRight(500)
    MoveUp(2000)

    if (MoveToHiveUp()) {
        RotateRight()
        return True
    }

    Debug("Hive not found...")
    return False
}

ExecutePepperScript() {
    if (ShouldGoToWealthClock()) {
        ExecuteWealthClockScript()
    }
    Respawn()

    Loop {
        Debug("Moving to pepper field")
        If (MoveToPepperField()) {
            Debug("Walk rose pattern")
            ResetSprinklers()
            WalkPepperPattern(g_patternRepeat, g_subpatternRepeat)
            Debug("Moving to hive")
            If (ToHiveFromPepperField()) {
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

;ExecutePepperScript()
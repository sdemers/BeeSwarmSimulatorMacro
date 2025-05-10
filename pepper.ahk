#Requires AutoHotkey v1.1.33+
#Persistent

#Include, config.ahk
#Include, common.ahk

CoordMode, Pixel, Screen

WinActivate Roblox

Sleep 200

MoveToPepperField() {
    ZoomOut(5)
    FromHiveToCannon(g_hivePosition, False)

    MoveRight(4000)

    KeyDown("d")
    Jump()
    Sleep, 2000
    KeyUp("d")

    KeyDown("w")
    Loop, 10 {
        Sleep, 700
        Jump()
    }
    KeyUp("w")

    MoveUp(2000)a
    MoveRight(2000)
    KeyDown("d")
    Sleep, 200
    Jump()
    Sleep, 2000
    Jump()
    KeyUp("d")

    RotateRight()
    MoveUp(5000)
    MoveRight(5000)

    return True
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
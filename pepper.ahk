#Requires AutoHotkey v1.1.33+
#Persistent

#Include, config.ahk
#Include, common.ahk

CoordMode, Pixel, Screen

WinActivate Roblox

Sleep 200

MoveToPepperField() {
    ZoomOut(5)
    FromHiveToCannon(hivePosition, False)

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
    global hivePosition

    StopFetching()

    MoveUp(5000)
    MoveRight(5000)

    MoveDown(10000)
    MoveRight(10000)

    RotateCamera(4)

    MoveUp(6000)
    MoveDown(2000)

    Loop, 4 {
        MoveRight(800)
        MoveUp(800)
    }

    MoveDown(2000)

    RotateRight()
    ZoomOut(5)

    MoveDown(500)
    if (MoveToHiveLeft()) {
        return True
    }

    Debug("Hive not found...")
    return False
}

ExecutePepperScript() {
    Respawn()

    Loop {
        Debug("Moving to pepper field")
        If (MoveToPepperField()) {
            Debug("Walk rose pattern")
            ResetSprinklers()
            WalkRosePattern(patternRepeat, subpatternRepeat)
            Debug("Moving to hive")
            If (ToHiveFromPepperField()) {
                Debug("Convert honey")
                ConvertHoney()
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

ExecutePepperScript()
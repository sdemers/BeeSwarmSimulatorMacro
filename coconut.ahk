#Requires AutoHotkey v1.1.33+
#Persistent

#Include, config.ahk
#Include, common.ahk

CoordMode, Pixel, Screen

WinActivate Roblox

Sleep 200

ValidateField() {
    return True

    day := CompareColorAt(3750, 2000, 0x7f7156) && CompareColorAt(1900, 650, 0xd06a42)
    If (day) {
        return True
    }

    night := CompareColorAt(3750, 2000, 0x000000) && CompareColorAt(1900, 650, 0x5d2b0c)
    return night
}

MoveToCoconut() {
    FromHiveToCannon(hivePosition, False)

    MoveRight(4000)

    KeyDown("d")
    Jump()
    Sleep, 2000
    KeyUp("d")

    KeyDown("w")
    Sleep, 200
    Jump()
    Sleep, 3000
    Jump()
    Sleep, 200
    Jump()
    Sleep, 2000
    KeyUp("w")

    MoveLeft(1000)
    MoveUp(3000)

    if (ValidateField()) {
        return True
    }

    return False
}

ToHiveFromCoconut() {
    StopFetching()

    MoveUp(5000)
    MoveRight(5000)
    MoveDown(5000)
    MoveLeft(8000)
    Sleep, 10000
    MoveDown(5000)
    MoveUp(2000)

    if (MoveToHiveSlot(hivePosition) = False) {
        Debug("Hive not found...")
        return False
    }

    return True
}

ExecuteCoconutScript() {
    Respawn()

    loop {
        Debug("Moving to coconut")
        if (MoveToCoconut()) {
            Debug("Walk coconut pattern")
            MoveUp(5000)
            MoveRight(5000)
            ZoomOut()
            ResetSprinklers()
            WalkPineTreePattern(patternRepeat, subpatternRepeat)
            Debug("Moving to hive")
            if (ToHiveFromCoconut()) {
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
ExecuteCoconutScript()

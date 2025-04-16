#Requires AutoHotkey v1.1.33+
#Persistent

; Dynamic settings
global hivePosition := 5
global speed := 33.3
global patternRepeat := 10
global subpatternRepeat := 10

#Include, common.ahk

; Field settings
global patternLength := 7
global patternWidth := 7

CoordMode, Pixel, Screen

WinActivate Roblox

Sleep 200

ValidateField() {
    day := CompareColorAt(1818, 245, 0x070c6c) && CompareColorAt(2800, 2000, 0xfdfdfd)
    If (day) {
        return True
    }

    dayCloseup := CompareColorAt(2800, 1940, 0x00003b) && CompareColorAt(500, 110, 0x050a5c)
    If (dayCloseup) {
        return True
    }

    night := CompareColorAt(1818, 245, 0x070c6c) && CompareColorAt(2800, 2000, 0x6e6e6e)
    return night
}

MoveToRoseField() {
    FromHiveToCannon(hivePosition)

    MoveRight(300)
    DeployChute()
    Sleep 2300
    SendSpace()
    Sleep 500
    MoveRight(1000)
    MoveUp(2500)
    MoveRight(3500)

    return True
}

ToHiveFromField() {
    global hivePosition

    StopFetching()

    ; Walk to switch next to blue cannon
    ; Give enough time to disable haste
    MoveUp(5000)
    MoveRight(5000)

    MoveDown(5000)
    RotateCamera(4)

    Loop, 5 {
        MoveRight(800)
        MoveUp(800)
    }

    MoveUp(12000)
    MoveRight(13000)
    RotateCamera(4)
    MoveUp(10000)

    JumpFromPolarBearToHive()

    if (MoveToHiveSlot(hivePosition) = False) {
        Debug("Hive not found...")
        return False
    }

    return True
}

ExecuteRoseScript() {
    Respawn()

    Loop {
        Debug("Moving to rose field")
        If (MoveToRoseField()) {
            Debug("Walk rose pattern")
            WalkRosePattern(patternRepeat, subpatternRepeat)
            Debug("Moving to hive")
            If (ToHiveFromField()) {
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

ExecuteRoseScript()

StopScript:
    ResetKeys()
ExitApp
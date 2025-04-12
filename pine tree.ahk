#Requires AutoHotkey v1.1.33+
#Persistent

#Include, common.ahk

stopKey := "F2"

global hivePosition := 2
global speed := 33.35

; Set the snake pattern parameters (adjust to your liking)
global patternRepeat := 10
global subpatternRepeat := 10
global patternLength := 10
global patternWidth := 10

global movespeedFactor := 28 / speed

Hotkey %stopKey%, StopScript

CoordMode, Pixel, Screen

WinActivate Roblox

Sleep 200

ToolTip Press F2 to stop script, 50, 400, 1

ValidateField() {

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
    FromHiveToCannon(hivePosition)

    Sleep 320
    MoveRight(170)
    Sleep 250
    DeployChute()
    Sleep 4700
    SendSpace()
    Sleep 500
    RotateRight()

    MoveRight(5000)
    MoveUp(5000)

    if (ValidateField()) {
        return True
    }

    return False
}

ToHiveFromPineTree() {
    global hivePosition

    StopFetching()

    ; Move next to polar bear
    MoveRight(7000)
    MoveDown(13000)
    RotateLeft()
    MoveUp(10000)

    JumpFromPolarBearToHive()

    if (MoveToHiveSlot(hivePosition) = False) {
        Debug("Hive not found...")
        return False
    }

    return True
}

ExecuteScript() {
    Respawn()

    loop {
        Debug("Moving to pine tree")
        if (MoveToPineTree()) {
            Debug("Walk pine tree pattern")
            WalkPineTreePattern(patternRepeat, subpatternRepeat)
            MoveRight(5000)
            MoveUp(5000)
            Debug("Moving to hive")
            if (ToHiveFromPineTree()) {
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

ExecuteScript()

StopScript:
    ResetKeys()
ExitApp
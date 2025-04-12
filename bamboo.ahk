#Requires AutoHotkey v1.1.33+
#Persistent

#Include, common.ahk

stopKey := "F2"

global hivePosition := 4
global speed := 33.35

; Set the snake pattern parameters (adjust to your liking)
global patternRepeat := 100
global subpatternRepeat := 100
global patternLength := 10
global patternWidth := 10

global movespeedFactor := 28 / speed

Hotkey %stopKey%, StopScript

CoordMode, Pixel, Screen

WinActivate Roblox

Sleep 200

ToolTip Press F2 to stop script, 50, 400, 1

ValidateField() {

    day := CompareColorAt(3750, 2000, 0x7f7156) && CompareColorAt(1900, 650, 0xd06a42)
    if (day) {
        return True
    }

    if CompareColorAt(3750, 2000, 0x857559) && CompareColorAt(1900, 650, 0x2C4421) {
        return True
    }

    night := CompareColorAt(3750, 2000, 0x000000) && CompareColorAt(1900, 650, 0x5d2b0c)
    return night
}

MoveToBamboo() {
    FromHiveToCannon(hivePosition)

    Sleep 500
    MoveLeft(300)
    Sleep 150
    DeployChute()
    Sleep 3000
    SendSpace()
    Sleep 500
    RotateCamera(4)

    MoveUp(3000)
    MoveRight(3000)

    return True
}

ToHiveFromBamboo() {
    global hivePosition

    StopFetching()

    ; Move to the wall on the right side
    MoveUp(3000)
    MoveRight(5000)

    ; Move next to spider
    MoveLeft(7000)
    MoveDown(600)
    MoveLeft(10000)

    RotateCamera(4)
    MoveDown(1000)

    ; Move to hive
    MoveUp(10000)
    MoveRight(600)
    MoveUp(8000)

    if (MoveToHiveSlot(hivePosition) = False) {
        Debug("Hive not found...")
        return False
    }

    return True
}

ExecuteScript() {
    Respawn()

    loop {
        Debug("Moving to bamboo")
        if (MoveToBamboo()) {
            Debug("Walk pine tree pattern")
            WalkPineTreePattern(patternRepeat, subpatternRepeat)
            Debug("Moving to hive")
            if (ToHiveFromBamboo()) {
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
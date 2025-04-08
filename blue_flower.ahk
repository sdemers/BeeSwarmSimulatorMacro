#Requires AutoHotkey v1.1.33+
#Persistent

#Include, common.ahk

stopKey := "F2"

global hivePosition := 4
global speed := 32.2

; Set the snake pattern parameters (adjust to your liking)
global patternRepeat := 100
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
    day := CompareColorAt(170, 1900, 0x006493) && CompareColorAt(2730, 270, 0x958465)
    if (day) {
        return True
    }

    night := CompareColorAt(170, 1900, 0x006491) && CompareColorAt(2730, 270, 0x000000)
    return night
}

MoveToField() {
    MoveUp(2875)
    MoveRight(5000)
    MoveLeft(50)
    ;MoveRight(57)
    JumpToRedCannon()
    MoveRight(1150)
    Sleep 200
    KeyPress("e", 15)

    MoveLeft(250)
    Sleep, 300
    DeployChute()
    Sleep, 3000
    SendSpace()
    Sleep, 2300

    MoveUp(3000)
    MoveRight(500)

    ; if (ValidateField()) {
    ;     return True
    ; }

    return True
}

MoveToHiveSlot(slot) {
    ; We should be facing the wall at slot #3

    MoveDown(500)

    if (slot < 3) {
        return MoveToHiveRight()
    }
    else {
        return MoveToHiveLeft()
    }
}

ToHiveFromPineapple() {
    global hivePosition

    StopFetching()

    RotateCamera(4)

    ; Walk to switch next to blue cannon
    ; Give enough time to disable haste
    MoveUp(15000)

    MoveDown(600)
    MoveRight(2000)
    MoveLeft(50)
    SendSpace(10)
    MoveRight(700)
    Sleep 300
    KeyPress("e", 20)
    Sleep 2500
    MoveUp(5000)

    if (MoveToHiveSlot(hivePosition) = False) {
        Debug("Hive not found...")
        return False
    }

    return True
}

ExecuteScript() {
    Respawn()

    loop {
        Debug("Moving to blue flower")
        if (MoveToField()) {
            Debug("Walk blue flower pattern")
            WalkZigZagCrossUpperRight(patternRepeat, subpatternRepeat)
            Debug("Moving to hive")
            if (ToHiveFromPineapple()) {
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
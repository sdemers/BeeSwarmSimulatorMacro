#Requires AutoHotkey v1.1.33+
#Persistent

#Include, common.ahk

stopKey := "F2"

global hivePosition := 4
global speed := 33.35

; Set the snake pattern parameters (adjust to your liking)
global patternRepeat := 1
global subpatternRepeat := 1
global patternLength := 10
global patternWidth := 10

global movespeedFactor := 28 / speed

Hotkey %stopKey%, StopScript

CoordMode, Pixel, Screen

WinActivate Roblox

Sleep 200

ToolTip Press F2 to stop script, 50, 400, 1

MoveToStrawberry() {
    FromHiveToCannon(hivePosition)

    MoveRight(170)
    Sleep, 400
    DeployChute()
    Sleep 1000
    SendSpace()
    Sleep 1500
    RotateRight()

    MoveRight(5000)
    MoveUp(5000)
    return True
}

ToHiveFromStrawbery() {
    global hivePosition

    StopFetching()

    ; Move right and down next to the spider field
    MoveRight(5000)
    MoveDown(5000)

    ; Move towards the hives, turn left then move to the hives
    RotateLeft()
    MoveUp(10000)
    MoveLeft(1000)
    MoveUp(6000)

    if (MoveToHiveSlot(hivePosition) = False) {
        Debug("Hive not found...")
        return False
    }

    return True
}

ExecuteStrawberryScript() {
    Respawn()

    loop {
        Debug("Moving to strawberry")
        if (MoveToStrawberry()) {
            Debug("Walk pine tree pattern")
            WalkPineTreePattern(patternRepeat, subpatternRepeat)
            Debug("Moving to hive")
            if (ToHiveFromStrawbery()) {
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

ExecuteStrawberryScript()

StopScript:
    ResetKeys()
ExitApp
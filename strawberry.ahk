#Requires AutoHotkey v1.1.33+
#Persistent

#Include, common.ahk

global hivePosition := 4
global speed := 33.35

; Set the snake pattern parameters (adjust to your liking)
global patternRepeat := 20
global subpatternRepeat := 20
global patternLength := 10
global patternWidth := 10

global movespeedFactor := 28 / speed

CoordMode, Pixel, Screen

WinActivate Roblox

Sleep 200

MoveToStrawberry() {
    FromHiveToCannon(hivePosition)

    MoveRight(170)
    Sleep, 400
    DeployChute()
    Sleep, 600
    MoveRight(100)
    Sleep, 1000
    SendSpace()
    Sleep 1500
    RotateCamera(4)

    MoveUp(5000)
    MoveRight(5000)
    return True
}

ToHiveFromStrawberry() {
    global hivePosition

    StopFetching()

    ; Move next to the spider field
    MoveUp(5000)
    MoveRight(5000)

    ; Move towards the hives, turn left then move to the hives
    ; Give time for the haste to expire
    MoveDown(5000)
    RotateCamera(4)
    MoveUp(15000)
    MoveLeft(700)
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
            if (ToHiveFromStrawberry()) {
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
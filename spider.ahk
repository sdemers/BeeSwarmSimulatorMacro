#Requires AutoHotkey v1.1.33+
#Persistent

#Include, common.ahk

global hivePosition := 2
global speed := 33.35

; Set the snake pattern parameters (adjust to your liking)
global patternRepeat := 10
global subpatternRepeat := 10
global patternLength := 10
global patternWidth := 10

global movespeedFactor := 28 / speed

CoordMode, Pixel, Screen

WinActivate Roblox

Sleep 200

MoveToSpider() {
    FromHiveToCannon(hivePosition)

    Sleep, 800
    DeployChute()
    MoveDown(1500)
    SendSpace()
    Sleep, 2000
    RotateCamera(4)

    MoveLeft(3000)
    return True
}

ToHiveFromSpider() {
    global hivePosition

    StopFetching()

    ; Move next to the straberry field
    MoveUp(5000)
    MoveLeft(5000)

    ; Move towards the hives, turn left then move to the hives
    RotateCamera(4)
    MoveUp(9000)
    MoveRight(500)
    MoveUp(6000)

    if (MoveToHiveSlot(hivePosition) = False) {
        Debug("Hive not found...")
        return False
    }

    return True
}

ExecuteSpiderScript() {
    Respawn()

    loop {
        Debug("Moving to spider")
        if (MoveToSpider()) {
            Debug("Walk spider pattern")
            WalkSpiderPattern(patternRepeat, subpatternRepeat)
            Debug("Moving to hive")
            if (ToHiveFromSpider()) {
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

ExecuteSpiderScript()
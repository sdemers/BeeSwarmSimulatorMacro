#Requires AutoHotkey v1.1.33+
#Persistent

#Include, common.ahk

global hivePosition := 1
global speed := 33.33

; Set the snake pattern parameters (adjust to your liking)
global patternRepeat := 10
global subpatternRepeat := 10
global patternLength := 10
global patternWidth := 10

global movespeedFactor := 28 / speed

CoordMode, Pixel, Screen

WinActivate Roblox

Sleep 200

MoveToMushroom(hivePosition) {
    FromHiveToCannon(hivePosition)

    Sleep, 100
    DeployChute()
    MoveDown(300)
    ReleaseChute()
    Sleep, 500
    RotateCamera(4)

    MoveRight(4000)
    MoveUp(4000)

    return True
}

ToHiveFromMushroom() {

    StopFetching()

    MoveUp(10000)
    MoveRight(10000)
    RotateCamera(4)

    MoveUp(5000)
    MoveRight(200)
    MoveUp(10000)

    if (MoveToHiveSlot(hivePosition, 5) = False) {
        Debug("Hive not found...")
        return False
    }

    return True
}

ExecuteMushroomScript() {
    Respawn()

    loop {
        Debug("Moving to mushroom")
        if (MoveToMushroom(hivePosition)) {
            Debug("Walk mushroom pattern")
            WalkPineTreePattern(patternRepeat, subpatternRepeat)
            Debug("Moving to hive")
            if (ToHiveFromMushroom()) {
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

;ExecuteMushroomScript()

ToHiveFromMushroom()
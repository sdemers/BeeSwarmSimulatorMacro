#Requires AutoHotkey v1.1.33+
#Persistent

#Include, common.ahk

global hivePosition := 4
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

MoveToSunflower(hive) {
    if (MoveFromHiveToCannon()) {
        MoveDown(4000)

        RotateCamera(4)
        MoveLeft(2000)
        MoveUp(1000)

        RotateLeft()
        MoveUp(1000)
        MoveLeft(1000)

        return True
    }

    return False

}

MoveToHiveSlotFrom1(slot) {
    ; We should be facing the wall at slot #1

    MoveDown(500)

    return MoveToHiveLeft()
}

ToHiveFromSunflower() {
    global hivePosition

    StopFetching()

    MoveUp(5000)
    MoveLeft(5000)
    MoveDown(1000)
    MoveLeft(3000)
    Sleep, 15000
    MoveDown(1300)
    RotateLeft()
    MoveUp(1000)
    MoveRight(1000)

    if (MoveToHiveSlotFrom1(hivePosition) = False) {
        Debug("Hive not found...")
        return False
    }

    return True
}

ExecuteScript() {
    Respawn()

    loop {
        Debug("Moving to Sunflower")
        if (MoveToSunflower(hivePosition)) {
            Debug("Walk Sunflower pattern")
            ZoomOut(5)
            WalkSunflowerPattern(patternRepeat, subpatternRepeat)
            Debug("Moving to hive")
            if (ToHiveFromSunflower()) {
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
#Requires AutoHotkey v1.1.33+
#Persistent

#Include, common.ahk

global hivePosition := 1
global speed := 32.5

; Set the snake pattern parameters (adjust to your liking)
global patternRepeat := 10
global subpatternRepeat := 10
global patternLength := 10
global patternWidth := 10

global movespeedFactor := 28 / speed

CoordMode, Pixel, Screen

WinActivate Roblox

Sleep 200

ValidateField() {
    day := CompareColorAt(170, 1900, 0x006493) && CompareColorAt(2730, 270, 0x958465)
    if (day) {
        return True
    }

    night := CompareColorAt(170, 1900, 0x006491) && CompareColorAt(2730, 270, 0x000000)
    return night
}

MoveToBlueFlowerField() {
    FromHiveToCannon(hivePosition)

    MoveLeft(250)
    Sleep, 300
    DeployChute()
    Sleep, 3000
    SendSpace()
    Sleep, 2300

    MoveUp(3000)
    MoveRight(500)

    return True
}

ToHiveFromBlueFlower() {
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

ExecuteBlueFlowerScript() {
    Respawn()

    loop {
        Debug("Moving to blue flower")
        if (MoveToBlueFlowerField()) {
            Debug("Walk blue flower pattern")
            TopView()
            WalkZigZagCrossUpperRight(patternRepeat, subpatternRepeat)
            Debug("Moving to hive")
            if (ToHiveFromBlueFlower()) {
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

;WalkZigZagCrossUpperRight(patternRepeat, subpatternRepeat)
ExecuteBlueFlowerScript()


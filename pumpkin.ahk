#Requires AutoHotkey v1.1.33+
#Persistent

#Include, common.ahk

global hivePosition := 3
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

MoveToPumpkin(hivePosition) {
    FromHiveToCannon(hivePosition)

    RotateCamera(4)
    ZoomOut(5)

    Sleep, 500
    MoveLeft(200)
    DeployChute()
    Sleep 2000
    MoveUp(1500)
    SendSpace()
    Sleep 1500

    MoveUp(5000)
    MoveRight(5000)
    RotateRight()

    return True
}

MoveToHiveSlotFrom1(slot) {
    ; We should be facing the wall at slot #1

    MoveDown(500)

    return MoveToHiveLeft()
}

ToHiveFromPumpkin() {
    global hivePosition

    StopFetching()

    RotateLeft()
    MoveLeft(5000)
    MoveUp(3000)
    MoveRight(12000)

    RotateCamera(4)
    MoveUp(10000)

    JumpFromPolarBearToHive()

    if (MoveToHiveSlot(hivePosition) = False) {
        Debug("Hive not found...")
        return False
    }

    return True
}

ExecutePumpkinScript() {
    Respawn()

    loop {
        Debug("Moving to Pumpkin")
        if (MoveToPumpkin(hivePosition)) {
            Debug("Walk Pumpkin pattern")
            ZoomOut(5)
            WalkSpiderPattern(patternRepeat, subpatternRepeat)
            Debug("Moving to hive")
            if (ToHiveFromPumpkin()) {
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

ExecutePumpkinScript()
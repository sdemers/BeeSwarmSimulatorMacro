#Requires AutoHotkey v1.1.33+
#Persistent

#Include, common.ahk

global hivePosition := 5
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

MoveToClover() {
    if (MoveFromHiveToCannon()) {
        JumpToCannonAndFire()
        MoveLeft(1000)
        DeployChute()
        MoveUp(1000)
        MoveLeft(200)
        Sleep, 3000
        SendSpace()
        Sleep, 2000
        ;Sleep, 2000
        ;RotateCamera(4)

        MoveUp(3000)
        MoveLeft(3000)
        return True

    }

    return False
}

ToHiveFromClover() {
    global hivePosition

    StopFetching()

    ; Move to the blue portal
    MoveUp(5000)
    MoveLeft(5000)
    MoveDown(400)
    MoveLeft(2000)
    MoveDown(6000)
    MoveRight(300)
    MoveDown(500)
    MoveLeft(5000)
    MoveRight(500)
    MoveUp(200)
    KeyPress("e", 15)
    Sleep, 2000

    ; Move to the first hive slot
    MoveDown(5000)
    MoveLeft(3200)
    MoveUp(4000)
    MoveRight(500)
    MoveDown(500)

    if (MoveToHiveLeft() = False) {
        Debug("Hive not found...")
        return False
    }

    return True
}

ExecuteCloverScript() {
    Respawn()

    loop {
        Debug("Moving to clover")
        if (MoveToClover()) {
            Debug("Walk clover pattern")
            WalkCloverPattern(patternRepeat, subpatternRepeat)
            Debug("Moving to hive")
            if (ToHiveFromClover()) {
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

ExecuteCloverScript()

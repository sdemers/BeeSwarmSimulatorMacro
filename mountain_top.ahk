#Requires AutoHotkey v1.1.33+
#Persistent

#Include, common.ahk

global hivePosition := 2
global speed := 33.3

; Set the snake pattern parameters (adjust to your liking)
global patternRepeat := 10
global patternLength := 20

global move := 100

global movespeedFactor := 28 / speed

WinActivate Roblox

Sleep 200

MoveToMountainTop() {
    FromHiveToCannon(hivePosition)

    Sleep 3000

    PlaceSprinkler()

    return True
}

WalkMountainTopPattern(nbLoops) {
    StartFetching()

    moveTime := move * patternLength
    stop := False

    RotateCamera(4)

    loop, %nbLoops% {
        Debug("Pattern #" . A_Index . "/" . nbLoops)

        MoveUp(4000)
        MoveRight(2000)

        MoveDown(500)

        loop, 6 {
            MoveLeft(700)
            MoveDown(200)
            MoveRight(500)
            MoveDown(200)
        }

        MoveLeft(2000)
        MoveRight(1000)

        loop, 4 {
            MoveRight(800)
            MoveUp(200)
            MoveLeft(500)
            MoveUp(200)
        }

        if (stop) {
            Break
        }
    }
}

ToHiveFromMountainTop() {
    global hivePosition

    StopFetching()

    MoveDown(8000)
    MoveRight(5000)
    MoveUp(5000)
    MoveRight(2000)
    MoveUp(2000)
    MoveRight(1500)
    MoveLeft(1500)
    MoveUp(5000)

    JumpFromPolarBearToHive()

    MoveToHiveSlot(hivePosition)
}

ExecuteMountainTopScript() {
    Respawn()

    loop {
        Debug("Moving to mountain top")
        if (MoveToMountainTop()) {
            Debug("Walk mountain top pattern")
            WalkMountainTopPattern(patternRepeat)
            Debug("Moving to hive")
            if (ToHiveFromMountainTop()) {
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

ExecuteMountainTopScript()

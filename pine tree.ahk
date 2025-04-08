#Requires AutoHotkey v1.1.33+
#Persistent

#Include, common.ahk

stopKey := "F2"

global hivePosition := 4
global speed := 32.2

; Set the snake pattern parameters (adjust to your liking)
global patternRepeat := 10
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
    day := CompareColorAt(3750, 2000, 0x7f7156) && CompareColorAt(1900, 650, 0xd06a42)
    If (day) {
        return True
    }

    night := CompareColorAt(3750, 2000, 0x000000) && CompareColorAt(1900, 650, 0x5d2b0c)
    return night
}

MoveToPineTree() {
    FromHiveToCannon(hivePosition)

    Sleep 320
    MoveRight(170)
    Sleep 200
    DeployChute()
    Sleep 4700
    SendSpace()
    Sleep 500
    RotateRight()

    MoveRight(5000)
    MoveUp(5000)

    if (ValidateField()) {
        return True
    }

    return False
}

WalkPineTreePattern(nbLoops, subrepeat) {
    StartFetching()

    move := 100 * movespeedFactor
    patternMoveTime := move * patternWidth
    containerFull := False

    MoveDown(15 * move)
    MoveLeft(10 * move)

    loop, %nbLoops% {
        if (A_Index = 1) {
            PlaceSprinkler()
        }

        Debug("Pattern #" . A_Index . "/" . nbLoops)
        loop, %subrepeat% {

            turnAroundTime := move * patternLength / 4

            MoveLeft(200)

            Loop, 2 {
                MoveUp(patternMoveTime)
                MoveLeft(turnAroundTime)
                PlaceSprinkler()
                MoveDown(patternMoveTime)
                MoveLeft(turnAroundTime)
            }

            Loop, 2 {
                MoveUp(patternMoveTime)
                MoveRight(turnAroundTime)
                MoveDown(patternMoveTime)
                MoveRight(turnAroundTime)
            }

            MoveUp(patternMoveTime)

            Loop, 2 {
                MoveLeft(patternMoveTime)
                MoveDown(turnAroundTime)
                MoveRight(patternMoveTime)
                MoveDown(turnAroundTime)
            }

            MoveLeft(patternMoveTime / 3)
            MoveUp(patternMoveTime * 1.5)
            MoveDown(200)

            Loop, 2 {
                MoveRight(patternMoveTime)
                MoveDown(turnAroundTime)
                MoveLeft(patternMoveTime)
                MoveDown(turnAroundTime)
            }

            MoveRight(patternMoveTime)

            if (IsContainerFull()) {
                containerFull := True
                Break
            }
        }

        if (containerFull || A_Index = nbLoops) {
            MoveRight(5000 * movespeedFactor)
            MoveUp(5000 * movespeedFactor)
            Break
        }
    }
}

MoveToHiveSlot(slot)  {
    ; We should be facing the wall at slot #3

    MoveDown(500)

    if (slot <= 3) {
        return MoveToHiveRight()
    }
    else {
        return MoveToHiveLeft()
    }
}

ToHiveFromPineTree() {
    global hivePosition

    StopFetching()

    ; Move next to polar bear
    MoveRight(7000)
    MoveDown(13000)
    RotateLeft()
    MoveUp(10000)

    JumpFromPolarBearToHive()

    if (MoveToHiveSlot(hivePosition) = False) {
        Debug("Hive not found...")
        return False
    }

    return True
}

ExecuteScript() {
    Respawn()

    loop {
        Debug("Moving to pine tree")
        if (MoveToPineTree()) {
            Debug("Walk pine tree pattern")
            WalkPineTreePattern(patternRepeat, subpatternRepeat)
            Debug("Moving to hive")
            if (ToHiveFromPineTree()) {
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

;WalkPineTreePattern(100, 10)

ExecuteScript()

StopScript:
    ResetKeys()
ExitApp
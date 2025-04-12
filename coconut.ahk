#Requires AutoHotkey v1.1.33+
#Persistent

#Include, common.ahk

stopKey := "F2"

global hivePosition := 1
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
    return True

    day := CompareColorAt(3750, 2000, 0x7f7156) && CompareColorAt(1900, 650, 0xd06a42)
    If (day) {
        return True
    }

    night := CompareColorAt(3750, 2000, 0x000000) && CompareColorAt(1900, 650, 0x5d2b0c)
    return night
}

MoveToCoconut() {
    FromHiveToCannon(hivePosition, False)

    MoveRight(4000)

    KeyDown("d")
    Jump()
    Sleep, 2000
    KeyUp("d")

    KeyDown("w")
    Sleep, 200
    Jump()
    Sleep, 3000
    Jump()
    Sleep, 200
    Jump()
    Sleep, 2000
    KeyUp("w")

    MoveLeft(1000)
    MoveUp(3000)

    if (ValidateField()) {
        return True
    }

    return False
}

WalkCoconutPattern(nbLoops, subrepeat) {
    StartFetching()

    move := 90
    patternMoveTime := move * patternWidth
    containerFull := False

    MoveDown(10 * move)
    MoveLeft(10 * move)

    loop, %nbLoops% {
        if (A_Index = 1) {
            PlaceSprinkler()
        }

        Debug("Pattern #" . A_Index . "/" . nbLoops)
        loop, %subrepeat% {

            turnAroundTime := move * patternLength / 5

            MoveLeft(200)

            Loop, 4 {
                MoveUp(patternMoveTime)
                MoveLeft(turnAroundTime)
                PlaceSprinkler()
                MoveDown(patternMoveTime)
                MoveLeft(turnAroundTime)
            }

            PlaceSprinkler()

            Loop, 4 {
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

MoveToHiveSlot()  {
    MoveDown(500)
    return MoveToHiveLeft()
}

ToHiveFromCoconut() {
    StopFetching()

    MoveUp(5000)
    MoveRight(5000)
    MoveDown(5000)
    MoveLeft(8000)
    Sleep, 10000
    MoveDown(5000)
    MoveUp(2000)

    if (MoveToHiveSlot() = False) {
        Debug("Hive not found...")
        return False
    }

    return True
}

ExecuteScript() {
    Respawn()

    loop {
        Debug("Moving to coconut")
        if (MoveToCoconut()) {
            Debug("Walk coconut pattern")
            WalkCoconutPattern(patternRepeat, subpatternRepeat)
            Debug("Moving to hive")
            if (ToHiveFromCoconut()) {
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
;WalkCoconutPattern(patternRepeat, subpatternRepeat)
;ToHiveFromCoconut()
ExecuteScript()

StopScript:
    ResetKeys()
ExitApp
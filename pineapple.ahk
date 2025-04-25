#Requires AutoHotkey v1.1.33+
#Persistent

global hivePosition := 3
global speed := 33.35

global patternRepeat := 20
global subpatternRepeat := 20
global patternLength := 10
global patternWidth := 10

global movespeedFactor := 28 / speed

#Include, common.ahk

CoordMode, Pixel, Screen

WinActivate Roblox

Sleep 200

ValidateField() {
    day := CompareColorAt(170, 1900, 0x006493) && CompareColorAt(2730, 270, 0x958465)
    If (day) {
        Return True
    }

    night := CompareColorAt(170, 1900, 0x006491) && CompareColorAt(2730, 270, 0x000000)
    Return night
}

MoveToPineapple() {
    if (MoveFromHiveToCannon()) {
        JumpToCannonAndFire()
        Sleep 2300
        MoveLeft(5500)
        RotateCamera(4)

        MoveUp(3000)
        MoveLeft(3000)

        If (ValidateField()) {
            Return True
        }
    }

    Return False
}

WalkPineapplePattern(nbLoops, subrepeat) {
    StartFetching()

    move := 100
    patternMoveTime := move * patternWidth
    containerFull := False

    MoveDown(20 * move)
    MoveRight(20 * move)

    loop, %nbLoops% {
        If (A_Index = 1) {
            PlaceSprinkler()
        }

        Debug("Pattern #" . A_Index . "/" . nbLoops)
        loop, %subrepeat% {

            turnAroundTime := move * patternLength / 6

            loop, 2 {
                MoveUp(patternMoveTime)
                MoveLeft(turnAroundTime)
                MoveDown(patternMoveTime)
                MoveLeft(turnAroundTime)
            }

            loop, 2 {
                MoveUp(patternMoveTime)
                PlaceSprinkler()
                MoveRight(turnAroundTime)
                MoveDown(patternMoveTime)
                MoveRight(turnAroundTime)
            }

            If (IsContainerFull()) {
                containerFull := True
                break
            }

            MoveUp(patternMoveTime)

            loop, 2 {
                MoveLeft(patternMoveTime)
                MoveDown(turnAroundTime)
                MoveRight(patternMoveTime)
                MoveDown(turnAroundTime)
            }

            MoveLeft(patternMoveTime / 3)
            MoveUp(patternMoveTime * 1.5)
            MoveDown(200)

            loop, 2 {
                MoveRight(patternMoveTime)
                MoveDown(turnAroundTime)
                MoveLeft(patternMoveTime)
                MoveDown(turnAroundTime)
            }

            MoveRight(500)

            If (IsContainerFull()) {
                containerFull := True
                break
            }
        }

        If (containerFull || A_Index = nbLoops) {
            MoveUp(5000)
            MoveRight(5000)
            break
        }
    }
}

ToHiveFromPineapple() {
    global hivePosition

    StopFetching()

    RotateCamera(4)

    ; Walk to switch next to blue cannon
    ; Give enough time to disable haste
    MoveUp(15000)

    MoveDown(800)
    MoveRight(2000)
    KeyDown("d")
    Jump()
    Sleep, 300
    KeyUp("d")
    Sleep, 500
    FireCannon()
    Sleep 2500
    MoveUp(5000)

    If (MoveToHiveSlot(hivePosition) = False) {
        Debug("Hive not found...")
        Return False
    }

    Return True
}

ExecutePineappleScript() {
    Respawn()

    Loop {
        Debug("Moving to pineapple")
        If (MoveToPineapple()) {
            Debug("Walk pineapple pattern")
            ResetSprinklers()
            WalkPineapplePattern(patternRepeat, subpatternRepeat)
            Debug("Moving to hive")
            If (ToHiveFromPineapple()) {
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

ExecutePineappleScript()
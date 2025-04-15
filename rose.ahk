#Requires AutoHotkey v1.1.33+
#Persistent

; Dynamic settings
global hivePosition := 1
global speed := 33.3
global patternRepeat := 10
global subpatternRepeat := 10

#Include, common.ahk

; Field settings
global patternLength := 7
global patternWidth := 7

CoordMode, Pixel, Screen

WinActivate Roblox

Sleep 200

ValidateField() {
    day := CompareColorAt(1818, 245, 0x070c6c) && CompareColorAt(2800, 2000, 0xfdfdfd)
    If (day) {
        return True
    }

    dayCloseup := CompareColorAt(2800, 1940, 0x00003b) && CompareColorAt(500, 110, 0x050a5c)
    If (dayCloseup) {
        return True
    }

    night := CompareColorAt(1818, 245, 0x070c6c) && CompareColorAt(2800, 2000, 0x6e6e6e)
    return night
}

MoveToRoseField() {
    FromHiveToCannon(hivePosition)

    MoveRight(300)
    DeployChute()
    Sleep 2300
    SendSpace()
    Sleep 500
    MoveRight(1000)
    MoveUp(2500)
    MoveRight(3500)

    return True
}

WalkRosePattern(nbLoops, subrepeat) {
    StartFetching()

    move := 100
    patternMoveTime := move * patternWidth
    containerFull := False

    MoveDown(1000)
    MoveLeft(1000)

    loop, %nbLoops% {
        If (A_Index = 1) {
            PlaceSprinkler()
        }

        Debug("Pattern #" . A_Index . "/" . nbLoops)
        loop, %subrepeat% {

            turnAroundTime := move * patternLength / 4

            loop, 2 {
                MoveUp(patternMoveTime)
                MoveLeft(turnAroundTime * 0.5)
                MoveDown(patternMoveTime)
                MoveLeft(turnAroundTime)
            }

            loop, 2 {
                MoveUp(patternMoveTime)
                MoveRight(turnAroundTime * 0.5)
                MoveDown(patternMoveTime)
                PlaceSprinkler()
                MoveRight(turnAroundTime)
            }

            If (IsContainerFull()) {
                containerFull := True
                break
            }

            MoveUp(patternMoveTime * 3)
            MoveDown(200)

            loop, 2 {
                MoveLeft(patternMoveTime)
                MoveDown(turnAroundTime * 0.5)
                MoveRight(patternMoveTime)
                MoveDown(turnAroundTime)
            }

            MoveLeft(patternMoveTime / 3)
            MoveUp(patternMoveTime * 1.5)
            MoveDown(200)

            loop, 2 {
                MoveRight(patternMoveTime)
                MoveDown(turnAroundTime * 0.5)
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

ToHiveFromField() {
    global hivePosition

    StopFetching()

    ; Walk to switch next to blue cannon
    ; Give enough time to disable haste
    MoveUp(5000)
    MoveRight(5000)

    MoveDown(5000)
    RotateCamera(4)

    Loop, 5 {
        MoveRight(800)
        MoveUp(800)
    }

    MoveUp(12000)
    MoveRight(13000)
    RotateCamera(4)
    MoveUp(10000)

    JumpFromPolarBearToHive()

    if (MoveToHiveSlot(hivePosition) = False) {
        Debug("Hive not found...")
        return False
    }

    return True
}

ExecuteRoseScript() {
    Respawn()

    Loop {
        Debug("Moving to rose field")
        If (MoveToRoseField()) {
            Debug("Walk rose pattern")
            WalkRosePattern(patternRepeat, subpatternRepeat)
            Debug("Moving to hive")
            If (ToHiveFromField()) {
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

ExecuteRoseScript()

StopScript:
    ResetKeys()
ExitApp
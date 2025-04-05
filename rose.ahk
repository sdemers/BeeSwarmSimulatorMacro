#Requires AutoHotkey v1.1.33+
#Persistent

#Include, common.ahk

stopKey := "F2"

; Dynamic settings
global hivePosition := 2
global speed := 32.2
global patternRepeat := 10
global subpatternRepeat := 5

; Field settings
global patternLength := 7
global patternWidth := 7

global movespeedFactor := 28 / speed

Hotkey %stopKey%, StopScript

CoordMode, Pixel, Screen

WinActivate Roblox

Sleep 200

ToolTip Press F2 to stop script, 50, 400, 1

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

MoveToField() {
    FromHiveToCannon(hivePosition)

    MoveRight(300)
    DeployChute()
    Sleep 2300
    SendSpace()
    Sleep 500
    MoveRight(1000)
    MoveUp(2500)
    MoveRight(3500)

    if (ValidateField()) {
        return True
    }

    return False
}

WalkPattern(nbLoops, subrepeat) {
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

MoveToHiveSlot(slot) {
    ; We should be facing the wall at slot #3

    MoveDown(500)

    If (slot < 3) {
        Return MoveToHiveRight()
    }
    else {
        Return MoveToHiveLeft()
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

ExecuteScript() {
    Respawn()

    Loop {
        Debug("Moving to rose field")
        If (MoveToField()) {
            Debug("Walk rose pattern")
            WalkPattern(patternRepeat, subpatternRepeat)
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

ExecuteScript()

StopScript:
    ResetKeys()
ExitApp
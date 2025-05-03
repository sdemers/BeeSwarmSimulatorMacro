#Requires AutoHotkey v1.1.33+
#Persistent

#Include, config.ahk
#Include, common.ahk

CoordMode, Pixel, Screen

WinActivate Roblox

Sleep 200

ValidateField() {
    return (CompareColorAt(170, 1900, 0x006493) or CompareColorAt(170, 1900, 0x006491) or CompareColorAt(170, 1900, 0x006593)) && (CompareColorAt(2730, 270, 0x958465) or CompareColorAt(2730, 270, 0x946736) or CompareColorAt(2730, 270, 0x946736) or CompareColorAt(2730, 270, 0x000000))
}

MoveToPineapple() {
    if (MoveFromHiveToCannon()) {
        JumpToCannonAndFire()
        Sleep 2500
        MoveLeft(7000)
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
    stopFetching := False

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

            If (ShouldStopFetching()) {
                stopFetching := True
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

            If (ShouldStopFetching()) {
                stopFetching := True
                break
            }
        }

        If (stopFetching || A_Index = nbLoops) {
            MoveUp(5000)
            MoveRight(5000)
            break
        }
    }
}

ToHiveFromPineapple() {
    global hivePosition

    MoveUp(5000)
    MoveRight(10000)

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
    if (ShouldGoToWealthClock()) {
        ExecuteWealthClockScript()
    }
    Respawn()

    Loop {
        Debug("Moving to pineapple")
        If (MoveToPineapple()) {
            Debug("Walk pineapple pattern")
            ResetSprinklers()
            WalkSpiderPattern(patternRepeat, subpatternRepeat, move:= 70)
            Debug("Moving to hive")
            If (ToHiveFromPineapple()) {
                Debug("Convert honey")
                ConvertHoney()
                if (ShouldGoToWealthClock()) {
                    ExecuteWealthClockScript()
                    Respawn()
                }
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
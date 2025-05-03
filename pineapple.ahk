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

        TwoKeyPress("w", "a", 5000)

        If (ValidateField()) {
            Return True
        }
    }

    Return False
}

ToHiveFromPineapple() {
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

PlacePineappleSprinklers() {
    ResetSprinklers()
    sprinklerPlacementDelay := 0
    MoveDown(600)
    MoveRight(600)
    PlaceSprinkler()
    MoveDown(600)
    PlaceSprinkler()
    MoveRight(600)
    PlaceSprinkler()
    MoveUp(600)
    PlaceSprinkler()
    MoveLeft(1000)
    MoveUp(1000)
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
            PlacePineappleSprinklers()
            WalkSpiderPattern(patternRepeat, subpatternRepeat, True, 70, False)
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
#Requires AutoHotkey v1.1.33+
#Persistent

#Include, config.ahk
#Include, common.ahk

ValidatePineappleField() {
    return (CompareColorAt(170, 1900, 0x006493) or CompareColorAt(170, 1900, 0x006491) or CompareColorAt(170, 1900, 0x006593)) && (CompareColorAt(2730, 270, 0x958465) or CompareColorAt(2730, 270, 0x946736) or CompareColorAt(2730, 270, 0x946736) or CompareColorAt(2730, 270, 0x000000))
}

MoveToPineapple() {
    if (MoveFromHiveToCannon()) {
        JumpToCannonAndFire()
        Sleep 2500
        MoveLeft(7000)
        RotateCamera(4)

        TwoKeyPress("w", "a", 5000)

        If (ValidatePineappleField()) {
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
    MoveUp(12000)

    MoveRight(3000)
    MoveUp(500)
    MoveDown(1000)
    MoveByChute()
    TwoKeyPress("a", "s", 100)

    FireCannon()
    Sleep 2500
    ZoomOut()
    MoveUp(5000)

    If (MoveToHiveSlot(g_hivePosition) = False) {
        Debug("Hive not found...")
        Return False
    }

    Return True
}

PlacePineappleSprinklers() {
    ResetSprinklers()
    g_sprinklerPlacementDelay := 0
    MoveDown(600)
    MoveRight(600)
    PlaceSprinkler(g_sprinklers)
    MoveDown(600)
    PlaceSprinkler(g_sprinklers)
    MoveRight(600)
    PlaceSprinkler(g_sprinklers)
    MoveUp(600)
    PlaceSprinkler(g_sprinklers)
    MoveLeft(1000)
    MoveUp(1000)
}

ExecutePineappleScript() {

    Respawn()

    Loop {
        Debug("Moving to pineapple")
        If (MoveToPineapple()) {
            Debug("Walk pineapple pattern")
            PlacePineappleSprinklers()
            RotateCamera(1)
            WalkSpiderPattern(g_patternRepeat, g_subpatternRepeat, True, 70, False)
            RotateCamera(-1)
            Debug("Moving to hive")
            If (ToHiveFromPineapple()) {
                Debug("Convert honey")
                ConvertHoneyThenPlantersAndClock()
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

;ExecutePineappleScript()
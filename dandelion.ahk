#Requires AutoHotkey v1.1.33+
#Persistent

#Include, common.ahk

MoveToDandelion() {
    if (MoveFromHiveToCannon()) {
        RotateCamera(4)
        TwoKeyPress("w", "d", 6000)
        return True
    }

    return False
}

WalkElolTopLeftDandPattern() {

    StartFetching()

    move := 1000

    stopFetching := False

    Send, Shift

    TwoKeyPress("w", "d", 1500)

    Loop {
        driftBack := Mod(A_Index, 5) == 0
        reposition := Mod(A_Index, 15) == 0

        Send, Shift
        StartFetching()
        Send, Shift

        Loop, 2 {
            MoveRight(move * 0.72)
            MoveUp(move * 0.1)
            MoveLeft(move * 0.72)
            MoveUp(move * 0.1)
        }

        if (ShouldStopFetching()) {
            stopFetching := True
            break
        }

        Loop, 2 {
            MoveRight(move * 0.72)
            MoveDown(move * 0.1)
            if (driftBack) {
                MoveLeft(move * 0.8)
            } else {
                MoveLeft(move * 0.72)
            }
            MoveDown(move * 0.1)
        }

        if (ShouldStopFetching()) {
            stopFetching := True
            break
        }

        if (reposition) {
            TwoKeyPress("a", "s", 2000)
            TwoKeyPress("w", "d", 700)
        }
    }

    Send, Shift
}

WalkDandelionPattern(patternRepeat, subrepeat) {

    RotateCamera(4)
    ; TwoKeyPress("w", "a", 1000)
    MoveLeft(2700)
    MoveDown(400)

    PlaceSprinkler(g_sprinklers)
    ;MoveLeft(500)
    ;PlaceSprinkler(g_sprinklers)

    RotateCamera(-2)
    Send, Shift
    MoveDown(4000)
    MoveLeft(2000)
    Send, Shift

    WalkElolTopLeftDandPattern()
}

ToHiveFromDandelion() {
    global g_hivePosition

    StopFetching()

    TwoKeyPress("w", "a", 2000)
    MoveLeft(2000)
    MoveUp(2000)

    MoveDown(400)
    KeyDown("w")
    HyperSleep(200)
    Jump()

    HyperSleep(3000)
    KeyUp("w")
    MoveRight(1200)
    MoveUp(1500)

    return MoveToHiveRight()
}

ExecuteDandelionScript() {
    Respawn(True)

    loop {
        Debug("Moving to dandelion")
        if (MoveToDandelion()) {
            Debug("Walk dandelion pattern")
            ResetSprinklers()
            WalkDandelionPattern(g_patternRepeat, g_subpatternRepeat)
            Debug("Moving to hive")
            if (ToHiveFromDandelion()) {
                Debug("Convert honey")
                ConvertHoneyThenPlantersAndClock()
            } else {
                Debug("Respawning")
                Respawn(True)
            }
        }
        else {
            Debug("Respawning")
            Respawn(True)
        }
    }
}
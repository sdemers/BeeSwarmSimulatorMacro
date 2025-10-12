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

WalkDandelionPattern(patternRepeat, subrepeat) {

    move := 500
    lateral := 60
    stopFetching := False

    ZoomOut()
    MoveRight(1000)
    PlaceSprinkler(g_sprinklers)

    Loop, %patternRepeat% {
        MoveRight(1000)
        MoveLeft(300)
        MoveDown(800)

        if (A_Index > 1) {
            PlaceSprinkler(g_sprinklers)
        }

        Loop, 10 {
            StartFetching()
            Loop, 2 {
                MoveDown(move)
                MoveLeft(lateral)
                MoveUp(move)
                MoveLeft(lateral)
            }

            Loop, 2 {
                MoveDown(move)
                MoveRight(lateral)
                MoveUp(move)
                MoveRight(lateral)
            }

            if (ShouldStopFetching()) {
                stopFetching := True
                Break
            }
        }

        if (stopFetching || A_Index = patternRepeat) {
            Debug("", 2)
            Debug("", 3)
            Break
        }

        MoveLeft(200)
        TwoKeyPress("w", "d", 500)
        MoveUp(2000)
        MoveRight(500)
    }
}

ToHiveFromDandelion() {
    global g_hivePosition

    StopFetching()

    MoveLeft(1000)
    MoveUp(5000)
    MoveRight(5000)

    RotateCamera(4)
    MoveUp(12000)
    MoveRight(300)
    MoveDown(200)

    return MoveToHiveSlot(g_hivePosition, 5)
}

ExecuteDandelionScript() {
    Respawn()

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
                Respawn()
            }
        }
        else {
            Debug("Respawning")
            Respawn()
        }
    }
}
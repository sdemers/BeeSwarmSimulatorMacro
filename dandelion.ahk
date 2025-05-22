#Requires AutoHotkey v1.1.33+
#Persistent

#Include, common.ahk

WinActivate Roblox

Sleep 200

MoveToDandelion() {
    if (MoveFromHiveToCannon()) {
        JumpToCannonAndFire()

        Sleep 500
        DeployChute()
        MoveUp(2500)
        ReleaseChute()
        Sleep, 2000

        RotateLeft()

        MoveRight(1500)
        MoveUp(1500)

        return True
    }

    return False
}

WalkDandelionPattern(patternRepeat, subrepeat) {

    move := 500
    lateral := 60
    stopFetching := False

    PlaceSprinkler(g_sprinklers)
    MoveRight(1000)
    MoveUp(4000)

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
    if (ShouldGoToWealthClock()) {
        ExecuteWealthClockScript()
    }

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
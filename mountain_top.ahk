#Requires AutoHotkey v1.1.33+
#Persistent

#Include, common.ahk

MoveToMountainTop() {
    if (MoveFromHiveToCannon()) {
        JumpToCannonAndFire()
        Sleep 3000
        PlaceSprinkler(g_sprinklers)
    }

    return True
}

WalkMountainTopPattern(g_patternRepeat) {
    RotateCamera(4)

    MoveUp(4000)
    MoveRight(2000)

    length := 600
    turn := 50
    stop := false

    Loop, %g_patternRepeat% {

        MoveDown(700)
        MoveLeft(400)

        Loop, 8 {
            Loop, 3 {
                StartFetching()
                MoveDown(length)
                MoveLeft(turn)
                MoveUp(length)
                MoveLeft(turn)
            }

            Loop, 3 {
                StartFetching()
                MoveDown(length)
                MoveRight(turn)
                MoveUp(length)
                MoveRight(turn)
            }

            if (ShouldStopFetching()) {
                stop := True
                break
            }
        }

        MoveLeft(300)
        MoveUp(300)
        TwoKeyPress("w", "d", 1000)
        MoveUp(1000)
        MoveRight(1000)

        if (stop) {
            break
        }
    }
}

ToHiveFromMountainTop() {
    global g_hivePosition

    StopFetching()

    MoveRight(1000)
    MoveUp(2000)
    RotateCamera(4)
    Jump()
    MoveUp(1000)

    Loop, 3 {
        SendSpace()
        Sleep, 200
        SendSpace()
        Sleep, 1200
    }

    SendSpace()
    Sleep, 200
    SendSpace()

    Sleep, 2000
    TwoKeyPress("w", "d", 10000)

    MoveDown(1000)
    TwoKeyPress("w", "d", 2000)

    MoveDown(450)
    return MoveToHiveLeft()
}

ExecuteMountainTopScript() {
    if (ShouldGoToWealthClock()) {
        ExecuteWealthClockScript()
    }

    Respawn()

    loop {
        Debug("Moving to mountain top")
        if (MoveToMountainTop()) {
            Debug("Walk mountain top pattern")
            ResetSprinklers()
            WalkMountainTopPattern(g_patternRepeat)
            Debug("Moving to hive")
            if (ToHiveFromMountainTop()) {
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

; WinActivate Roblox
; Sleep 200
; ToHiveFromMountainTop()

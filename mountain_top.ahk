#Requires AutoHotkey v1.1.33+
#Persistent

#Include, common.ahk
#Include, pine tree.ahk

MoveToMountainTop() {
    if (MoveFromHiveToCannon()) {
        JumpToCannonAndFire()
        Sleep 3000
    }

    return True
}

WalkMountainTopPattern(g_patternRepeat) {
    RotateCamera(4)

    ResetSprinklers()

    PlaceSprinkler(g_sprinklers)
    MoveUp(600)
    PlaceSprinkler(g_sprinklers)
    MoveRight(600)
    PlaceSprinkler(g_sprinklers)
    MoveDown(600)
    PlaceSprinkler(g_sprinklers)

    MoveUp(4000)
    MoveRight(2000)

    length := 400
    turn := 60
    stop := false

    Loop, %g_patternRepeat% {

        MoveDown(700)
        MoveLeft(300)

        Loop, 6 {
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

            if (ShouldStopFetching() or A_Min < 15 or A_Min = 59) {
                stop := True
                break
            }
        }

        MoveLeft(300)
        MoveUp(300)
        TwoKeyPress("w", "d", 1000)
        MoveUp(1000)
        MoveRight(500)
        MoveUp(500)

        if (stop) {
            break
        }
    }
}

ToHiveFromMountainTop() {
    global g_hivePosition

    StopFetching()

    MoveUp(1000)
    MoveLeft(5000)
    MoveDown(8000)
    RotateCamera(4)

    Jump()
    HyperSleep(400)
    Jump()
    HyperSleep(1000)
    Jump()
    HyperSleep(400)
    Jump()
    MoveUp(6500)
    ReleaseChute()

    MoveUp(3000)
    MoveRight(1000)

    if (MoveToHiveRight() = False) {
        Debug("Hive not found...")
        return False
    }

    return True
}

ExecuteMountainTop() {
    Debug("Moving to mountain top")
    if (MoveToMountainTop()) {
        Debug("Walk mountain top pattern")
        ResetSprinklers()
        WalkMountainTopPattern(g_patternRepeat)
        Debug("Moving to hive")
        if (ToHiveFromMountainTop()) {
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

ExecuteMountainTopScript() {
    Respawn()

    loop {
        if (A_Min > 15) {
            ExecuteMountainTop()
        }
        Else {
            ExecutePineTree()
        }
    }
}

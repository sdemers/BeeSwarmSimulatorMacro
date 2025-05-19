#Requires AutoHotkey v1.1.33+
#Persistent

global g_hivePosition := 5
global g_speed := 33.3
global g_patternRepeat := 10
global g_patternWidth := 8
global g_patternLength := 10

#Include, common.ahk

WinActivate Roblox

Sleep 200

MoveToMountainTop() {
    if (MoveFromHiveToCannon()) {
        JumpToCannonAndFire()
        FromHiveToCannon(g_hivePosition)
        Sleep 3000
        PlaceSprinkler(g_sprinklers)
    }

    return True
}

WalkMountainTopPattern(g_patternRepeat) {
    RotateCamera(4)

    MoveUp(4000)
    MoveRight(2000)

    length := 1200
    turn := 50

    Loop, %g_patternRepeat% {

        MoveDown(1000)

        Loop, 4 {
            StartFetching()
            MoveDown(length)
            MoveLeft(turn)
            MoveUp(length)
            MoveLeft(turn)
        }

        Loop, 4 {
            StartFetching()
            MoveDown(length)
            MoveRight(turn)
            MoveUp(length)
            MoveRight(turn)
        }

        if (ShouldStopFetching()) {
            break
        }

        MoveLeft(500)
        MoveUp(1500)
        MoveRight(1000)
    }
}

ToHiveFromMountainTop() {
    global g_hivePosition

    StopFetching()

    MoveDown(8000)
    MoveRight(5000)
    MoveUp(5000)
    MoveRight(2000)
    MoveUp(2000)
    MoveRight(1500)
    MoveLeft(1500)
    MoveUp(5000)

    JumpFromPolarBearToHive()

    MoveToHiveSlot(g_hivePosition)
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

;ExecuteMountainTopScript()

;WalkPineTreePattern(10, 10, 2, 400)

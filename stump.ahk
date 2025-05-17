#Requires AutoHotkey v1.1.33+
#Persistent

#Include, config.ahk
#Include, common.ahk

WinActivate Roblox

Sleep 200

MoveToStump() {
    if (MoveFromHiveToCannon()) {
        JumpToCannonAndFire()
        Sleep 1600

        DeployChute()
        RotateCamera(2)
        MoveUp(5000)
        Sleep, 3000
        MoveDown(1600)
        MoveLeft(1500)

        return True
    }
}

WalkStumpPattern() {
    PlaceSprinkler(g_sprinklers)
    Loop {
        if (ShouldStopFetching()) {
            break
        }
        StartFetching()

        if (Mod(A_Index, 300) = 0) {
            RotateCamera(1)
            RotateCamera(-1)
        }
        Sleep, 1000
    }
}

ToHiveFromStump() {
    global g_hivePosition

    StopFetching()

    RotateCamera(-2)
    MoveRight(2500)
    MoveUp(5000)
    KeyDown("d")
    Jump()
    Sleep, 400
    KeyUp("d")
    MoveUp(6000)

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

    If (MoveToHiveSlot(g_hivePosition) = False) {
        Debug("Hive not found...")
        Return False
    }

    MoveToHiveSlot(g_hivePosition)
}

ExecuteStumpScript() {
    if (ShouldGoToWealthClock()) {
        ExecuteWealthClockScript()
    }

    Respawn()

    loop {
        Debug("Moving to stump")
        if (MoveToStump()) {
            Debug("Walk stump pattern")
            ResetSprinklers()
            WalkStumpPattern()
            Debug("Moving to hive")
            if (ToHiveFromStump()) {
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

;ExecuteStumpScript()
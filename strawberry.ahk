#Requires AutoHotkey v1.1.33+
#Persistent

#Include, config.ahk
#Include, common.ahk

CoordMode, Pixel, Screen

WinActivate Roblox

Sleep 200

MoveToStrawberry() {
    if (MoveFromHiveToCannon()) {
        JumpToCannonAndFire()

        MoveRight(170)
        Sleep, 400
        DeployChute()
        Sleep, 600
        MoveRight(100)
        Sleep, 1000
        SendSpace()
        Sleep 1500
        RotateCamera(4)
    }

    return True
}

ToHiveFromStrawberry() {
    global g_hivePosition

    StopFetching()

    ; Move next to the spider field
    MoveUp(5000)
    MoveRight(5000)

    ; Move towards the hives, turn left then move to the hives
    ; Give time for the haste to expire
    MoveDown(5000)
    RotateCamera(4)
    MoveUp(15000)
    MoveLeft(700)
    MoveUp(6000)

    if (MoveToHiveSlot(g_hivePosition) = False) {
        Debug("Hive not found...")
        return False
    }

    return True
}

ExecuteStrawberryScript() {
    if (ShouldGoToWealthClock()) {
        ExecuteWealthClockScript()
    }
    Respawn()

    loop {
        Debug("Moving to strawberry")
        if (MoveToStrawberry()) {
            Debug("Walk pine tree pattern")
            ResetSprinklers()
            MoveLeft(3000)
            MoveUp(3000)
            WalkSpiderPattern(g_patternRepeat, g_subpatternRepeat)
            Debug("Moving to hive")
            if (ToHiveFromStrawberry()) {
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

;ExecuteStrawberryScript()
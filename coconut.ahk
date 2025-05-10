#Requires AutoHotkey v1.1.33+
#Persistent

#Include, wealth_clock.ahk
#Include, config.ahk
#Include, common.ahk

CoordMode, Pixel, Screen

WinActivate Roblox

Sleep 200

ValidateCoconutField() {
    return True

    day := CompareColorAt(3750, 2000, 0x7f7156) && CompareColorAt(1900, 650, 0xd06a42)
    If (day) {
        return True
    }

    night := CompareColorAt(3750, 2000, 0x000000) && CompareColorAt(1900, 650, 0x5d2b0c)
    return night
}

MoveToCoconut() {
    FromHiveToCannon(g_hivePosition)

    MoveUp(300)
    DeployChute()
    MoveUp(300)
    Sleep, 4000
    MoveUp(3500)
    MoveRight(10000)
    MoveUp(1000)

    return True
}

ToHiveFromCoconut() {
    StopFetching()

    MoveUp(5000)
    MoveRight(5000)
    MoveDown(5000)
    MoveLeft(8000)
    Sleep, 10000
    MoveDown(5000)
    MoveUp(2000)
    MoveDown(500)

    if (MoveToHiveLeft() = False) {
        Debug("Hive not found...")
        return False
    }

    return True
}

ExecuteCoconutScript() {
    if (ShouldGoToWealthClock()) {
        ExecuteWealthClockScript()
    }

    Respawn()

    loop {
        Debug("Moving to coconut")
        if (MoveToCoconut()) {
            Debug("Walk coconut pattern")
            ZoomOut()
            ResetSprinklers()
            WalkRosePattern(g_patternRepeat, g_subpatternRepeat)
            Debug("Moving to hive")
            if (ToHiveFromCoconut()) {
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

;ExecuteCoconutScript()

#Requires AutoHotkey v1.1.33+
#Persistent

#Include, config.ahk
#Include, common.ahk

CoordMode, Pixel, Screen

WinActivate Roblox

Sleep 200

ValidateRoseField() {
    day := CompareColorAt(1818, 245, 0x070c6c) && CompareColorAt(2800, 2000, 0xfdfdfd)
    If (day) {
        return True
    }

    dayCloseup := CompareColorAt(2800, 1940, 0x00003b) && CompareColorAt(500, 110, 0x050a5c)
    If (dayCloseup) {
        return True
    }

    night := CompareColorAt(1818, 245, 0x070c6c) && CompareColorAt(2800, 2000, 0x6e6e6e)
    return night
}

MoveToRoseField() {
    if (MoveFromHiveToCannon()) {
        JumpToCannonAndFire()
        MoveRight(300)
        DeployChute()
        Sleep 2300
        SendSpace()
        Sleep 500
        RotateCamera(4)
        TwoKeyPress("w", "d", 3000)
        MoveRight(1000)
        MoveUp(1000)
        ;MoveRight(1000)
        ;MoveUp(2500)
        ;MoveRight(3500)
        return True
    }

    return False
}

ToHiveFromRoseField() {
    global g_hivePosition

    TwoKeyPress("w", "d", 5000)
    Loop, 6 {
        MoveLeft(500)
        MoveUp(500)
    }

    StopFetching()

    TwoKeyPress("w", "d", 3000)

    MoveUp(12000)
    MoveRight(13000)
    RotateCamera(4)
    MoveUp(10000)

    JumpFromPolarBearToHive()

    if (MoveToHiveSlot(g_hivePosition) = False) {
        Debug("Hive not found...")
        return False
    }

    return True
}

ExecuteRoseScript() {
    if (ShouldGoToWealthClock()) {
        ExecuteWealthClockScript()
    }
    Respawn()

    Loop {
        Debug("Moving to rose field")
        If (MoveToRoseField()) {
            Debug("Walk rose pattern")
            ResetSprinklers()
            WalkSpiderPattern(g_patternRepeat, g_subpatternRepeat, left := False, move:= 70)
            Debug("Moving to hive")
            If (ToHiveFromRoseField()) {
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

;ExecuteRoseScript()
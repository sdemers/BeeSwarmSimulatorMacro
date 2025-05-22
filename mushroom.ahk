#Requires AutoHotkey v1.1.33+
#Persistent

#Include, config.ahk
#Include, common.ahk

CoordMode, Pixel, Screen

WinActivate Roblox

Sleep 200

MoveToMushroom(g_hivePosition) {
    if (MoveFromHiveToCannon()) {
        JumpToCannonAndFire()

        Sleep, 100
        DeployChute()
        MoveDown(300)
        ReleaseChute()
        Sleep, 500
        RotateCamera(4)

        MoveUp(4000)
        MoveLeft(4000)

        return True
    }

    return False
}

ToHiveFromMushroom() {

    StopFetching()

    MoveUp(2000)
    MoveRight(10000)
    RotateCamera(4)

    MoveUp(5000)
    MoveRight(200)
    MoveUp(10000)

    if (MoveToHiveSlot(g_hivePosition, 5) = False) {
        Debug("Hive not found...")
        return False
    }

    return True
}

ExecuteMushroomScript() {
    if (ShouldGoToWealthClock()) {
        ExecuteWealthClockScript()
    }
    Respawn()

    loop {
        Debug("Moving to mushroom")
        if (MoveToMushroom(g_hivePosition)) {
            Debug("Walk mushroom pattern")
            ZoomOut()
            MoveUp(2000)
            MoveLeft(3000)
            ResetSprinklers()
            WalkSpiderPattern(g_patternRepeat, g_subpatternRepeat)
            Debug("Moving to hive")
            if (ToHiveFromMushroom()) {
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

;ExecuteMushroomScript()
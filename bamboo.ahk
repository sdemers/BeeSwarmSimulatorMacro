#Requires AutoHotkey v1.1.33+
#Persistent

#include, config.ahk
#Include, common.ahk

MoveToBamboo() {
    if (MoveFromHiveToCannon()) {
        JumpToCannonAndFire()
        Sleep 500
        MoveLeft(300)
        Sleep 150
        DeployChute()
        Sleep 3000
        SendSpace()
        Sleep 500
        RotateCamera(4)

        ZoomOut()
        StartFetching()

        MoveUp(3000)
        MoveLeft(3000)

        ; Give time for the bees to arrive and not being killed by the bugs
        loop, 2 {
            MoveDown(2000)
            MoveUp(2000)
        }

        return True
    }

    return False
}

ToHiveFromBamboo() {
    StopFetching()

    ; Move to the wall on the right side
    MoveUp(3000)
    MoveLeft(5000)

    ; Move next to spider
    MoveDown(600)
    MoveLeft(10000)

    RotateCamera(4)
    MoveDown(1000)

    ; Move to hive
    MoveUp(6000)
    MoveRight(600)
    MoveUp(12000)

    if (MoveToHiveSlot(g_hivePosition) = False) {
        Debug("Hive not found...")
        return False
    }

    return True
}

ExecuteBambooScript() {

    if (ShouldGoToWealthClock()) {
        ExecuteWealthClockScript()
    }

    Respawn()

    loop {
        Debug("Moving to bamboo")
        if (MoveToBamboo()) {
            Debug("Walk bamboo pattern")
            ZoomOut()
            ResetSprinklers()
            ;RotateCamera(-1)
            WalkBlueFlowerPattern(g_patternRepeat, g_subpatternRepeat, 2, 200, 50, False)
            ;WalkSpiderPattern(g_patternRepeat, g_subpatternRepeat, left := False)
            ;RotateCamera(1)
            Debug("Moving to hive")
            if (ToHiveFromBamboo()) {
                Debug("Convert honey")
                ConvertHoney()
                if (ShouldGoToWealthClock()) {
                    ExecuteWealthClockScript()
                    Respawn()
                }
            } else {
                Debug("Respawning")
                Respawn()ddd
            }
        }
        else {
            Debug("Respawning")
            Respawn()
        }
    }
}
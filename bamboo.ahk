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

    MoveDown(4000)

    RotateCamera(4)
    MoveRight(12000)
    MoveUp(2000)

    DeployChute()
    HyperSleep(350)
    ReleaseChute()

    MoveUp(15000)
    MoveLeft(1000)
    MoveUp(1500)
    MoveRight(1000)

    if (MoveToHiveSlot(g_hivePosition, 1) = False) {
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
            MoveRight(4000)
            MoveUp(2000)
            WalkElolTopRightPattern()
            ;WalkBlueFlowerPattern(g_patternRepeat, g_subpatternRepeat, 2, 200, 50, False)
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
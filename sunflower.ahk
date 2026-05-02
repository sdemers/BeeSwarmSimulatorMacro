#Requires AutoHotkey v1.1.33+
#Persistent

#Include, config.ahk
#Include, common.ahk

MoveToSunflower(hive) {
    if (MoveFromHiveToCannon()) {
        MoveDown(2000)
        TwoKeyPress("s", "d", 4000)

        RotateCamera(-2)
        MoveUp(1000)
        MoveLeft(4000)

        return True
    }

    return False
}

ToHiveFromSunflower() {
    global g_hivePosition

    StopFetching()

    MoveRight(2000)
    TwoKeyPress("w", "d", 2500)
    MoveUp(2000)
    MoveLeft(500)
    TwoKeyPress("w", "d", 1000)
    KeyDown("w")
    HyperSleep(1000)
    Jump()
    HyperSleep(2000)
    KeyUp("w")

    KeyDown("a")
    KeyDown("s")
    Jump(300)
    DeployChute()
    HyperSleep(400)
    ReleaseChute()
    HyperSleep(1000)
    KeyUp("a")
    KeyUp("s")

    MoveUp(5000)
    MoveRight(5000)

    if (MoveToHiveSlotFrom1(g_hivePosition) = False) {
        Debug("Hive not found...")
        return False
    }

    return True
}

ExecuteSunflowerScript() {
    ActivateFieldBooster()

    loop {
        Debug("Moving to Sunflower")
        if (MoveToSunflower(g_hivePosition)) {
            Debug("Walk Sunflower pattern")
            RotateCamera(2)
            ResetSprinklers()
            WalkElolTopRightPatternSunflower(550)
            ;WalkBlueFlowerPattern(g_patternRepeat, g_subpatternRepeat, 3, 500, 60, False)
            Debug("Moving to hive")
            if (ToHiveFromSunflower()) {
                Debug("Convert honey")
                ConvertHoneyThenPlantersAndClock()
            } else {
                Debug("Respawning")
                Respawn(True)
            }
        }
        else {
            Debug("Respawning")
            Respawn(True)
        }
        ActivateFieldBooster()
    }
}

;ExecuteSunflowerScript()
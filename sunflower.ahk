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

    MoveUp(5000)
    MoveLeft(15000)
    MoveDown(1000)
    MoveLeft(3000)
    MoveDown(1300)
    RotateLeft()
    MoveUp(1000)
    MoveRight(1000)

    if (MoveToHiveSlotFrom1(g_hivePosition) = False) {
        Debug("Hive not found...")
        return False
    }

    return True
}

ExecuteSunflowerScript() {
    if (ShouldGoToWealthClock()) {
        ExecuteWealthClockScript()
    }
    Respawn()

    loop {
        Debug("Moving to Sunflower")
        if (MoveToSunflower(g_hivePosition)) {
            Debug("Walk Sunflower pattern")
            RotateCamera(2)
            ResetSprinklers()
            WalkElolTopRightPattern()
            RotateCamera(-2)
            ;WalkBlueFlowerPattern(g_patternRepeat, g_subpatternRepeat, 3, 500, 60, False)
            Debug("Moving to hive")
            if (ToHiveFromSunflower()) {
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

;ExecuteSunflowerScript()
#Requires AutoHotkey v1.1.33+
#Persistent

#Include, common.ahk

MoveToMushroom(g_hivePosition) {
    if (MoveFromHiveToCannon()) {
        RotateCamera(4)
        ZoomOut()
        TwoKeyPress("w", "d", 5000)

        MoveUp(10000)
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
            ResetSprinklers()
            ZoomOut()
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
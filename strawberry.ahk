#Requires AutoHotkey v1.1.33+
#Persistent

#Include, config.ahk
#Include, common.ahk

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
            WalkElolTopLeftPattern()
            ;WalkSpiderPattern(g_patternRepeat, g_subpatternRepeat)
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
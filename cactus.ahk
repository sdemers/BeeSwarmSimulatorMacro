#Requires AutoHotkey v1.1.33+
#Persistent

#Include, config.ahk
#Include, common.ahk

CoordMode, Pixel, Screen

WinActivate Roblox

Sleep 200

MoveToCactus(hivePosition) {
    FromHiveToCannon(hivePosition)

    RotateCamera(4)

    Sleep, 500
    MoveLeft(200)
    DeployChute()
    Sleep 2000
    MoveUp(1000)
    SendSpace()
    Sleep 1000

    MoveRight(3000)
    MoveDown(6000)
    RotateRight()

    ZoomOut(5)
    return True
}

MoveToHiveSlotFrom1(slot) {
    ; We should be facing the wall at slot #1

    MoveDown(500)

    return MoveToHiveLeft()
}

ToHiveFromCactus() {
    global hivePosition

    MoveUp(3000)
    MoveRight(2000)
    MoveDown(500)
    MoveRight(500)
    MoveUp(1000)
    RotateRight()

    MoveUp(15000)
    MoveLeft(300)

    StopFetching()

    if (MoveToHiveSlot(hivePosition) = False) {
        Debug("Hive not found...")
        return False
    }

    return True
}

ExecuteCactusScript() {
    if (ShouldGoToWealthClock()) {
        ExecuteWealthClockScript()
    }
    Respawn()

    loop {
        Debug("Moving to cactus")
        if (MoveToCactus(hivePosition)) {
            Debug("Walk Cactus pattern")
            ZoomOut(5)
            ResetSprinklers()
            WalkCactusPattern(patternRepeat, subpatternRepeat)
            Debug("Moving to hive")
            if (ToHiveFromCactus()) {
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

ExecuteCactusScript()
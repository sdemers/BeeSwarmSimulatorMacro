#Requires AutoHotkey v1.1.33+
#Persistent

#Include, config.ahk
#Include, common.ahk

CoordMode, Pixel, Screen

WinActivate Roblox

Sleep 200

MoveToSpider() {
    if (MoveFromHiveToCannon()) {
        JumpToCannonAndFire()
        Sleep, 800
        DeployChute()
        MoveDown(1100)
        SendSpace()
        Sleep, 2000
        RotateCamera(4)

        MoveUp(2000)
        MoveLeft(3000)
        return True

    }

    return False
}

ToHiveFromSpider() {
    global hivePosition

    StopFetching()

    ; Move next to the straberry field
    MoveUp(5000)
    MoveLeft(5000)

    ; Move towards the hives, turn left then move to the hives
    RotateCamera(4)
    MoveUp(9000)
    MoveRight(500)
    MoveUp(6000)

    if (MoveToHiveSlot(hivePosition) = False) {
        Debug("Hive not found...")
        return False
    }

    return True
}

ExecuteSpiderScript() {
    Respawn()

    loop {
        Debug("Moving to spider")
        if (MoveToSpider()) {
            Debug("Walk spider pattern")
            ResetSprinklers()
            WalkSpiderPattern(patternRepeat, subpatternRepeat)
            Debug("Moving to hive")
            if (ToHiveFromSpider()) {
                Debug("Convert honey")
                ConvertHoney()
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

;WalkSpiderPattern(patternRepeat, subpatternRepeat)

ExecuteSpiderScript()
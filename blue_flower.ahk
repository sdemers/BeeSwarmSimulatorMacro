#Requires AutoHotkey v1.1.33+
#Persistent

;#Include, config.ahk
;#Include, common.ahk

CoordMode, Pixel, Screen

WinActivate Roblox

Sleep 200

Debug("nb sprinklers: " . g_sprinklers)

ValidateField() {
    day := CompareColorAt(170, 1900, 0x006493) && CompareColorAt(2730, 270, 0x958465)
    if (day) {
        return True
    }

    night := CompareColorAt(170, 1900, 0x006491) && CompareColorAt(2730, 270, 0x000000)
    return night
}

MoveToBlueFlowerField() {
    FromHiveToCannon(g_hivePosition)

    MoveLeft(550)
    DeployChute()
    Sleep, 3000
    moveUp(300)
    SendSpace()
    Sleep, 2000

    MoveUp(3000)
    MoveRight(1000)

    return True
}

ToHiveFromBlueFlower() {
    global g_hivePosition

    StopFetching()

    ;RotateCamera(2)

    ; Walk to switch next to blue cannon
    ; Give enough time to disable haste
    MoveUp(5000)
    MoveLeft(15000)
    MoveRight(500)
    MoveDown(1000)

    MoveLeft(6000)
    MoveRight(200)
    MoveUp(100)
    KeyPress("e", 200)
    KeyPress("e", 200)
    KeyPress("e", 200)
    Sleep 3000
    MoveLeft(6000)
    MoveDown(1000)
    MoveRight(300)
    MoveDown(1000)
    MoveLeft(1000)
    MoveUp(500)
    MoveRight(1000)

    if (MoveToHiveSlot(g_hivePosition, 1) = False) {
        Debug("Hive not found...")
        return False
    }

    return True
}

ExecuteBlueFlowerScript() {
    if (ShouldGoToWealthClock()) {
        ExecuteWealthClockScript()
    }

    Respawn()

    loop {
        Debug("Moving to blue flower")
        if (MoveToBlueFlowerField()) {
            Debug("Walk blue flower pattern")
            ZoomOut()
            ResetSprinklers()
            ;WalkBlueFlowerPattern(g_patternRepeat, g_subpatternRepeat)
            Debug("Moving to hive")
            if (ToHiveFromBlueFlower()) {
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

;ExecuteBlueFlowerScript()
;ToHiveFromBlueFlower()


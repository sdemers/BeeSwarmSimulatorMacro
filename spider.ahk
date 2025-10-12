#Requires AutoHotkey v1.1.33+
#Persistent

#Include, config.ahk
#Include, common.ahk

ToHiveFromSpider() {
    global g_hivePosition

    StopFetching()
    MoveUp(3000)
    MoveLeft(3000)

    KeyDown("a")
    Jump()
    Sleep, 3000
    KeyUp("a")

    return ToHiveFromStrawberry()
}

ExecuteSpiderScript() {
    Respawn()

    loop {
        Debug("Moving to spider")
        if (MoveToSpider()) {
            Debug("Walk spider pattern")
            ResetSprinklers()
            ;WalkElolTopLeftPattern()
            WalkSpiderPattern(g_patternRepeat, g_subpatternRepeat, True, 50)
            Debug("Moving to hive")
            if (ToHiveFromSpider()) {
                Debug("Convert honey")
                ConvertHoneyThenPlantersAndClock()
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

;ExecuteSpiderScript()
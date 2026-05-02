#Requires AutoHotkey v1.1.33+
#Persistent

#Include, config.ahk
#Include, common.ahk

ValidatePineTreeField() {

    day := CompareColorAt(3780, 80, 0x7f6e45)
    If (day) {
        return True
    }

    if CompareColorAt(3780, 80, 0x857559) {
        return True
    }

    return CompareColorAt(3780, 80, 0x000000)
}

MoveToPineTree() {
    if (MoveFromHiveToCannon()) {
        if (JumpToCannonAndFire()) {

            Sleep 320
            MoveRight(150, True)
            Sleep 250
            DeployChute()
            Sleep 4700
            SendSpace()
            Sleep 500
            RotateRight()

            ZoomOut(5)

            MoveRight(5000)
            MoveUp(5000)
            return True
        }
    }

    ; if (ValidateField()) {
    ;     return True
    ; }

    return False
}

ToHiveFromPineTree() {
    MoveRight(2000)
    MoveUp(2000)

    StopFetching()

    ; Move next to polar bear
    Debug("Moving next to polar bear")
    MoveDown(11000)
    RotateLeft()
    MoveUp(9000)

    Debug("Jumping from polar bear to hive")
    JumpFromPolarBearToHive()

    Debug("Moving to hive slot")
    if (MoveToHiveSlot(g_hivePosition) = False) {
        Debug("Hive not found...")
        return False
    }

    Debug("Detected hive slot")
    return True
}

ExecutePineTree() {
    Debug("Moving to pine tree")
    if (MoveToPineTree()) {
        Debug("Walk pine tree pattern")
        ZoomOut()
        ResetSprinklers()
        WalkElolTopRightPattern(750)
        ;WalkBlueFlowerPattern(g_patternRepeat, g_subpatternRepeat, 2, 200, 50)
        ;WalkPineSwirl(200, false)
        Debug("Moving to hive")
        if (ToHiveFromPineTree()) {
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

ExecutePineTreeScript() {

    ;ActivateBlueBooster()
    Respawn()

    loop {
        ExecutePineTree()
        ;ActivateBlueBooster()
    }
}

;JumpToRedCannon()
;ExecutePineTreeScript()
#Requires AutoHotkey v1.1.33+
#Persistent

#Include, config.ahk
#Include, common.ahk

MoveToStrawberry() {
    if (MoveFromHiveToCannon()) {
        if (JumpToCannonAndFire()) {
            Debug("Flying to strawberry field")
            MoveRight(150, True)
            Sleep, 500
            DeployChute()
            Sleep, 600
            MoveRight(100, True)
            Sleep, 1000
            SendSpace()
            Sleep 1500
            RotateCamera(4)
            return True
        }
    }
    return False
}

MoveToStrawberryByFoot() {
    if (MoveFromHiveToCannon()) {
        RotateCamera(4)
        ZoomOut()
        TwoKeyPress("w", "d", 5000)

        MoveUp(10000)
        MoveLeft(4000)
        MoveRight(700)
        HyperSleep(500)
        KeyDown("w")
        HyperSleep(500)
        Jump()
        HyperSleep(900)
        KeyUp("w")

        HyperSleep(200)
        TwoKeyPress("w", "a", 1000)
        MoveUp(1000)
        MoveLeft(1000)

        return True
    }

    return True
}

ExecuteStrawberryScript() {
    Respawn(True)
    ActivateRedBooster()

    loop {
        Debug("Moving to strawberry")
        if (MoveToStrawberry() = True) {
            Debug("Walk pine tree pattern")
            ResetSprinklers()
            MoveLeft(3000)
            MoveUp(3000)
            WalkElolTopLeftPattern()
            Debug("Moving to hive")
            if (ToHiveFromStrawberry()) {
                Debug("Convert honey")
                ConvertHoneyThenPlantersAndClock()
            } else {
                Debug("Respawning")
                Respawn(True)
            }
        }
        else {
            Debug("Respawning")
            Respawn()
            ActivateRedBooster()
        }
    }
}

;ExecuteStrawberryScript()
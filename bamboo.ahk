#Requires AutoHotkey v1.1.33+
#Persistent

#include, config.ahk
#Include, common.ahk

CoordMode, Pixel, Screen

WinActivate Roblox

Sleep 200

MoveToBamboo() {
    if (MoveFromHiveToCannon()) {
        JumpToCannonAndFire()
        Sleep 500
        MoveLeft(300)
        Sleep 150
        DeployChute()
        Sleep 3000
        SendSpace()
        Sleep 500
        RotateCamera(4)

        MoveUp(3000)
        MoveRight(3000)
        return True
    }

    return False
}

ToHiveFromBamboo() {
    global hivePosition

    StopFetching()

    ; Move to the wall on the right side
    MoveUp(3000)
    MoveRight(5000)

    ; Move next to spider
    MoveLeft(7000)
    MoveDown(600)
    MoveLeft(10000)

    RotateCamera(4)
    MoveDown(1000)

    ; Move to hive
    MoveUp(10000)
    MoveRight(600)
    MoveUp(8000)

    if (MoveToHiveSlot(hivePosition) = False) {
        Debug("Hive not found...")
        return False
    }

    return True
}

ExecuteBambooScript() {
    Respawn()

    loop {
        Debug("Moving to bamboo")
        if (MoveToBamboo()) {
            Debug("Walk pine tree pattern")
            TopView()
            WalkPineTreePattern(patternRepeat, subpatternRepeat)
            Debug("Moving to hive")
            if (ToHiveFromBamboo()) {
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

ExecuteBambooScript()
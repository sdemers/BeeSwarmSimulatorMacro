#Requires AutoHotkey v1.1.33+
#Persistent

#Include, config.ahk
#Include, common.ahk

global g_lastPlanters := 0
global g_usePlanters := 0
global g_plantersTimeHours := 3

ReadLastPlanters()
ReadUsePlanters()

ShouldGoToPlanters() {
    nextIn := A_TickCount - g_lastPlanters

    Debug("Time since last planters: " . Round(nextIn / 1000) . " seconds", 6)

    if (nextIn < 0 or nextIn > 3600 * g_plantersTimeHours * 1000) {
        ReadUsePlanters()
        return g_usePlanters
    }

    return False
}

ReadUsePlanters() {
    IniRead, Name, config.ini, Config, UsePlanters
    g_usePlanters := Name
}

ReadLastPlanters() {
    IniRead, Value, config.ini, Config, LastPlanters
    g_lastPlanters := Value
    Debug("Last Planters: " . g_lastPlanters)
}

WriteLastPlanters(Value) {
    g_lastPlanters := Value
    IniWrite, %Value%, config.ini, Config, LastPlanters
}

FetchPlanter() {
    KeyPress("e", 100)
    Sleep, 500
    Click, 1750, 1150, Down
    Sleep, 300
    Click, 1750, 1150, Up
    Sleep, 1000
}

GatherPlanterRight() {
    TwoKeyPress("a", "w", 400)
    Loop, 5 {
        MoveDown(1300)
        MoveRight(120)
        MoveUp(1300)
        MoveRight(120)
    }
}

GatherPlanterLeft() {
    TwoKeyPress("d", "w", 400)
    Loop, 5 {
        MoveDown(1300)
        MoveLeft(120)
        MoveUp(1300)
        MoveLeft(120)
    }
}

MoveToPineTreePlanter(plant := True) {
    Respawn()
    MoveToPineTree()
    TwoKeyPress("a", "s", 400)
    Sleep, 1000

    FetchPlanter()

    ; plant
    KeyPress("5", 100)
    Sleep, 1000

    GatherPlanterLeft()
}

MoveToSpiderPlanter(plant := True) {
    Respawn()
    MoveToSpider()
    TwoKeyPress("s", "d", 400)
    Sleep, 1000

    FetchPlanter()

    ; plant
    KeyPress("6", 100)
    Sleep, 1000

    GatherPlanterRight()
}

MoveToSunflowerPlanter() {
    Respawn()
    MoveToSunflower(g_hivePosition)
    TwoKeyPress("s", "d", 400)
    Sleep, 1000

    FetchPlanter()

    ; plant
    KeyPress("7", 100)
    Sleep, 1000

    TwoKeyPress("d", "s", 400)
    GatherPlanterRight()
}

ExecutePlanters() {
    if (ShouldGoToPlanters() = False) {
        return
    }

    Debug("Executing Planters")

    MoveToPineTreePlanter()
    MoveToSpiderPlanter()
    MoveToSunflowerPlanter()

    WriteLastPlanters(A_TickCount)

    Debug("Planters done")

    Respawn()
}

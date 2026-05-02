#Requires AutoHotkey v1.1.33+
#Persistent

#Include, config.ahk
#Include, common.ahk

global g_lastBlueBooster := 0
global g_lastRedBooster := 0
global g_lastFieldBooster := 0
global g_boosterTimeout := 2705 * 1000 ; 45 minutes
global g_useBlueBooster := 0
global g_useRedBooster := 0
global g_useFieldBooster := 0

global lastWeathClock := 0

ReadUseBlueBooster() {
    IniRead, Name, config.ini, Config, UseBlueBooster
    g_useBlueBooster := Name
}

ReadLastBlueBooster() {
    IniRead, Value, config.ini, Config, LastBlueBooster
    g_lastBlueBooster := Value
    Debug("Last blue booster: " . g_lastBlueBooster)
}

WriteLastBlueBooster(Value) {
    g_lastBlueBooster := Value
    IniWrite, %Value%, config.ini, Config, LastBlueBooster
}

ShouldGoToBlueBooster() {
    ReadLastBlueBooster()
    if (g_useBlueBooster = 0) {
        Debug("Blue booster disabled...")
        return False
    }

    nextIn := A_TickCount - g_lastBlueBooster

    Debug("Time since last blue booster: " . Round(nextIn / 1000) . " seconds", 6)

    if (nextIn < 0 or nextIn > g_boosterTimeout) {
        return True
    }

    return False
}

ReadUseRedBooster() {
    IniRead, Name, config.ini, Config, UseRedBooster
    g_useRedBooster := Name
}

ReadLastRedBooster() {
    IniRead, Value, config.ini, Config, LastRedBooster
    g_lastRedBooster := Value
    Debug("Last red booster: " . g_lastRedBooster)
}

WriteLastRedBooster(Value) {
    g_lastRedBooster := Value
    IniWrite, %Value%, config.ini, Config, LastRedBooster
}

ShouldGoToRedBooster() {
    if (g_useRedBooster = 0) {
        Debug("Red booster disabled...")
        return False
    }

    ReadLastRedBooster()

    nextIn := A_TickCount - g_lastRedBooster

    Debug("Time since last red booster: " . Round(nextIn / 1000) . " seconds", 6)

    if (nextIn < 0 or nextIn > g_boosterTimeout) {
        return True
    }

    return False
}

ReadUseFieldBooster() {
    IniRead, Name, config.ini, Config, UseFieldBooster
    g_useFieldBooster := Name
}

ReadLastFieldBooster() {
    IniRead, Value, config.ini, Config, LastFieldBooster
    g_lastFieldBooster := Value
    Debug("Last Field booster: " . g_lastFieldBooster)
}

WriteLastFieldBooster(Value) {
    g_lastFieldBooster := Value
    IniWrite, %Value%, config.ini, Config, LastFieldBooster
}

ShouldGoToFieldBooster() {
    if (g_useFieldBooster = 0) {
        Debug("Field booster disabled...")
        return False
    }

    ReadLastFieldBooster()
    nextIn := A_TickCount - g_lastFieldBooster

    Debug("Time since last Field booster: " . Round(nextIn / 1000) . " seconds", 6)

    if (nextIn < 0 or nextIn > g_boosterTimeout) {
        return True
    }

    return False
}

ActivateFieldBooster() {
    Debug("Activating field booster (Respawn)")
    Respawn(True)

    Debug("Activating field booster...")
    if (ShouldGoToFieldBooster() = False) {
        Debug("Field booster is on cooldown...")
        return False
    }

    if (MoveFromHiveToCannon() = False) {
        return False
    }

    if (JumpToCannonAndFire() = False) {
        return False
    }

    HyperSleep(3000)
    RotateCamera(-2)
    MoveUp(5000)
    KeyPress("e")
    Sleep, 300
    WriteLastFieldBooster(A_TickCount)
    Respawn(True)
    return True
}

ActivateBlueBooster() {

    if (ShouldGoToBlueBooster() = False) {
        Debug("Blue booster is on cooldown...")
        return False
    }

    Respawn(True)
    if (MoveFromHiveToCannon()) {
        JumpToCannonAndFire()
        HyperSleep(550)
        DeployChute()
        RotateCamera(2)
        MoveUp(4000, True)
        ReleaseChute()

        HyperSleep(1000)
        TwoKeyPress("a", "w", 2000)
        MoveUp(1000)
        MoveRight(1000)
        MoveDown(100)
        MoveRight(500)
        MoveUp(4000)

        KeyDown("w")
        Jump()
        KeyUp("w")
        MoveUp(500)
        MoveRight(3000)
        MoveDown(5000)
        RotateCamera(2)
        MoveRight(300)
        MoveUp(3000)
        KeyPress("e")

        WriteLastBlueBooster(A_TickCount)
        return True
    }

    return False
}

ActivateRedBooster() {
    if (ShouldGoToRedBooster() = False) {
        Debug("Red booster is on cooldown...")
        return False
    }

    Respawn(True)
    if (MoveFromHiveToCannon() = False) {
        return False
    }

    if (JumpToCannonAndFire() = False) {
        return False
    }

    HyperSleep(400)
    DeployChute()
    RotateCamera(-2)
    MoveUp(2300, True)
    ReleaseChute()
    RotateCamera(2)
    HyperSleep(800)

    ; Landed in rose field, move to wall
    TwoKeyPress("a", "s", 1700)
    ZoomOut(6)

    ; Move next to sprout, move to booster
    MoveUp(6500)
    MoveRight(1000)
    MoveDown(1000)
    MoveLeft(300)
    MoveDown(400)
    MoveRight(1300)
    MoveUp(1000)
    KeyPress("e")
    Sleep, 300
    WriteLastRedBooster(A_TickCount)
    Respawn(True)
    return True
}

; CheckBoosterImage(path) {
;     CoordMode, Pixel, Screen
;     ImageSearch, x, y, 0, 0, A_ScreenWidth, 300, *32 %path%
;     if (ErrorLevel = 0) {
;         Debug("Found " . %path% . " at " . x . ", " . y)
;         return True
;     }
; }

; CheckForStrawberryBooster() {
;     CheckBoosterImage(%A_ScriptDir%\assets\straw_booster.png)
;     return ""
; }

; CheckForFieldBooster() {
;     CheckBoosterImage(%A_ScriptDir%\assets\pumpkin_booster.png)
;     CheckBoosterImage(%A_ScriptDir%\assets\clock.png)
;     return ""
; }

ReadUseBlueBooster()
ReadUseRedBooster()
ReadUseFieldBooster()
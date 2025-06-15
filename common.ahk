#Requires AutoHotkey v1.1.33+

#Include, wealth_clock.ahk

global GoToHiveRequested := False
global g_pause := False
global g_startTimestamp := 0

CoordMode, Pixel, Screen

ToolTip F2 to stop    F3 go to hive    F5 to pause/resume, 3200, 400, 1

Hotkey, F2, StopScript
Hotkey, F3, SetGoToHive
Hotkey, F5, PauseResume

SetGoToHive()
{
    GoToHiveRequested := True
}

StopScript() {
    ResetKeys()
    ExitApp
}

HyperSleep(ms)
{
    SetBatchLines, -1

    DllCall("QueryPerformanceFrequency", "Int64*", freq)
    DllCall("QueryPerformanceCounter", "Int64*", CounterBefore)

    ;Debug("freq: " . freq . ", Counter: " . CounterBefore)

    DllCall("QueryPerformanceCounter", "Int64*", CounterAfter)

    While (((CounterAfter - CounterBefore) / freq * 1000) < ms) {
        ;Debug("CounterAfter - CounterBefore: " . (CounterAfter - CounterBefore) / freq * 1000)
        DllCall("QueryPerformanceCounter", "Int64*", CounterAfter)
    }

    ;return ((CounterAfter - CounterBefore) / freq * 1000)

    ;Sleep, %ms%
    ; static freq := (DllCall("QueryPerformanceFrequency", "Int64*", &f := 0), f)
    ; DllCall("QueryPerformanceCounter", "Int64*", &begin := 0)
    ; current := 0, finish := begin + ms * freq / 1000
    ; while (current < finish)
    ; {
    ;     if ((finish - current) > 30000)
    ;     {
    ;         DllCall("Winmm.dll\timeBeginPeriod", "UInt", 1)
    ;         DllCall("Sleep", "UInt", 1)
    ;         DllCall("Winmm.dll\timeEndPeriod", "UInt", 1)
    ;     }
    ;     DllCall("QueryPerformanceCounter", "Int64*", &current)
    ; }
}

PauseResume() {
    g_pause := !g_pause
}

CheckPause() {
    if (!g_pause) {
        return
    }

    loop {
        Sleep, 500
        if (!g_pause) {
            return
        }
    }
}

Debug(text, index := 2) {
    FormatTime, currentTime, A_Now, yyyy-MM-dd HH:mm:ss

    FileAppend, [%currentTime%] %text% `n, log.txt
    ToolTip %text%, 3200, 400 + (index * 50), index
}

KeyDown(key)
{
    Send, {%key% down}
}

KeyUp(key)
{
    Send, {%key% up}
}

KeyPress(key, duration := 0)
{
    CheckPause()
    Send, {%key% down}
    HyperSleep(duration * g_movespeedFactor)
    Send, {%key% up}
}

TwoKeyPress(key1, key2, duration := 0)
{
    CheckPause()
    Send, {%key1% down}
    Send, {%key2% down}
    HyperSleep(duration * g_movespeedFactor)
    Send, {%key1% up}
    Send, {%key2% up}
}

global nbSprinklers := 0
global lastSprinkler := 0

ResetSprinklers() {
    nbSprinklers := 0
}

PlaceSprinkler(totalSprinklers := 4) {

    ;Debug("Total sprinklers: " . totalSprinklers)

    if (totalSprinklers = 0) {
        return True
    }

    if (A_NowUTC - lastSprinkler > g_sprinklerPlacementDelay && nbSprinklers < totalSprinklers) {
        nbSprinklers := nbSprinklers + 1
        Debug("Placing sprinkler #" . nbSprinklers . "/" . totalSprinklers)
        lastSprinkler := A_NowUTC
        Sleep, 300
        Jump(25)
        Sleep, 100
        KeyPress("1", 15)
        Sleep, 600
        return True
    }

    return False
}

MoveUp(time) {
    KeyPress("w", time)
}

MoveDown(time) {
    KeyPress("s", time)
}

MoveLeft(time) {
    KeyPress("a", time)
}

MoveRight(time) {
    KeyPress("d", time)
}

TopView() {
    ZoomOut(5)
    MouseMove, 1000, 100
    Send, {RButton down}
    MouseMove, 0, 1000, 0.2, R
    Send, {RButton up}
}

RotateCamera(times :=1 )
{
    If times == 0
        Return True

    camera_rotation_loops := Mod(Abs(times), 8)
    Loop, %camera_rotation_loops%
    {
        KeyPress(times > 0 ? "," : ".", 15)
    }
}

ZoomOut(times := 5)
{
    Loop, %times%
    {
        KeyPress("o", 15)
    }
}

ZoomIn(times:=1)
{
    Loop, %times%
    {
        KeyPress("i", 15)
    }
}

RotateRight() {
    RotateCamera(-2)
}

RotateLeft() {
    RotateCamera(2)
}

Jump(time := 25) {
    Send {Space down}
    HyperSleep(%time%)
    Send {Space up}
}

JumpToRedCannon() {
    DeployChute()
    HyperSleep(350)
    ReleaseChute()
    HyperSleep(400)
    DeployChute()
    HyperSleep(350)
    ReleaseChute()
    HyperSleep(500)
}

StartFetching() {
    Click, 600, 400, Down
}

StopFetching() {
    Click, Up
}

MoveByChute() {
    SendSpace()
    HyperSleep(200)
    SendSpace()
    HyperSleep(1200)
}

ConvertHoney() {
    KeyPress("e", 50)

    initialCount := 0
    safeCount := 0
    g_startTimestamp := A_TickCount / (1000 * 60)
    Loop {
        initialCount := initialCount + 1
        If (initialCount > 10) {
            If (CompareColorAt(1851, 112, 0x646d70)) {
                safeCount := safeCount + 1
            }
            Else {
                safeCount := 0
            }
        }

        if (safeCount > 5) {
            Break
        }
        Sleep, 1000
    }
}

ResetKeys() {
    Send {d up}
    Send {w up}
    Send {a up}
    Send {s up}
    Click up
}

Reset() {
    ResetKeys()
    Send {Esc}
    Sleep 300
    Send {R}
    Sleep 300
    Send {Enter}
    Sleep 7000
}

Respawn() {
    WinActivate Roblox
    Sleep 200

    done := False
    while (!done) {
        Reset()
        done := ValidateStart()
    }

    g_startTimestamp := A_TickCount / (1000 * 60)
}

SendSpace(wait := 100) {
    Send {Space down}
    Sleep wait
    Send {Space up}
}

DeployChute() {
    SendSpace()
    SendSpace()
}

ReleaseChute() {
    SendSpace()
}

MoveToHiveSlotFrom1(slot) {
    ; We should be facing the wall at slot #1

    MoveDown(500)

    return MoveToHiveLeft()
}

MoveToHiveSlot(slot, fromSlot := 3) {
    ; We should be facing the wall at slot #fromSlot

    MoveDown(400)

    if (slot <= fromSlot) {
        return MoveToHiveRight()
    }
    else {
        return MoveToHiveLeft()
    }
}

CheckPixel(x, y, color, xytolerance := 5) {
    PixelSearch, FoundX, FoundY, x-xytolerance, y-xytolerance, x+xytolerance, y+xytolerance, color, 10, True
    If (ErrorLevel != 0) {
        Debug("Pixel at " . x . "," . y . " not found", 3)
        return False
    }
    return True
}

CompareColorAt(x, y, targetColor, tolerance := 20) {
    PixelGetColor, color, x, y
    Debug("Pixel at " . x . "," . y . " is " . color, 4)

    tr := format("{:d}","0x" . substr(targetColor, 3, 2))
    tg := format("{:d}","0x" . substr(targetColor, 5, 2))
    tb := format("{:d}","0x" . substr(targetColor, 7, 2))

    ;split pixel into rgb
    pr := format("{:d}","0x" . substr(color, 3, 2))
    pg := format("{:d}","0x" . substr(color, 5, 2))
    pb := format("{:d}","0x" . substr(color, 7, 2))

    ;check distance
    distance := sqrt((tr-pr)**2+(tg-pg)**2+(pb-tb)**2)
    return distance <= tolerance
}

CompareColor(sourceColor, targetColor, tolerance := 20) {
    tr := format("{:d}","0x" . substr(targetColor, 3, 2))
    tg := format("{:d}","0x" . substr(targetColor, 5, 2))
    tb := format("{:d}","0x" . substr(targetColor, 7, 2))

    ;split pixel into rgb
    pr := format("{:d}","0x" . substr(sourceColor, 3, 2))
    pg := format("{:d}","0x" . substr(sourceColor, 5, 2))
    pb := format("{:d}","0x" . substr(sourceColor, 7, 2))

    ;check distance
    distance := sqrt((tr-pr)**2+(tg-pg)**2+(pb-tb)**2)
    return distance <= tolerance
}

ValidateMakeHoney() {
    if (CompareColorAt(2170, 240, 0xf9fff7)) {
        return CompareColorAt(2197, 185, 0xf9fff7)
    }
    return False
}

ValidateStart() {
    PixelGetColor, color, 1915, 2080
    Debug("Pixel at " . x . "," . y . " is " . color, 4)

    if (CompareColor(color, 0xffffff) || CompareColor(color, 0xb1b1b1) || CompareColor(color, 0xFF805D) || CompareColor(color, 0x6F6F6F) || CompareColor(color, 0x830404) || CompareColor(color, 0x9A4E3B)) {
        return True
    }
}

FireCannon() {
    Sleep 200
    KeyPress("e", 15)
}

JumpToCannonAndFire() {
    JumpToRedCannon()
    FireCannon()
}

MoveToHiveLeft() {
    If (ValidateMakeHoney()) {
        return True
    }

    step := 0
    while (step < 500) {
        MoveLeft(50)
        If (ValidateMakeHoney()) {
            return True
        }
        step := step + 1
    }

    return False
}

MoveToHiveUp() {
    If (ValidateMakeHoney()) {
        return True
    }

    step := 0
    while (step < 500) {
        MoveUp(100)
        If (ValidateMakeHoney()) {
            return True
        }
        step := step + 1
    }

    return False
}

MoveToHiveRight() {
    If (ValidateMakeHoney()) {
        return True
    }

    step := 0
    while (step < 500) {
        MoveRight(50)
        If (ValidateMakeHoney()) {
            return True
        }
        step := step + 1
    }

    return False
}

MoveFromHiveToCannon() {
    ZoomIn(6)
    MoveUp(600)
    good := false
    Loop, 10 {
        MoveRight(2000)

        PixelGetColor, color, 1950, 55
        if (CompareColor(color, 0x949184) or CompareColor(color, 0x848279) or CompareColor(color, 0x1F8BA8) or CompareColor(color, 0x16157B) or CompareColor(color, 0x053F1A) or CompareColor(color, 0x7E706D) or CompareColor(color, 0x4E9193) or CompareColor(color, 0x4E9193) or CompareColor(color, 0x645049)) {
            PixelGetColor, color, 3020, 115
            if (CompareColor(color,0xa08a76) or CompareColor(color,0x927C6B) or CompareColor(color,0xEDEAEB)) {
                ZoomOut(5)
                good := True
                Break
            }
        }
    }

    return good
}

ShouldStopFetching() {
    if GoToHiveRequested {
        GoToHiveRequested := False
        Debug("GoToHiveRequested")
        g_startTimestamp := A_TickCount / (1000 * 60)
        return True
    }

    if (ShouldGoToWealthClock()) {
        Debug("ShouldGoToWealthClock")
        g_startTimestamp := A_TickCount / (1000 * 60)
        return True
    }

    minutes := A_TickCount / (1000 * 60)
    ;Debug("minutes: " . minutes . ", startTimestamp: " . g_startTimestamp . ", maxTimeMin: " . g_maxTimeMin, 6)
    if (minutes - g_startTimestamp >= g_maxTimeMin) {
        Debug("minutes - g_startTimestamp >= g_maxTimeMin " . (minutes - g_startTimestamp) . " >= " . g_maxTimeMin)
        g_startTimestamp := A_TickCount / (1000 * 60)
        return True
    }

    ; Check if container is full
    if (CompareColorAt(2408, 100, 0x1700F7)) {
        Debug("Container full")
        g_startTimestamp := A_TickCount / (1000 * 60)
        return True
    }

    return False
}

IsConvertingHoney() {
    ;PixelSearch, FoundX, FoundY, 2028, 90, 2030, 92, 0x646E71, 5, True
    ;return ErrorLevel = 0
    return CompareColorAt(1858, 110, 0x75cde7)
}

JumpFromPolarBearToHive() {
    MoveRight(2000)
    MoveDown(500)
    MoveUp(1000)
    MoveByChute()
    MoveUp(7000)
    MoveLeft(600)
}

WalkZigZagCrossUpperRight(nbLoops, subrepeat, move := 100) {
    StartFetching()

    patternMoveTime := move * g_patternWidth
    stopFetching := False

    StartFetching()

    loop, %nbLoops% {
        if (A_Index = 1) {
            PlaceSprinkler(g_sprinklers)
        }

        Debug("Pattern #" . A_Index . "/" . nbLoops)
        loop, %subrepeat% {

            turnAroundTime := move * g_patternLength / 6

            loop, 4 {
                MoveLeft(patternMoveTime)
                MoveDown(turnAroundTime)
                MoveRight(patternMoveTime)
                MoveDown(turnAroundTime)
            }

            MoveLeft(patternMoveTime * 1.5)

            PlaceSprinkler(g_sprinklers)

            Loop, 3 {
                MoveUp(patternMoveTime)
                MoveRight(turnAroundTime)
                MoveDown(patternMoveTime)
                MoveRight(turnAroundTime)
            }

            KeyDown("a")
            KeyDown("w")
            Sleep, 3000 * g_movespeedFactor
            KeyUp("a")
            KeyUp("w")

            moveUp(1000)
            MoveRight(3000)

            if (ShouldStopFetching()) {
                stopFetching := True
                break
            }
        }

        if (stopFetching || A_Index = nbLoops) {
            break
        }
    }
}

WalkPineTreePattern(nbLoops, subrepeat) {
    StartFetching()

    move := 100
    patternMoveTime := move * g_patternWidth
    stopFetching := False

    loop, %nbLoops% {
        MoveDown(1500)

        If (A_Index = 1) {
            PlaceSprinkler(g_sprinklers)
        }

        Debug("Pattern #" . A_Index . "/" . nbLoops)
        loop, %subrepeat% {

            if (stopFetching) {
                break
            }

            loop, 10 {
                StartFetching()
                loop, 2 {
                    Random, turnAroundTime, 50, 150

                    MoveUp(patternMoveTime)
                    MoveLeft(turnAroundTime)
                    MoveDown(patternMoveTime)
                    MoveLeft(turnAroundTime)
                }

                If (ShouldStopFetching()) {
                    stopFetching := True
                    break
                }

                loop, 2 {
                    Random, turnAroundTime, 50, 150

                    MoveUp(patternMoveTime)
                    MoveRight(turnAroundTime)
                    MoveDown(patternMoveTime)
                    PlaceSprinkler(g_sprinklers)
                    MoveRight(turnAroundTime)
                }

                If (ShouldStopFetching()) {
                    stopFetching := True
                    break
                }
            }

            MoveUp(patternMoveTime * 1.5)
        }

        If (stopFetching || A_Index = nbLoops) {
            break
        }
    }
}

WalkSpiderPattern(nbLoops, subrepeat, left := True, move := 60, placeSplinkers := True) {
    StartFetching()

    patternMoveTime := move * g_patternWidth
    stopFetching := False

    MoveDown(patternMoveTime * 1.5)
    MoveLateral(patternMoveTime, !left)

    loop, %nbLoops% {

        Debug("Pattern #" . A_Index . "/" . nbLoops)
        loop, %subrepeat% {
            StartFetching()

            Debug("Sub-Pattern #" . A_Index . "/" . subrepeat, 3)
            turnAroundTime := move * g_patternLength / 4

            MoveLateral(200, !left)

            Loop, 2 {
                MoveUp(patternMoveTime)
                MoveLateral(turnAroundTime * 0.5, !left)
                MoveDown(patternMoveTime)
                if (placeSplinkers) {
                    PlaceSprinkler(g_sprinklers)
                }
                MoveLateral(turnAroundTime, !left)
            }

            if (ShouldStopFetching()) {
                stopFetching := True
                Break
            }

            Loop, 2 {
                MoveUp(patternMoveTime)
                MoveLateral(turnAroundTime * 0.5, left)
                MoveDown(patternMoveTime)
                MoveLateral(turnAroundTime, left)
            }

            if (ShouldStopFetching()) {
                stopFetching := True
                Break
            }

            if (placeSplinkers) {
                PlaceSprinkler(g_sprinklers)
            }

            MoveUp(patternMoveTime * 2)
            MoveDown(300)

            Loop, 2 {
                MoveLateral(patternMoveTime, !left)
                MoveDown(turnAroundTime * 0.5)
                if (placeSplinkers) {
                    PlaceSprinkler(g_sprinklers)
                }
                MoveLateral(patternMoveTime, left)
                MoveDown(turnAroundTime * 0.75)
            }

            if (ShouldStopFetching()) {
                stopFetching := True
                Break
            }

            MoveUp(patternMoveTime * 2)
            MoveLateral(patternMoveTime / 3, !left)
            MoveDown(300)

            Loop, 2 {
                MoveLateral(patternMoveTime, left)
                MoveDown(turnAroundTime * 0.5)
                if (placeSplinkers) {
                    PlaceSprinkler(g_sprinklers)
                }
                MoveLateral(patternMoveTime, !left)
                MoveDown(turnAroundTime)
            }

            MoveLateral(patternMoveTime, left)

            if (ShouldStopFetching()) {
                stopFetching := True
                Break
            }
        }

        if (stopFetching || A_Index = nbLoops) {
            Debug("", 2)
            Debug("", 3)
            Break
        }
    }
}

WalkSunflowerPattern(nbLoops, subrepeat) {
    StartFetching()

    move := 50
    patternMoveTime := move * g_patternWidth
    stopFetching := False

    ZoomOut(5)

    sprinklerMove := 700
    MoveRight(sprinklerMove * 1.5)
    MoveDown(sprinklerMove * 1.5)
    PlaceSprinkler(g_sprinklers)
    MoveRight(sprinklerMove * 1.5)
    PlaceSprinkler(g_sprinklers)
    MoveDown(sprinklerMove * 1.5)
    PlaceSprinkler(g_sprinklers)
    MoveLeft(sprinklerMove * 1.5)
    PlaceSprinkler(g_sprinklers)
    MoveUp(sprinklerMove * 2)
    MoveLeft(sprinklerMove * 2)

    loop, %nbLoops% {
        Debug("Pattern #" . A_Index . "/" . nbLoops)
        loop, %subrepeat% {

            MoveRight(500)
            MoveDown(500)

            ZoomOut(5)
            Debug("Sub-Pattern #" . A_Index . "/" . subrepeat, 3)
            turnAroundTime := move * g_patternLength / 6

            loop, 16 {
                StartFetching()
                Loop, 2 {
                    MoveDown(patternMoveTime)
                    MoveRight(turnAroundTime)
                    MoveUp(patternMoveTime)
                    MoveRight(turnAroundTime)
                }

                Loop, 2 {
                    MoveDown(patternMoveTime)
                    MoveLeft(turnAroundTime)
                    MoveUp(patternMoveTime)
                    MoveLeft(turnAroundTime)
                }

                MoveRight(30)

                if (ShouldStopFetching()) {
                    stopFetching := True
                    Break
                }
            }

            MoveRight(1000)
            MoveUp(3000)
            MoveLeft(4000)

            if (stopFetching) {
                Break
            }
        }

        if (stopFetching || A_Index = nbLoops) {
            Debug("", 2)
            Debug("", 3)
            Break
        }
    }
}

WalkPepperPattern(nbLoops, subrepeat) {
    StartFetching()

    move := 55
    patternMoveTime := move * g_patternWidth
    stopFetching := False

    g_sprinklerPlacementDelay := 0

    ZoomOut(5)

    sprinklerMove := 700
    MoveLeft(sprinklerMove)
    MoveDown(sprinklerMove)
    if (g_sprinklers > 1) {
        PlaceSprinkler(g_sprinklers)
    }
    MoveLeft(sprinklerMove)
    if (g_sprinklers > 1) {
        PlaceSprinkler(g_sprinklers)
    }
    MoveDown(sprinklerMove)
    PlaceSprinkler(g_sprinklers)
    MoveRight(sprinklerMove)
    if (g_sprinklers > 1) {
        PlaceSprinkler(g_sprinklers)
    }
    MoveUp(sprinklerMove * 2)
    MoveRight(sprinklerMove * 2)

    TwoKeyPress("a", "s", 800)
    MoveLeft(300)

    loop, %nbLoops% {
        Debug("Pattern #" . A_Index . "/" . nbLoops)
        loop, %subrepeat% {

            TwoKeyPress("a", "s", 600)
            MoveLeft(200)

            ZoomOut(5)
            Debug("Sub-Pattern #" . A_Index . "/" . subrepeat, 3)
            turnAroundTime := move * g_patternLength / 6

            StartFetching()
            loop, 16 {
                Loop, 2 {
                    MoveDown(patternMoveTime)
                    MoveLeft(turnAroundTime)
                    MoveUp(patternMoveTime)
                    MoveLeft(turnAroundTime)
                }

                Loop, 2 {
                    MoveDown(patternMoveTime)
                    MoveRight(turnAroundTime)
                    MoveUp(patternMoveTime)
                    MoveRight(turnAroundTime)
                }

                if (ShouldStopFetching()) {
                    stopFetching := True
                    Break
                }
            }

            TwoKeyPress("w", "d", 3000)

            if (stopFetching) {
                Break
            }
        }

        if (stopFetching || A_Index = nbLoops) {
            Debug("", 2)
            Debug("", 3)
            Break
        }
    }
}

WalkRosePattern(nbLoops, subrepeat, initialMoveDown := 1000, initialMoveLeft := 1000, moveDown := 200) {
    StartFetching()

    move := 70
    patternMoveTime := move * g_patternWidth
    turnAroundTime := move * g_patternLength / 8
    stopFetching := False

    MoveDown(100)
    MoveLeft(100)
    MoveDown(initialMoveDown)
    MoveLeft(initialMoveLeft)

    loop, %nbLoops% {
        If (A_Index = 1) {
            PlaceSprinkler(g_sprinklers)
        }

        Debug("Pattern #" . A_Index . "/" . nbLoops)
        loop, %subrepeat% {
            StartFetching()
            loop, 2 {
                MoveUp(patternMoveTime)
                MoveLeft(turnAroundTime)
                MoveDown(patternMoveTime)
                MoveLeft(turnAroundTime)
            }

            If (ShouldStopFetching()) {
                stopFetching := True
                break
            }

            loop, 2 {
                MoveUp(patternMoveTime)
                MoveRight(turnAroundTime)
                MoveDown(patternMoveTime)
                PlaceSprinkler(g_sprinklers)
                MoveRight(turnAroundTime)
            }

            If (ShouldStopFetching()) {
                stopFetching := True
                break
            }

            MoveUp(patternMoveTime * 1.5)
            MoveDown(moveDown)

            loop, 2 {
                MoveLeft(patternMoveTime)
                MoveDown(turnAroundTime)
                MoveRight(patternMoveTime)
                MoveDown(turnAroundTime)
            }

            MoveLeft(patternMoveTime / 3)

            If (ShouldStopFetching()) {
                stopFetching := True
                break
            }

            MoveUp(patternMoveTime * 1.5)
            MoveDown(moveDown)

            loop, 2 {
                MoveRight(patternMoveTime)
                MoveDown(turnAroundTime)
                MoveLeft(patternMoveTime)
                MoveDown(turnAroundTime)
            }

            MoveRight(500)

            If (ShouldStopFetching()) {
                stopFetching := True
                break
            }
        }

        If (stopFetching || A_Index = nbLoops) {
            break
        }
    }
}

WalkCloverPattern(nbLoops, subrepeat) {
    StartFetching()

    move := 50
    patternMoveTime := move * g_patternWidth
    turnAroundTime := 50
    stopFetching := False

    MoveRight(2500)
    MoveDown(1500)

    PlaceSprinkler(g_sprinklers)

    loop, %nbLoops% {
        Debug("Pattern #" . A_Index . "/" . nbLoops)
        loop, %subrepeat% {

            ZoomOut(5)
            Debug("Sub-Pattern #" . A_Index . "/" . subrepeat, 3)

            loop, 16 {
                StartFetching()
                Loop, 2 {
                    MoveDown(patternMoveTime)
                    MoveRight(turnAroundTime)
                    MoveUp(patternMoveTime)
                    MoveRight(turnAroundTime)
                }

                Loop, 2 {
                    MoveDown(patternMoveTime)
                    MoveLeft(turnAroundTime)
                    MoveUp(patternMoveTime)
                    MoveLeft(turnAroundTime)
                }

                MoveRight(30)

                if (ShouldStopFetching()) {
                    stopFetching := True
                    Break
                }
            }

            TwoKeyPress("w", "a", 3000)

            if (stopFetching) {
                Break
            }

            MoveRight(1500)
            MoveDown(600)
        }

        if (stopFetching || A_Index = nbLoops) {
            Debug("", 2)
            Debug("", 3)
            Break
        }
    }
}

WalkBlueFlowerPattern(nbLoops, subrepeat, nbzigzag := 2, initialMoveLeft := 200, move := 70, left := True) {

    patternMoveTime := move * g_patternWidth
    stopFetching := False

    MoveDown(15 * move)
    MoveLateral(10 * move, left)

    loop, %nbLoops% {
        if (A_Index = 1) {
            PlaceSprinkler(g_sprinklers)
        }

        Debug("Pattern #" . A_Index . "/" . nbLoops)
        loop, %subrepeat% {

            ZoomOut()
            StartFetching()

            Debug("Sub-Pattern #" . A_Index . "/" . subrepeat, 3)
            turnAroundTime := move * g_patternLength / 4

            MoveLateral(initialMoveLeft, left)

            Loop, %nbzigzag% {
                MoveUp(patternMoveTime)
                MoveLateral(turnAroundTime * 0.5, left)
                PlaceSprinkler(g_sprinklers)
                MoveDown(patternMoveTime)
                MoveLateral(turnAroundTime * 0.75, left)
            }

            if (ShouldStopFetching()) {
                stopFetching := True
                Break
            }

            Loop, %nbzigzag% {
                MoveUp(patternMoveTime)
                MoveLateral(turnAroundTime * 0.5, left = false)
                MoveDown(patternMoveTime)
                MoveLateral(turnAroundTime * 0.75, left = false)
            }

            if (ShouldStopFetching()) {
                stopFetching := True
                Break
            }

            MoveUp(patternMoveTime * 1.25)
            MoveDown(200)

            Loop, %nbzigzag% {
                MoveLateral(patternMoveTime, left)
                MoveDown(turnAroundTime * 0.5)
                MoveLateral(patternMoveTime, left = False)
                MoveDown(turnAroundTime * 0.75)
            }

            if (ShouldStopFetching()) {
                stopFetching := True
                Break
            }

            MoveLateral(patternMoveTime, left)
            MoveUp(patternMoveTime * 1.5)
            MoveLateral(patternMoveTime * 2.25, left = False)
            If (left) {
                TwoKeyPress("a", "s", 200)
            } Else {
                TwoKeyPress("s", "d", 200)
            }

            MoveDown(patternMoveTime)

            if (ShouldStopFetching()) {
                stopFetching := True
                Break
            }
        }

        if (stopFetching || A_Index = nbLoops) {
            Debug("", 2)
            Debug("", 3)
            Break
        }
    }
}

MoveLateral(time, left := True) {
    if (left) {
        MoveLeft(time)
    } else {
        MoveRight(time)
    }
}

WalkElolPattern(nbLoops, subrepeat, left := True, move := 180) {

    stopFetching := False

    loop, %nbLoops% {
        if (A_Index = 1) {
            PlaceSprinkler(g_sprinklers)
        }

        Debug("Pattern #" . A_Index . "/" . nbLoops)

        loop, %subrepeat% {

            StartFetching()

            Debug("Sub-Pattern #" . A_Index . "/" . subrepeat, 3)

            Loop, 3 {
                MoveLateral(move * 0.75, left)
                if (A_Index = 2) {
                    PlaceSprinkler(g_sprinklers)
                }
                MoveDown(move * 2.5)
                MoveLateral(move * 1.25, left)
                MoveUp(move * 2.5)
            }

            MoveLateral(move * 6, !left)
            MoveLateral(100 ,left)

            Loop, 2 {
                MoveDown(move * 2.5)
                MoveLateral(move * 0.75, left)
                if (A_Index = 1) {
                    PlaceSprinkler(g_sprinklers)
                }
                MoveUp(move * 2.5)
                MoveLateral(move * 1.25, left)
            }

            if (ShouldStopFetching()) {
                stopFetching := True
                Break
            }

            MoveDown(move * 2.5)
            PlaceSprinkler(g_sprinklers)
            MoveLateral(move * 6, !left)
            MoveLateral(100, left)
            MoveUp(move * 3)
            MoveDown(100)
        }

        if (stopFetching || A_Index = nbLoops) {
            Debug("", 2)
            Debug("", 3)
            Break
        }
    }
}

WalkCactusPattern(nbLoops, subrepeat) {
    StartFetching()

    move := 2000
    stopFetching := False

    StartFetching()

    g_sprinklerPlacementDelay := 0

    MoveDown(500)
    PlaceSprinkler(g_sprinklers)
    MoveDown(700)
    MoveLeft(400)
    PlaceSprinkler(g_sprinklers)
    MoveRight(800)
    PlaceSprinkler(g_sprinklers)
    MoveLeft(400)
    MoveDown(700)
    PlaceSprinkler(g_sprinklers)
    MoveUp(3000)

    loop, %nbLoops% {

        Debug("Pattern #" . A_Index . "/" . nbLoops)

        loop, %subrepeat% {
            StartFetching()

            Debug("Sub-Pattern #" . A_Index . "/" . subrepeat, 3)

            MoveDown(1200)

            if (ShouldStopFetching()) {
                stopFetching := True
                break
            }

            MoveLeft(40)
            MoveUp(1500)
            MoveRight(50)

            if (stopFetching || A_Index = subrepeat) {
                break
            }
        }

        if (stopFetching || A_Index = nbLoops) {
            break
        }
    }
}

ToHiveFromStrawberry() {
    global g_hivePosition

    StopFetching()

    ; Move next to the spider field
    MoveUp(5000)
    MoveRight(5000)

    ; Move towards the hives, turn left then move to the hives
    ; Give time for the haste to expire
    MoveDown(5000)
    RotateCamera(4)
    MoveUp(15000)
    MoveDown(500)
    KeyDown("w")
    Sleep, 300
    Jump()
    Sleep, 10000
    KeyUp("w")
    MoveDown(200)
    MoveRight(3000)
    MoveUp(500)

    if (MoveToHiveSlot(g_hivePosition, 1) = False) {
        Debug("Hive not found...")
        return False
    }

    return True
}
#Requires AutoHotkey v1.1.33+

global GoToHiveRequested := False

global movespeedFactor := 28 / speed

ToolTip Press F2 to stop script / F3 to go to hive, 50, 400, 1

Hotkey, F2, StopScript
Hotkey, F3, SetGoToHive

SetGoToHive()
{
    GoToHiveRequested := True
}

StopScript() {
    ResetKeys()
    ExitApp
}

Debug(text, index := 2) {
    FormatTime, CurrentTime, A_Now, yyyy-MM-dd HH:mm:ss
    FileAppend, [%CurrentTime%] %text% `n, log.txt
    ToolTip %text%, 50, 400 + (index * 50), index
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
    Send, {%key% down}
    Sleep, (duration * movespeedFactor)
    Send, {%key% up}
}

PlaceSprinkler() {
    KeyPress("1", 15)
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

ZoomOut(times:=1)
{
    Loop, %times%
    {
        KeyPress("o", 15)
    }
}

RotateRight() {
    RotateCamera(-2)
}

RotateLeft() {
    RotateCamera(2)
}

Jump() {
    Send {Space down}
    Sleep 25
    Send {Space up}
}

JumpToRedCannon() {
    KeyDown("d")
    KeyDown("w")
    Sleep, 50
    Jump()
    Sleep, 100
    KeyUp("w")
    KeyUp("d")
}

StartFetching() {
    Click, 600, 400, Down
}

StopFetching() {
    Click, Up
}

ConvertHoney() {
    KeyPress("e", 50)
    Loop, 90 {
        Sleep, 1000
    }

    ; ; Wait to convert honey to start
    ; Debug("Waiting to start converting honey")
    ; While IsConvertingHoney() = False {
    ;     Sleep, 250
    ; }

    ; ; Wait to convert honey to end
    ; Debug("Waiting to end converting honey")
    ; While, IsConvertingHoney() {
    ;     Sleep, 250
    ; }

    ; Debug("")
    ; ; Loop {
    ; ;     Sleep 500
    ; ;     If (IsConvertingHoney() = False) {
    ; ;         Break
    ; ;     }
    ; ; }
}

ResetKeys() {
    Send {d up}
    Send {w up}
    Send {a up}
    Send {s up}
    Click up
}

Respawn() {
    ResetKeys()
    Send {Esc}
    Sleep 300
    Send {R}
    Sleep 300
    Send {Enter}
    Sleep 7000

    If (ValidateStart()) {
        ZoomOut(5)
    }
    else {
        Respawn()
    }
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

; Fouille moé pourquoi faut faire ça...
ReleaseChute() {
    SendSpace(15)
    SendSpace(15)
    SendSpace(15)
    SendSpace(15)
    SendSpace(15)
    SendSpace(15)
}

MoveToHiveSlot(slot, fromSlot := 3) {
    ; We should be facing the wall at slot #fromSlot

    MoveDown(500)

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
    Debug("Pixel at " . x . "," . y . " is " . color)

    tr := format("{:d}","0x" . substr(targetColor, 3, 2))
    tg := format("{:d}","0x" . substr(targetColor, 5, 2))
    tb := format("{:d}","0x" . substr(targetColor, 7, 2))

    ;split pixel into rgb
    pr := format("{:d}","0x" . substr(color, 3, 2))
    pg := format("{:d}","0x" . substr(color, 5, 2))
    pb := format("{:d}","0x" . substr(color, 7, 2))

    ;check distance
    distance := sqrt((tr-pr)**2+(tg-pg)**2+(pb-tb)**2)
    ;Debug(distance)
    return distance <= tolerance
}

ValidatePixel(x, y, color) {
    return CompareColorAt(x, y, color)
}

ValidateMakeHoney() {
    return CompareColorAt(2170, 240, 0xf9fff7) && CompareColorAt(2197, 185, 0xf9fff7)
}

ValidateStart() {
    return CompareColorAt(1915, 2080, 0xffffff) || CompareColorAt(1915, 2080, 0xb1b1b1) || CompareColorAt(1915, 2080, 0xFF805D) || CompareColorAt(1915, 2080, 0x6F6F6F)
}

FireCannon() {
    Sleep 200
    KeyPress("e", 15)
}

FromHiveToCannon(hive, fire := True) {
    MoveUp(2875)
    MoveRight(hive * 1200)
    JumpToRedCannon()

    if (fire) {
        MoveRight(1300)
        FireCannon()
    }
}

MoveToHiveLeft() {
    If (ValidateMakeHoney()) {
        return True
    }

    step := 0
    while (step < 30) {
        MoveLeft(125)
        If (ValidateMakeHoney()) {
            return True
        }
        step++
    }

    return False
}

MoveToHiveRight() {
    If (ValidateMakeHoney()) {
        return True
    }

    step := 0
    while (step < 30) {
        MoveRight(125)
        If (ValidateMakeHoney()) {
            return True
        }
        step++
    }

    return False
}

IsContainerFull() {
    if GoToHiveRequested {
        GoToHiveRequested := False
        return True
    }

    PixelSearch, FoundX, FoundY, 2408, 100, 2410, 102, 0x1700F7, 5, True
    return ErrorLevel = 0
}

IsConvertingHoney() {
    ;PixelSearch, FoundX, FoundY, 2028, 90, 2030, 92, 0x646E71, 5, True
    ;return ErrorLevel = 0
    return CompareColorAt(1858, 110, 0x75cde7)
}

JumpFromPolarBearToHive() {
    MoveDown(50)
    KeyDown("w")
    SendSpace(10)
    Sleep, 500
    KeyUp("w")
    Sleep, 500
    MoveRight(500)
    MoveUp(10000)
    MoveRight(600)
    MoveUp(8000)
}

WalkZigZagCrossUpperRight(nbLoops, subrepeat, move := 100) {
    StartFetching()

    patternMoveTime := move * patternWidth
    containerFull := False

    StartFetching()

    loop, %nbLoops% {
        if (A_Index = 1) {
            PlaceSprinkler()
        }

        Debug("Pattern #" . A_Index . "/" . nbLoops)
        loop, %subrepeat% {

            turnAroundTime := move * patternLength / 6

            loop, 4 {
                MoveLeft(patternMoveTime)
                MoveDown(turnAroundTime)
                MoveRight(patternMoveTime)
                MoveDown(turnAroundTime)
            }

            MoveLeft(patternMoveTime * 1.5)

            PlaceSprinkler()

            Loop, 3 {
                MoveUp(patternMoveTime)
                MoveRight(turnAroundTime)
                MoveDown(patternMoveTime)
                MoveRight(turnAroundTime)
            }

            KeyDown("a")
            KeyDown("w")
            Sleep, 3000 * movespeedFactor
            KeyUp("a")
            KeyUp("w")

            moveUp(1000)
            MoveRight(3000)

            if (IsContainerFull()) {
                containerFull := True
                break
            }
        }

        if (containerFull || A_Index = nbLoops) {
            break
        }
    }
}

WalkPineTreePattern(nbLoops, subrepeat, nbzigzag := 2) {

    move := 85
    patternMoveTime := move * patternWidth
    containerFull := False

    MoveDown(15 * move)
    MoveLeft(10 * move)

    loop, %nbLoops% {
        if (A_Index = 1) {
            PlaceSprinkler()
        }

        Debug("Pattern #" . A_Index . "/" . nbLoops)
        loop, %subrepeat% {

            StartFetching()

            Debug("Sub-Pattern #" . A_Index . "/" . subrepeat, 3)
            turnAroundTime := move * patternLength / 4

            MoveLeft(200)

            Loop, %nbzigzag% {
                MoveUp(patternMoveTime)
                MoveLeft(turnAroundTime * 0.5)
                PlaceSprinkler()
                MoveDown(patternMoveTime)
                MoveLeft(turnAroundTime * 0.75)
            }

            Loop, %nbzigzag% {
                MoveUp(patternMoveTime)
                MoveRight(turnAroundTime * 0.5)
                MoveDown(patternMoveTime)
                MoveRight(turnAroundTime * 0.75)
            }

            MoveUp(patternMoveTime)

            if (IsContainerFull()) {
                containerFull := True
                Break
            }

            Loop, %nbzigzag% {
                MoveLeft(patternMoveTime)
                MoveDown(turnAroundTime * 0.5)
                MoveRight(patternMoveTime)
                MoveDown(turnAroundTime * 0.75)
            }

            MoveLeft(patternMoveTime / 3)
            MoveUp(patternMoveTime * 1.5)
            MoveDown(200)

            Loop, %nbzigzag% {
                MoveRight(patternMoveTime)
                MoveDown(turnAroundTime * 0.5)
                MoveLeft(patternMoveTime)
                MoveDown(turnAroundTime * 0.75)
            }

            MoveRight(patternMoveTime)

            if (IsContainerFull()) {
                containerFull := True
                Break
            }
        }

        if (containerFull || A_Index = nbLoops) {
            Debug("", 2)
            Debug("", 3)
            Break
        }
    }
}

WalkSpiderPattern(nbLoops, subrepeat) {
    StartFetching()

    move := 80
    patternMoveTime := move * patternWidth
    containerFull := False

    MoveDown(15 * move)
    MoveRight(10 * move)

    loop, %nbLoops% {
        if (A_Index = 1) {
            PlaceSprinkler()
        }

        Debug("Pattern #" . A_Index . "/" . nbLoops)
        loop, %subrepeat% {
            StartFetching()

            Debug("Sub-Pattern #" . A_Index . "/" . subrepeat, 3)
            turnAroundTime := move * patternLength / 4

            MoveRight(200)

            Loop, 2 {
                MoveUp(patternMoveTime)
                MoveRight(turnAroundTime * 0.5)
                PlaceSprinkler()
                MoveDown(patternMoveTime)
                MoveRight(turnAroundTime)
            }

            Loop, 2 {
                MoveUp(patternMoveTime)
                MoveLeft(turnAroundTime * 0.5)
                MoveDown(patternMoveTime)
                MoveLeft(turnAroundTime)
            }

            MoveUp(patternMoveTime * 1.5)

            Loop, 2 {
                MoveRight(patternMoveTime)
                MoveDown(turnAroundTime * 0.5)
                MoveLeft(patternMoveTime)
                MoveDown(turnAroundTime)
            }

            MoveRight(patternMoveTime / 3)
            MoveUp(patternMoveTime * 1.5)
            MoveDown(200)

            Loop, 2 {
                MoveLeft(patternMoveTime)
                MoveDown(turnAroundTime * 0.5)
                MoveRight(patternMoveTime)
                MoveDown(turnAroundTime)
            }

            MoveLeft(patternMoveTime)

            if (IsContainerFull()) {
                containerFull := True
                Break
            }
        }

        if (containerFull || A_Index = nbLoops) {
            Debug("", 2)
            Debug("", 3)
            Break
        }
    }
}

WalkSunflowerPattern(nbLoops, subrepeat) {
    StartFetching()

    move := 80
    patternMoveTime := move * patternWidth
    containerFull := False

    loop, %nbLoops% {
        if (A_Index = 1) {
            PlaceSprinkler()
        }
        Debug("Pattern #" . A_Index . "/" . nbLoops)
        loop, %subrepeat% {
            StartFetching()

            MoveDown(200)
            MoveRight(15 * move)
            MoveDown(15 * move)
            ZoomOut(5)

            Debug("Sub-Pattern #" . A_Index . "/" . subrepeat, 3)
            turnAroundTime := move * patternLength / 4

            Loop, 2 {
                MoveUp(patternMoveTime)
                MoveRight(turnAroundTime * 0.5)
                PlaceSprinkler()
                MoveDown(patternMoveTime)
                MoveRight(turnAroundTime)
            }

            Loop, 2 {
                MoveUp(patternMoveTime)
                MoveLeft(turnAroundTime * 0.5)
                MoveDown(patternMoveTime)
                MoveLeft(turnAroundTime)
            }

            MoveUp(patternMoveTime * 1.5)
            MoveDown(200)

            Loop, 2 {
                MoveRight(patternMoveTime)
                MoveDown(turnAroundTime * 0.5)
                MoveLeft(patternMoveTime)
                MoveDown(turnAroundTime)
            }

            MoveRight(patternMoveTime / 3)
            MoveUp(patternMoveTime * 1.5)
            MoveDown(200)

            Loop, 2 {
                MoveLeft(patternMoveTime)
                MoveDown(turnAroundTime * 0.5)
                MoveRight(patternMoveTime)
                MoveDown(turnAroundTime)
            }

            MoveUp(3000)
            MoveLeft(3000)

            if (IsContainerFull()) {
                containerFull := True
                Break
            }
        }

        if (containerFull || A_Index = nbLoops) {
            Debug("", 2)
            Debug("", 3)
            Break
        }
    }
}

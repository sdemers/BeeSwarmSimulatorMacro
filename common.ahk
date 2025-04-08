#Requires AutoHotkey v1.1.33+

Debug(text, index := 2) {
    FormatTime, CurrentTime, A_Now, yyyy-MM-dd HH:mm:ss
    FileAppend, [%CurrentTime%] %text% `n, log.txt
    ToolTip %text%, 50, 700, index
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
    Sleep, 50
    Send {Space down}
    Sleep 25
    Send {Space up}
    Sleep 25
    KeyUp("d")
}

StartFetching() {
    Click Down
}

StopFetching() {
    Click Up
}

ConvertHoney() {
    KeyPress("e", 50)
    Sleep, 90000

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
    maxSteps := 30
    while (step < 30) {
        MoveLeft(125)
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
    maxSteps := 30
    while (step < 30) {
        MoveRight(125)
        If (ValidateMakeHoney()) {
            return True
        }
        step := step + 1
    }

    return False
}

IsContainerFull() {
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
    SendSpace(10)
    MoveUp(500)
    Sleep 2000
    MoveRight(500 * movespeedFactor)
    MoveUp(10000 * movespeedFactor)
    MoveRight(600 * movespeedFactor)
    MoveUp(8000 * movespeedFactor)
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

            turnAroundTime := move * patternLength / 4

            loop, 4 {
                MoveLeft(patternMoveTime)
                MoveDown(turnAroundTime)
                MoveRight(patternMoveTime)
                MoveDown(turnAroundTime)
            }

            PlaceSprinkler()

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

#Persistent

stopKey := "F2"

global hivePosition := 5
global speed := 32.2

; Set the snake pattern parameters (adjust to your liking)
global patternRepeat := 10
global subpatternRepeat := 10
global patternLength := 10
global patternWidth := 10

global movespeedFactor := 28 / speed

Hotkey %stopKey%, StopScript

CoordMode, Pixel, Screen

WinActivate Roblox

Sleep 200

ToolTip Press F2 to stop script, 50, 400, 1

Debug(text, index := 2) {
    FileAppend, %text% `n, log.txt
    ToolTip %text%, 50, 700, index
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

JumpToRedCannon() {
    Send {Space down}
    Sleep 25
    Send {Space up}
    Sleep 25
    KeyPress("d", 400)
}

StartFetching() {
    Click Down
}

StopFetching() {
    Click Up
}

ConvertHoney() {
    KeyPress("e", 50)
    Sleep, 60000

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
    ; ;     if (IsConvertingHoney() = False) {
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

    if (ValidateStart()) {
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
    if (ErrorLevel != 0) {
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
    return CompareColorAt(1915, 2080, 0xffffff) || CompareColorAt(1915, 2080, 0xb1b1b1)
}

ValidatePineTreeLocation() {
    day := CompareColorAt(3750, 2000, 0x7f7156) && CompareColorAt(1900, 650, 0xd06a42)
    if (day) {
        return True
    }

    night := CompareColorAt(3750, 2000, 0x000000) && CompareColorAt(1900, 650, 0x5d2b0c)
    return night
}

MoveToHiveLeft() {
    if (ValidateMakeHoney()) {
        return True
    }

    step := 0
    maxSteps := 30
    while (step < 30) {
        MoveLeft(125)
        if (ValidateMakeHoney()) {
            return True
        }
        step := step + 1
    }

    return False
}

MoveToHiveRight() {
    if (ValidateMakeHoney()) {
        return True
    }

    step := 0
    maxSteps := 30
    while (step < 30) {
        MoveRight(125)
        if (ValidateMakeHoney()) {
            return True
        }
        step := step + 1
    }

    return False
}

MoveToMountainTop() {
    MoveUp(2875)
    MoveRight(5000)
    MoveLeft(172)
    MoveRight(57)
    JumpToRedCannon()
    MoveRight(1150)
    Sleep 200

    KeyPress("e", 15)
    Sleep 320
    MoveRight(170)
    Sleep 200
    DeployChute()
    Sleep 4700
    SendSpace()
    Sleep 500
    RotateRight()

    MoveRight(5000)
    MoveUp(5000)

    if (ValidatePineTreeLocation()) {
        return True
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

WalkPineTreePattern(nbLoops, subrepeat) {
    StartFetching()

    move := 100 * movespeedFactor
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

            turnAroundTime := move * patternLength / 4

            MoveLeft(200)

            Loop, 2 {
                MoveUp(patternMoveTime)
                MoveLeft(turnAroundTime)
                PlaceSprinkler()
                MoveDown(patternMoveTime)
                MoveLeft(turnAroundTime)
            }

            Loop, 2 {
                MoveUp(patternMoveTime)
                MoveRight(turnAroundTime)
                MoveDown(patternMoveTime)
                MoveRight(turnAroundTime)
            }

            MoveUp(patternMoveTime)

            Loop, 2 {
                MoveLeft(patternMoveTime)
                MoveDown(turnAroundTime)
                MoveRight(patternMoveTime)
                MoveDown(turnAroundTime)
            }

            MoveLeft(patternMoveTime / 3)
            MoveUp(patternMoveTime * 1.5)
            MoveDown(200)

            Loop, 2 {
                MoveRight(patternMoveTime)
                MoveDown(turnAroundTime)
                MoveLeft(patternMoveTime)
                MoveDown(turnAroundTime)
            }

            MoveRight(patternMoveTime)

            if (IsContainerFull()) {
                containerFull := True
                Break
            }
        }

        if (containerFull || A_Index = nbLoops) {
            MoveRight(5000 * movespeedFactor)
            MoveUp(5000 * movespeedFactor)
            Break
        }
    }
}

MoveToHiveSlot(slot)  {
    ; We should be facing the wall at slot #3

    MoveDown(500)

    if (slot <= 3) {
        return MoveToHiveRight()
    }
    else {
        return MoveToHiveLeft()
    }
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

ToHiveFromPineTree() {
    global hivePosition

    StopFetching()

    ; Move next to polar bear
    MoveRight(7000 * movespeedFactor)
    MoveDown(13000 * movespeedFactor)
    RotateLeft()
    MoveUp(10000 * movespeedFactor)

    JumpFromPolarBearToHive()

    if (MoveToHiveSlot(hivePosition) = False) {
        Debug("Hive not found...")
        return False
    }

    return True
}

ExecuteScript() {
    Respawn()

    loop {
        Debug("Moving to mountain top")
        if (MoveToMountainTop()) {
            Debug("Walk pine tree pattern")
            WalkPineTreePattern(patternRepeat, subpatternRepeat)
            Debug("Moving to hive")
            if (ToHiveFromPineTree()) {
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

ExecuteScript()

StopScript:
    ResetKeys()
    ExitApp
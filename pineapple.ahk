#Requires AutoHotkey v1.1.33+
#Persistent

stopKey := "F2"

global hivePosition := 2
global speed := 32.2

; Set the snake pattern parameters (adjust to your liking)
global patternRepeat := 2
global subpatternRepeat := 2
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

KeyPress(key, duration := 0) {
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

RotateCamera(times := 1) {
    If times == 0
        Return True

    camera_rotation_loops := Mod(Abs(times), 8)
    Loop, %camera_rotation_loops% {
        KeyPress(times > 0 ? "," : ".", 15)
    }
}

ZoomOut(times := 1) {
    Loop, %times% {
        KeyPress("o", 25)
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
    Else {
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
    PixelSearch, FoundX, FoundY, x - xytolerance, y - xytolerance, x + xytolerance, y + xytolerance, color, 10, True
    If (ErrorLevel != 0) {
        Debug("Pixel at " . x . "," . y . " not found", 3)
        Return False
    }
    Return True
}

CompareColorAt(x, y, targetColor, tolerance := 20) {
    PixelGetColor, color, x, y
    Debug("Pixel at " . x . "," . y . " is " . color)

    tr := format("{:d}", "0x" . substr(targetColor, 3, 2))
    tg := format("{:d}", "0x" . substr(targetColor, 5, 2))
    tb := format("{:d}", "0x" . substr(targetColor, 7, 2))

    ;split pixel into rgb
    pr := format("{:d}", "0x" . substr(color, 3, 2))
    pg := format("{:d}", "0x" . substr(color, 5, 2))
    pb := format("{:d}", "0x" . substr(color, 7, 2))

    ;check distance
    distance := sqrt((tr - pr) ** 2 + (tg - pg) ** 2 + (pb - tb) ** 2)
    ;Debug(distance)
    Return distance <= tolerance
}

ValidatePixel(x, y, color) {
    Return CompareColorAt(x, y, color)
}

ValidateMakeHoney() {
    Return CompareColorAt(2170, 240, 0xf9fff7) && CompareColorAt(2197, 185, 0xf9fff7)
}

ValidateStart() {
    Return CompareColorAt(1915, 2080, 0xffffff) || CompareColorAt(1915, 2080, 0xb1b1b1)
}

ValidateLocation() {
    day := CompareColorAt(170, 1900, 0x006493) && CompareColorAt(2730, 270, 0x958465)
    If (day) {
        Return True
    }

    night := CompareColorAt(170, 1900, 0x006491) && CompareColorAt(2730, 270, 0x000000)
    Return night
}

MoveToHiveLeft() {
    If (ValidateMakeHoney()) {
        Return True
    }

    step := 0
    maxSteps := 30
    While (step < 30) {
        MoveLeft(125)
        If (ValidateMakeHoney()) {
            Return True
        }
        step := step + 1
    }

    Return False
}

MoveToHiveRight() {
    If (ValidateMakeHoney()) {
        Return True
    }

    step := 0
    maxSteps := 30
    While (step < 30) {
        MoveRight(125)
        If (ValidateMakeHoney()) {
            Return True
        }
        step := step + 1
    }

    Return False
}

MoveToPineapple() {
    MoveUp(2875)
    MoveRight(5000)
    MoveLeft(172)
    MoveRight(57)
    JumpToRedCannon()
    MoveRight(1150)
    Sleep 200
    KeyPress("e", 15)

    Sleep 2300
    MoveLeft(5500)
    RotateCamera(4)

    MoveUp(3000)
    MoveLeft(3000)

    If (ValidateLocation()) {
        Return True
    }

    Return False
}

IsContainerFull() {
    PixelSearch, FoundX, FoundY, 2408, 100, 2410, 102, 0x1700F7, 5, True
    Return ErrorLevel = 0
}

IsConvertingHoney() {
    Return CompareColorAt(1858, 110, 0x75cde7)
}

WalkPineapplePattern(nbLoops, subrepeat) {
    StartFetching()

    move := 100
    patternMoveTime := move * patternWidth
    containerFull := False

    MoveDown(20 * move)
    MoveRight(20 * move)

    loop, %nbLoops% {
        If (A_Index = 1) {
            PlaceSprinkler()
        }

        Debug("Pattern #" . A_Index . "/" . nbLoops)
        loop, %subrepeat% {

            turnAroundTime := move * patternLength / 4

            loop, 2 {
                MoveUp(patternMoveTime)
                MoveLeft(turnAroundTime)
                MoveDown(patternMoveTime)
                MoveLeft(turnAroundTime)
            }


            loop, 2 {
                MoveUp(patternMoveTime)
                PlaceSprinkler()
                MoveRight(turnAroundTime)
                MoveDown(patternMoveTime)
                MoveRight(turnAroundTime)
            }

            If (IsContainerFull()) {
                containerFull := True
                break
            }

            MoveUp(patternMoveTime)

            loop, 2 {
                MoveLeft(patternMoveTime)
                MoveDown(turnAroundTime)
                MoveRight(patternMoveTime)
                MoveDown(turnAroundTime)
            }

            MoveLeft(patternMoveTime / 3)
            MoveUp(patternMoveTime * 1.5)
            MoveDown(200)

            loop, 2 {
                MoveRight(patternMoveTime)
                MoveDown(turnAroundTime)
                MoveLeft(patternMoveTime)
                MoveDown(turnAroundTime)
            }

            MoveRight(500)

            If (IsContainerFull()) {
                containerFull := True
                break
            }
        }

        If (containerFull || A_Index = nbLoops) {
            MoveUp(5000)
            MoveRight(5000)
            break
        }
    }
}

MoveToHiveSlot(slot) {
    ; We should be facing the wall at slot #3

    MoveDown(500)

    If (slot <= 3) {
        Return MoveToHiveRight()
    }
    else {
        Return MoveToHiveLeft()
    }
}

ToHiveFromPineapple() {
    global hivePosition

    StopFetching()

    RotateCamera(4)

    ; Walk to switch next to blue cannon
    ; Give enough time to disable haste
    MoveUp(15000)

    MoveDown(600)
    MoveRight(2000)
    MoveLeft(50)
    SendSpace(10)
    MoveRight(700)
    Sleep 300
    KeyPress("e", 20)
    Sleep 2500
    MoveUp(5000)

    If (MoveToHiveSlot(hivePosition) = False) {
        Debug("Hive not found...")
        Return False
    }

    Return True
}

ExecuteScript() {
    Respawn()

    Loop {
        Debug("Moving to pineapple")
        If (MoveToPineapple()) {
            Debug("Walk pineapple pattern")
            WalkPineapplePattern(patternRepeat, subpatternRepeat)
            Debug("Moving to hive")
            If (ToHiveFromPineapple()) {
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
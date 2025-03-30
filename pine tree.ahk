#Persistent

stopKey := "F2"

global hivePosition := 3
global speed := 32.2

; Set the snake pattern parameters (adjust to your liking)
global patternRepeat := 5
global patternLength := 5
global patternWidth := 6

global move := 100

; Set the delay between actions (adjust to your liking)
global delay := 100
global movespeedFactor := 28 / speed

Hotkey %stopKey%, StopScript

WinActivate Roblox

Sleep 200

ToolTip Press F2 to stop script, 50, 400, 1

Debug(text) {
    ToolTip %text%, 50, 700, 2
}

KeyPress(key, duration := 0)
{
    Send, {%key% down}
    Sleep, (duration * movespeedFactor)
    Send, {%key% up}
}


PlaceSprinkler() {
    Send {1 down}
    Sleep 10
    Send {1 up}
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
        KeyPress(times > 0 ? "," : ".")
    }
}

ZoomOut(times:=1)
{
    Loop, %times%
    {
        KeyPress("o")
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
    Loop {
        Sleep 500
        if (IsContainerEmpty()) {
            Sleep 2000
            Break
        }
    }
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
    ZoomOut(5)
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

MoveToPineTree() {
    MoveUp(2875)
    MoveRight(3300)
    MoveLeft(172)
    MoveRight(57)
    JumpToRedCannon()
    MoveRight(1150)

    KeyPress("e", 10)
    Sleep 320
    MoveRight(150)
    Sleep 200
    DeployChute()
    Sleep 4700
    SendSpace()
    Sleep 500
    RotateRight()

    MoveUp(3450)
    MoveRight(2300)
    MoveDown(1725)
    MoveLeft(1150)

    PlaceSprinkler()
}

IsContainerFull() {
    CoordMode, Pixel, Screen
    PixelSearch, FoundX, FoundY, 2408, 100, 2410, 102, 0x1700F7, 5, True
    return ErrorLevel = 0
}

IsContainerEmpty() {
    CoordMode, Pixel, Screen
    PixelSearch, FoundX, FoundY, 2028, 90, 2030, 92, 0x646E71, 5, True
    return ErrorLevel = 0
}

WalkPineTreePattern(nbLoops) {
    StartFetching()

    lateralMoveTime := move * patternWidth * 1.5

    loop, %nbLoops% {
        Debug("Pattern #" . A_Index . "/" . nbLoops)
        loop, %patternRepeat% {

            if (IsContainerFull()) {
                Break
            }

            moveUpTime := move * patternLength * 0.5

            MoveUp(moveUpTime)
            MoveLeft(lateralMoveTime)
            MoveUp(moveUpTime)
            MoveRight(lateralMoveTime)
            MoveUp(moveUpTime)
            MoveLeft(lateralMoveTime)
            MoveUp(moveUpTime)
            MoveRight(lateralMoveTime)

            MoveDown(moveUpTime)
            MoveLeft(lateralMoveTime)
            MoveDown(moveUpTime)
            MoveRight(lateralMoveTime)
            MoveDown(moveUpTime)
            MoveLeft(lateralMoveTime)
            MoveDown(moveUpTime)
            MoveRight(lateralMoveTime)
        }

        containerFull := IsContainerFull()

        MoveUp(moveUpTime * 8)
        MoveRight(moveUpTime * 8)
        MoveDown(moveUpTime * 4)
        MoveLeft(moveUpTime * 2)

        if (containerFull) {
            Break
        }
    }
}

MoveToHiveSlot(slot)  {
    ; We should be facing the wall at slot #3

    distance := 1150

    MoveLeft(100)
    MoveDown(630)

    if (slot == 1) {
        MoveRight(distance * 2)
    } else if (slot == 2) {
        MoveRight(distance)
    }
    else if (slot > 3) {
        MoveLeft(distance * slot - 3)
    }

    Sleep 500
}

JumpFromPolarBearToHive() {
    SendSpace(150)
    DeployChute()
    Sleep 3000
    SendSpace()
    Sleep 1000
    MoveRight(650 * movespeedFactor)
    MoveUp(10000 * movespeedFactor)
}

ToHiveFromPineTree() {
    global hivePosition

    StopFetching()

    ; Move next to polar bear
    MoveRight(5750)
    MoveDown(10300)
    RotateLeft()
    MoveUp(6 * 1150)

    JumpFromPolarBearToHive()

    MoveToHiveSlot(hivePosition)
}

Respawn()

loop {
    if (Mod(A_Index, 5) == 0) {
        Respawn()
    }

    MoveToPineTree()
    WalkPineTreePattern(10)
    ToHiveFromPineTree()
    ConvertHoney()
}

StopScript:
    ResetKeys()
    ExitApp
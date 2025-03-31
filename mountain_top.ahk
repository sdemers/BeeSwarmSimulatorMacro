#Persistent

stopKey := "F2"

global hivePosition := 3
global speed := 32.2

; Set the snake pattern parameters (adjust to your liking)
global patternRepeat := 10
global patternLength := 20

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
    Sleep, duration
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
    Loop {
        Sleep 500
        if (IsContainerEmpty()) {
            Sleep 10000
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

MoveToCannonAndFire() {
    MoveUp(2875)
    MoveRight(3300)
    MoveLeft(172)
    MoveRight(57)
    JumpToRedCannon()
    MoveRight(1150)
    Sleep 200
    KeyPress("e", 15)
}

MoveToMountainTop() {
    MoveToCannonAndFire()

    Sleep 3000
    ;RotateRight()

    ;MoveUp(3450)
    ;MoveRight(2300)
    ;MoveDown(1725)
    ;MoveLeft(1150)

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

WalkPattern(nbLoops) {
    StartFetching()

    moveTime := move * patternLength * movespeedFactor

    loop, %nbLoops% {
        Debug("Pattern #" . A_Index . "/" . nbLoops)
        loop, %patternRepeat% {

            Loop, 10 {
                MoveUp(moveTime)
                MoveDown(moveTime)
            }

            if (IsContainerFull()) {
                containerFull := True
                Break
            }
        }

        if (containerFull) {
            Break
        }
    }
}

MoveToHiveSlot(slot)  {
    ; We should be facing the wall at slot #3

    distance := 1150

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
    SendSpace(20)
    MoveUp(500 * movespeedFactor)
    Sleep 2000
    MoveRight(1000 * movespeedFactor)
    MoveUp(10000 * movespeedFactor)
    MoveRight(600 * movespeedFactor)
    MoveUp(8000 * movespeedFactor)
}

ToHiveFromMountainTop() {
    global hivePosition

    StopFetching()

    MoveDown(8000 * movespeedFactor)
    MoveRight(5000 * movespeedFactor)
    MoveUp(5000 * movespeedFactor)
    MoveRight(2000 * movespeedFactor)
    MoveUp(2000 * movespeedFactor)
    MoveRight(1500 * movespeedFactor)
    MoveLeft(1500 * movespeedFactor)
    MoveUp(5000 * movespeedFactor)

    JumpFromPolarBearToHive()

    MoveToHiveSlot(hivePosition)
}

Respawn()

loop {
    if (Mod(A_Index, 5) == 0) {
        Respawn()
    }

    MoveToMountainTop()
    WalkPattern(1)
    ToHiveFromMountainTop()
    ConvertHoney()
}

StopScript:
    ResetKeys()
    ExitApp
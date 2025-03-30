#Persistent

stopKey := "F2"

global hivePosition := 1
global speed := 32.2

; Set the snake pattern parameters (adjust to your liking)
global patternLength := 1
global patternWidth := 5

global move := 100

; Set the delay between actions (adjust to your liking)
global delay := 100
global movespeedFactor := 28 / speed

Hotkey %stopKey%, StopScript

WinActivate Roblox

Sleep 200

ToolTip "Press F2 to stop script", 50, 300

Debug(text) {
    ToolTip %text%, 50, 800
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
    Sleep, 25000
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

WalkPineTreePattern(nbLoops) {
    StartFetching()

    lateralMoveTime := move * patternWidth * 1.5

    loop, %nbLoops% {
        loop, %patternLength% {

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

        MoveUp(moveUpTime * 8)
        MoveRight(moveUpTime * 8)
        MoveDown(moveUpTime * 4)
        MoveLeft(moveUpTime * 2)
    }
}

MoveToHiveSlot(slot)  {
    global speed

    ; Move to the hive wall in front
    MoveUp(2300)
    MoveDown(230)

    ; Facing hive, move to right end
    ; if (slot != 3) {
    ;     MoveRight(4600)
    ;     MoveUp(1150)
    ;     MoveDown(575)
    ; }

    if (slot == 3) {
        MoveDown(200)
    }
    else {
        MoveRight(4600)
        MoveUp(1150)
        MoveDown(430)
        MoveLeft(300 + 1200 * slot)
    }
}

JumpFromPolarBearToHive() {
    SendSpace()
    DeployChute()
    Sleep 5700
}

ToHiveFromPineTree() {
    global hivePosition
    global speed

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
loop, 1 {
    MoveToPineTree()
    WalkPineTreePattern(1)
    ToHiveFromPineTree()
    ;ConvertHoney()
}

StopScript:
    ResetKeys()
    ExitApp
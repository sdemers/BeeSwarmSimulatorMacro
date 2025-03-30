#Persistent

stopKey := "F2"

; Set the delay between actions (adjust to your liking)
delay := 100

move := 100

hivePosition := 3
speed := 32.2

; Set the snake pattern parameters (adjust to your liking)
patternLength := 5
patternWidth := 5
rotateTime := 740

Hotkey %stopKey%, StopScript

WinActivate Roblox

Sleep 200
Click 1000, 1000, down
Sleep 200

ToolTip "Press F2 to stop script", 50, 300

Debug(text) {
    ToolTip %text%, 50, 800
}


PlaceSprinkler() {
    Send {1 down}
    Sleep 10
    Send {1 up}
}

MoveUp(time) {
    Send {w down}
    Sleep time
    Send {w up}
}

MoveDown(time) {
    Send {s down}
    Sleep %time%
    Send {s up}
}

MoveLeft(time) {
    Send {a down}
    Sleep %time%
    Send {a up}
}

MoveRight(time) {
    Send {d down}
    Sleep %time%
    Send {d up}
}

RotateRight() {
    global rotateTime
    Send {Right down}
    Sleep rotateTime
    Send {Right up}
}

RotateLeft() {
    global rotateTime
    Send {Left down}
    Sleep rotateTime
    Send {Left up}
}

JumpRight() {
    Send {Space down}
    Sleep 25
    Send {Space up}
    Sleep 25
    Send {d down}
    Sleep 400
    Send {d up}
}

StartFetching() {
    Click 1000, 1000, Down
}

StopFetching() {
    Click 1000, 1000, Up
}

ConvertHoney() {
    Send {e down}
    Sleep 50
    Send {e up}
    Sleep, 25000
}

ResetKeys() {
    Send {d up}
    Send {w up}
    Send {a up}
    Send {s up}
    Click 1000, 1000, up
}

Respawn() {
    ResetKeys()
    Send {Esc}
    Sleep 300
    Send {R}
    Sleep 300
    Send {Enter}
    Sleep 7000
    loop, 5 {
        Send {o}
        Sleep 100
    }
}

Jump(wait := 100) {
    Send {Space down}
    Sleep wait
    Send {Space up}
}

DeployChute() {
    Jump(100)
    Jump(100)
}

MoveToPineTree() {
    MoveUp(2500)
    MoveRight(5000)
    MoveLeft(150)
    MoveRight(50)
    JumpRight()
    MoveRight(1000)

    Send {e down}
    Sleep 10
    Send {e up}
    Sleep 200
    MoveRight(150)
    Sleep 300
    DeployChute()
    MoveDown(150)
    Sleep 500
    MoveRight(50)
    Sleep 2000
    MoveRight(50)
    Sleep 3000
    RotateRight()

    MoveUp(3000)
    MoveRight(2000)
    MoveDown(1500)
    MoveLeft(1000)

    PlaceSprinkler()
}

WalkPineTreePattern(nbLoops) {
    StartFetching()

    global move
    global patternWidth
    global patternLength
    lateralMoveTime := move * patternWidth * 1.5

    loop, %nbLoops% {
        loop, %patternLength% {

            Random, rand, -10, 10
            moveUpTime := (move + rand) * patternWidth * 0.5

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
    MoveUp(2000)
    MoveDown(200)

    ; Facing hive, move to right end
    MoveRight(4000)
    MoveUp(1000)
    MoveDown(500)

    if (slot == 1) {
        MoveLeft(300)
    }
    else {
        MoveLeft(300 + (25000 / speed) * slot)
    }

    Sleep 300
}

JumpFromPolarBearToHive() {
    Jump()
    DeployChute()
    Sleep 3700
    MoveLeft(15)
    Sleep 2000
}

ToHiveFromPineTree() {
    global hivePosition
    global speed

    StopFetching()

    ; Move next to polar bear
    MoveRight(5000)
    MoveDown(9000)
    MoveLeft(1000)
    MoveDown(300)
    MoveLeft(1000)
    MoveDown(300)
    MoveLeft(1000)
    MoveDown(300)
    MoveLeft(4000)
    RotateLeft()
    MoveRight(2500)
    MoveDown(800)
    MoveUp(1000)

    JumpFromPolarBearToHive()

    MoveToHiveSlot(hivePosition)
}

Respawn()
loop, 1000 {
    MoveToPineTree()
    WalkPineTreePattern(20)
    ToHiveFromPineTree()
    ConvertHoney()
}

StopScript:
    ResetKeys()
    ExitApp
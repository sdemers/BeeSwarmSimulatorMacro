#Persistent

stopKey := "F2"

; Set the delay between actions (adjust to your liking)
delay := 100

move := 100

hivePosition := 1
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

ToolTip "Press F2 to stop script", 100, 300

Debug(text) {
    ToolTip %text%, 100, 500
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
    Sleep, 15000
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

Jump() {
    Send {Space down}
    Sleep 100
    Send {Space up}
}

DeployChute() {
    Jump()
    Jump()
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
}

PineTreePattern() {
    StartFetching()

    global move
    global patternWidth
    global patternLength
    time := move * patternWidth * 0.5
    time2 := move * patternWidth * 1.5

    loop, 1 {
        loop, %patternLength% {
            MoveUp(time)
            MoveLeft(time2)
            MoveUp(time)
            MoveRight(time2)
            MoveUp(time)
            MoveLeft(time2)
            MoveUp(time)
            MoveRight(time2)

            MoveDown(time)
            MoveLeft(time2)
            MoveDown(time)
            MoveRight(time2)
            MoveDown(time)
            MoveLeft(time2)
            MoveDown(time)
            MoveRight(time2)
        }

        MoveUp(time * 8)
        MoveRight(time * 8)
        MoveDown(time * 4)
        MoveLeft(time * 4)
    }
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
    MoveRight(1500)
    MoveDown(800)
    MoveUp(1000)

    ; Jump to hive
    Jump()
    DeployChute()
    Sleep 5700
    MoveUp(800)
    MoveRight(3000)
    MoveUp(1000)
    MoveDown(500)

    if (hivePosition == 1) {
        MoveLeft(300)
    }
    else {
        MoveLeft(300 + (35000 / speed) * hivePosition)
    }

    Sleep 300
}

Respawn()
MoveToPineTree()
PineTreePattern()
ToHiveFromPineTree()
ConvertHoney()

StopScript:
    ResetKeys()
    ExitApp
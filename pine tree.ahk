#Persistent

stopKey := "F2"

; Set the delay between actions (adjust to your liking)
delay := 100

move := 100

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

Forward(time) {
    Debug(time)
    Send {w down}
    Sleep time
    Send {w up}
}

Backward(time) {
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

DeployChute() {
    Send {Space down}
    Sleep 100
    Send {Space up}
    Send {Space down}
    Sleep 100
    Send {Space up}
}

MoveToPineTree() {
    Forward(2500)
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
    Backward(150)
    Sleep 500
    MoveRight(50)
    Sleep 5000
    RotateRight()
    ;Forward(100)
    ;Backward(100)
    ;RotateRight()
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
            Forward(time)
            MoveLeft(time2)
            Forward(time)
            MoveRight(time2)
            Forward(time)
            MoveLeft(time2)
            Forward(time)
            MoveRight(time2)

            Backward(time)
            MoveLeft(time2)
            Backward(time)
            MoveRight(time2)
            Backward(time)
            MoveLeft(time2)
            Backward(time)
            MoveRight(time2)
        }

        Forward(time * 8)
        MoveRight(time * 8)
        Backward(time * 4)
        MoveLeft(time * 4)
    }
}

Respawn()
MoveToPineTree()
PineTreePattern()

StopScript:
    ResetKeys()
    ExitApp
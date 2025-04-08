#Requires AutoHotkey v1.1.33+
#Persistent

#Include, common.ahk

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

WalkHubPattern(nbLoops, subrepeat) {
    StartFetching()

    move := 100 * movespeedFactor
    patternMoveTime := move * patternWidth

    loop, %nbLoops% {
        loop, %subrepeat% {

            turnAroundTime := move * patternLength / 4

            Loop, 2 {
                MoveUp(patternMoveTime)
                MoveLeft(turnAroundTime)
                MoveDown(patternMoveTime)
                MoveLeft(turnAroundTime)
            }

            Loop, 2 {
                MoveUp(patternMoveTime)
                MoveRight(turnAroundTime)
                MoveDown(patternMoveTime)
                MoveRight(turnAroundTime)
            }
        }
    }
}

WalkHubPattern(100, 100)

StopScript:
    ResetKeys()
ExitApp
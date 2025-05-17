#Requires AutoHotkey v1.1.33+
#Persistent

#Include, common.ahk

stopKey := "F2"

global g_hivePosition := 5
global g_speed := 32.2

; Set the snake pattern parameters (adjust to your liking)
global g_patternRepeat := 10
global g_subpatternRepeat := 10
global g_patternLength := 10
global g_patternWidth := 10

global g_movespeedFactor := 28 / g_speed

Hotkey %stopKey%, StopScript

CoordMode, Pixel, Screen

WinActivate Roblox

Sleep 200

ToolTip Press F2 to stop script, 3200, 400, 1

WalkHubPattern(nbLoops, subrepeat) {
    StartFetching()

    move := 100 * g_movespeedFactor
    patternMoveTime := move * g_patternWidth

    loop, %nbLoops% {
        loop, %subrepeat% {

            turnAroundTime := move * g_patternLength / 4

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
#Requires AutoHotkey v1.1.33+
#Persistent

#Include, config.ahk
#Include, common.ahk

WalkHub(move := 1000) {

    Loop {
        StartFetching()

        MoveLeft(move)
        MoveDown(move)
        MoveRight(move)
        MoveUp(move)
    }
}

WalkTopRightPattern(move := 1000) {

    StartFetching()

    TwoKeyPress("a", "s", 1500)
    PlaceSprinkler(g_sprinklers)

    stopFetching := False

    Loop {
        driftBack := Mod(A_Index, 5) == 0
        reposition := Mod(A_Index, 15) == 0

        StartFetching()

        Loop, 2 {
            MoveLeft(move * 0.72)
            MoveDown(move * 0.1)
            MoveRight(move * 0.72)
            MoveDown(move * 0.1)
        }

        Loop, 2 {
            MoveLeft(move * 0.72)
            MoveUp(move * 0.1)
            if (driftBack) {
                MoveRight(move * 0.8)
            } else {
                MoveRight(move * 0.72)
            }
            MoveUp(move * 0.1)
        }

        if (reposition) {
            MoveRight(1000)
            MoveUp(1000)
            TwoKeyPress("a", "s", 700)
            MoveRight(300)
        }
    }
}

WinActivate Roblox
Sleep 200

;WalkHub()
WalkTopRightPattern(750)
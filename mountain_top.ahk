#Requires AutoHotkey v1.1.33+
#Persistent

global hivePosition := 5
global speed := 33.3
global patternRepeat := 10
global patternWidth := 8
global patternLength := 10

#Include, common.ahk

WinActivate Roblox

Sleep 200

MoveToMountainTop() {
    FromHiveToCannon(hivePosition)

    Sleep 3000

    PlaceSprinkler()

    return True
}

WalkMountainTopPattern(patternRepeat) {
    RotateCamera(4)

    MoveUp(5000)
    MoveRight(3000)
    WalkRosePattern(patternRepeat, 10, 3000, 500)
}

;     loop, %nbLoops% {
;         Debug("Pattern #" . A_Index . "/" . nbLoops)

;         MoveUp(4000)
;         MoveRight(2000)

;         MoveDown(500)

;         loop, 6 {
;             MoveLeft(700)
;             MoveDown(200)
;             MoveRight(500)
;             MoveDown(200)
;         }

;         MoveLeft(2000)
;         MoveRight(1000)

;         loop, 4 {
;             MoveRight(800)
;             MoveUp(200)
;             MoveLeft(500)
;             MoveUp(200)
;         }

;         if (stop) {
;             Break
;         }
;     }
; }

ToHiveFromMountainTop() {
    global hivePosition

    StopFetching()

    MoveDown(8000)
    MoveRight(5000)
    MoveUp(5000)
    MoveRight(2000)
    MoveUp(2000)
    MoveRight(1500)
    MoveLeft(1500)
    MoveUp(5000)

    JumpFromPolarBearToHive()

    MoveToHiveSlot(hivePosition)
}

ExecuteMountainTopScript() {
    Respawn()

    loop {
        Debug("Moving to mountain top")
        if (MoveToMountainTop()) {
            Debug("Walk mountain top pattern")
            WalkMountainTopPattern(patternRepeat)
            Debug("Moving to hive")
            if (ToHiveFromMountainTop()) {
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

;ExecuteMountainTopScript()

WalkPineTreePattern(10, 10, 2, 400)

#Requires AutoHotkey v1.1.33+
#Persistent

#Include, config.ahk
#Include, common.ahk
#Include, booster.ahk

Sleep, 5

; missing dandelion return to hive

runBamboo := False
runBlueFlower := False
runCactus := False
runClover := False
runCoconut := False
runDandelion := False
runHub := False
runMountainTop := False
runMushroom := False
runPepper := False
runPineapple := False
runPineTree := False
runPumpkin := False
runRose := False
runSpider := False
runStrawberry := False
runStump := False
runSunflower := False

g_hivePosition := 2

;runBamboo := True
;runBlueFlower := True
;runCactus := True
;runClover := True
;runCoconut := True
runDandelion := True
;runHub := True
;runMountainTop := True
;runMushroom := True
;runPepper := True
;runPineapple := True
;runPineTree := True
;runPumpkin := True
;runRose := True
;runSpider := True
;runStrawberry := True
;runStump := True
;runSunflower := True

WinActivate Roblox
Sleep 200

;CheckForFieldBooster()

;Respawn(True)
;TestCannon()
;Sleep, 10000

If (runSunflower) {
    #Include, sunflower.ahk
    ExecuteSunflowerScript()
}

If (runCactus) {
    #Include, cactus.ahk
    ExecuteCactusScript()
}

if (runStrawberry) {
    #Include, strawberry.ahk
    ExecuteStrawberryScript()
}

If (runPumpkin) {
    #Include, pumpkin.ahk
    ExecutePumpkinScript()
}

If (runBlueFlower) {
    #Include, blue_flower.ahk
    ExecuteBlueFlowerScript()
}

If (runPepper) {
    #Include, pepper.ahk
    ExecutePepperScript()
}

If (runPineTree) {
    #Include, pine tree.ahk
    ExecutePineTreeScript()
}

If (runPineapple) {
    #Include, pineapple.ahk
    ExecutePineappleScript()
}

If (runCoconut) {
    #Include, coconut.ahk
    ExecuteCoconutScript()
}

If (runRose) {
    #Include, rose.ahk
    ExecuteRoseScript()
}

If (runMountainTop) {
    #Include, mountain_top.ahk
    ExecuteMountainTopScript()
}

If (runSpider) {
    #Include, spider.ahk
    ExecuteSpiderScript()
}

If (runMushroom) {
    #Include, mushroom.ahk
    ExecuteMushroomScript()
}

if (runStump) {
    #Include, stump.ahk
    ExecuteStumpScript()
}

If (runBamboo) {
    #Include, bamboo.ahk
    ExecuteBambooScript()
}

If (runDandelion) {
    #Include, dandelion.ahk
    ;MoveToDandelion()
    ExecuteDandelionScript()
}

If (runHub) {
    #Include, hub.ahk
    WalkHubPattern()
}

If (runClover) {
    #Include, clover.ahk
    ExecuteCloverScript()
}
#Requires AutoHotkey v1.1.33+
#Persistent

#Include, config.ahk
#Include, common.ahk

runSunflower := False
runCactus := False
runStrawberry := False
runPumpkin := False
runBlueFlower := False
runPepper := False
runPineTree := False
runPineapple := False
runCoconut := False
runRose := False
runMountainTop := False
runSpider := False
runMushroom := False
runStump := True

If (runSunflower) {
    #Include, sunflower.ahk
    ExecuteSunflowerScript()
}

If (runCactus) {
    #Include, cactus.ahk
    ExecuteCactusScript()
}

If (runStrawberry) {
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

import datetime
import pyautogui
import win32gui
import json
import httpx
import time

webhook_url = 'https://discord.com/api/webhooks/1378860365961756766/hmJ77NkKBhHPqghftZ3Q6bhmaIs2uPGEKvLiicWd1jQh_8gAaSrLv8zRUIf24rxr4Yfs'

def postImageToDiscord(image1, image2):
    global webhook_url
    with open(image1, "rb") as io_object1:
        with open(image2, "rb") as io_object2:
            response = httpx.post(
                webhook_url,
                data={"payload_json": json.dumps({
                    "embeds": [{
                        "description": datetime.datetime.now().strftime('[%H:%M:%S] Current Honey/Pollen'),
                        "image": {"url": f"attachment://{image1}"}
                    },
                    {
                        "image": {"url": f"attachment://{image2}"}
                    }]
                })},
                files={"file1": (image1, io_object1, "image/png"), "file2": (image2, io_object2, "image/png")}
            )

            # raise an exception if the operation failed.
            response.raise_for_status()

while True:
    hwnd = win32gui.FindWindow(None, 'Roblox')
    if win32gui.IsWindowVisible(hwnd):
        # Take a screenshot
        honey = pyautogui.screenshot(region=(1405, 82, 481, 50))
        pollen = pyautogui.screenshot(region=(1931, 82, 481, 50))

        # Save the screenshot to a file
        honey.save('honey.png')
        pollen.save('pollen.png')
        postImageToDiscord('honey.png', 'pollen.png')

    time.sleep(10)
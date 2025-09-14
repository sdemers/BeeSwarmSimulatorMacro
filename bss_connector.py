import datetime
import pyautogui
import win32gui
import time
import cv2
import numpy as np
import config
from discord_webhook import DiscordWebhook, DiscordEmbed

webhook = DiscordWebhook(url=config.webhook_url)

g_message_id = 0


def copy_images(img1, img2):
    # Load the images
    img1 = cv2.imread(img1)
    img2 = cv2.imread(img2)

    # Get the dimensions of the images
    height1, width1, _ = img1.shape
    height2, width2, _ = img2.shape

    # Create a new image with the combined height of the two images
    new_height = height1 + height2
    new_width = max(width1, width2)
    new_img = np.zeros((new_height, new_width, 3), dtype=np.uint8)

    # Copy the first image to the top of the new image
    new_img[:height1, :width1, :] = img1
    new_img[height1:, :width2, :] = img2

    small = cv2.resize(new_img, (0,0), fx=0.7, fy=0.7)
    cv2.imwrite('merged.png', small)
    return 'merged.png'

def post_image(image_filename, add_new_message=False):
    global webhook
    with open(image_filename, "rb") as f:
        webhook.remove_embeds()
        webhook.remove_files()
        embed = DiscordEmbed(
            description=f"{datetime.datetime.now().strftime('[%H:%M:%S] Current Honey/Pollen')}")
        embed.set_image(url=f"attachment://{image_filename}")
        webhook.add_embed(embed)
        webhook.add_file(file=f.read(), filename=image_filename)
        if add_new_message:
            webhook.execute()
        else:
            webhook.edit()

add_new_message = True
last_update = datetime.datetime.now()
while True:
    try:
        hwnd = win32gui.FindWindow(None, 'Roblox')
        foreground_window = win32gui.GetForegroundWindow()
        if hwnd == foreground_window:
            # Take a screenshot
            honey = pyautogui.screenshot(region=(1405, 82, 481, 50))
            pollen = pyautogui.screenshot(region=(1931, 82, 481, 50))

            honey.save('honey.png')
            pollen.save('pollen.png')
            merged = copy_images('honey.png', 'pollen.png')

            now = datetime.datetime.now()
            if now.minute < last_update.minute:
                add_new_message = True
            post_image(merged, add_new_message)
            last_update = now
            add_new_message = False

        time.sleep(1)
    except Exception as e:
        print("Error:", e)
        time.sleep(10)
        webhook = DiscordWebhook(url=config.webhook_url)
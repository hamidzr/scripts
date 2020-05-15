#!/usr/bin/env -S pipenv run python

import os
import pyautogui
from statistics import mean
import numpy as np
from PIL import Image
import cv2

PIXEL_SIZE = 1
WHITE = True
BLACK = False

pyautogui.FAILSAFE = True
pyautogui.PAUSE = 0.005


def threshold(imageArray):
    balanceAr = []
    # newAr = imageArray
    for eachRow in imageArray:
        for eachPix in eachRow:
            avgNum = mean(eachPix[:3])
            balanceAr.append(avgNum)
    return np.array(balanceAr)


image = Image.open(
    f"{os.getenv('HOME')}/dl/hamid-biz.jpeg")  # open color image
image = image.convert("1")  # convert image to black and white
# reduce size keeping the aspect ratio
image.thumbnail((300, 300), Image.ANTIALIAS)
image = cv2.Canny(image, threshold1=200, threshold2=300)
pix = np.array(image)
# pix = threshold(pix)
# pix_image = Image.fromarray(pix)
# pix_image.save("output2.jpg")
# image.save("output.jpg")
cv2.imshow('window', image)


print("input image shape:", pix.shape)

sx, sy = pyautogui.position()


# approach 1
# for y, lines in enumerate(pix):
#     # pyautogui.moveTo(sx, None)
#     for x, v in enumerate(lines):
#         # print(x, y, '=', v)
#         pyautogui.move(PIXEL_SIZE, 0, 0)
#         print(v)
#         if v:
#             pyautogui.click()
#     pyautogui.move(-1 * PIXEL_SIZE * len(picture[0]), PIXEL_SIZE)

# approach 2
# for y, lines in enumerate(pix):
#     # pyautogui.moveTo(sx, None)
#     if y % 2 == 0:
#         continue
#     for x, v in enumerate(lines):
#         if v:
#             pyautogui.moveTo(sx+x, sy+y, 0)
#             pyautogui.click()

# approach 3
# for y, line in enumerate(pix):
#     if y % 5 != 0:
#         continue
#     pyautogui.mouseUp()
#     mouseDown = False
#     for x, v in enumerate(line):
#         if v == BLACK and not mouseDown:
#             pyautogui.moveTo(sx+x, sy+y, 0)
#             pyautogui.mouseDown()
#             mouseDown = True
#         elif v == WHITE and mouseDown:
#             pyautogui.moveTo(sx+x, sy+y, 0)
#             pyautogui.mouseUp()
#             mouseDown = False
#         elif x == len(line)-1:
#             pyautogui.moveTo(sx+x, sy+y, 0)
#             pyautogui.mouseUp()
#             mouseDown = False

# pyautogui.mouseUp()
# mouseDown = False

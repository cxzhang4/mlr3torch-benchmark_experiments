import torch
import torchvision.transforms as transforms
import torchvision.transforms.functional as F

class CustomCrop(object):
    def __init__(self, top, left, height, width):
        self.top = top
        self.left = left
        self.height = height
        self.width = width

    def __call__(self, img):
        return F.crop(img, self.top, self.left, self.height, self.width)

class AddChannelDimension(object):
    def __call__(self, img):
        return img.unsqueeze(1)

class RGB_to_Grayscale(object):
    def __call__(self, img):
        return transforms.functional.rgb_to_grayscale(img)
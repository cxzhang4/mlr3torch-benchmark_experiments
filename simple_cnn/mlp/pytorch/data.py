import torch
import os
from torch.utils.data import Dataset
import torchvision.transforms as transforms
from torchvision.transforms import ToTensor
from torchvision.io import read_image
from torchvision.io import ImageReadMode
import custom_transforms
import pandas as pd

trn_idx = range(0, 10000)
val_idx = range(10001, 15000)
tst_idx = range(15001, 20000)

class GuessTheCorrelationDataset(Dataset):
    def __init__(self, root, responses_file_path, transform=None, target_transform=None):
        self.root = root
        self.images = pd.read_csv(root + "/" + responses_file_path)
        self.transform = transform
        self.target_transform = target_transform

    def __len__(self):
        return len(self.images)
    
    def __getitem__(self, index):
        row = self.images.iloc[index]

        img_path = self.root + "/train_imgs/" + row["id"] + ".png"
        img = read_image(img_path, mode = ImageReadMode.GRAY)
        img = img.unsqueeze(1)

        if self.transform:
            img = self.transform(img)

        label = row["corr"].astype(float)

        return img, label
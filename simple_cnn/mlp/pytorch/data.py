import torch
import os
from torch.utils.data import Dataset
from torchvision.transforms import ToTensor
from torchvision.io import read_image
import pandas as pd

trn_idx = range(0, 10000)
val_idx = range(10001, 15000)
tst_idx = range(15001, 20000)

class GuessTheCorrelationDataset(Dataset):
    def __init__(self, root, responses_file_path, path, transform=None, target_transform=None):
        self.root = root
        self.images = pd.read_csv(responses_file_path)
        self.path = path
        self.transform = transform
        self.target_transform = target_transform

    def __len__(self):
        return len(self.images)
    
    def __getitem__(self, index):
        row = self.images.iloc[index]

        img_path = root + "/" + row["id"].astype(str) + ".png"
        img = read_image(img_path)
        
        default_transforms = transforms.Compose([
            transforms.ToTensor(),
            transforms.functional.rgb_to_grayscale()
        ])

        img = default_transforms(img)

        if self.transform:
            img = self.transform(img)

        return img
import torch
import os
from torch.utils.data import Dataset
import torchvision.transforms as transforms
from torchvision.transforms import ToTensor
from torchvision.io import read_image
from torchvision.io import ImageReadMode
import custom_transforms
import pandas as pd

class GuessTheCorrelationDataset(Dataset):
    def __init__(self, root, responses_file_path, transform=None, indexes=None, target_transform=None):
        self.root = root
        self.responses_df = pd.read_csv(root + "/" + responses_file_path)
        self.transform = transform
        self.target_transform = target_transform
        
        if indexes:
            self.responses_df = self.responses_df.iloc[indexes]

    def __len__(self):
        return len(self.responses_df)
    
    def __getitem__(self, index):
        row = self.responses_df.iloc[index]

        # TODO: refactor this to use os.path.join
        # https://pytorch.org/tutorials/beginner/data_loading_tutorial.html
        img_path = self.root + "/train_imgs/" + row["id"] + ".png"
        img = read_image(img_path, mode = ImageReadMode.GRAY)
        img = img.unsqueeze(1)

        if self.transform:
            img = self.transform(img)

        label = row["corr"].astype(float)

        return img, label
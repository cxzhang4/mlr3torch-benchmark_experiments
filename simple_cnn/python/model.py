import torch
from torch import nn
import torch.nn.functional as F

class CorrCNN(nn.Module):
    """A CNN for guessing the correlation of a scatter plot."""

    def __init__(self):
        super().__init__()

        self.conv1 = nn.Conv2d(in_channels = 1, out_channels = 32, kernel_size = 3)
        self.conv2 = nn.Conv2d(in_channels = 32, out_channels = 64, kernel_size = 3)
        self.conv3 = nn.Conv2d(in_channels = 64, out_channels = 128, kernel_size = 3)

        self.fc1 = nn.Linear(in_features = 14 * 14 * 128, out_features = 128)
        self.fc2 = nn.Linear(in_features = 128, out_features = 1)
    
    def forward(self, x: torch.Tensor) -> torch.Tensor:
        x = torch.relu(self.conv1(x))
        x = F.avg_pool2d(x, kernel_size=2)

        x = torch.relu(self.conv2(x))
        x = F.avg_pool2d(x, kernel_size=2)

        x = torch.relu(self.conv3(x))
        x = F.avg_pool2d(x, kernel_size=2)

        x = torch.fflatten(x, start_dim = 2)

        x = F.relu(self.fc1(x))

        x = self.fc2(x)

        return x

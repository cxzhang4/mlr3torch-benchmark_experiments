import torch
from torch import nn
import torch.nn.functional as F

def create_mlp():
    mlp = nn.Sequential(
        nn.Flatten(),
        nn.Linear(16900, 20),
        nn.ReLU(),
        nn.Linear(20, 20),
        nn.ReLU(),
        nn.Linear(20, 1)
    )
    return mlp

def create_cnn():
    cnn =  nn.Sequential(
        nn.Conv2d(in_channels=1, out_channels=32, kernel_size=3),
        nn.ReLU(),
        nn.AvgPool2d(2),
        nn.Conv2d(in_channels=32, out_channels=64, kernel_size=3),
        nn.ReLU(),
        nn.AvgPool2d(2),
        nn.Conv2d(in_channels=64, out_channels=128, kernel_size=3),
        nn.ReLU(),
        nn.AvgPool2d(2),
        nn.Flatten(start_dim=2),
        nn.Linear(in_features=14 * 14 * 128, out_features=128),
        nn.ReLU(),
        nn.Linear(in_features=128, out_features=1)
    )
    return cnn

def create_learner(architecture_id):
    if architecture_id == "mlp":
        return create_mlp()
    if architecture_id == "cnn":
        return create_cnn()
    
def create_opt(learner, lr):
    return torch.optim.Adam(learner.parameters(), lr)
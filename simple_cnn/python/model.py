import torch
from torch import nn

class MLP(nn.Module):
    """A multi-layer perceptron"""

    def __init__(self):
        super().__init__()
        
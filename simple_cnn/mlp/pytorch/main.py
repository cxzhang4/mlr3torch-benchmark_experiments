import torch
import torch.nn as nn 

n_epochs = 3
batch_size = 64
lr = 0.01

# create a torch dataset


# create a learner
# TODO: compute input_dim instead of hard-coding it
input_dim = 16900
output_dim = 1

learner_torch_mlp = nn.Sequential(
    nn.Flatten(),
    nn.Linear(input_dim, 20),
    nn.ReLU(),
    nn.Linear(20, 20),
    nn.ReLU(),
    nn.Linear(20, output_dim)
)

# train the learner

for i in range(n_epochs):


# predict using the learner
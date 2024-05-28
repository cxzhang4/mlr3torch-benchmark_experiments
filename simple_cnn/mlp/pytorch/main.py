import torch
import torch.nn as nn 
import torchvision.transforms as transforms
import custom_transforms
from data import GuessTheCorrelationDataset
import time

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

loss_fn = torch.nn.MSELoss()
optimizer = torch.optim.Adam(learner_torch_mlp.parameters(), lr = lr)

transforms_for_corr_images = transforms.Compose([
    custom_transforms.AddChannelDimension(),
    custom_transforms.CustomCrop(top = 0, left = 21, height = 131, width = 130),
])

train_ds = GuessTheCorrelationDataset(root = "data/correlation/guess-the-correlation",
                                      responses_file_path = "train.csv",
                                      transform = transforms_for_corr_images,
                                      )

print(train_ds.__getitem__(0)[0].shape)

train_dataloader = torch.utils.data.DataLoader(train_ds, batch_size=batch_size)

start_time = time.time()
for i in range(n_epochs):
    learner_torch_mlp.train()
    for i, (img, target) in enumerate(train_dataloader):
        # img, target = img.to(DEVICE), target.to(DEVICE)
        optimizer.zero_grad()
        y_pred = learner_torch_mlp(img)
        loss = loss_fn(y_pred, target)
        loss.backward()
        optimizer.step()
end_time = time.time()

print(end_time - start_time)
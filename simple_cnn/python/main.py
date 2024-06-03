import torch
import torch.nn as nn 
import torchvision.transforms as transforms
from data import GuessTheCorrelationDataset
import time
import custom_transforms
import model

n_epochs = 2
batch_size = 64
lr = 0.01

# create a torch dataset

# create a learner
# TODO: compute input_dim instead of hard-coding it
# TODO: fix the transformations so that the true input dimension matches the hard-coded input dimension
input_dim = 16900
output_dim = 1

learner_torch_cnn = model.CorrCNN()

# train the learner

loss_fn = torch.nn.MSELoss()
optimizer = torch.optim.Adam(learner_torch_cnn.parameters(), lr = lr)

transforms_for_corr_images = transforms.Compose([
    custom_transforms.CustomCrop(top = 0, left = 21, height = 130, width = 130),
    # custom_transforms.AddChannelDimension()
])

trn_idx = range(0, 10000)
# val_idx = range(10001, 15000)
# tst_idx = range(15001, 20000)

train_ds = GuessTheCorrelationDataset(root = "data/correlation/guess-the-correlation",
                                      responses_file_path = "train.csv",
                                      transform = transforms_for_corr_images,
                                      indexes = trn_idx)

# print(train_ds.__getitem__(0)[0].shape)
# print(train_ds.__getitem__(0)[1])

train_dataloader = torch.utils.data.DataLoader(train_ds, batch_size=batch_size)

start_time = time.time()
for i in range(n_epochs):
    learner_torch_cnn.train()
    for i, (img, target) in enumerate(train_dataloader):
        optimizer.zero_grad()
        img = img.float()
        y_pred = learner_torch_cnn(img)
        loss = loss_fn(torch.squeeze(y_pred), target.float())
        loss.backward()
        optimizer.step()
end_time = time.time()

print(end_time - start_time)
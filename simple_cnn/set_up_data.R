# get the data, if necessary
# set up datasets and dataloaders

library(torch)
library(torchvision)
library(torchdatasets)

trn_idx <- 1:10000
val_idx <- 10001:15000
tst_idx <- 15001:20000

add_channel_dim <- function(img) img$unsqueeze(1)
crop_axes <- function(img) transform_crop(img, top = 0, left = 21, height = 131, width = 130)

root <- file.path("data", "correlation")

train_ds <- guess_the_correlation_dataset(
  root = root,
  transform = function(img) add_channel_dim(crop_axes(img)),
  indexes = trn_idx,
  download = FALSE # change if necessary
)

valid_ds <- guess_the_correlation_dataset(
  root = root,
  transform = function(img) add_channel_dim(crop_axes(img)),
  indexes = val_idx,
  download = FALSE
)

test_ds <- guess_the_correlation_dataset(
  root = root,
  transform = function(img) add_channel_dim(crop_axes(img)),
  indexes = tst_idx,
  download = FALSE
)

train_dl <- dataloader(train_ds, batch_size = 64, shuffle = TRUE)
valid_dl <- dataloader(valid_ds, batch_size = 64)
test_dl <- dataloader(test_ds, batch_size = 64)


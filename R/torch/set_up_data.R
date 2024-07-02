# largely copied from the tutorial

library(torch)
library(torchvision)
library(torchdatasets)

data_dir = here("data", "correlation")

# arbitrarily define indices
trn_idx = 1:10000
val_idx = 10001:15000
tst_idx = 15001:20000

# helper functions for data transformation
add_channel_dim = function(img) img$unsqueeze(1)
crop_axes = function(img) transform_crop(img, top = 0, left = 21, height = 131, width = 130)

# create the datasets
train_torch_ds = guess_the_correlation_dataset(
  root = data_dir,
  transform = function(img) add_channel_dim(crop_axes(img)),
  indexes = trn_idx,
  download = FALSE
)

valid_torch_ds = guess_the_correlation_dataset(
  root = data_dir,
  transform = function(img) add_channel_dim(crop_axes(img)),
  indexes = val_idx,
  download = FALSE
)

test_torch_ds = guess_the_correlation_dataset(
  root = data_dir,
  transform = function(img) add_channel_dim(crop_axes(img)),
  indexes = tst_idx,
  download = FALSE
)
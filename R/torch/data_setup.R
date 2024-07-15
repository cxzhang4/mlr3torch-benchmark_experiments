# creates the dataset and dataloader
library(torchvision)
library(torchdatasets)

# helper functions for data transformation
add_channel_dim = function(img) img$unsqueeze(1)
crop_axes = function(img) transform_crop(img, top = 0, left = 21, height = 131, width = 130)

create_torch_ds = function(data_dir, trn_idx) {
  guess_the_correlation_dataset(
    root = data_dir,
    transform = function(img) add_channel_dim(crop_axes(img)),
    indexes = trn_idx,
    download = FALSE
  )
}

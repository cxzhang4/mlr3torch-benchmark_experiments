# creates the dataset and dataloader
library(torchvision)
library(torchdatasets)

# helper functions for data transformation
add_channel_dim = function(img) img$unsqueeze(1)
crop_axes = function(img) transform_crop(img, top = 0, left = 21, height = 131, width = 130)

mlp_transform = function(img) {
  torch_flatten(add_channel_dim(crop_axes(img)))
}

cnn_transform = function(img) {
  add_channel_dim(crop_axes(img))
}

create_torch_ds = function(data_dir, idx, architecture_id) {
  if (architecture_id == "mlp") {
    guess_the_correlation_dataset(
      root = data_dir,
      transform = mlp_transform,
      indexes = idx,
      download = FALSE
    )
  } else if (architecture_id == "cnn") {
    guess_the_correlation_dataset(
      root = data_dir,
      transform = cnn_transform,
      indexes = idx,
      download = FALSE
    )
  } else {
    guess_the_correlation_dataset(
      root = data_dir,
      transform = cnn_transform,
      indexes = idx,
      download = FALSE
    )
  }
}

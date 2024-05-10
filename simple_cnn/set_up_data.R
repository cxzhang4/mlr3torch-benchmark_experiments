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

# train_torch_ds <- guess_the_correlation_dataset(
#   root = root,
#   transform = function(img) add_channel_dim(crop_axes(img)),
#   indexes = trn_idx,
#   download = FALSE # change if necessary
# )

# valid_torch_ds <- guess_the_correlation_dataset(
#   root = root,
#   transform = function(img) add_channel_dim(crop_axes(img)),
#   indexes = val_idx,
#   download = FALSE
# )

# test_torch_ds <- guess_the_correlation_dataset(
#   root = root,
#   transform = function(img) add_channel_dim(crop_axes(img)),
#   indexes = tst_idx,
#   download = FALSE
# )

# train_dl <- dataloader(train_torch_ds, batch_size = 64, shuffle = TRUE)
# valid_dl <- dataloader(valid_torch_ds, batch_size = 64)
# test_dl <- dataloader(test_torch_ds, batch_size = 64)

maybe_download <- function(url, root, name, extract_fun, download) {
  data_path <- fs::path_expand(fs::path(root, name))

  if (!fs::dir_exists(data_path) && download) {
    tmp <- tempfile()
    download_file(url, tmp)
    fs::dir_create(fs::path_dir(data_path), recurse = TRUE)
    extract_fun(tmp, data_path)
  }

  if (!fs::dir_exists(data_path))
    stop("No data found. Please use `download = TRUE`.")

  data_path
}

guess_the_correlation_dataset_ <- torch::dataset(
  "GuessTheCorrelation",
  initialize = function(root, split = "train", transform = NULL, target_transform = NULL, indexes = NULL, download = FALSE) {

    self$transform <- transform
    self$target_transform <- target_transform

    # donwload ----------------------------------------------------------
    data_path <- maybe_download(
      root = root,
      name = "guess-the-correlation",
      url = "https://storage.googleapis.com/torch-datasets/guess-the-correlation.zip",
      download = download,
      extract_fun = function(temp, data_path) {
        unzip2(temp, exdir = data_path)
        unzip2(fs::path(data_path, "train_imgs.zip"), exdir = data_path)
        unzip2(fs::path(data_path, "test_imgs.zip"), exdir = data_path)
      }
    )

    # variavel resposta -------------------------------------------------

    if(split == "train") {
      self$images <- readr::read_csv(fs::path(data_path, "train.csv"), col_types = c("cn"))
      if(!is.null(indexes)) self$images <- self$images[indexes, ]
      self$.path <- file.path(data_path, "train_imgs")
    } else if(split == "submission") {
      self$images <- readr::read_csv(fs::path(data_path, "example_submition.csv"), col_types = c("cn"))
      self$images$corr <- NA_real_
      self$.path <- file.path(data_path, "test_imgs")
    }
  },

  .getitem = function(index) {

    force(index)

    sample <- self$images[index, ]
    id <- sample$id
    x <- torchvision::base_loader(file.path(self$.path, paste0(sample$id, ".png")))
    x <- torchvision::transform_to_tensor(x) %>% torchvision::transform_rgb_to_grayscale()

    if (!is.null(self$transform))
      x <- self$transform(x)

    # y <- torch::torch_scalar_tensor(sample$corr)
    # if (!is.null(self$target_transform))
    #   y <- self$target_transform(y)

    return(list(x = x))
  },

  .length = function() {
    nrow(self$images)
  }
)

train_mlr3torch_ds <- guess_the_correlation_dataset_(
  root = root,
  transform = function(img) crop_axes(img),
  indexes = trn_idx,
  download = TRUE # change if necessary
)

valid_mlr3torch_ds <- guess_the_correlation_dataset_(
  root = root,
  transform = function(img) crop_axes(img),
  indexes = val_idx,
  download = FALSE
)

test_mlr3torch_ds <- guess_the_correlation_dataset_(
  root = root,
  transform = function(img) crop_axes(img),
  indexes = tst_idx,
  download = FALSE
)

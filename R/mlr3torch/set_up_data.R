library(data.table)
library(torch)
library(mlr3torch)
library(torchvision)

# a modified version of the function from torchdatasets
# where $.getitem() returns only the features
guess_the_correlation_dataset_mlr3torch = torch::dataset(
  "GuessTheCorrelation",
  initialize = function(root, split = "train", transform = NULL, target_transform = NULL, indexes = NULL, download = FALSE) {

    self$transform = transform
    self$target_transform = target_transform

    # donwload ----------------------------------------------------------
    data_path = maybe_download(
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
      self$images = readr::read_csv(fs::path(data_path, "train.csv"), col_types = c("cn"))
      if(!is.null(indexes)) self$images = self$images[indexes, ]
      self$.path = file.path(data_path, "train_imgs")
    } else if(split == "submission") {
      self$images = readr::read_csv(fs::path(data_path, "example_submition.csv"), col_types = c("cn"))
      self$images$corr = NA_real_
      self$.path = file.path(data_path, "test_imgs")
    }
  },

  .getitem = function(index) {

    force(index)

    sample = self$images[index, ]
    id = sample$id
    x = torchvision::base_loader(file.path(self$.path, paste0(sample$id, ".png")))
    x = torchvision::transform_to_tensor(x) %>% torchvision::transform_rgb_to_grayscale()

    if (!is.null(self$transform))
      x = self$transform(x)

    # y = torch::torch_scalar_tensor(sample$corr)
    # if (!is.null(self$target_transform))
    #   y = self$target_transform(y)

    return(list(x = x))
  },

  .length = function() {
    nrow(self$images)
  }
)

# arbitrarily define indices
trn_idx = 1:10000

# helper functions for data transformation
crop_axes = function(img) transform_crop(img, top = 0, left = 21, height = 131, width = 130) 
add_channel_dim = function(img) img$unsqueeze(1)

# no channel dimension
train_mlr3torch_ds = guess_the_correlation_dataset_mlr3torch(
  root = data_dir,
  transform = function(img) add_channel_dim(crop_axes(img)),
  indexes = trn_idx,
  download = FALSE
)

create_task_from_ds = function(ds, responses_dt, response_col_name) {
  dd_gtcorr = as_data_descriptor(ds, list(x = c(NA, 1, 130, 130)))

  lt = lazy_tensor(dd_gtcorr)

  dt_train = data.table(corr = train_responses[[response_col_name]][trn_idx], x = lt)

  as_task_regr(dt_train, target = "corr", id = "guess_the_correlation")
}
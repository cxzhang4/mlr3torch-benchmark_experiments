library(here)

source(here("simple_cnn", "download_data.R"))

source(here("simple_cnn", "R", "time_training.R"))
n_epochs = 10
batch_size = 64
lr = 0.01

print("torch:")
print(time_torch(n_epochs, batch_size, lr))

print("mlr3torch:")
print(time_mlr3torch(n_epochs, batch_size, lr))

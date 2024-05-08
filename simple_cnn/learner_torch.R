input_dim <- prod(dim(train_ds[1]$x))
print(input_dim)
output_dim <- 1

learner_torch_mlp <- nn_sequential(
  nn_flatten(),
  nn_linear(input_dim, 20),
  nn_relu(),
  nn_linear(20, 20),
  nn_relu(),
  nn_linear(20, output_dim)
)

# torch_manual_seed(777)

# corr_cnn <- nn_module(
#   "corr-cnn",
  
#   initialize = function() {
#     self$conv1 <- nn_conv2d(in_channels = 1, out_channels = 32, kernel_size = 3)
#     self$conv2 <- nn_conv2d(in_channels = 32, out_channels = 64, kernel_size = 3)
#     self$conv3 <- nn_conv2d(in_channels = 64, out_channels = 128, kernel_size = 3)
    
#     self$fc1 <- nn_linear(in_features = 14 * 14 * 128, out_features = 128)
#     self$fc2 <- nn_linear(in_features = 128, out_features = 1)
#   },
  
#   forward = function(x) {
#     x |>
#       self$conv1() |>
#       nnf_relu() |>
#       nnf_avg_pool2d(2) |>
      
#       self$conv2() |>
#       nnf_relu() |>
#       nnf_avg_pool2d(2) |>
      
#       self$conv3() |>
#       nnf_relu() |>
#       nnf_avg_pool2d(2) |>
      
#       torch_flatten(start_dim = 2) |>
#       self$fc1() |>
#       nnf_relu() |>
      
#       self$fc2()
#   }
  
# )
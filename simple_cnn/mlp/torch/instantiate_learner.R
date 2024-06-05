input_dim = prod(dim(train_torch_ds[1]$x))
output_dim = 1

learner_torch_mlp = nn_sequential(
  nn_flatten(),
  nn_linear(input_dim, 20),
  nn_relu(),
  nn_linear(20, 20),
  nn_relu(),
  nn_linear(20, output_dim)
)

library(coro)

opt = optim_adam(learner_torch_mlp$parameters, lr = lr)

# function(lr)
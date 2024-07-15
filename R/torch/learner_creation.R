create_torch_mlp = function() {
    nn_sequential(
        nn_flatten(),
        nn_linear(input_dim, 20),
        nn_relu(),
        nn_linear(20, 20),
        nn_relu(),
        nn_linear(20, output_dim)
    )
}

create_torch_cnn = function() {
    nn_sequential(
        nn_conv2d(in_channels = 1, out_channels = 32, kernel_size = 3),
        nn_relu(),
        nn_avg_pool2d(2),
        nn_conv2d(in_channels = 32, out_channels = 64, kernel_size = 3),
        nn_relu(),
        nn_avg_pool2d(2),
        nn_conv2d(in_channels = 64, out_channels = 128, kernel_size = 3),
        nn_relu(),
        nn_avg_pool2d(2),
        nn_flatten(start_dim = 2),
        nn_linear(in_features = 14 * 14 * 128, out_features = 128),
        nn_relu(),
        nn_linear(in_features = 128, out_features = 1)
    )   
}

create_torch_learner = function(architecture_id) {
  if (architecture_id == "mlp") {
    create_torch_mlp()
  }
  else if (architecture_id == "cnn") {
    create_torch_cnn()
  }
  else {
    print("invalid id")
  }
}

create_opt = function(learner, lr) {
  optim_adam(learner$parameters, lr = lr)
}
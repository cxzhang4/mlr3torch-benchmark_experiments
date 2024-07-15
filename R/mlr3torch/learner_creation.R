library(mlr3)
library(mlr3torch)

create_mlr3torch_mlp = function() {
  lrn("regr.mlp",
    # defining network parameters
    activation     = nn_relu,
    neurons        = c(20, 20),
    # training parameters
    batch_size     = batch_size,
    epochs         = n_epochs,
    device         = "auto",
    # Defining the optimizer, loss, and callbacks
    optimizer      = t_opt("adam", lr = lr),
    loss           = t_loss("mse"),
    # predict type (required by logloss)
    predict_type = "response"
  )
}

create_mlr3torch_cnn = function() {
  cnn_architecture = po("torch_ingress_ltnsr") %>>%
  po("nn_conv2d_1", out_channels = 32, kernel_size = 3) %>>%
  po("nn_relu_1") %>>%
  po("nn_avg_pool2d_1", kernel_size = 2) %>>% # TODO: determine whether we need to specify kernel size
  po("nn_conv2d_2", out_channels = 64, kernel_size = 3) %>>%
  po("nn_relu_2") %>>%
  po("nn_avg_pool2d_2", kernel_size = 2) %>>%
  po("nn_conv2d_3", out_channels = 128, kernel_size = 3) %>>%
  po("nn_relu_3") %>>%
  po("nn_avg_pool2d_3", kernel_size = 2) %>>%
  po("nn_flatten", start_dim = 2) %>>%
  po("nn_linear", out_features = 128) %>>%
  po("nn_relu_4") %>>%
  po("nn_head")

  graph_cnn = cnn_architecture %>>%
      po("torch_loss", loss = t_loss("mse")) %>>%
      po("torch_optimizer", optimizer = t_opt("adam", lr = lr)) %>>%
      po("torch_model_regr", batch_size = batch_size, epochs = n_epochs, device = "cpu")

  as_learner(graph_cnn)
}

create_mlr3torch_learner = function(architecture_id) {
  if (architecture_id == "mlp") {
    create_mlr3torch_mlp()
  }
  else if (architecture_id == "cnn") {
    create_mlr3torch_cnn()
  }
  else {
    print("invalid id")
  }
}
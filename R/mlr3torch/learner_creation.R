library(mlr3)
library(mlr3torch)

create_mlr3torch_mlp = function(batch_size, n_epochs, lr, accelerator) {
  lrn("regr.mlp",
    # defining network parameters
    activation     = nn_relu,
    neurons        = c(20, 20),
    # training parameters
    batch_size     = batch_size,
    epochs         = n_epochs,
    device         = accelerator,
    # Defining the optimizer, loss, and callbacks
    optimizer      = t_opt("adam", lr = lr),
    loss           = t_loss("mse"),
    # predict type (required by logloss)
    predict_type = "response"
  )
}

create_mlr3torch_cnn = function(batch_size, n_epochs, lr, accelerator) {
  cnn_architecture = po("torch_ingress_ltnsr") %>>%
    po("nn_conv2d_1", out_channels = 32, kernel_size = 3) %>>%
    po("nn_relu_1") %>>%
    po("nn_avg_pool2d_1", kernel_size = 2) %>>%
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
      po("torch_model_regr", batch_size = batch_size, epochs = n_epochs, device = accelerator)

  as_learner(graph_cnn)
}

create_copy_from_nn_module = function(task, torch_learner, architecture_id, batch_size, n_epochs, lr, accelerator) {
  ingress_tokens = list(
    input = TorchIngressToken(task$feature_names, batchgetter_num, get_dd_dims(architecture_id))
  )
  
  lrn("regr.torch_model",
    network = torch_learner,
    ingress_tokens = ingress_tokens,
    batch_size     = batch_size,
    epochs         = n_epochs,
    device         = accelerator,
    optimizer      = t_opt("adam", lr = lr),
    loss           = t_loss("mse")
  )
}

create_mlr3torch_learner = function(task, torch_learner, architecture_id, batch_size, n_epochs, lr, accelerator) {
  if (architecture_id == "mlp") {
    create_mlr3torch_mlp(batch_size, n_epochs, lr, accelerator)
  }
  else if (architecture_id == "cnn") {
    # create_copy_from_nn_module(task, torch_learner, batch_size, n_epochs, lr, accelerator)
    create_mlr3torch_cnn(batch_size, n_epochs, lr, accelerator)
  }
  else {
    print("invalid id")
  }
}

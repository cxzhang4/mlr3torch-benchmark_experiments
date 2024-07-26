valid_batch <- function(b) {
  output <- model(b[[1]]$to(device = device))
  target <- b[[2]]$to(device = device)
  
  loss <- nn_mse_loss(output, target)
  loss$item()
}
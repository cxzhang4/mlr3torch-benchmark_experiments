for (t in seq_len(n_epochs)) {
    # save intermediate loss values
    # l <- c()

    coro::loop(for (b in train_dl) {
        # setup
        opt$zero_grad()

        # forward pass
        output <- learner_torch_mlp(b[[1]])
        # compute loss
        loss <- nnf_mse_loss(output$squeeze(2), b[[2]])
        # backpropagation
        loss$backward()
        opt$step()
        # l <- c(l, loss$item())
    })
}
train_torch_learner = function(learner, optimizer, train_dl, n_epochs) {
    for (t in seq_len(n_epochs)) {
        coro::loop(for (b in train_dl) {
            opt$zero_grad()

            output = learner(b[[1]])

            loss = nnf_mse_loss(output$squeeze(2), b[[2]])

            loss$backward()
            opt$step()
        })
    }
}

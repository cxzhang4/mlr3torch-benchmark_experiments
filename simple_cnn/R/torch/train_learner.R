for (t in seq_len(n_epochs)) {
    coro::loop(for (b in train_dl) {
        opt$zero_grad()

        output = learner_torch_cnn(b[[1]])

        loss = nnf_mse_loss(output$squeeze(2), b[[2]])

        loss$backward()
        opt$step()
    })
}

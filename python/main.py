import torch
import torch.nn as nn 
import torchvision.transforms as transforms
from data import GuessTheCorrelationDataset
import time
import custom_transforms
from model import create_learner
import hydra
import os
import polars as pl
import pandas as pd
import yaml

@hydra.main(version_base=None, config_path=".", config_name="config")
def main(config):
    # create a torch dataset
    transforms_for_corr_images = transforms.Compose([
        custom_transforms.CustomCrop(top = 0, left = 21, height = 130, width = 130),
        # custom_transforms.AddChannelDimension()
    ])

    trn_idx = range(0, config.default.train_size)
    train_ds = GuessTheCorrelationDataset(root = "data/correlation/guess-the-correlation",
                                        responses_file_path = "train.csv",
                                        transform = transforms_for_corr_images,
                                        indexes = trn_idx)
    train_dataloader = torch.utils.data.DataLoader(train_ds, batch_size=config.default.batch_size)

    learner = create_learner(config.default.architecture_id)

    DEVICE = config.default.accelerator
    learner = learner.to(DEVICE)

    loss_fn = nn.MSELoss()
    optimizer = torch.optim.Adam(learner.parameters(), lr = config.default.learning_rate)

    start_time = time.time()
    for i in range(config.default.n_epochs):
        learner.train()
        for i, (img, target) in enumerate(train_dataloader):
            img, target = img.to(DEVICE), target.to(DEVICE)

            optimizer.zero_grad()
            img = img.float()
            y_pred = learner(img)
            loss = loss_fn(torch.squeeze(y_pred), target.float())
            loss.backward()
            optimizer.step()
    end_time = time.time()

    elapsed_time = end_time - start_time

    print(elapsed_time)

    config_stream = open("python/config.yaml", "r")
    config = yaml.load(config_stream, Loader=yaml.CLoader)
    experiment_results = pd.DataFrame(config["default"], index = [0])
    experiment_results.insert(len(experiment_results.columns), "elapsed_time", elapsed_time)


    output_file_name = "benchmark_results-python.csv"
    if os.path.isfile(output_file_name):
        previous_results = pd.read_csv(output_file_name)
        pd.concat([previous_results, experiment_results]).to_csv(output_file_name, index = False)
    else:
        experiment_results.to_csv(output_file_name, index = False)

if __name__ == "__main__":
    main()
library(glue)
library(here)
library(readr)

source(here("R", "output_dir_name.R"))

config_file_name = "config.yml"
config_file_path = here(result_dir_name(), config_file_name)
yml_chunk_start = paste("\n```{.yaml filename=\"", config_file_name, "\"}", sep = "")

config_str = read_file(config_file_path)

chunk_end = "```"

config_chunk_str = paste(yml_chunk_start, config_str, chunk_end, sep = "\n")

write_file(config_chunk_str, here("index.qmd"), append = TRUE)

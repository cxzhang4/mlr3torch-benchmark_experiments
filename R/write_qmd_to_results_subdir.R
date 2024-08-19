library(here)

source(here("R", "output_dir_name.R"))

result_dir_name = most_recent_result_name()
result_report_file_path = here(result_dir_name, "index.qmd")
result_html_file_path = here(result_dir_name, "index.html")

file.copy(here("index.qmd"), result_report_file_path)
file.copy(here("index.html"), result_html_file_path)
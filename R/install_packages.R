# Package names
packages <- c("here", "config", "bench", "magrittr", "dplyr", "data.table", "readr", "tibble", "torch", "mlr3", "mlr3torch",
              "knitr", "rmarkdown", "glue")

# Install packages not yet installed
installed_packages <- packages %in% rownames(installed.packages())
if (any(installed_packages == FALSE)) {
  install.packages(packages[!installed_packages], repos = "https://ftp.fau.de/cran/")
}
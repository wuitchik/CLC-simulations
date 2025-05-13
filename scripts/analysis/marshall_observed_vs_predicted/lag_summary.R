library(tidyverse)

# List all lag_*.csv files
files <- list.files(
  path = "/Users/danielwuitchik/Documents/Experiments/Crepidula_tufts/Github/CLC-simulations/data/raw/eta_marshall_comp_seasons/",
  pattern = "^lag_[0-9]+\\.csv$",
  full.names = TRUE
)

# Function to read and summarize each file
summarize_lag <- function(file) {
  seed <- as.numeric(str_extract(file, "\\d+"))
  eta <- seed * 0.01
  
  df <- read.delim(file, sep = "\t", header = TRUE) %>%
    filter(tick > 1100) # %>%
    #filter(if_all(starts_with("obsLag"), is.finite), 
     #      if_all(starts_with("predLag"), is.finite))
  
  #if (nrow(df) == 0) return(NULL)  # Skip empty summaries
  
  tibble(
    eta = eta,
    avg_obsLagLarvae = mean(df$obsLagLarvae, na.rm = TRUE),
    avg_predLagLarvae = mean(df$predLagLarvae, na.rm = TRUE),
    avg_obsLagAdults = mean(df$obsLagAdults, na.rm = TRUE),
    avg_predLagAdults = mean(df$predLagAdults, na.rm = TRUE)
  )
}

# Apply the function to all files and combine
summary_df <- map_dfr(files, summarize_lag)

# Save to CSV
write_csv(summary_df, "/Users/danielwuitchik/Documents/Experiments/Crepidula_tufts/Github/CLC-simulations/data/processed/eta_ground_YESseason_summary.csv")

# Print first few lines to confirm
print(head(summary_df))


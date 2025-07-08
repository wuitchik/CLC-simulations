# Load necessary libraries
library(dplyr)
library(tidyr)

# Read your data
fst_data <- read.csv("your_data.csv")

# Choose which column to pivot, for example "distance" or "Fst_all"
pivot_column <- "distance"

# Create symmetric matrix
fst_matrix <- fst_data %>%
  select(site1, site2, all_of(pivot_column)) %>%
  pivot_wider(names_from = site2, values_from = pivot_column) %>%
  column_to_rownames(var = "site1")

# Convert to matrix
fst_matrix <- as.matrix(fst_matrix)

# Fill lower triangle
fst_matrix[lower.tri(fst_matrix)] <- t(fst_matrix)[lower.tri(fst_matrix)]

# Replace NA with 0 for diagonal
fst_matrix[is.na(fst_matrix)] <- 0

# Remove row and column names
rownames(fst_matrix) <- NULL
colnames(fst_matrix) <- NULL

# View matrix
print(fst_matrix)

# Optionally write to CSV without row or column names
write.table(fst_matrix, "fst_matrix.csv", sep = ",", row.names = FALSE, col.names = FALSE)

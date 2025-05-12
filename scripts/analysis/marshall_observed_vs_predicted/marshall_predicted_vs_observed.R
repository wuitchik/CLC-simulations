library(tidyverse)
library(viridis)

# Load the summary data
df <- read_csv("lag_summary_cleaned.csv") %>%
  filter(eta < 0.37)

# Plot for larvae
max_larvae <- max(c(df$avg_predLagLarvae, df$avg_obsLagLarvae), na.rm = TRUE)

ggplot(df, aes(x = avg_predLagLarvae, y = avg_obsLagLarvae, fill = eta)) +
  geom_point(alpha = 0.9, shape = 21, color = "black", size = 3, stroke = 0.3) +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed") +
  coord_equal(xlim = c(0, max_larvae), ylim = c(0, max_larvae)) +
  theme_bw() +
  labs(x = "Predicted Larval Lag", y = "Observed Larval Lag", fill = "η") +
  scale_fill_viridis(option = "viridis", direction = -1) +
  theme(
    legend.position = c(0.95, 0.05),
    legend.justification = c(1, 0),
    legend.background = element_rect(fill = alpha('white', 0.6), color = "black"),
    legend.title = element_text(size = 8),
    legend.text = element_text(size = 6),
    legend.key.size = unit(0.3, "cm"),
    legend.title.align = 0.5
  )

ggsave("summary_lag_larvae_by_eta.png", width = 5, height = 5)

# Plot for adults
max_adults <- max(c(df$avg_predLagAdults, df$avg_obsLagAdults), na.rm = TRUE)

ggplot(df, aes(x = avg_predLagAdults, y = avg_obsLagAdults, fill = eta)) +
  geom_point(alpha = 0.9, shape = 21, color = "black", size = 3, stroke = 0.3) +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed") +
  coord_equal(xlim = c(0, max_adults), ylim = c(0, max_adults)) +
  theme_bw() +
  labs(x = "Predicted Adult Lag", y = "Observed Adult Lag", fill = "η") +
  scale_fill_viridis(option = "viridis", direction = -1) +
  theme(
    legend.position = c(0.95, 0.05),
    legend.justification = c(1, 0),
    legend.background = element_rect(fill = alpha('white', 0.6), color = "black"),
    legend.title = element_text(size = 8),
    legend.text = element_text(size = 6),
    legend.key.size = unit(0.3, "cm"),
    legend.title.align = 0.5
  )

ggsave("summary_lag_adults_by_eta.png", width = 5, height = 5)

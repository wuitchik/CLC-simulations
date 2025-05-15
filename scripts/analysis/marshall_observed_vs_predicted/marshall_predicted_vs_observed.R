library(tidyverse)
library(viridis)
library(patchwork)

# Load and clean data
df <- read_csv("/Users/danielwuitchik/Documents/Experiments/Crepidula_tufts/Github/CLC-simulations/data/processed/eta_ground_YESseason_summary_negCOV.csv") %>%
  filter(if_all(everything(), is.finite)) %>%
  filter(!if_any(everything(), ~ . < 0)) %>%
  filter(eta < 0.32) %>%
  na.omit()

# Plot for larvae
max_larvae <- max(c(df$avg_predLagLarvae, df$avg_obsLagLarvae), na.rm = TRUE)
p1 <- ggplot(df, aes(x = avg_predLagLarvae, y = avg_obsLagLarvae, fill = eta)) +
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

# Plot for adults
max_adults <- max(c(df$avg_predLagAdults, df$avg_obsLagAdults), na.rm = TRUE)
p2 <- ggplot(df, aes(x = avg_predLagAdults, y = avg_obsLagAdults, fill = eta)) +
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

# Combine with patchwork and add labels A) and B)
combined_plot <- p1 + p2 + plot_annotation(tag_levels = "A")
ggsave("/Users/danielwuitchik/Documents/Experiments/Crepidula_tufts/Github/CLC-simulations/figs/ground_truth/season_negCOV_pred_vs_obser.png", combined_plot, width = 10, height = 5)
ggsave("/Users/danielwuitchik/Documents/Experiments/Crepidula_tufts/Github/CLC-simulations/figs/ground_truth/season_negCOV_pred_vs_obser.pdf", combined_plot, width = 10, height = 5)

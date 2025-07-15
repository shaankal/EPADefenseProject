# ─────────────────────────────
# 1. Load Libraries
# ─────────────────────────────
library(tidyverse)
library(nflfastR)
library(data.table)
library(ggimage)

# ─────────────────────────────
# 2. Load Play-by-Play Data (2024)
# ─────────────────────────────
data <- load_pbp(2024)
data <- data.table(data)

# ─────────────────────────────
# 3. Filter for Offensive Plays
# ─────────────────────────────
data <- data[!is.na(epa) & (pass == 1 | rush == 1)]
data[, shotgun_type := ifelse(shotgun == 1, "Shotgun", "Under Center")]

# ─────────────────────────────
# 4. Create Team Conference Lookup Table
# ─────────────────────────────
team_conferences <- data.frame(
  team_abbr = c("BUF", "MIA", "NE", "NYJ",  # AFC East
                "CIN", "BAL", "CLE", "PIT", # AFC North
                "HOU", "IND", "JAX", "TEN", # AFC South
                "KC", "DEN", "LAC", "LV",   # AFC West
                "PHI", "DAL", "WAS", "NYG", # NFC East
                "GB", "MIN", "CHI", "DET",  # NFC North
                "ATL", "CAR", "NO", "TB",   # NFC South
                "SF", "SEA", "LAR", "ARI"), # NFC West
  conference = c(rep("AFC", 16), rep("NFC", 16))
)

# ─────────────────────────────
# 5. Prepare Logo and Conference Data
# ─────────────────────────────
teams <- teams_colors_logos %>%
  select(team_abbr, team_logo_espn) %>%
  left_join(team_conferences, by = "team_abbr") %>%
  data.table()

# ─────────────────────────────
# 6. Group EPA by Defense and Formation
# ─────────────────────────────
epa_defense <- data[, .(
  epa_avg = round(mean(epa, na.rm = TRUE), 3),
  plays = .N
), by = .(defteam, shotgun_type)]

# Filter out small sample size
epa_defense <- epa_defense[plays >= 30]

# Merge logo and conference info
epa_defense <- merge(epa_defense, teams, by.x = "defteam", by.y = "team_abbr")

# ─────────────────────────────
# 7. Set Aesthetic Parameters
# ─────────────────────────────
logo_size <- 0.10  # Increased logo size
font_size <- 14
title_size <- 20
subtitle_size <- 15

# ─────────────────────────────
# 8. AFC Plot
# ─────────────────────────────
epa_afc <- epa_defense[conference == "AFC"]

ggplot(epa_afc, aes(x = shotgun_type, y = epa_avg, fill = shotgun_type)) +
  geom_col(width = 0.6, alpha = 0.85, show.legend = FALSE) +
  geom_text(aes(label = paste0(shotgun_type, "\n", round(epa_avg, 2))),
            vjust = -1, size = 3.5, fontface = "bold") +
  geom_image(aes(image = team_logo_espn), size = logo_size, asp = 16/9) +
  facet_wrap(~ defteam, ncol = 4) +
  scale_fill_manual(values = c("Shotgun" = "#1f77b4", "Under Center" = "#ff7f0e")) +
  labs(
    title = "Defensive EPA Allowed vs. Offensive Formation (AFC, 2024)",
    subtitle = "Shotgun vs. Under Center — Which defenses are getting exposed?",
    x = "Offensive Formation",
    y = "Average EPA Allowed",
    caption = "BY Shaan Kalgaonkar"
  ) +
  theme_minimal(base_size = font_size) +
  theme(
    plot.title = element_text(size = title_size, face = "bold", hjust = 0.5),
    plot.subtitle = element_text(size = subtitle_size, hjust = 0.5),
    plot.caption = element_text(size = 10, face = "italic", hjust = 1),
    strip.text = element_text(face = "bold", size = 13),
    axis.text.x = element_text(face = "bold", size = 11),
    axis.title.x = element_text(margin = margin(t = 10)),
    panel.grid.major.y = element_line(size = 0.3, color = "grey80"),
    panel.grid.minor = element_blank()
  )

ggsave("epa_afc_by_formation.png", width = 12, height = 10, dpi = 320)

# ─────────────────────────────
# 9. NFC Plot
# ─────────────────────────────
epa_nfc <- epa_defense[conference == "NFC"]

ggplot(epa_nfc, aes(x = shotgun_type, y = epa_avg, fill = shotgun_type)) +
  geom_col(width = 0.6, alpha = 0.85, show.legend = FALSE) +
  geom_text(aes(label = paste0(shotgun_type, "\n", round(epa_avg, 2))),
            vjust = -1, size = 3.5, fontface = "bold") +
  geom_image(aes(image = team_logo_espn), size = logo_size, asp = 16/9) +
  facet_wrap(~ defteam, ncol = 4) +
  scale_fill_manual(values = c("Shotgun" = "#1f77b4", "Under Center" = "#ff7f0e")) +
  labs(
    title = "Defensive EPA Allowed vs. Offensive Formation (NFC, 2024)",
    subtitle = "Shotgun vs. Under Center — Which defenses are getting exposed?",
    x = "Offensive Formation",
    y = "Average EPA Allowed",
    caption = "BY Shaan Kalgaonkar"
  ) +
  theme_minimal(base_size = font_size) +
  theme(
    plot.title = element_text(size = title_size, face = "bold", hjust = 0.5),
    plot.subtitle = element_text(size = subtitle_size, hjust = 0.5),
    plot.caption = element_text(size = 10, face = "italic", hjust = 1),
    strip.text = element_text(face = "bold", size = 13),
    axis.text.x = element_text(face = "bold", size = 11),
    axis.title.x = element_text(margin = margin(t = 10)),
    panel.grid.major.y = element_line(size = 0.3, color = "grey80"),
    panel.grid.minor = element_blank()
  )

ggsave("epa_nfc_by_formation.png", width = 12, height = 10, dpi = 320)

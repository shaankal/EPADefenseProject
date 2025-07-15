# EPADefenseProject

# 🏈 Offensive Formation vs. Defensive EPA — 2024 NFL Analysis

**Author:** Shaan Kalgaonkar  
**Last Updated:** 2024 Season  
**Language:** R (using `nflfastR`, `tidyverse`, `ggimage`)

---

## 📘 Project Overview

This project explores how NFL defenses perform in terms of **Expected Points Added (EPA) allowed** against two primary offensive formations:  
- **Shotgun**
- **Under Center**

Using 2024 play-by-play data from [`nflfastR`](https://www.nflfastr.com/), this analysis visualizes which teams are more susceptible to specific formations — broken down by conference (AFC and NFC).

---

## 🎯 Research Question

> _Which NFL defenses are getting exposed by certain offensive formations in 2024, and is there a conference-wide trend in EPA allowed based on shotgun vs. under-center looks?_

---

## 🧰 Tools & Packages

- [`nflfastR`](https://github.com/nflverse/nflfastR) – Play-by-play NFL data
- `tidyverse` – Data wrangling and plotting
- `data.table` – Fast in-memory operations
- `ggimage` – Adds team logos to visualizations

---

## 📂 Project Structure

| File | Description |
|------|-------------|
| `"OffensiveSchemesVSC2.R"` | Main R script containing data processing, grouping, plotting |
| `epa_afc_by_formation.png` | Final visualization of AFC defenses |
| `epa_nfc_by_formation.png` | Final visualization of NFC defenses |
| `README.md` | This documentation file |

---

## 🔄 Workflow Summary

1. **Load Data:** 2024 season play-by-play data using `load_pbp()`
2. **Filter Plays:** Only include offensive plays (run/pass) with available EPA
3. **Feature Engineering:** Add `shotgun_type` label based on play alignment
4. **Group Data:** Compute average EPA allowed by defensive team and formation type
5. **Join Metadata:** Add team logos and conference info
6. **Plotting:** Generate faceted bar charts per defense for both AFC and NFC

---

## 📊 Output Visuals

- `epa_afc_by_formation.png`  
  > AFC team-by-team bar plot of average EPA allowed vs. Shotgun vs. Under Center

- `epa_nfc_by_formation.png`  
  > NFC team-by-team bar plot of average EPA allowed vs. Shotgun vs. Under Center

Each bar shows:
- Average EPA allowed by that defense when facing each formation
- Team logo
- Color-coded formation types

---

## 📈 Example Plot (AFC Preview)

![AFC EPA Chart](epa_afc_by_formation.png)

---

## ⚙️ How to Reproduce

Make sure you have the following R packages installed:


source("OffensiveSchemesVSC2.R")
```r
install.packages(c("nflfastR", "tidyverse", "data.table", "ggimage"))



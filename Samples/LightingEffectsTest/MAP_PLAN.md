# Lighting Effects Test map

**26 rooms, 41 two-way orthogonal connections**. Start in Seasonal Shelter (row 4, column 2). Rooms use the 800x600 canvas and 40-pixel grid. Traversal & Composition contains the initially hidden large inheritance fixture; Stress Lab is east of Lifecycle & Restore.

| Row | Column | Room | Environment |
| ---: | ---: | --- | --- |
| 1 | 1 | Snow & Hail | Outdoor |
| 1 | 2 | Leaves | Outdoor |
| 1 | 3 | Storm | Outdoor |
| 1 | 4 | Ash & Cinders | Outdoor |
| 1 | 5 | Triggered Bursts | Indoor |
| 2 | 1 | Environmental Scope | Outdoor |
| 2 | 2 | Fog & Motes | Indoor |
| 2 | 3 | Impacts & Debris | Indoor |
| 2 | 4 | Magic & Toxic | Indoor |
| 2 | 5 | Fire Outside | Outdoor |
| 3 | 1 | Seasonal Grass | Outdoor |
| 3 | 2 | Traversal & Composition | Indoor |
| 3 | 3 | Tuning & Bindings | Indoor |
| 3 | 4 | Fire Lab | Indoor |
| 3 | 5 | Rain Lab | Outdoor |
| 4 | 1 | Seasonal Pavement | Outdoor |
| 4 | 2 | Seasonal Shelter | Indoor |
| 4 | 3 | Image & Object Effects | Indoor |
| 4 | 4 | Wind & Clouds | Indoor |
| 4 | 5 | Lifecycle & Restore | Indoor |
| 4 | 6 | Stress Lab | Outdoor |
| 5 | 1 | Seasonal Snow Ground | Outdoor |
| 5 | 2 | Stains | Indoor |
| 5 | 3 | Visual Pipeline | Indoor |
| 5 | 4 | Phase & Light | Indoor |
| 5 | 5 | Rain Details | Outdoor |

## Runs

FullWalkThru.txt contains 504 commands and ends at its genuine save checkpoint. EffectsRegression.txt is a separate 68-command frequent regression with 45 seconds of authored pauses. StressLab.txt is a separate 157-command sustained-load run. Focused scripts and their guides are listed in [README.md](README.md).

The seasonal backdrop circuit is Shelter west to Pavement, then north to Grass or south to Snow Ground. Global phase weather applies across all three outdoor views. Stress Lab intentionally replaces inherited environment names with standalone local definitions and controlled stress mixtures. Both primary custom-art and packaged-default runtime exports are retained.

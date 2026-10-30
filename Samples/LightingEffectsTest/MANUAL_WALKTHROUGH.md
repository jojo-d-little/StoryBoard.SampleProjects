# Manual effects walkthrough

Open LightingEffectsTest.sbe.json in Designer or load the normal runtime export. Start a **new game in Seasonal Shelter**. Use [TEST_CONTROLS.md](TEST_CONTROLS.md) for available commands and [MAP_PLAN.md](MAP_PLAN.md) for room locations. Each line in a command file is a command followed by its observation pause in milliseconds.

1. For the complete visual review, run [CommandSequence/FullWalkThru.txt](CommandSequence/FullWalkThru.txt): 504 commands and 69.2 minutes of authored pauses. It combines the weather, phase, composition, tuning, art, burst, lifecycle and catalog scenarios in one session.
2. Watch the expected changes in each station rather than relying only on command success. Compare ambient changes within one room, wind-driven atmosphere, moving light/emitter sources, shadows, and complete outgoing/incoming transition images.
3. The final segment prepares a changed state and stops for a **real save**. Follow [SAVE_RESTORE_CHECKPOINT.md](SAVE_RESTORE_CHECKPOINT.md) before running the disturbance/after-restore scripts. A comment in a command file does not capture or load a save.
4. For a narrower review, start another fresh session and choose the focused script from [README.md](README.md). Repeat applicable scenarios with the packaged-default export to compare custom and built-in image use.
5. Use [CommandSequence/EffectsRegression.txt](CommandSequence/EffectsRegression.txt) for the bounded authoritative-data regression. Its short pauses are not a replacement for this visual review. Use StressLab.txt separately for performance/resource observations.

## Seasonal backdrop checks

West of Shelter is Seasonal Pavement; north/south of pavement are Seasonal Grass and Seasonal Snow Ground. Keep the phase/weather unchanged while moving between these backdrops. Returning indoors should filter outdoor effects without changing the weather state.

| Season | Starting precipitation | Atmosphere |
| --- | --- | --- |
| Spring | Moderate rain | Two puffy cloud layers |
| Summer | Moderate rain | Puffy clouds and warmer ambient color |
| Fall | Light rain | Mixed leaves and fog |
| Winter | Moderate snow | Two broad grey overcast layers |

Confirm ambient changes while remaining in the same room, allow the authored transition window, then interrupt one transition to check smooth retargeting. Compare rain intensities independently of wind; setting speed zero must not stop precipitation. Manual weather overrides should survive room entry. PhaseMatrix.txt exercises all four times of day in all four seasons.

Record actual versions, commands and observed defects when reviewing. Generated editor diagnostics and one-time construction logs are local outputs. The legacy/reference command file remains available with its existing historical designation.

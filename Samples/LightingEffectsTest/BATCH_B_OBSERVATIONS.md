# Current composition calibration — 2026-10-29

The original green beacon now uses its independent 0.12 artwork fit. Both original beacon lights use room-space offset (20,20), radius 135 and sway 10; the earlier artwork-fit compensation is removed. IDs and parts movement commands remain unchanged. A separate large inheritance fixture, initially hidden, is available with parts_hide and inherit_show; see INHERITANCE_COVERAGE.md. Use the large fixture for category inheritance comparisons.

# Batch B — objects, lights, and tuning

Run [CommandSequence/ObjectsLightsTuning.txt](CommandSequence/ObjectsLightsTuning.txt) from a NEW game in Seasonal Shelter, or immediately after the seasonal WalkThru.txt finishes there. It starts and ends in the shelter and uses only four-direction room navigation. It contains 104 commands and about 16.6 minutes of authored observation pauses. Each fixture movement command names its target in its action payload; no mouse selection is required.

## Route

```text
Shelter --north--> Composition --east--> Tuning & Bindings --east--> Fire Lab
                                                                      |
                                                                    south
                                                                      v
                                                               Wind & Clouds
                                                               (transit only)
                                                                      |
                                                                    south
                                                                      v
             Visual Pipeline <---------------west--------------- Phase & Light
                    |
                  north
                    v
          Image & Object Effects --west--> Shelter
             (transit only)
```

The route exercises checklist items 5–8 in geographic order: composition, bindings, moving fire, lighting/pipeline. Seasonal WalkThru.txt and PhaseMatrix.txt remain separate focused runs. This route deliberately does not claim custom-image, burst, removal, or save/restore coverage.

## Observation checkpoints

| Station | Commands / layout | Expected observation |
| --- | --- | --- |
| Traversal & Composition | Brown parent (240,280); green beacon offset (80,-80) from the parent's top-left footprint anchor; blue beacon (520,400). `parts_east`, `parts_north`, `parts_west`, `parts_south`. | Parent route: (240,280) → (360,280) → (360,200) → (240,200) → start. Green sprite, light, smoke and the separate spark move with the parent. Blue sprite, light and aura stay fixed throughout. Compare during movement and after settling. |
| Tuning & Bindings | Top row, left to right: Recipe Defaults, Literal Overrides, Ordinary Binding, Shared Binding, Computed Binding. All use `particle.campfire`. | Default lane stays untouched. Literal lane remains small and blue. Other lanes respond only to their own controls. Bottom-left optional-binding fire is compared with its fixed size-0.75 neighbor. |
| Fire Lab | Left green crate: stationary fire/smoke without paired light. Right brown crate: moving fire/smoke with swaying/flickering light. | `fire_east/south/west/north` form a closed route: (560,160) → (640,160) → (640,320) → (560,320) → start. Sprite, flame source, smoke source, and light follow together. Left fixture stays fixed. Inspect the blue marker's shadow as the right light moves. Already emitted smoke can trail and decay. |
| Fire Lab growth | `fire_size_small/large`, `fire_rate_low/high`, `fire_life_short/long`, `fire_core_yellow/orange`, `fire_edge_yellow/orange`. | Both comparisons share the phase controls, allowing small yellow fire to grow and become orange. Recipe/internal stream proportions remain intact. Core and edge commands act independently. `wind_south` changes smoke; `wind_calm` stops wind response while flames keep emitting. |
| Phase & Light | Four top-row lamps: static, sway, flicker, sway+flicker. Four blue columns below them cast shadows. | At Night, compare positional motion, intensity motion, and combined motion. Day/Night changes ambient without leaving. The 2-second Day interruption followed by Night should retarget smoothly, without a jump or stuck ambient value. |
| Visual Pipeline | Left: pre-light smoke. Room: pre-light motes. Right: post-light torch. Overlay: faint post-light fog. Center: sway/flicker light and blue shadow marker. | Day/Night changes how pre-light effects are lit; post-light torch/fog remain in their declared stage. On east/west room transitions, both outgoing and incoming images should contain their complete composed scenes: sprites, pre-light effects, point lighting/shadows, and post-light effects. Look for missing layers, sudden disappearance, or stale ambient. |

Lighting and pipeline labs are Indoor with the same wooden-floor/wall setting to isolate the demonstrations from global outdoor weather. Each beacon keeps its independent artwork fit. Light offsets and radii are authored in room pixels; both original beacon radii are 135. The original paired fire's recipe settings and point-light tuning are preserved; smoke source alignment is corrected to match its flame anchor.

## Binding and tuning details

Every change has a 13-second pause unless it is setup or the deliberate transition interruption. The current recipe transition is 10 seconds. A neutral reset follows each one-control comparison so later changes can be interpreted.

| Exercise | Commands | Expected result |
| --- | --- | --- |
| Ordinary numeric binding | `tune_size_small/large/normal`, `tune_rate_low/high/normal`, `tune_life_short/long/normal`, `tune_radius_wide/normal` | Only the ordinary lane's corresponding target changes. Defaults and literal lane remain stable. |
| Valid numeric zero | `tune_radius_zero`, `tune_rate_zero`, `tune_size_zero` | Radius zero collapses the spawn region; rate zero stops new emission without treating the variable as missing. Size zero remains a legitimate bound zero in Host data; the family's `zeroBehavior: omit` tells the renderer to retain recipe dimensions. Verify the visible outcome in Portal. |
| Independent colors | `tune_primary_blue`, `tune_primary_yellow`, `tune_secondary_violet`, `tune_secondary_orange` | Primary and secondary are distinct settings. Changing either preserves the other target. Birth-snapshot recipes apply changing color to newly born particles; old particles may retain their birth colors. |
| Shared variables | `shared_peer_large`, `shared_object_small`, `shared_peer_normal` | Write from the room participant and then the effect-object participant. Both shared values and the effect's size target agree: 1.8 → 0.5 → 1. |
| Computed numeric/string outputs | `computed_boost_on/off` | On: rate 2.4, lifetime 0.5, colors #FF9030/#C83C12. Off: rate 0.6, lifetime 1.4, colors #FFF2A0/#FFD060. Uses existing branch outputs; no arithmetic extension is needed. |
| Valid false versus fallback | `tuning_rain_on/off`; Spring Day optional motes | Authored Enabled defaults true, but a resolved false binding disables the effect. False must not be replaced by that default. |
| Unresolved source with literal | Spring Day → Spring Night → Spring Day | OptionalFxSize exists only on Spring Day. Size is 1.8 when resolved, otherwise its literal 0.75, matching the neighbor. Returning to Day restores 1.8. |
| Unresolved source without literal | Same phase sequence | OptionalFxLife is 0.55 on Day. On Night it is absent from Host target controls, allowing the recipe lifetime to apply. This uses a valid anchor and a real property; no nonexistent variable names or disabled validation rules are saved. |
| Unresolved Enabled source | Same phase sequence | OptionalFxEnabled is false on Day, so motes are off. Night has no source, so this definition's true fallback applies. Returning to Day restores bound false. |
| Same rain recipe, different motion feel | `tuning_rain_on`, `tuning_rain_rate_high`, `tuning_rain_life_short`, `tuning_rain_size_large`, then corresponding normal commands and `tuning_rain_off` | Rate 1→2, lifetime 1→0.5, size 1→1.6, each changed separately. Compare density and travel/lifetime behavior; this does not invent a separate fall-speed control. |

All fixture parts remain one level deep and keep individual local alignment. The script also includes the large fixture's category inheritance comparison; see INHERITANCE_COVERAGE.md. Structural/situational scaling remains separate from an authored Scale cue.


## Regression

Permanent automated coverage lives in the GameEngine/GameHost and Portal owner test suites. The saved effects recording is selected by the GameHost recording-playback manifest with `hostEffects` assertions. Run those owner tests for current results; command/state checks do not establish a visual or performance pass. One-time construction reports and temporary probe programs are not shipped with this sample.

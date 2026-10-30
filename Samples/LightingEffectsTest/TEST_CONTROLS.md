# Test controls

Start a NEW game in Seasonal Shelter. West: Seasonal Pavement. From pavement, north: Seasonal Grass; south: Seasonal Snow Ground. All three surfaces keep the same active phase/weather. Shelter filters outdoor effects.

| Commands | Behavior |
| --- | --- |
| season_spring / season_summer / season_fall / season_winter | Select that season at Day; a changed phase establishes its weather defaults. |
| phase_start | Select Spring Dawn. |
| phase_SEASON_TIME | Select an exact phase; SEASON: spring/summer/fall/winter; TIME: dawn/day/evening/night. |
| nextphase / previousphase | Traverse the common 16 pages. Stop at boundaries; use phase_start to return. |
| weather_status | Report season/time/sky/precipitation/intensity/rate multiplier/wind/IsWindy and expected ambient target. |
| weather_none / weather_rain / weather_snow / weather_hail | Set precipitation independently of season or wind. |
| intensity_light / intensity_moderate / intensity_heavy / intensity_catastrophic | Rate multipliers 0.5 / 1 / 2 / 3. |
| sky_clear / sky_cloudy / sky_fog / sky_overcast | No atmosphere / puffy clouds / fog / grey overcast. Leaves follow Fall. |
| wind_calm / wind_speed_still | Set speed to zero, retaining direction. |
| wind_speed_breeze / wind_speed_windy / wind_speed_gale | Speed 40 / 100 / 200 room pixels per second. |
| wind_north / wind_northeast / wind_east / wind_southeast / wind_south / wind_southwest / wind_west / wind_northwest | Direction only. |

Deterministic reset, even if Spring Day is already selected: run season_spring, sky_cloudy, weather_rain, intensity_moderate, wind_east, wind_speed_breeze, then weather_status.

Each season_*, phase_*, and phase_start selector uses one direct SetPhase action with the target phaseKey. Selecting a different phase establishes its authored defaults. Selecting the current phase succeeds without resetting manual weather overrides. Use the full explicit baseline to restore every weather dimension reliably. Moving rooms preserves the current values. Particle wind uses actual WindSpeed and WindDirection, without synthetic EffectiveWindSpeed.

Current review: CommandSequence/WalkThru.txt, then CommandSequence/PhaseMatrix.txt. Allow ten seconds for live transitions plus observation time.

## Batch B — objects, lights, and tuning

Run CommandSequence/ObjectsLightsTuning.txt from Seasonal Shelter. Detailed commands, layouts, target values, and expected outcomes: [BATCH_B_OBSERVATIONS.md](BATCH_B_OBSERVATIONS.md).

| Room | Added controls |
| --- | --- |
| Traversal & Composition | parts_east / parts_north / parts_west / parts_south |
| Tuning & Bindings | tune_size_*, tune_rate_*, tune_life_*, tune_radius_*, tune_primary_*, tune_secondary_*; shared_peer_large / shared_object_small / shared_peer_normal; computed_boost_on/off; tuning_rain_* |
| Fire Lab | fire_east / fire_south / fire_west / fire_north; fire_size_small/large, fire_rate_low/high, fire_life_short/long, fire_core_yellow/orange, fire_edge_yellow/orange |
| Phase & Light; Visual Pipeline | Existing phase_spring_day/night; east/west between the two labs |

The room-entry announcement gives each station's purpose. Fixture commands are local to their station. The scripts use direct targets, so no object selection is needed.

## Batch C — scope, atmosphere, art

Run CommandSequence/ScopeAtmosphereImages.txt from a NEW game in Seasonal Shelter. Use BATCH_C_OBSERVATIONS.md for the route, exact expected winners, image variants, and Portal cache controls.

| Scope / room | Controls |
| --- | --- |
| Area-wide probes | scope_applicability_on/off, scope_country_on/off, scope_area_on/off, scope_room_on/off, scope_disabled_on/off, scope_all_off |
| Fog & Motes | fog_1_on/off, fog_2_on/off, motes_on/off, organic_motes_on/off, atmosphere_all_on/off |
| Leaves | leaves_oak_on/off, leaves_maple_on/off, leaves_oval_on/off, leaves_mixed_on/off, leaves_all_on/off |
| Ash & Cinders | ash_on/off, cinders_on/off, embers_all_on/off |
| Wind & Clouds | cloud_1_on/off through cloud_4_on/off, clouds_all_on/off; existing independent wind commands |
| Image & Object Effects | image_leaves_on/off, image_candle_show/hide; leave/revisit and repeat in packaged-default companion |

All new scope and isolation variables start false. Turning production off can leave already emitted particles until they decay. Scope on/off commands are ordinary variable writes; group actions only combine those writes.

## Batch D controls

- Triggered Bursts: burst_sparks_a/b, burst_water, burst_debris, burst_dust, burst_pair, burst_all; burst_source_east/south/west/north.
- Lifecycle & Restore: life_smoke_hide/show/disable/enable; life_fog_on/off; restore_beacon_hide/show/disable/enable/east/south/west/north; restore_size_small/large.
- Stains: stain_<splatter|patch|streak|spray>_hide/show/disable/enable; stain_splatter_east/south/west/north.
- Impacts: survey_pipe_steam_hide/show, survey_leaking_drip_hide/show.
- Magic & Toxic: survey_insect_orbit_hide/show, survey_magic_aura_hide/show, survey_toxic_cloud_hide/show.
- SaveRestoreSetup.txt only prepares state; capture/load must use actual persistence operations. No save or restore game verb is fabricated.

## Burst quantity controls — current

These commands are local to Triggered Bursts. The original single, pair/all and movement commands remain.

| Commands | Meaning |
| --- | --- |
| burst_sparks_a_half/normal/double/zero | Literal 0.5 / 1 / 2 / 0 on Sparks A. |
| burst_water_half/normal/double/zero | Same literal comparison for water spatter. |
| burst_debris_half/normal/double/zero | Same comparison for flying chips; settled rubble remains a follow-up. |
| burst_dust_half/normal/double/zero | Same comparison for dust. |
| burst_quantity_half/normal/double/zero | Set the ordinary room property BurstQuantity; does not trigger by itself. |
| burst_sparks_a_bound / burst_water_bound / burst_debris_bound / burst_dust_bound | Sample BurstQuantity via a direct currentRoom reference when invoked; literal fallback 1. |
| burst_snapshot_pair | Set 0.5, trigger A, set 2, trigger A, reset to 1 within one linked flow. Two distinct occurrence snapshots survive one poll. |
| burst_boost_off/on; burst_sparks_a_computed | A normal numeric computed property outputs 0.5 or 2 from the Boolean BurstBoost; the trigger binds directly to it. |
| burst_sparks_a_tiny | Positive multiplier 0.01 produces a Host event; 16 × 0.01 rounds to zero particles. Successful completion, no visible spark expected. |

A zero multiplier succeeds with NoParticlesRequested and sends no burst event. It is not a disabled object or failed command. Quantity changes particle count only; size, lifetime, color and wind retain their existing independent controls.

## Removal controls - current

In Lifecycle & Restore: removal_all_on/off/hide/show; removal_natural_on/off/hide/show; removal_fade_on/off/hide/show; removal_immediate_on/off/hide/show. The all_on command shows AND activates. all_show only clears isHidden. Off sets isActive=false and keeps the crate visible. See REMOVAL_POLICY_COVERAGE.md for observation timing.

## Stress Lab controls

stress_help, stress_quiet, stress_low, stress_high, stress_hide, stress_show, stress_burst, stress_debris and stress_checkpoint are local to the new room east of Lifecycle & Restore. See STRESS_LAB_COVERAGE.md. No background timer runs; stress_burst is one explicit wave.

## Category inheritance controls

In Traversal & Composition, run parts_hide then inherit_show and inherit_help. Red inherits all five eligible categories; green Movement/Scale; white none; blue Movement/Highlight/ColorOverlay. The room-coordinate control stays fixed. Use inherit_east/south/west/north; inherit_scale/shake/highlight/color with matching _off commands; inherit_local_on/off; inherit_clear; inherit_hide then parts_show to restore the original demonstration. See [INHERITANCE_COVERAGE.md](INHERITANCE_COVERAGE.md).

For the 68-command bounded regression and saved baseline, see [EFFECTS_REGRESSION_GUIDE.md](EFFECTS_REGRESSION_GUIDE.md).

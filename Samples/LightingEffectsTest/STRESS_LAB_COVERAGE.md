# Stress Lab - run and observation guide

## Start

Reopen **LightingEffectsTest.sbe.json** in Designer. Start a **NEW game in Seasonal Shelter** and run **CommandSequence/StressLab.txt**. It uses only ordinary north/south/east/west navigation (the focused route needs east/west), goes east four rooms to Stress Lab, completes 157 commands with **16.3 minutes** of authored pauses, then returns west four rooms to Shelter. It finishes on Spring Day, normal breeze, with Stress Lab quiet.

The room is **row 4, column 6**, immediately east of Lifecycle & Restore. Existing 25 rooms/40 connections are retained; the map now has **26 rooms and 41 two-way orthogonal connections**. The full walkthrough retains its genuine save checkpoint. Stress is a separate optional run, not inserted into the normal full route.

Both clean exports are refreshed normally. Repeat in a new game with **Variants/PackagedDefaults/GameRuntimeJson/LightingEffectsTest.sbr.runtime.json** for the packaged-only companion. Existing project overrides remain on particle.oval-leaves (leaf-oval) and particle.candle (flame-tip) in the primary export; defaults companion has no overrides. Travel through Image & Object Effects can warm an image before Stress Lab. This route does **not** prove cold first-use loading by itself; a Portal controlled-cache test must arrange that condition explicitly.

## Controls

| Command | Result |
| --- | --- |
| stress_help | Repeat room guidance. Entry also announces the station. |
| stress_quiet | Disable all 11 local stress environment definitions and hide all fire/smoke/light assemblies. No new continuous production or paired-light contribution. Existing short-lived particles drain; deliberately triggered debris is separate. |
| stress_low | Rain + cloud 1 + fire/smoke/light group 1. Emission, size and burst quantity are 1x. |
| stress_high | All 11 stress environments + 4 fires + 4 direct smoke parts + 4 paired swaying/flickering lights. Emission 4x, size 1.5x, burst quantity 4x. |
| stress_hide / stress_show | Hide/show all four fire assemblies and their relative smoke parts and lights. Environment settings are unchanged. Showing all four while LOW is selected intentionally changes the fire count; reapply a preset to reset it. |
| stress_burst | One invocation emits four distinct occurrences: Sparks A, Sparks B, water spatter and impact dust. Explicit script waves provide repetition; no timer keeps firing after the script stops. |
| stress_debris | One separate wall-debris occurrence. Flying chips leave intentionally long-lived settled rubble. |
| stress_checkpoint | Echo an observation marker. Record Portal counters/frame timing here; the command does not measure resources. |

Existing **wind_east**, **wind_south**, wind speed commands and phase commands remain usable. All wind-capable stress instances bind directly to ordinary currentPhase.WindSpeed/WindDirection; no synthetic EffectiveWindSpeed, hidden weather-intensity calculation or new arithmetic is involved. Independent cloud response factors are 0.25 / 0.6 / 1.2 / 1.8 with offsets -20 / 0 / +15 / +35 degrees. Other stress wind factors preserve per-family supported controls; smoke binds the two absolute inputs directly.

The controlled weather mixture is intentionally simultaneous rain/snow/hail/leaves/ash/motes/fog plus four cloud layers, independent of seasonal precipitation enablement. Same-name disabled room definitions explicitly suppress inherited weather/scope demonstrations, so changing phase affects wind and ambient lighting without accidentally adding an unrelated inherited load. Room variables StressEmission, StressSize and StressBurstQuantity are ordinary numeric sources. Presets set these values and the local environment enabled properties; source objects use existing isHidden. No per-effect proxy variable system was added.

## Layout and target scene counts

The pavement backdrop makes weather and lighting visible. Four two-cell fire footprints occupy the corners at (120,120), (600,120), (120,400), (600,400). Their effect/light anchors are +40/+40. Each contains one direct ParentRelative smoke part, placed (0,40) from the parent's top-left footprint anchor, with local effect offset (40,0), so flame/smoke anchors coincide. Two central shadow columns stress the four paired lights. Five one-cell burst markers run along y=280; effect anchors are at y=300. The west arrival point is (36,300), clear of those markers. No pre-existing objects moved.

| Preset | Enabled environmental instances | Producing fire effects | Producing smoke parts | Paired lights |
| --- | ---: | ---: | ---: | ---: |
| Quiet | 0 | 0 | 0 | 0 |
| Low | 2 | 1 | 1 | 1 |
| High | 11 | 4 | 4 | 4 |

These are **Host scene declarations**, not live particle counts. Burst sources may remain in render metadata with no continuous emission. Hidden persistent source sprites are absent; their in-flight residuals are owned by the renderer lifecycle. Environmental Host instance IDs are stable room/definition identities, not authored definition IDs. The checks verify stability across updates and visits.

## Script stages

1. Establish Spring Day / clear sky / no ordinary precipitation / east wind at the existing windy speed. Enter quiet; wait 30 seconds and record the initial baseline.
2. Apply LOW, warm for 25 seconds, record it and invoke a fresh finite-lived wave.
3. Repeat **four identical HIGH rounds**: warm 25 seconds; record high; send 12 explicit waves at 250 ms authored spacing; observe steady high; turn wind south; hide/show fire assemblies; switch to Spring Night and inspect ambient/paired lighting. Leave and return while HIGH remains enabled, record reconstruction, then QUIET/drain 30 seconds. Leave and return quiet; record the equivalent checkpoint. Reset Spring Day/east wind before the next round.
4. Separately enable HIGH and send four debris occurrences. Stop and observe intentional rubble; leave/revisit and verify old rubble/bursts do not replay.
5. Verify a fresh LOW and a fresh short-lived wave still work; return quiet, drain, return to Shelter and restore Spring Day/breeze.

Total: **10 visits**, **30 checkpoints**, **200 finite-lived burst occurrences plus 4 debris occurrences**, each with a distinct BurstId. Script spacing is an authored observation delay, not a guaranteed wall-clock dispatch benchmark. Each finite-lived wave requests sparks 16+16, water 12 and dust 10 particles times the current quantity (54 at 1x, 216 at 4x). All 48 high waves request 10,368 particles over time; capacity limits can reduce actual emission. This is not a claim about simultaneously live particles.

**Debris is deliberately separate:** each of the four high debris occurrences requests 8 flying chips x 4 quantity = 32 chips. The on-death settled-rubble stream has a recipe lifetime of **86400 seconds**. Up to 128 settled follow-ups can legitimately accumulate in this segment. A 30-second quiet hold is not expected to remove them; room departure must dispose of their old scene and return must not replay old occurrences. Do not shorten recipe lifetimes to make this check reach zero.

## Record actual renderer measurements

Use **STRESS_LAB_OBSERVATIONS.csv**. Each row identifies command index, visit, preset and expected Host scene counts; measurement fields are blank and Status is Not measured. Record frame-time median/p95 (ms), live particles/emitters, decoded textures, subscriptions, pending image work and pending bursts using the Portal's existing diagnostics/test facilities where available. If a metric is unavailable, record that limitation rather than inventing a counter or a pass.

Compare the **same high/quiet/revisit checkpoints in rounds 2-4** after normal cache warmup. Retained decoded textures can be intentional; they need a stable plateau, not a count of zero. Finite-lived residuals may outlast a chosen observation window; verify actual lifetime/exit behavior before calling growth a leak. After departure, inspect old room resources while recognizing that Lifecycle & Restore has its own existing smoke/light fixtures. The quiet-in-Stress-Lab checkpoints are the cleaner like-for-like baseline.

Expected observations: no continuing upward trend at equivalent settled checkpoints; no duplicate active producer after hide/show/re-entry; no historical burst replay; responsive controls under load. Numeric frame-time targets depend on the test machine and existing Portal budgets: record hardware/browser, observation windows and actual results. This content delivery does not establish a performance pass.

Controlled **slow/failed custom-image loads and capacity exhaustion** remain Portal harness work. Reuse this fixture, intercept/delay the existing image request or configure existing test limits, and verify bounded retries/queues/logs and no late stale burst emission. Do not corrupt sample art, introduce invalid recipes or add an endless burst timer. Effect control boundary checks are separate from this weather stress route.


## Regression and observations

Permanent automated coverage lives in the GameEngine/GameHost and Portal owner test suites. The saved effects recording is selected by the GameHost recording-playback manifest with `hostEffects` assertions. Run those owner tests for current results; command/state checks do not establish a visual or performance pass. One-time construction reports and temporary probe programs are not shipped with this sample. Resource results belong in the measurement worksheet with hardware/browser and actual observation windows.

# Burst quantities — commands, observations and acceptance

## Run

Start a **NEW game in Seasonal Shelter** and run **CommandSequence/BurstQuantities.txt**. It navigates east three times and north three times to Triggered Bursts, then returns to Shelter at the end. It uses only standard four-direction navigation. Allow its 3.7 minutes of observation pauses; sparks last only 0.12–0.3 seconds, so watch when each trigger executes.

For lifecycle and moving-source checks too, use **CommandSequence/BurstsLifecycle.txt** (119 commands, 13.3 minutes). For the complete project, **CommandSequence/FullWalkThru.txt** now contains 504 commands and 69.2 minutes of pauses, ending at the existing genuine save checkpoint. These are separate starting choices; do not concatenate the focused quantity run into the combined route.

Repeat in a new game using **Variants/PackagedDefaults/GameRuntimeJson/LightingEffectsTest.sbr.runtime.json**. The quantity station uses packaged burst art in both exports; its companion run checks consistent export behavior. It does not replace the custom-image station's first-use/cache checks.

## What the count means

Recipe baseline × action multiplier, rounded half up, yields the directly emitted stream's requested count. One occurrence has one BurstId even when it emits many particles. Low-level capacity limits can reduce actual live particles; Host tests do not measure rendered particles. Existing debris may remain as settled follow-up rubble, so compare the flying chips, not the accumulated floor marks.

| Source / recipe stream | Half | Normal | Double | Zero |
| --- | ---: | ---: | ---: | ---: |
| Sparks A/B / particles (baseline 16) | 8 | 16 | 32 | 0 |
| Water / particles (baseline 12) | 6 | 12 | 24 | 0 |
| Debris / flying-chips (baseline 8) | 4 | 8 | 16 | 0 |
| Dust / puff (baseline 10) | 5 | 10 | 20 | 0 |

Sparks B remains a fixed normal comparison; literal half/normal/double/zero commands target Sparks A, water, debris and dust. The unchanged commands use neutral quantity 1; the current Designer may serialize that default explicitly. This sample does not claim to prove omitted-wire-field behavior.

## Commands

See [TEST_CONTROLS.md](TEST_CONTROLS.md#burst-quantity-controls--current) for the command table. New source properties are authored on the ordinary room: numeric **BurstQuantity** (default 1), Boolean **BurstBoost** (default false), and numeric computed **BurstComputedQuantity** (false → 0.5; true → 2). No special weather variable or arithmetic extension is needed. Bound actions save direct currentRoom references and independent literal fallback 1.

- First compare the four literal quantities on each source. Zero intentionally produces no flash and a successful no-particles echo.
- Change BurstQuantity and invoke the same bound trigger again. Previously emitted particles retain their sampled quantity.
- Run burst_snapshot_pair: two requests at 0.5 and 2 are queued before delivery; the final room variable is 1. Visual overlap may make counting difficult, so consult Host snapshots.
- Toggle BurstBoost and invoke burst_sparks_a_computed to inspect the normal computed numeric source.
- A positive tiny multiplier produces a valid Host occurrence whose stream rounds to zero; Portal must complete it without emission or retry.
- After leaving and returning, inspect without triggering first; only a new explicit command should produce a new occurrence.

## Coverage

| Case | Expected behavior | Verification focus |
| --- | --- | --- |
| Literal half / normal / double / zero | All four families at the same fixed markers. Zero returns success and no occurrence. | Compare Host state and visible output |
| Default and fixed comparison | Original burst_all plus unchanged Sparks B compare the neutral multiplier and source identity. | Compare Host state and visible output |
| Ordinary direct binding | Change BurstQuantity, then invoke bound sparks and water. Bound zero stays zero. | Compare Host state and visible output |
| Invocation snapshots | burst_snapshot_pair produces two distinct IDs at 0.5 and 2 even though the final variable is 1. | Check distinct occurrence IDs and sampled quantities |
| Computed numeric source | burst_boost_off/on followed by burst_sparks_a_computed resolves 0.5/2 through ordinary computed-variable machinery. | Compare Host state and visible output |
| Positive rounds to zero | burst_sparks_a_tiny emits one 0.01 Host occurrence; presentation should complete its zero-count stream once without retry. | Verify zero-count completion without retry |
| Repeats / grouped sources | Existing rapid repeats, burst_pair and burst_all remain in BurstsLifecycle and the full route. | Check the focused route and renderer |
| Movement | The existing closed square still moves only Sparks A; new quantity actions retain the same position semantics. | Check the focused route and renderer |
| Leave and revisit | Fire a burst, go south to Fire Outside, then north. No occurrence replays on return. Explicitly trigger a fresh one. | Compare Host state and visible output |
| Pending and consolidated events | Probe polls after A→B, after A→B→A, and after queuing an event that had not entered a delta before leaving. | Check distinct occurrence IDs and sampled quantities |
| Host ownership | Host bursts carry no RoomId. Engine performs departure invalidation; Portal does not determine membership. | Check current serialized Host shape |
| Follow-up rubble / natural decay | Only flying chips are counted directly; inspect settled rubble after debris and normal decay for the other families. | Observe natural decay/follow-ups |
| Deferred custom art / duplicates | Use the existing art/cold-cache scenarios and owner Portal checks; do not infer success from this packaged burst-art station. | Use the Portal loading/cache regression |


## Regression

Permanent automated coverage lives in the GameEngine/GameHost and Portal owner test suites. The saved effects recording is selected by the GameHost recording-playback manifest with `hostEffects` assertions. Run those owner tests for current results; command/state checks do not establish a visual or performance pass. One-time construction reports and temporary probe programs are not shipped with this sample.

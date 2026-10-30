# Removal policies - observation and regression guide

Compare the three recipe-owned removal behaviors through the commands below.

## Run

Use a compatible installed catalog containing all three keys listed below.

Start a **NEW game in Seasonal Shelter**. Run **CommandSequence/RemovalPolicies.txt**: east three rooms to Lifecycle & Restore, isolate the smoke row, perform the comparisons, then return west three rooms. Allow 3.1 minutes of pauses. Standard orthogonal directions only. The same comparison is integrated in **BurstsLifecycle.txt** (119 commands, 13.3 minutes) and **FullWalkThru.txt** (504 commands, 69.2 minutes, still ends at the genuine save checkpoint). These are alternative starting scripts; do not concatenate the focused script into the combined route.

Repeat using **Variants/PackagedDefaults/GameRuntimeJson/LightingEffectsTest.sbr.runtime.json** in a fresh game. Both smoke rows use packaged smoke art; the companion validates consistent export behavior and preserves the separate image-comparison station.

## Comparable specimens

All three have size 1.4, emission multiplier 1.5, lifetime multiplier 1.5, and the same direct currentPhase wind bindings. The focus script sets calm wind, disables Restore Fog and hides the nearby paired Restore Beacon light to remove those comparison variables. Each uses the same crate marker; left/centre/right distinguish them. Footprints below are top-left room coordinates; effect anchors are the local +20/+20 offsets.

| Specimen | Footprint | Emitter | Catalog key | Removal |
| --- | --- | --- | --- | --- |
| natural | (160,160) | (180,180) | particle.campfire.smoke | Natural lifetime (null) |
| fade | (400,160) | (420,180) | particle.campfire.smoke.fade | 2000 ms |
| immediate | (640,160) | (660,180) | particle.campfire.smoke.immediate | 0 ms |

Only key/display name/removal duration differ in the three catalog entries. Natural Smoke and Restore Beacon retain their original IDs/positions; the save/restore fixture is preserved. The positive removal duration applies a gradual opacity fade, not a delay followed by an abrupt clear. The general 10000 ms tuning transition is a separate policy; it must not turn 0 ms removal into a gradual stop or change the 2000 ms removal duration.

## Controls and observations

| Commands | Expected observation |
| --- | --- |
| removal_all_on | Show and activate all three. Wait eight seconds for enough smoke. A repeated on is valid; it must not duplicate instances. |
| removal_all_off | Source crates remain. Production stops together: left residual smoke ages normally, centre opacity fades over two seconds, right residual disappears on the next render update. |
| removal_all_hide | All source crates disappear; existing smoke follows the same three removal policies. |
| removal_all_show | Show sources under their existing active state. After this script's hide case they are active, so smoke resumes. |
| removal_natural_on/off/hide/show | Individually control the left source using ordinary isActive/isHidden. Natural off/on may overlap old residual smoke; there must be only one producing source. |
| removal_fade_on/off/hide/show | Individually control the centre. Off, wait one second, then on; repeat hide, wait one second, show. Verify smooth re-enable without opacity jump, duplicate active source or an obsolete fade completing against the re-enabled effect. |
| removal_immediate_on/off/hide/show | Individually control the right. New emission can start after immediate removal. |

The script ends with all three active/visible, Restore Beacon shown and the original breeze restored. Local Restore Fog stays disabled, matching the existing lifecycle exercise. Natural smoke lifetimes are 1.2-2.3 seconds times 1.5 (1.8-3.45 seconds), so the longest residual should finish shortly after the two-second fade. Observe the first two seconds closely; the 18-second holds intentionally include a stable empty state.

Re-enable halfway through fade at one second. Assert continuity and the absence of a stale removal after the original two-second deadline; do not require the exact old particle population to survive beyond its natural age. Timed removal may leave fully transparent particle records until normal expiry, so zero rendered contribution is the acceptance criterion, not an immediate zero allocation count.


## Regression

Permanent automated coverage lives in the GameEngine/GameHost and Portal owner test suites. The saved effects recording is selected by the GameHost recording-playback manifest with `hostEffects` assertions. Run those owner tests for current results; command/state checks do not establish a visual or performance pass. One-time construction reports and temporary probe programs are not shipped with this sample.

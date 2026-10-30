# Genuine save/restore checkpoint

Use a real Portal/Host save operation between the command sequences. The full walkthrough's final comments mark an observation break; they do not execute persistence.

1. Start in Seasonal Shelter. Run [CommandSequence/SaveRestoreSetup.txt](CommandSequence/SaveRestoreSetup.txt), or reach that final segment of FullWalkThru.txt. It ends in Lifecycle & Restore with deliberately changed object, phase and environment state.
2. Capture the current session through the supported save workflow and retain the returned save/envelope. The Host persistence API is capture-state; require capture success before continuing.
3. Run [CommandSequence/SaveRestoreDisturb.txt](CommandSequence/SaveRestoreDisturb.txt). Confirm the beacon, sources, weather/phase and current room actually change.
4. Load the saved state through the supported restore workflow/Host load-state operation. Require load success and refresh the session baseline as the client normally does.
5. Inspect restored state **before issuing mutations**, then run [CommandSequence/SaveRestoreAfterRestore.txt](CommandSequence/SaveRestoreAfterRestore.txt) for the remaining rooms.

| State | Expected after restore |
| --- | --- |
| Room / phase | Lifecycle & Restore; Winter Evening |
| Ambient / weather | Saved ambient target/color; Snow, Heavy, southeast wind at 100 room pixels/second |
| Player | Saved position in the saved room |
| Beacon | Footprint (560,240), effect/light at the saved authored offsets, size target 2 |
| Natural Smoke / Restore Fog | Smoke hidden; fog enabled |
| Wind & Clouds | cloud_2 enabled |
| Image station | Oval leaves enabled; custom image mappings and asset locators remain usable |
| Stains | Splatter footprint (240,240), patch hidden, spray inactive, streak unchanged |

For the newer composition fixture, use InheritanceSavePrepare.txt, perform a real save, run InheritanceSaveDisturb.txt, restore, then run InheritanceAfterRestore.txt. Its parent is saved at (280,240) with Scale/Shake/Highlight and an independent blue highlight. See [INHERITANCE_COVERAGE.md](INHERITANCE_COVERAGE.md).

Permanent save/restore checks are in GameEngine's LightingEffectsSaveRestoreRegressionTests and the Portal owner tests. They are distinct from the short saved command recording. Compare authoritative values, active phase/room, anchors, bound targets and asset resolution; random particles, particle ages and already-consumed bursts are not restored visual baselines. Record current owner test results and any observed discrepancy rather than relying on old construction reports.

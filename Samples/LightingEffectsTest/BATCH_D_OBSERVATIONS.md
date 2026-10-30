# Bursts, lifecycle, and remaining catalog appearances

Start a NEW Portal game in Seasonal Shelter. Run CommandSequence/BurstsLifecycle.txt (119 commands, 13.3 minutes of pauses). Its route uses only north/south/east/west. Use compatible current Designer/Engine/Portal builds.

| Station / action | Observe |
| --- | --- |
| Triggered Bursts, initial entry | Five visible crate markers; the four surge-only recipes should not emit continuously. |
| Five single trigger commands | Sparks A, Sparks B, water, debris and dust each produce one occurrence from their marker. Compare both sparks sources. |
| Three rapid burst_sparks_a repeats | Three occurrences; no dropped trigger or duplicate replay. Host evidence has distinct IDs. |
| burst_pair / burst_all | Two / five occurrences in a single command, all at the correct source. |
| burst_source_east/south/west/north then trigger | Sparks A effect anchors: (260,180), (260,260), (180,260), (180,180). Sparks B stays at (500,180). Movement is two 40-pixel grid cells per leg. |
| Lifecycle smoke hide/show | Hide removes the object/effect from room presentation; already emitted particles should finish under the recipe's natural-removal policy. Show recreates production. No abandoned/duplicate emitter. |
| Lifecycle smoke disable/enable | Object stays represented and IsProducing changes false/true. Compare visual stop/restart to hide/show. |
| life_fog_on/off, twice | Environmental Enabled toggles its producing state. Observe overlay cleanup and recreation explicitly; do not assume fog behaves like finite-lifetime particles. |
| Restore Beacon hide/show and disable/enable | Hide removes its renderable object and attached light/effect. Disable suppresses particle production; the current Host presentation retains the object/light. This route does not assert a new lighting rule for isActive. |
| Stains closed movement route | The first mark's resolved anchor follows its object; no accidental permanent trail or duplicate marks. The other three remain fixed. |
| Stain hide/show and disable/enable | Compare each style's removal/recreation. A stain is persistent while active; no burst command is required. Record actual appearance rather than assuming it has a finite emitted-particle lifetime. |

For all three removal policies, use RemovalPolicies.txt and REMOVAL_POLICY_COVERAGE.md.

## Other catalog appearances

Run CommandSequence/CatalogRemainder.txt from Shelter (37 commands, 6.5 minutes). It deliberately isolates pipe steam, leaking drip, insects, aura and toxic cloud, then compares outdoor torches/torch smoke and indoor flame/smoke appearance in day/night. The burst-only markers in Impacts & Debris are not continuous demonstrations; their real triggers are covered in Triggered Bursts.

## Complete route and actual save break

CommandSequence/FullWalkThru.txt combines seasonal surfaces, the 16-page phase matrix, objects/lights/tuning, scope/atmosphere/images, bursts/lifecycle/stains, the catalog remainder and save preparation: 504 commands and 69.2 minutes of pauses. Start one NEW game; do not restart between segments. It ends in Lifecycle & Restore and stops playback for a real save. Comments alone cannot perform capture/load or pause an already queued next file. Follow SAVE_RESTORE_CHECKPOINT.md; use the genuine save/restore workflow between segments.

Permanent automated coverage lives in the GameEngine/GameHost and Portal owner test suites. The saved effects recording is selected by the GameHost recording-playback manifest with `hostEffects` assertions. Run those owner tests for current results; command/state checks do not establish a visual or performance pass. One-time construction reports and temporary probe programs are not shipped with this sample.

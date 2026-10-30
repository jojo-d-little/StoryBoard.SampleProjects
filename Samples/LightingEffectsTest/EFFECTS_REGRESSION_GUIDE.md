# Frequent effects regression

Run **CommandSequence/EffectsRegression.txt** from a **new game in Seasonal Shelter**, with recording started before the first command. It contains **68 commands, 18 orthogonal moves, 16 distinct rooms**, and **exactly 45 seconds of authored pauses**. The paced Engine run completed in **46.9 seconds**. Portal command, polling, loading and transition overhead is additional; the browser target is **45–90 seconds**. The saved baseline spans **82.7 seconds from first to last accepted command**, excluding UI setup and the final pause.

For predictable recording, set Dev Tools session-delta polling to **100–250 ms** during capture. The command player already awaits each command and its delta observation before applying the file's pause. Restore the normal poll setting afterward. Start after the initial room is ready; the 45–90 second budget is for this command route, excluding session startup, selecting a file, or saving the recording. Stop recording after the last output and drain interval. Retain the observed elapsed time with the resulting artifact. Default 750 ms polling can add substantial overhead; do not remove the room/movement waits merely to counter polling overhead.

The route returns to Seasonal Shelter with nondefault state intentionally retained: Spring Night, rain/heavy, wind south at 100 room pixels/second; some scope/cloud/lifecycle settings and moved fixtures remain changed. Always start a new session for another run. There is no manual persistence checkpoint in this fast file. Use the existing real save/restore tests separately.

## Checkpoints for recording playback

| Command steps | Representative assertions |
| --- | --- |
| 1–9 | Indoor baseline then outdoor heavy rain with explicit wind; Winter Night gives snow/overcast and an ambient update; Fall Evening supplies leaves/fog; preserve weather over the second backdrop. Ambient target/window changes use CurrentRoom rather than fake travel. |
| 10–14 | Room same-name winner; explicit disabled replacement suppresses the area winner. Neighbor without that replacement receives its own area winner. Outdoor ash stops indoors; indoor motes and Both effects remain eligible. |
| 15–26 | All five inherited cue categories; red=all, green=Movement/Scale, white=none, blue=Movement/Highlight/ColorOverlay; fixed room-coordinate control. Independent blue highlight survives parent highlight removal/clear. Shared activation equality and distinct child activation survive normalization. Check local fit, pivot, own light/emitter positions and Movement opt-out. |
| 27–33 | Defaults/literals in entry snapshot; numeric zero; primary color changes while secondary stays fixed; shared size 1.8; computed rate 2.4/lifetime 0.5 and string colors; phase source overrides, then literal 0.75 and missing lifetime tuning on fallback. Bound false and unresolved Enabled fallback remain distinct. |
| 34–39 | Moving fire/light/smoke preserve their separately authored offsets; stationary fire remains fixed. Rain in the same room changes rate 0.5 to 2. |
| 40–49 | Eight burst occurrences total: half, double, successful zero/no event, same-command sampled half/double, two sources, water and sparks after source movement. Preserve source/key/quantity/position and distinct BurstIds. |
| 50–55 | Depart burst room without replay. Three smoke recipe keys remain distinct with production off; timed-fade source can resume; environment Enabled changes via binding. This checks declarations, not renderer fade completion or unpublished departure-race behavior. |
| 56–62 | Four independent cloud instances keep speed factors 0.5/0.85/1.3/2 and direction offsets while wind changes. Primary sends exactly the overridden candle flame-tip and oval-leaf slot mappings on demand; default companion sends none. Actual downloads, cache behavior and pixels remain separate checks. |
| 63–68 | Pre/post-light room declarations, persistent stain disable/re-enable without changing anchor, return indoors and no old burst replay. |

The new file samples integration behavior; the existing long walkthroughs remain the detailed visual review. Stress/resource bounds, every recipe, completed fades, cold-cache requests and genuine save/restore retain their existing focused tests. Short pauses deliberately check authoritative targets and deltas rather than waiting ten seconds after each tuning change. Three movement waits remain 5.2 seconds; travel waits are 1.2 seconds; a 3.2-second final drain lets the last output/delta be observed.


## Saved baseline and playback

[Lighting Effects Test__RegressionWalk__e2e6ca87baa245c48d62956d93997c18.sbe.recording.json](GameRuntimeJson/Recordings/Lighting%20Effects%20Test__RegressionWalk__e2e6ca87baa245c48d62956d93997c18.sbe.recording.json) is the schema-4, 68-step fresh-session recording. It includes initialHostBaseline, full observed hostSessionData, current-room updates and export/configuration fingerprints. GameHost's recording-test-cases.json selects it with commandResult, outputLines, soundCues, roomTransitions and hostEffects assertions. This cleanup did not run the owner tests or recapture the baseline.

For a replacement recording, start recording before this command file, retain the final output/drain interval, then save the recording normally. Adopt the replacement deliberately in the owner playback manifest. Keep authored IDs/keys and typed values exact; normalize generated IDs consistently while preserving shared activations and distinct burst occurrences. Compare consolidated poll windows and resulting scene state, not identical poll counts or random particles.

The earlier isolated Engine check honored the pauses in 46.9 seconds; actual Portal run time includes transport/polling/assets. Full visual, stress, cold-cache and actual save/restore checks retain their focused scripts.

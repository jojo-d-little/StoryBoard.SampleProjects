# Batch C — scope, atmosphere, and custom art

Run [CommandSequence/ScopeAtmosphereImages.txt](CommandSequence/ScopeAtmosphereImages.txt) from a **new game in Seasonal Shelter**. It has 105 commands and 18.2 minutes of observation pauses, starts and ends there, and uses four-direction navigation. The image station comes first so its first use can be inspected before another candle/leaf station has warmed the cache.

## Custom versus packaged art

| Export | Runtime project | Image choices |
| --- | --- | --- |
| Custom | `GameRuntimeJson/LightingEffectsTest.sbr.runtime.json` | Oval leaves override `leaf-oval`; candle overrides only `flame-tip`. |
| Packaged defaults | `Variants/PackagedDefaults/GameRuntimeJson/LightingEffectsTest.sbr.runtime.json` | None. All effect images come from the component's package. |

Load each runtime project as a separate fresh run through the Host's normal runtime-project loading/registration path. Repeat the same command file and compare the image station. The companion is a runnable Engine export, not a second Designer source project. Its rooms, objects, bindings, recipe catalog, and tuning are identical; only image choices and their asset inventory differ. If the current game picker has only the main export registered, select/register the companion runtime path for the second run in the owning Host session. No Host configuration was changed here.

| Image test | What to inspect |
| --- | --- |
| First visit east from shelter | Object candle is already producing. `image_candle_show` confirms its state. `image_leaves_on` enables the room effect. Textures should appear without missing-image boxes or a permanently untextured first activation. |
| Custom oval leaves | Uses the existing project leaf artwork. In the packaged-default run, this exact recipe and tuning use the component's oval-leaf image. |
| Partial candle override | Only the `flame-tip` texture is customized. The marker intentionally reuses leaf artwork so replacement is recognizable. `candle-flame` and `spark-glow` remain packaged, and all three slots are used by the candle recipe. Compare with the exact same candle in the packaged-default export. |
| Hide/show | `image_candle_hide/show` stops/resumes the object's production using normal object visibility. Art should remain usable. Existing particles can decay. |
| Early and late revisit | Leave west to shelter and return east; visit again west from Wind & Clouds near the end. Previously loaded art should remain correct, without redundant body downloads while the browser's cache entry is fresh. |

Image overrides are **project-wide per effect key and slot**. The candle marker also applies to the existing Candle in Fire Lab; it does not change campfire or torch recipes. Different instances of one recipe do not choose different image mappings. That is why the exact comparison uses two exports.

### Cold loading and prefetch are separate checks

1. **Demand loading:** begin with a fresh browser/session asset cache and uncheck **Dev Tools → Cache → Warm discovered particle art (session only)**. Enter the image station first. Inspect the Portal network/trace for the image requests and correct first rendered use. Clearing cache/reloading is a manual preparation step outside the command file. Current Portal source defaults warmup on for normal launch and off otherwise; inspect the actual control rather than assuming the launch default.
2. **Discovery:** repeat with the Portal's discovery feature enabled. `NearMe` from the shelter can discover the adjacent image station's two custom images with `AdjacentRoom` priority. Early image fetching is expected in this run.
3. **Warm revisit:** leave and return without clearing the cache. Check reuse. When revalidation occurs, the asset API supports ETag `NotModified` with no payload bytes; browser request scheduling/freshness remains a Portal behavior to inspect.

The authoritative feed check captures the first room delta containing both image mappings. Starting shelter has no relevant custom effect mappings. A full snapshot taken after the command has consumed those one-time mappings may omit them; the existing session mapping cache is expected to retain them.

## Scope comparison

From shelter: north through Composition, west through Seasonal Grass, north to **Environmental Scope (Outdoor)**. Its east neighbor is **Fog & Motes (Indoor)**. Keep Spring Day, Clear, no precipitation, Moderate, east wind 40 throughout these tests. Scope switches start off and `scope_all_off` resets them. The source variables are normal Area properties bound through `currentArea`.

| Test | Outdoor station | Indoor neighbor |
| --- | --- | --- |
| `scope_applicability_on` | Outdoor ash + Both pale fog; Indoor blue motes suppressed | Indoor blue motes + Both pale fog; Outdoor ash suppressed |
| `scope_country_on` | Country gold fog replaces the same-name Global purple cloud | Same Country winner |
| `scope_area_on` | Area drifting motes replace the same-name Country fog | Same Area winner |
| `scope_room_on` | Room organic green motes replace Area drifting motes; the Area size override does not carry over | Area drifting motes, size multiplier 2 |
| `scope_disabled_on` | Explicit Room `enabled:false` replaces the same-name enabled Area fog, so no orange fog appears | Area orange fog appears |

Each name test is turned off before the next. Definitions replace one another completely by name; they do not merge controls. The Country winner has no Global cloud coverage override. The Area winner has no Country fog settings. The Room winner has no Area size override. The disabled Room definition has neither a binding nor inherited controls. Moving rooms must not reset weather or the Area switch values.

## Atmospheric isolation

All local atmosphere switches start off. Wait through the authored observation window and any outgoing particles' normal decay before judging isolation.

| Room | Individual controls | Combined control | Observation |
| --- | --- | --- | --- |
| Fog & Motes | `fog_1_on/off`, `fog_2_on/off`, `motes_on/off`, `organic_motes_on/off` | `atmosphere_all_on/off` | Inspect each fog layer and each mote style alone, then all four; change wind south while combined. Scope probes must be off first. |
| Leaves | `leaves_oak_on/off`, `leaves_maple_on/off`, `leaves_oval_on/off`, `leaves_mixed_on/off` | `leaves_all_on/off` | Inspect four styles separately, then combine. Compare gale and calm. Oval is custom art in the main export; the other styles keep packaged art. Spring/Clear prevents an additional seasonal leaf layer. |
| Ash & Cinders | `ash_on/off`, `cinders_on/off` | `embers_all_on/off` | Distinguish ash from cinders before combining and changing wind. Ash is pre-light; cinders have recipe-authored pre/post-light streams. |
| Wind & Clouds | `cloud_1_on/off` through `cloud_4_on/off` | `clouds_all_on/off` | Inspect each instance alone, then depth from combined motion. Each keeps its own multiplier, offset, coverage, opacity, and instance identity while shared wind changes. |

| Cloud instance | Wind multiplier | Direction offset |
| --- | ---: | ---: |
| 1 | 0.5 | −30° |
| 2 | 0.85 | −10° |
| 3 | 1.3 | +15° |
| 4 | 2.0 | +40° |

Four is the sample's chosen count, not a component limit. Calm changes wind inputs to speed zero; it does not disable cloud production. The route then restores east wind 40 and turns the local instances off.

## Route and review gate

```text
Shelter → Image station → Shelter → Image station → Shelter
    north Composition → west Grass → north Outdoor Scope ↔ east Indoor Fog & Motes
    north Leaves → east Storm (transit) → east Ash & Cinders
    south Magic & Toxic (transit) → south Fire Lab (transit) → south Wind & Clouds
    west Image station (late revisit) → west Shelter
```

Transit alone does not establish a visual comparison. Check actual appearance, cleanup, first-use loading and cache behavior during the focused run; record observed differences separately from Host state checks.

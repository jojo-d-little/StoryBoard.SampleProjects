# Spatial Sound Test Lab

An authored project and runtime export for exercising located sound behavior. It uses a 7 x 7 square area with four distance bands (center plus rings 1–3), 45 occupied rooms, and four open map cells. All room-to-room traversals are two-way, passable, and have no door requirement.

## Map

Each occupied cell has one independently controlled emitter. All start disabled. The four ## cells are intentionally empty; the Engine can still propagate through them using the project open-space loss setting.

``text
 3 A  3 B  3 C  3 D  3 E  3 F  3 G 
 3 A  2 B  2 C  2 D  2 E  2 F  3 G 
 3 A  2 B   ##    1 D   ##    2 F  3 G 
 3 A  2 B  1 C   C     1 E  2 F  3 G 
 3 A  2 B   ##    1 D   ##    2 F  3 G 
 3 A  2 B  2 C  2 D  2 E  2 F  3 G 
 3 A  3 B  3 C  3 D  3 E  3 F  3 G 
``

Rooms on the outer ring are outdoors. Others are indoor. Room canvases vary between 800 x 600 and larger sizes to exercise room-size scaling. Each room has a center default spawn and a spawn point for every incoming traversal.

## Sound catalog

| Sound | Lane | Susceptibility | In-room range | Repeat | Intended contrast |
| --- | --- | ---: | ---: | --- | --- |
| Tin-roof rain | Ambient | 1.6 | Whole room | Continuous random repeats | Weather ambience with higher loss |
| Crickets | Ambient | 1.1 | Whole room | Continuous random repeats | Outdoor/night ambience |
| Hammer on metal | SFX | 0.35 | 900 px | One shot | High-reach impact |
| Distant thunder | SFX | 0.25 | Whole room | Long random repeats | Directional, low-loss impact |
| Ghostly whisper | SFX | 2.0 | 500 px | One shot | Short-range, high-loss voice |
| Electrical arc | SFX | 0.8 | Whole room | Random repeats | Remote-only emitter case |
| Cave drip | Ambient | 1.25 | Whole room | Random repeats | Quiet interior ambience |
| Metal door slam | SFX | 0.65 | 1200 px | One shot | Medium-range impact |
| People passing | Ambient | 1.45 | Whole room | Random repeats | Diffuse crowd ambience |
| Metal cart | SFX | 0.55 | 1500 px | One shot | Moving/mechanical sound |

Source audio is included under SourceAssets/Sounds; the runtime export has staged copies under GameRuntimeJson/assets/sounds/_shared. The source audio was selected from the local D:\SoundLibrary and existing StoryBoard sample assets.

## Central-room controls

Every emitter is bound to its own shared boolean game property. The center room contains a matching on/off action pair for every emitter. From the central room, issue the exact command from the onCommand or offCommand column in SoundEmitterIndex.csv. For example, sound_r1_n_on and sound_r1_n_off toggle the north-ring source. The CSV maps every command to its room, sound key, lane, susceptibility, and in/out-of-room flags.

## Suggested listening passes

1. **Attenuation by sound type:** Enable the hammer and ghost whisper sources at comparable ring distances. Walk toward and away from them. Compare their reach with the same route and room-loss settings.
2. **Room distance and size:** Enable one emitter in each ring. Move outward and compare regular versus larger room canvases.
3. **Open-cell propagation:** Compare aligned sources whose direct area-map line crosses one of the empty cells against a line with no empty cells.
4. **Indoor/outdoor/weather:** Enable rain or crickets in an outer outdoor room, then listen from an outdoor room, an edge-adjacent indoor room, and the center.
5. **Local distance fade:** In the source room, approach and retreat from the hammer, whisper, door, and cart emitters to test their authored MaxInRoomDistancePixels.
6. **Direction:** Enable thunder or a distant impact, then face north, east, south, and west from the listener. Compare pan as the player faces the source and turns away.
7. **Room eligibility:** Compare emitters configured for local-only, remote-only, and both contexts using the CSV columns.
8. **Playback policy:** Toggle each ambient loop and one-shot off and on. Confirm continuous/random repeats, replay policy, and a fresh activation after re-enabling.

## Notes

- Use the center room for toggles, then walk the open grid to hear the levels and pan change.
- DampeningSusceptibility belongs to the sound definition. 1 uses room/open-cell loss as authored; values below 1 reduce that loss and values above 1 increase it. Same-room pixel fade is independent.
- This is a manual game-engine/host/portal harness, not an automated test suite. Keep the CSV and this guide with the sample when refreshing the Designer export.

## Visual orientation aids

Each room uses a neutral title-card image showing its room name, area-map cell, and indoor/outdoor type. Each sound emitter has a small icon keyed to its sound (rain, crickets, hammer, thunder, whisper, electrical arc, drip, door, crowd, or cart). These are navigation and test hints; they do not change sound behavior.

The source images are in `SourceAssets/Images/SoundTestRooms` and `SourceAssets/Images/SoundTestEmitters`. The corresponding hashed runtime images are in `GameRuntimeJson/assets/images/_shared`.
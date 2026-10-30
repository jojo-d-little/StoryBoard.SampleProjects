# Category inheritance comparison

Use a new game and CommandSequence/Inheritance.txt. From Seasonal Shelter go north; in Traversal & Composition run parts_hide, inherit_show, inherit_help. The original demo is hidden only for this comparison. inherit_hide then parts_show returns it.

The large brown parent starts at (200,160) with a 200x200 room-pixel footprint. Every part fits its own artwork independently. Red/green/white/blue footprints are 80x80, with offsets snapped to the 40-pixel room grid from the parent's top-left footprint anchor. The fixed white control at (600,400) has a blue light and sparks. The parent's collision footprint is not the union of its parts; these are passive visual fixtures.

| Part | Baseline anchor | Inherited categories | Own source |
| --- | --- | --- | --- |
| Red, upper left | (120,160) | All five | Red light and sparks |
| Green, upper right | (400,160) | Movement, Scale | Green light and smoke |
| White, lower left | (120,280) | None, explicit empty list | Pale light and candle |
| Blue, lower right | (400,280) | Movement, Highlight, ColorOverlay | Independently controlled danger outline |
| Fixed white, far right | (600,400) | None; RoomCoordinates | Blue light and sparks |

## Deliberate observations

| Command | Expected comparison |
| --- | --- |
| inherit_east/south/west/north | Each moves the parent two cells. Red/green/blue animate; relative white snaps to its new destination. Fixed control stays put. Own light/emitter sources follow the same behavior; old particles can trail and decay. |
| inherit_scale / inherit_scale_off | Five-second 1.5x growth makes the pivot visible. Parent/red/green scale as a group. White/blue receive no inherited Scale cue. Parent-relative anchors still follow spatial placement. Lights/emitter sources track the displayed transform; artwork fit must not shrink room-space offsets. |
| inherit_shake / inherit_shake_off | Parent/red share large slow shake; green/white/blue/fixed remain unshaken. Inspect red light and new spark origin too. |
| inherit_highlight / inherit_highlight_off | Explicit cyan outline on parent/red/blue only. Green/white/fixed stay unoutlined. Commands directly target IDs so selection highlighting does not supply this test. |
| inherit_color / inherit_color_off | A two-second color flash on parent/red/blue only. Watch immediately. Remove before reapplying for a fresh activation. |
| inherit_local_on / inherit_local_off | Blue has an independent danger outline with its own activation. Parent and local highlights can coexist; removing either must preserve the other. Their blend/priority is renderer-defined, so inspect Host state as well as the visual. |
| inherit_clear | Clear parent activations and all derived targets; blue's independent outline remains. No new parent-child information is needed by Portal. |
| inherit_status | Observation reminder and baseline coordinates; does not evaluate live state. |

The focused sequence tests each category separately, then combines Scale/Shake/Highlight, moves the parent, revisits the room, clears parent cues and replays Scale. Baseline child geometry and activation identity are checked separately from rendered animation. One parent activation shares ActivationId across its targets; (ObjectId, ActivationId) distinguishes the rendered instances. A separately activated child cue has its own ID.

## Genuine save and restore

Run InheritanceSavePrepare.txt from a new game. Use the Portal's real Save UI after the final observation pause. Parent is at (280,240), with Scale/Shake/Highlight and blue's independent highlight active. Run InheritanceSaveDisturb.txt, then restore that actual save through the UI. Before mutating anything, inspect the restored room, moved board, visible sources, category choices, and active cues. Run InheritanceAfterRestore.txt to check parent clear leaves the child's independent cue and return to baseline. The finite ColorOverlay flash is intentionally not the saved visual checkpoint.

Automated verification uses the actual Engine save-envelope API with serialization/deserialization; it does not replace this Portal UI check. Include saved phase/ambient targets in the actual restore comparison.


## Regression

Permanent automated coverage lives in the GameEngine/GameHost and Portal owner test suites. The saved effects recording is selected by the GameHost recording-playback manifest with `hostEffects` assertions. Run those owner tests for current results; command/state checks do not establish a visual or performance pass. One-time construction reports and temporary probe programs are not shipped with this sample.
